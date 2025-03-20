1. Set up a Linux Bridge for Internal Network
First, let's create a dedicated bridge for your internal network:

``` bash
# Edit the network configuration file
nano /etc/network/interfaces

# Add the following bridge configuration
auto vmbr1
iface vmbr1 inet static
    address 192.168.100.1/24
    bridge_ports none
    bridge_stp off
    bridge_fd 0
    
    # Enable IP forwarding and NAT
    post-up echo 1 > /proc/sys/net/ipv4/ip_forward
    post-up iptables -t nat -A POSTROUTING -s '192.168.100.0/24' -o vmbr0 -j MASQUERADE
    post-down iptables -t nat -D POSTROUTING -s '192.168.100.0/24' -o vmbr0 -j MASQUERADE

```

2. Set up DHCP Server
Install and configure a DHCP server:

```
# Install the DHCP server package
apt-get update
apt-get install isc-dhcp-server

# Configure the DHCP server
nano /etc/dhcp/dhcpd.conf
```

2a. Add the following configuration:


```
# DHCP Server Configuration
default-lease-time 600;
max-lease-time 7200;
authoritative;

# Internal subnet
subnet 192.168.100.0 netmask 255.255.255.0 {
  range 192.168.100.50 192.168.100.150;
  option domain-name-servers 8.8.8.8, 8.8.4.4;
  option domain-name "internal.proxmox";
  option routers 192.168.100.1;
  option broadcast-address 192.168.100.255;
}
```
2b. Then specify the interface for the DHCP server:

```
# Edit the DHCP server defaults
nano /etc/default/isc-dhcp-server

# Set the interface
INTERFACESv4="vmbr1"
```

3. Enable IP Forwarding Permanently:

```
# Edit sysctl configuration
nano /etc/sysctl.conf

# Uncomment or add the following line
net.ipv4.ip_forward=1

# Apply the changes
sysctl -p
```

4. Set up Port Forwarding (Optional)
If you need to access services on your VMs from the internet:

```
# Forward port 80 on your public IP to a web server VM at 192.168.100.50
iptables -t nat -A PREROUTING -i vmbr0 -p tcp --dport 80 -j DNAT --to 192.168.100.50:80

# Forward SSH (port 22) to another VM
iptables -t nat -A PREROUTING -i vmbr0 -p tcp --dport 2222 -j DNAT --to 192.168.100.51:22

```
4a. To make these rules persistent:

```
apt-get install iptables-persistent
netfilter-persistent save
```

5. Configure VMs
When creating VMs in Proxmox:

Connect them to the vmbr1 bridge
Use DHCP for network configuration or set static IPs in the 192.168.100.0/24 range
Set the default gateway to 192.168.100.1

  Please remember that this is a guide and what might work for me may not work for you. This exact network config is not what \
I use on my Proxmox server but in general I see this as a good start as it seperates VMs from the outside network while still providing internet via NAT.




   




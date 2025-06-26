#!/bin/bash

# Alpine Linux OSINT/Pentesting Setup Script
# This script sets up a complete Alpine Linux system with KDE desktop and security tools

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root"
        exit 1
    fi
}

# Update system and enable community repository
setup_repositories() {
    log "Setting up repositories and updating system..."
    
    # Enable community repository
    sed -i 's/^#.*community//' /etc/apk/repositories
    
    # Add edge repositories for latest packages
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
    
    # Update package index
    apk update
    apk upgrade
}

# Install base desktop environment
setup_desktop() {
    log "Setting up desktop environment..."
    
    # Run Alpine's desktop setup
    setup-desktop xfce
    
    # Install additional XFCE components and applications
    apk add \
        xfce4-terminal \
        xfce4-taskmanager \
        xfce4-screenshooter \
        xfce4-notifyd \
        thunar \
        mousepad \
        firefox \
        chromium \
        vlc \
        libreoffice
}

# Setup X.org
setup_xorg() {
    log "Setting up X.org..."
    
    # Run Alpine's X.org setup
    setup-xorg-base
    
    # Install additional X.org drivers
    apk add \
        xf86-video-intel \
        xf86-video-amdgpu \
        xf86-video-nouveau \
        xf86-input-libinput
}

# Install networking and wireless tools
install_network_tools() {
    log "Installing networking tools..."
    
    apk add \
        networkmanager \
        networkmanager-wifi \
        wpa_supplicant \
        wireless-tools \
        iw \
        hostapd \
        bridge-utils \
        iptables \
        nftables \
        tcpdump \
        wireshark \
        tshark \
        ettercap \
        aircrack-ng \
        reaver \
        bully \
        kismet \
        hostapd-mana
}

# Install OSINT tools
install_osint_tools() {
    log "Installing OSINT tools..."
    
    # Basic OSINT tools available in Alpine repos
    apk add \
        nmap \
        masscan \
        zmap \
        dmitry \
        dnsrecon \
        dnsenum \
        fierce \
        theharvester \
        recon-ng \
        maltego \
        spiderfoot \
        shodan \
        curl \
        wget \
        whois \
        dig \
        host \
        traceroute \
        mtr \
        netcat-openbsd \
        socat \
        proxychains-ng
    
    # Install Python3 and pip for additional OSINT tools
    apk add python3 python3-dev py3-pip
    
    # Install additional Python OSINT tools
    pip3 install \
        osrframework \
        social-analyzer \
        sherlock-project \
        photon \
        sublist3r \
        knockpy \
        dnspython \
        requests \
        beautifulsoup4 \
        selenium \
        shodan \
        censys \
        python-whois
}

# Install penetration testing tools
install_pentest_tools() {
    log "Installing penetration testing tools..."
    
    apk add \
        metasploit \
        ncrack \
        hydra \
        john \
        hashcat \
        sqlmap \
        nikto \
        dirb \
        gobuster \
        wfuzz \
        burpsuite \
        zaproxy \
        beef \
        armitage \
        exploitdb \
        searchsploit \
        responder \
        impacket \
        crackmapexec \
        enum4linux \
        smbclient \
        nbtscan \
        onesixtyone \
        snmpwalk \
        rpcclient \
        sslscan \
        sslyze \
        testssl \
        openvas \
        lynis \
        chkrootkit \
        rkhunter
}

# Install forensics and analysis tools
install_forensics_tools() {
    log "Installing forensics tools..."
    
    apk add \
        sleuthkit \
        autopsy \
        volatility \
        binwalk \
        foremost \
        scalpel \
        ddrescue \
        dc3dd \
        ewf-tools \
        afflib \
        hexedit \
        ghex \
        strings \
        file \
        exiftool \
        steghide \
        stegosuite \
        outguess \
        pdfcrack \
        fcrackzip \
        rarcrack
}

# Install development and reverse engineering tools
install_dev_tools() {
    log "Installing development and reverse engineering tools..."
    
    apk add \
        git \
        vim \
        nano \
        gcc \
        g++ \
        make \
        cmake \
        gdb \
        radare2 \
        ghidra \
        ida-free \
        objdump \
        readelf \
        strace \
        ltrace \
        ldd \
        hexdump \
        xxd \
        upx \
        yara \
        clamav \
        python3-dev \
        ruby \
        ruby-dev \
        go \
        nodejs \
        npm
}

# Install virtualization tools
install_virtualization() {
    log "Installing virtualization tools..."
    
    apk add \
        qemu \
        qemu-system-x86_64 \
        libvirt \
        virt-manager \
        docker \
        docker-compose
}

# Configure services
configure_services() {
    log "Configuring services..."
    
    # Enable and start essential services
    rc-update add networkmanager default
    rc-update add dbus default
    rc-update add consolekit default
    rc-update add cgmanager default
    rc-update add udev default
    rc-update add udev-settle default
    rc-update add udev-trigger default
    
    # Enable virtualization services
    rc-update add libvirtd default
    rc-update add docker default
    
    # Start NetworkManager
    service networkmanager start
    
    # Configure firewall
    iptables -F
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    
    # Save iptables rules
    /etc/init.d/iptables save
    rc-update add iptables default
}

# Create user and configure groups
setup_user() {
    log "Setting up user configuration..."
    
    # Prompt for username if not provided
    if [[ -z "$1" ]]; then
        read -p "Enter username for the new user: " USERNAME
    else
        USERNAME="$1"
    fi
    
    # Create user with home directory
    adduser -h /home/$USERNAME -s /bin/bash $USERNAME
    
    # Add user to important groups
    addgroup $USERNAME wheel
    addgroup $USERNAME audio
    addgroup $USERNAME video
    addgroup $USERNAME input
    addgroup $USERNAME netdev
    addgroup $USERNAME plugdev
    addgroup $USERNAME wireshark
    addgroup $USERNAME docker
    addgroup $USERNAME libvirt
    
    # Configure doas instead of sudo
    apk add doas
    echo "permit persist :wheel" >> /etc/doas.d/doas.conf
    
    info "User $USERNAME created and configured"
}

# Install additional security configurations
security_hardening() {
    log "Applying security hardening..."
    
    # Install and configure fail2ban
    apk add fail2ban
    rc-update add fail2ban default
    
    # Configure SSH (if installed)
    if [[ -f /etc/ssh/sshd_config ]]; then
        sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
        sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
        sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
    fi
    
    # Set up automatic updates
    apk add apk-cron
    rc-update add crond default
    echo "0 2 * * * apk update && apk upgrade" | crontab -
}

# Create desktop shortcuts and menu entries
create_shortcuts() {
    log "Creating desktop shortcuts..."
    
    # Create pentest menu directory
    mkdir -p /usr/share/applications/pentest
    
    # Create category desktop files for organized menu
    cat > /usr/share/applications/pentest/osint.desktop << EOF
[Desktop Entry]
Type=Application
Name=OSINT Tools
Comment=Open Source Intelligence Tools
Icon=applications-internet
Categories=Network;Security;
EOF

    cat > /usr/share/applications/pentest/network.desktop << EOF
[Desktop Entry]
Type=Application
Name=Network Tools
Comment=Network Analysis and Testing Tools
Icon=applications-internet
Categories=Network;Security;
EOF
}

# Main installation function
main() {
    log "Starting Alpine Linux OSINT/Pentesting Setup"
    
    check_root
    
    log "This script will install:"
    info "- XFCE Desktop Environment"
    info "- OSINT Tools (nmap, recon-ng, theharvester, etc.)"
    info "- Penetration Testing Tools (metasploit, burpsuite, etc.)"
    info "- Forensics Tools (volatility, sleuthkit, etc.)"
    info "- Development Tools (radare2, ghidra, etc.)"
    info "- Virtualization Tools (qemu, docker, etc.)"
    
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
    
    # Execute setup steps
    setup_repositories
    setup_xorg
    setup_desktop
    install_network_tools
    install_osint_tools
    install_pentest_tools
    install_forensics_tools
    install_dev_tools
    install_virtualization
    configure_services
    security_hardening
    create_shortcuts
    
    # Setup user
    setup_user "$1"
    
    log "Installation completed successfully!"
    warn "Please reboot the system to ensure all services start properly"
    info "After reboot, log in with your user account and start XFCE with: startx"
    
    echo
    log "Installed tools summary:"
    info "OSINT: nmap, recon-ng, theharvester, shodan, maltego, spiderfoot"
    info "Network: wireshark, aircrack-ng, kismet, ettercap, tcpdump"
    info "Pentest: metasploit, burpsuite, sqlmap, nikto, hydra, john"
    info "Forensics: volatility, sleuthkit, binwalk, autopsy"
    info "Reverse Engineering: radare2, ghidra, gdb, objdump"
    info "Virtualization: qemu, docker, libvirt"
    
    log "Setup completed! Reboot recommended."
}

# Run main function with all arguments
main "$@"

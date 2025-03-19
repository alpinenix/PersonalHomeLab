# This is my personal Configuration.nix, used specifically on my laptop. 
# This config contains packages and confs for Pentest/Network testing, my RTL-SDR, and general virt software. 
nixpkgs.overlays = [
    (self: super: {
      unstablePackages = import <nixos-unstable> {
        config = config.nixpkgs.config;
      };
    })
  ];{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {
    config = config.nixpkgs.config;
  };
in
{
  # Python packages for pentesting tools that might need them
  nixpkgs.config.packageOverrides = pkgs: {
    python3 = pkgs.python3.override {
      packageOverrides = python-self: python-super: {
        # Add any Python packages that might be needed for pentesting tools
        # For example:
        # pythonPkgs = python-self.pythonPackages;
      };
    };
  };

  # Allow Nix to find unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      # Add any packages that might be marked as insecure but are needed
      # For example: "openssl-1.0.2u"
    ];
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
      };
    };
    
    printing.enable = false;
  };

  environment.systemPackages = with pkgs; [
    wireshark
    nmap
    netcat
    tcpdump
    mtr
    iperf
    bind
    whois
    ethtool
    traceroute
    inetutils
    iw
    wavemon
    speedtest-cli
    dnsutils
    curl
    wget
    openssl
    bandwhich
    
    # Pentesting tools from unstable channel
    unstable.burpsuite
    unstable.zaproxy
    unstable.metasploit
    unstable.sqlmap
    unstable.hydra
    unstable.hashcat
    unstable.john
    unstable.aircrack-ng
    unstable.kismet
    unstable.wifite
    unstable.dirb
    unstable.nikto
    unstable.macchanger
    unstable.ettercap
    unstable.wireshark-cli
    unstable.ncrack
    unstable.sslscan
    unstable.masscan
    unstable.crackmapexec
    unstable.exploitdb
    unstable.gobuster
    unstable.recon-ng

    rtl-sdr
    gqrx
    gnuradio
    soapysdr
    soapyrtlsdr
    hackrf
    qsstv
    multimon-ng
    airspy
    limesuite
    cubicsdr
    
    remmina
    teamviewer
    tigervnc
    x11vnc
    barrier
    libvncserver
    wol
    synergy
    xrdp
    freerdp

    htop
    glances
    tmux
    screen
    git
    vim
    nano
    zsh
    bash
    rsync
    file
    lsof
    gnupg
    usbutils
    pciutils
    hdparm
    smartmontools
    killall
    psmisc

    xorg.xhost
    pavucontrol
    virt-manager
    wireshark-qt
  ];

  hardware = {
    rtl-sdr.enable = true;
    bluetooth.enable = true;
    pulseaudio.enable = true;
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 
        22
        3389
        5900
        24800
        5353
        8080
        8081
        4444
      ];
      allowedUDPPorts = [
        5353
        67
        68
      ];
    };
    
    networkmanager.enable = true;
  };

  users.users.YOUR_USERNAME = {
    extraGroups = [ 
      "wheel"
      "dialout"
      "plugdev"
      "wireshark"
      "networkmanager"
      "docker"
      "libvirtd"
      "kvm"
    ];
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2832", GROUP="plugdev", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2838", GROUP="plugdev", MODE="0666"
    
    ATTR{idVendor}=="1d50", ATTR{idProduct}=="6089", SYMLINK+="hackrf-one-%k", GROUP="plugdev", MODE="0666"
    
    ATTR{idVendor}=="1d50", ATTR{idProduct}=="60a1", SYMLINK+="airspy-%k", GROUP="plugdev", MODE="0666"
  '';

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        runAsRoot = false;
      };
    };
    podman.enable = true;
  };
}

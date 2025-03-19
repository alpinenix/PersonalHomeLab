# This is my personal Configuration.nix, used specifically on my laptop. 
# This config contains packages and confs for Pentest/Network testing, my RTL-SDR, and general virt software. 

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/boot/crypto_keyfile.bin" = null;
  };

  boot.loader.grub.enableCryptodisk = true;

  boot.initrd.luks.devices."luks-6xxxxxxxxxxxxx".keyFile = "/boot/crypto_keyfile.bin";
  networking.hostName = "tetomikulaptop";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant. (This is handled with networkmanager so... no)


  boot.kernelParams = [ "modprobe.blacklist=dvb_usb_rtl28xxu" ]; # blacklist this module

  services.udev.packages = [ pkgs.rtl-sdr ];
    
  hardware.rtl-sdr.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = false;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  
  users.users.jaming = {
    isNormalUser = true;
    description = "jaming";
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
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    librewolf
    sdrpp
    libusb1
    pkgs.rtl-sdr
    gqrx

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
    
    burpsuite
    zap
    metasploit
    sqlmap
    hydra
    hashcat
    john
    aircrack-ng
    kismet
    wifite2
    dirb
    nikto
    macchanger
    ettercap
    wireshark-cli
    ncrack
    sslscan
    masscan
    netexec
    exploitdb
    gobuster
    
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
    x11vnc
    barrier
    libvncserver
    wol
    synergy
    xrdp
    freerdp

    htop
    btop
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
    ventoy-full

    xorg.xhost
    pavucontrol
    virt-manager
    wireshark-qt
    
  ];

  networking.firewall = {
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

  services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
      };
    };

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2832", GROUP="plugdev", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2838", GROUP="plugdev", MODE="0666"
    
    ATTR{idVendor}=="1d50", ATTR{idProduct}=="6089", SYMLINK+="hackrf-one-%k", GROUP="plugdev", MODE="0666"
    
    ATTR{idVendor}=="1d50", ATTR{idProduct}=="60a1", SYMLINK+="airspy-%k", GROUP="plugdev", MODE="0666"
  '';

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
  
  system.stateVersion = "24.11"; # Did you read the comment? HA... no

}

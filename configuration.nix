{ config, pkgs, ... }:

{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # === Programs ===

  # programs.niri.enable = true;

  programs.dconf.enable = true;
  programs.fish.enable = true;
  # programs.xwayland.enable = true;  
  programs.git.enable = true;
  programs.steam.enable = true;
  programs.gamemode.enable = true; 
  virtualisation.virtualbox.host.enable = true;

  # === Packages === 
  environment.systemPackages = with pkgs; [
     
     # = Dev =
     vscode.fhs
     neovim
     yazi
     arduino-ide
     tree-sitter
     nodejs
     jdk21
     jdt-language-server
     jetbrains.idea
     python3          
     python3Packages.pip 

     # = Applications = 
     firefox
     nautilus
     discord
     spotify-player
     gnome-text-editor
    
     # = Essentials = 
     gnome-tweaks
     gnome-extension-manager
     papirus-icon-theme
     ghostty
     nwg-displays
     networkmanagerapplet
     gcc
     pavucontrol
     blueman
     wget
     unzip     
     zip 
     gnutar
     gzip
     libnotify
     zoxide
     tmux
     gpu-screen-recorder

     # = Gaming = 
     protonup-qt   
     protontricks    
     
     # = Theming = 
     fastfetch
     nwg-look
  ];
  
  environment.extraInit = ''
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
  '';

  # === Services ===

  services.power-profiles-daemon.enable = true; 
  security.polkit.enable = true;   
  services.blueman.enable = true;
  services.upower.enable = true;  
  services.gvfs.enable = true;
  services.udisks2.enable = true; 
  services.openssh.enable = true;
  

  # === Themeing === 

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;  

  # === User ===
 
  # = Define a user account =
  users.users."kei" = {
    isNormalUser = true;
    description = "Kei Farouk";
    extraGroups = [ "networkmanager" "wheel" "video" "dialout" ];
    shell = pkgs.fish;
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKrF+siRa7198mKVcgE/5+Da7rChaDkj116DjnEiWAy/ kei@Trisium"
    ];
  };

  # = Passwordless sudo = 
  security.sudo.extraRules = [
    {
      users = [ "kei" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # === Hardware ===

  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;  

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # === Settings ===

  # = Enable flakes = 
  nix.settings.experimental-features = [ "nix-command" "flakes" ];  

  time.timeZone = "Africa/Johannesburg";

  # = Configure keymap in X11 = 
  services.xserver.xkb = {
    layout = "za";
    variant = "";
  };
  
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # = Allow unfree packages = 
  nixpkgs.config.allowUnfree = true;

  # = Select internationalisation properties =
  i18n.defaultLocale = "en_GB.UTF-8";

  # === Bootloader ===
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # === Network ===

  networking.networkmanager.enable = true;
  networking.hostName = "Trisium";

  # === Drivers ===

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true; 
  };

  hardware.nvidia = {
    # Modesetting is required for most modern setups (Wayland especially)
    modesetting.enable = true;

    # Power management — helps with suspend/resume on laptops
    powerManagement.enable = true;
    powerManagement.finegrained = false; # only for Turing+ with proper PRIME support, test later

    # Use the open kernel module if your GPU supports it (Turing+, so RTX 3050 qualifies)
    open = true;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
    # Use offload mode: AMD iGPU renders by default, NVIDIA only kicks in per-app
    offload = {
      enable = true;
      enableOffloadCmd = true; # gives you a `nvidia-offload` command
    };

    amdgpuBusId = "PCI:5:0:0";   
    nvidiaBusId = "PCI:1:0:0";   
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; 

}

{ config, pkgs, ... }:

{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # === Programs ===

  # programs.niri.enable = true;

  programs.dconf.enable = true;
  programs.niri.enable = true;
  programs.fish.enable = true;
  programs.xwayland.enable = true;  
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
     (python3.withPackages (ps: with ps; [
       pip
       numpy
       matplotlib
       scipy
     ]))
   
     # = Applications = 
     nautilus
     discord
     spotify-player
     gnome-text-editor   
     firefox
     blanket
     libreoffice
     typora
    
     # = Essentials = 
     gnome-tweaks
     gnome-extension-manager
     papirus-icon-theme
     ghostty
     nwg-displays
     networkmanagerapplet
     gcc
     cmake
     gnumake
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
     xwayland-satellite
     btop
     tree
     wev
     keyd

     # = Gaming = 
     protonup-qt   
     protontricks    
     gamemode                                                                                       
     prismlauncher     

     # = Theming = 
     fastfetch
     nwg-look
     awww
     noctalia-shell
  ];

  # Dsecribes default GTK apps for some apps (Vbox) to open   
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

  # keyd rebind for gamedia keyboard
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            leftalt = "leftmeta";
            leftmeta = "leftalt";
            rightalt = "leftalt";
          };
        };
      };
    };
  };
	
  
  # === Themeing === 

#  services.xserver.enable = true;
#  services.xserver.displayManager.gdm.enable = true;
#  services.xserver.desktopManager.gnome.enable = true;  

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

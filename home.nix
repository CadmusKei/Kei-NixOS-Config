{ config, lib, pkgs, inputs, ... }:
{
  home.stateVersion = "26.05";

  gtk = {
    enable = true;
    iconTheme = {
      name = "Yaru";
      package = pkgs.yaru-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = lib.mkForce "gtk";
  };

  programs.bat.enable = true;

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      username = {
        style_user = "bold #C0394A";
        style_root = "bold #C0394A";
        format = "[$user]($style)";
        show_always = true;
      };
      hostname = {
        ssh_only = false;
        style = "bold #C0394A";
        format = "[@$hostname]($style) ";
      };
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      icon-theme = "Yaru";
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
      toggle-fullscreen = [ "<Super>f" ];
    };
  };

  home.packages = [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.antigravity.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
    inputs.notion-desktop.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.quickshell
  ];
}

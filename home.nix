{ config, lib, pkgs, inputs, ... }:
{
  home.stateVersion = "26.05";

  gtk.enable = true;
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

  programs.kitty = {
    enable = true;
    extraConfig = ''
      window_padding_width 25
      hide_window_decorations yes
      confirm_os_window_close 0
    '';
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
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
    };
  };

  home.packages = [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.quickshell
  ];
}

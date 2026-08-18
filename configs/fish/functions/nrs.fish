function nrs --wraps='sudo nixos-rebuild --switch /etc/nixos#nixos' --wraps='sudo nixos-rebuild switch --flake /etc/nixos#nixos' --description 'alias nrs=sudo nixos-rebuild switch --flake /etc/nixos#nixos'
    sudo nixos-rebuild switch --flake /etc/nixos#nixos $argv
end

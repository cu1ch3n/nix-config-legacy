{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    ./alacritty
    ./autorandr
    ./chromium
    ./exa
    ./fzf
    ./git
    ./micro
    ./nix-index
    ./nnn
    ./opam
    ./rime
    ./rofi
    ./ssh
    ./vscode
    ./xmonad
    ./zoxide
    ./zsh
  ];

  programs = {
    home-manager.enable = true;
    emacs.enable = true;
    feh.enable = true;
    firefox.enable = true;
    obs-studio.enable = true;
    sioyek.enable = true;
    tmux.enable = true;
    vim.enable = true;
  };
}

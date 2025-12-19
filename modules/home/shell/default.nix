{...}: {
  imports = [
    ./zsh.nix
    ./zsh_alias.nix
    ./zsh_keybinds.nix
    ./p10k.nix # this thing on the shell that looks cool
    ./fzf.nix # shell fuzzy finder (ctrl + r)
    ./bat.nix # better cat, less, man
    ./direnv.nix
  ];
}

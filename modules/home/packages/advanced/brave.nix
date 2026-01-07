{pkgs, ...}: {
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
      {id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp";} # Privacy Badger
    ];
  };
}

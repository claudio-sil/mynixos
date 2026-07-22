{ self, inputs, ... }: {
  flake.nixosModules.files = { pkgs, ... }: {
    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
        "ffmpeg-full"
      ];
    };

    environment.systemPackages = with pkgs; [
      kdePackages.dolphin
      yazi
      kdePackages.kio-extras
      kdePackages.ffmpegthumbs
      (ffmpeg-full.override { withUnfree = true; })
      p7zip          # 7-Zip (non-standalone)
      jq
      poppler-utils  # PDF preview
      fd
      ripgrep
      fzf
      zoxide
      resvg
      imagemagick
      fastfetch
      wl-clipboard   # Wayland clipboard (you're on Wayland)
    ];
  };
}

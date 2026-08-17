{ self, inputs, ... }: {
  flake.nixosModules.secrets = { config, ... }: {
    imports = [ inputs.sops-nix.nixosModules.sops ];

    # Each host decrypts using its own dedicated age key, generated
    # once via `age-keygen` and stored at /var/lib/sops-nix/key.txt
    # (root-only, never committed to git). Claudio's personal SSH key
    # is also a recipient in .sops.yaml, so `sops secrets.yaml` can be
    # edited directly from mictlan too.
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    sops.defaultSopsFile = ../../secrets.yaml;

    sops.secrets.github_token = {};

    # nix.conf doesn't support Nix-eval-time secrets directly (it's a
    # static file generated at build time), so the token is rendered
    # into a small runtime-only snippet and pulled in via `!include`.
    sops.templates."nix-github-token.conf" = {
      content = ''
        access-tokens = github.com=${config.sops.placeholder.github_token}
      '';
    };

    nix.extraOptions = ''
      !include ${config.sops.templates."nix-github-token.conf".path}
    '';
  };
}

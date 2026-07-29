{ self, inputs, ... }: {
  flake.nixosModules.llm = { pkgs, config, lib, ... }: {

    services.ollama = {
      enable = true;
      package = pkgs.ollama.override { acceleration = "cuda"; };
    };

    services.open-webui = {
      enable = true;
      port = 11111;
      environment = {
        OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
      };
    };

    environment.systemPackages = with pkgs; [
      aichat
      oterm
    ];
  };
}

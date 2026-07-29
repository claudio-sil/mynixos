{ self, inputs, ... }: {
  flake.nixosModules.llm = { pkgs, config, lib, ... }: {

    # Enable CUDA support for Ollama backend
    services.ollama = {
      enable = true;
      acceleration = "cuda";
    };

    # ChatGPT-style web UI running locally
    services.open-webui = {
      enable = true;
      port = 11111;
      environment = {
        OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
      };
    };

    # Useful CLI tools for terminal usage & scripting
    environment.systemPackages = with pkgs; [
      aichat
      oterm
    ];
  };
}

{ self, inputs, ... }: {
  flake.nixosModules.llm = { pkgs, config, lib, ... }: {

    # Enable Ollama with NVIDIA CUDA support
    services.ollama = {
      enable = true;
      package = pkgs.ollama-cuda; # <--- Changed here
    };

    # ChatGPT-style web UI running locally
    services.open-webui = {
      enable = true;
      port = 11111;
      environment = {
        OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
      };
    };

    # Terminal CLI tools
    environment.systemPackages = with pkgs; [
      aichat
      oterm
    ];
  };
}

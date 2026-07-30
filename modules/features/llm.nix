{ self, inputs, ... }: {
  flake.nixosModules.llm = { pkgs, config, lib, ... }: {

    services.ollama = {
      enable = true;
      package = pkgs.ollama-vulkan;
      environmentVariables = {
        # Optional: automatically unload idle models from VRAM after 2 mins
        OLLAMA_KEEP_ALIVE = "2m";
      };
    };

    # Stop Ollama before sleep to release the GPU Vulkan context,
    # enabling smooth display wake on Niri/Wayland.
    systemd.services.ollama = {
      unitConfig = {
        Conflicts = [ "sleep.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
        Before = [ "sleep.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
      };
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

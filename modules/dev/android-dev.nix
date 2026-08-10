{ self, inputs, ... }:

{
  perSystem =
    { pkgs, ... }:

    let
      androidComposition = pkgs.androidenv.composeAndroidPackages {
        platformVersions = [ "35" "36" ];
        buildToolsVersions = [ "35.0.0" "36.0.0" ];

        includeEmulator = false;
        includeSystemImages = false;
        includeNDK = false;
      };

      androidSdk = androidComposition.androidsdk;
      sdkRoot = "${androidSdk}/libexec/android-sdk";
    in
    {
      devShells.android = pkgs.mkShell {
        name = "android-dev";

        packages = with pkgs; [
          android-studio
          androidSdk
          android-tools
          jdk17
        ];

        ANDROID_HOME = sdkRoot;
        ANDROID_SDK_ROOT = sdkRoot;
        JAVA_HOME = pkgs.jdk17.home;

        # Force Gradle to use the aapt2 supplied by the Nix Android SDK.
        GRADLE_OPTS =
          "-Dorg.gradle.project.android.aapt2FromMavenOverride=${sdkRoot}/build-tools/36.0.0/aapt2";

        shellHook = ''
          echo
          echo "Android development environment active"
          echo "  SDK:  $ANDROID_SDK_ROOT"
          echo "  Java: $JAVA_HOME"
          echo
          echo "Start Android Studio with: android-studio ."
          echo "List connected devices with: adb devices"
          echo
        '';
      };
    };
}

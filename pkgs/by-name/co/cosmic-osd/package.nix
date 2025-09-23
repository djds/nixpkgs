{
  lib,
  fetchFromGitHub,
  sound-theme-freedesktop,
  rustPlatform,
  libcosmicAppHook,
  libinput,
  pipewire,
  pulseaudio,
  udev,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-osd";
  version = "1.0.0-beta.1";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-osd";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-+NwsMCOZeZlPcVVQv3WzRj8vAM8P8qPGsOMaTACVEFQ=";
  };

  patches = [
    ./patches/play_audio_volume_change.patch
  ];

  postPatch = ''
    substituteInPlace src/components/app.rs \
      --replace-fail 'SOUND-THEME-FREEDESKTOP' '${sound-theme-freedesktop}'
  '';

  cargoHash = "sha256-YcNvvK+Zf8nSS5YjS5iaoipogstiyBdNY7LhWPsz9xQ=";

  nativeBuildInputs = [
    libcosmicAppHook
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libinput
    pipewire
    pulseaudio
    udev
  ];

  env.POLKIT_AGENT_HELPER_1 = "/run/wrappers/bin/polkit-agent-helper-1";

  passthru = {
    tests = {
      inherit (nixosTests)
        cosmic
        cosmic-autologin
        cosmic-noxwayland
        cosmic-autologin-noxwayland
        ;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "unstable"
        "--version-regex"
        "epoch-(.*)"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-osd";
    description = "OSD for the COSMIC Desktop Environment";
    mainProgram = "cosmic-osd";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
  };
})

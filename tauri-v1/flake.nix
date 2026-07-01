{

  description = "@ign-var:DESCRIPTION@";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    git-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      flake-utils,
      git-hooks,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        pkgs-unstable = import nixpkgs-unstable { inherit system; };
        lib = pkgs.lib;

        linuxGuiLibraries = with pkgs; [
          atk
          cairo
          gdk-pixbuf
          glib
          gtk3
          libsoup_3
          pango
          webkitgtk_4_1
        ];

        commonBuildInputs = with pkgs; [
          openssl
          pkg-config
        ]
        ++ lib.optionals pkgs.stdenv.isLinux linuxGuiLibraries
        ++ lib.optionals pkgs.stdenv.isDarwin [
          darwin.apple_sdk.frameworks.AppKit
          darwin.apple_sdk.frameworks.Cocoa
          darwin.apple_sdk.frameworks.CoreFoundation
          darwin.apple_sdk.frameworks.CoreServices
          darwin.apple_sdk.frameworks.Foundation
          darwin.apple_sdk.frameworks.Security
          darwin.apple_sdk.frameworks.SystemConfiguration
          darwin.apple_sdk.frameworks.WebKit
        ];

        preCommitCheck = git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            gitleaks = {
              enable = true;
              name = "gitleaks";
              entry = "${pkgs.lib.getExe pkgs.gitleaks} git --pre-commit --redact --staged --verbose";
              language = "system";
              pass_filenames = false;
            };
          };
        };

        devPackages = (with pkgs; [
          fd
          gh
          gitleaks
          gnused
          go-task
          pkg-config
          rust-analyzer
          rustup
        ])
        ++ (with pkgs-unstable; [
          biome
          bun
          typescript
          typescript-language-server
        ])
        ++ preCommitCheck.enabledPackages;
      in
      {
        checks.pre-commit-check = preCommitCheck;

        devShells.default = pkgs.mkShell {
          packages = devPackages;
          buildInputs = commonBuildInputs;

          shellHook = ''
            ${preCommitCheck.shellHook}

            echo "Tauri development environment ready"
            echo "Biome version: $(biome --version 2>/dev/null || echo 'not available')"
            echo "Bun version: $(bun --version)"
            echo "Rust version: $(rustc --version)"
            echo "Task version: $(task --version 2>/dev/null || echo 'not available')"
            echo "Gitleaks version: $(gitleaks version 2>/dev/null || echo 'not available')"
          '';
        };
      }
    );
}

{
  description = "@ign-var:PROJECT_NAME={current_dir}@ iOS app development environment";

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
        unstablePkgs = import nixpkgs-unstable { inherit system; };
        lib = pkgs.lib;

        runtimePackages =
          with pkgs;
          [
            git
            go-task
            python3
            unstablePkgs.fastlane
            unstablePkgs.ruby_3_4
          ]
          ++ lib.optionals pkgs.stdenv.isDarwin [
            swiftlint
          ]
          ++ lib.optionals pkgs.stdenv.isLinux [
            swift
          ];

        devOnlyPackages = with pkgs; [
          gitleaks
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

        devPackages = runtimePackages ++ devOnlyPackages ++ preCommitCheck.enabledPackages;
      in
      {
        packages.dev-tools = pkgs.buildEnv {
          name = "@ign-var:PROJECT_NAME={current_dir}@-dev-tools";
          paths = devPackages;
          pathsToLink = [ "/bin" ];
        };

        checks.pre-commit-check = preCommitCheck;

        # On Darwin, use mkShellNoCC so Nix apple-sdk setup hooks stay out of
        # the shell. iOS builds use the selected Xcode toolchain.
        devShells.default = (if pkgs.stdenv.isDarwin then pkgs.mkShellNoCC else pkgs.mkShell) {
          packages = devPackages;

          shellHook = ''
            ${preCommitCheck.shellHook}
            ${lib.optionalString pkgs.stdenv.isDarwin ''
              unset SDKROOT
              if [ -x /Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild ]; then
                export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
              else
                unset DEVELOPER_DIR
              fi
            ''}

            echo "@ign-var:PROJECT_NAME={current_dir}@ iOS development environment ready"
            echo "Swift version: $(swift --version 2>/dev/null | head -n 1 || echo 'not available')"
            echo "Task version: $(task --version 2>/dev/null || echo 'not available')"
            echo "Python version: $(python3 --version 2>/dev/null || echo 'not available')"
            echo "Ruby version: $(ruby --version 2>/dev/null || echo 'not available')"
            echo "Fastlane version: $(fastlane --version 2>/dev/null | tail -n 1 || echo 'not available')"
            echo "SwiftLint version: $(swiftlint version 2>/dev/null || echo 'not available')"
            echo "Gitleaks version: $(gitleaks version 2>/dev/null || echo 'not available')"
          '';
        };
      }
    );
}

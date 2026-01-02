{

  description = "@ign-var:DESCRIPTION=A Rust project@";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crane = {
      url = "github:ipetkov/crane/v0.17.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      flake-utils,
      fenix,
      crane,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ fenix.overlays.default ];
        pkgs = import nixpkgs { inherit system overlays; };
        pkgs-unstable = import nixpkgs-unstable { inherit system; };

        rust-components = fenix.packages.${system}.fromToolchainFile {
          file = ./rust-toolchain.toml;
          sha256 = pkgs.lib.fakeSha256;
        };

        craneLib = (crane.mkLib pkgs).overrideToolchain rust-components;

        # Common build inputs
        commonBuildInputs = with pkgs; [
          openssl
          pkg-config
        ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
          darwin.apple_sdk.frameworks.Security
          darwin.apple_sdk.frameworks.SystemConfiguration
        ];

        # Build the crate
        @ign-var:PROJECT_NAME@-crate = craneLib.buildPackage {
          pname = "@ign-var:PROJECT_NAME@";
          version = "0.1.0";
          src = craneLib.cleanCargoSource ./.;
          buildInputs = commonBuildInputs;
          nativeBuildInputs = with pkgs; [ pkg-config ];
        };

        devPackages = with pkgs; [
          fd
          gnused
          rust-components
          rust-analyzer
          netcat-gnu
          pkgs-unstable.docker
          openssl
          pkg-config
          taplo
          gh
          go-task
        ];

      in
      {
        checks = {
          inherit @ign-var:PROJECT_NAME@-crate;

          clippy = craneLib.cargoClippy {
            pname = "@ign-var:PROJECT_NAME@-clippy";
            version = "0.1.0";
            src = craneLib.cleanCargoSource ./.;
            buildInputs = commonBuildInputs;
            nativeBuildInputs = with pkgs; [ pkg-config ];
            cargoClippyExtraArgs = "--all-targets -- -D warnings";
          };

          fmt = craneLib.cargoFmt {
            pname = "@ign-var:PROJECT_NAME@-fmt";
            version = "0.1.0";
            src = craneLib.cleanCargoSource ./.;
          };
        };

        packages = {
          default = @ign-var:PROJECT_NAME@-crate;
          @ign-var:PROJECT_NAME@ = @ign-var:PROJECT_NAME@-crate;
        };

        apps = {
          default = {
            type = "app";
            program = "${@ign-var:PROJECT_NAME@-crate}/bin/@ign-var:PROJECT_NAME@";
          };
        };

        devShells.default = craneLib.devShell {
          checks = self.checks.${system};
          packages = devPackages;
          buildInputs = commonBuildInputs;

          shellHook = ''
            echo "Rust development environment ready"
            echo "Rust version: $(rustc --version)"
            echo "Cargo version: $(cargo --version)"
            echo "Task version: $(task --version 2>/dev/null || echo 'not available')"
          '';
        };
      }
    );
}

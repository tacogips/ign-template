{

  description = "@ign-var:DESCRIPTION=A Golang project@";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      # Single source of truth for version
      version = builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile ./internal/build/VERSION);
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        packages = {
          @ign-var:PROJECT_NAME@ = pkgs.buildGoModule {
            pname = "@ign-var:PROJECT_NAME@";
            inherit version;
            src = ./.;
            vendorHash = null;
            subPackages = [ "cmd/@ign-var:PROJECT_NAME@" ];
            ldflags = [
              "-s"
              "-w"
              "-X @ign-var:MODULE_PATH@/internal/build.version=${version}"
            ];
            meta = with pkgs.lib; {
              description = "@ign-var:DESCRIPTION@";
              homepage = "@ign-var:HOMEPAGE=https://github.com/user/repo@";
              license = licenses.mit;
              maintainers = [ ];
            };
          };

          default = self.packages.${system}.@ign-var:PROJECT_NAME@;
        };

        apps = {
          @ign-var:PROJECT_NAME@ = {
            type = "app";
            program = "${self.packages.${system}.@ign-var:PROJECT_NAME@}/bin/@ign-var:PROJECT_NAME@";
          };

          default = self.apps.${system}.@ign-var:PROJECT_NAME@;
        };

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            go
            gopls
            gotools
            golangci-lint
            go-task
          ];

          shellHook = ''
            export GOPATH="$HOME/.cache/go/@ign-var:MODULE_PATH@"
            export GOMODCACHE="$HOME/.cache/go/mod"
            mkdir -p "$GOPATH" "$GOMODCACHE"
            echo "Go development environment ready"
            echo "GOPATH: $GOPATH"
            echo "GOMODCACHE: $GOMODCACHE"
            echo "Go version: $(go version)"
            echo "Task version: $(task --version)"
            echo "golangci-lint version: $(golangci-lint --version)"
          '';
        };
      }
    );
}

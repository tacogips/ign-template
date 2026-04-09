{

  description = "@ign-var:DESCRIPTION=A general investigation workspace@";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            agent-browser
            playwright-cli
            go-task
          ];

          shellHook = ''
            echo "General investigation environment ready"
            echo "agent-browser: $(command -v agent-browser || echo 'not available')"
            echo "Playwright: $(playwright --version 2>/dev/null || echo 'not available')"
            echo "Task: $(task --version 2>/dev/null || echo 'not available')"
          '';
        };
      }
    );
}

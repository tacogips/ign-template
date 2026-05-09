{

  description = "@ign-var:DESCRIPTION=A general investigation workspace@";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    git-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      git-hooks,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
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
      in
      {
        checks.pre-commit-check = preCommitCheck;

        devShells.default = pkgs.mkShell {
          packages = (with pkgs; [
            agent-browser
            playwright-cli
            go-task
            gitleaks
          ]) ++ preCommitCheck.enabledPackages;

          shellHook = ''
            ${preCommitCheck.shellHook}

            echo "General investigation environment ready"
            echo "agent-browser: $(command -v agent-browser || echo 'not available')"
            echo "Playwright: $(playwright --version 2>/dev/null || echo 'not available')"
            echo "Task: $(task --version 2>/dev/null || echo 'not available')"
            echo "Gitleaks version: $(gitleaks version 2>/dev/null || echo 'not available')"
          '';
        };
      }
    );
}

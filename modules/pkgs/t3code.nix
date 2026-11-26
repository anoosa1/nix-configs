# modules/pkgs/t3code.nix
#
# nixpkgs' t3code lags upstream releases, so rebuild its derivation from the
# latest tag. Bump `version` and refresh both hashes to update.
{
  perSystem = { pkgs, ... }: let
    version = "0.1.11";

    unwrapped = pkgs.t3code.unwrapped.overrideAttrs (finalAttrs: prev: {
      inherit version;

      src = pkgs.fetchFromGitHub {
        owner = "pingdotgg";
        repo = "t3code";
        tag = "v${version}";
        hash = "sha256-oI8gyTWFgtTmVK+0cVQaEcfO8EzxUUOW5s8JFG/z/U8=";
      };

      pnpmDeps = prev.pnpmDeps.overrideAttrs {
        inherit (finalAttrs) src version;
        outputHash = "sha256-s/vm8Ox4o/AYpNC/amYP1KFWwh7SY5bCmVBuIJn9f/c=";
      };
    });
  in {
    packages.t3code = pkgs.t3code.override {
      t3code-unwrapped = unwrapped;
    };
  };
}

# Tools that are not in Nixpkgs. Bump a version: change `version`, set both
# hashes to lib.fakeHash, then build and paste the "got:" hashes back in.
{ lib, callPackage }:

let
  mkAxi = callPackage ./mk-axi.nix { };
in
{
  gh-axi = mkAxi {
    pname = "gh-axi";
    version = "0.1.44";
    srcHash = "sha256-uRGzQDynPe5k6jfi6l24XbxPvfFr1VFnuSqtrXLL6UE=";
    depsHash = "sha256-Ps93wg2mN1g1Rq4SY1FuNh8g9CF3o1WjCtioBWLcogU=";
    entry = "dist/bin/gh-axi.js";
    description = "AXI-compliant gh CLI wrapper for AI agents";
  };
  lavish-axi = mkAxi {
    pname = "lavish-axi";
    version = "0.1.94";
    srcHash = "sha256-9IsDqJ0nso0U1CgSJYmiMOeAAnksuqzCZhDswB19Sa4=";
    depsHash = "sha256-g1MZOKo3DR4x9qGgxEN2Ab9YhQkQcOTupsr3mXtkr4w=";
    entry = "dist/cli.mjs";
    build = "node scripts/build.js";
    description = "Turn agent responses into reviewable HTML artifacts";
  };
  quota-axi = mkAxi {
    pname = "quota-axi";
    version = "0.1.68";
    srcHash = "sha256-y0/qtt9kt46ZbRsCv1uiBl2n2wYfjVR+8Nu51Swd9Ho=";
    depsHash = "sha256-hyIFKoiIGiulwW6EW74j8136gduDbaEoZ6gQVfAcONw=";
    entry = "dist/bin/quota-axi.js";
    description = "Report local AI provider quota windows";
  };
  chrome-devtools-axi = mkAxi {
    pname = "chrome-devtools-axi";
    version = "0.1.45";
    srcHash = "sha256-Hn1K7G3L6Xg6yY62NCLfVYSnIetcZMDRdrncmk19Dzs=";
    depsHash = "sha256-bkR7KrArylGtteCEwBSQeMsi0J2CJvdMV3TCATPwWt4=";
    entry = "dist/bin/chrome-devtools-axi.js";
    description = "Control a Chrome session through Chrome DevTools for AI agents";
  };
}

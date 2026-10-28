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
    depsHash = "sha256-2vlp9u0I8gb5/VGEQwS9Z57/wOMzV+YW6U+/JL482d0=";
    entry = "dist/bin/gh-axi.js";
    description = "AXI-compliant gh CLI wrapper for AI agents";
  };
  lavish-axi = mkAxi {
    pname = "lavish-axi";
    version = "0.1.94";
    srcHash = "sha256-9IsDqJ0nso0U1CgSJYmiMOeAAnksuqzCZhDswB19Sa4=";
    depsHash = "sha256-kZ//hT7zRQWt/fdd9Wj3NF6Napmrr6L7YVmXbRLVJ2Q=";
    entry = "dist/cli.mjs";
    build = "node scripts/build.js";
    # Upstream sets trustPolicy: no-downgrade, which pnpm 11.27 trips over on these two.
    # Checked 2026-10-28: both are published by the packages' own maintainers (paulmillr,
    # msujew), are 9+ months old, and the lockfile integrity matches the npm registry.
    trustPolicyExclude = [ "chokidar@4.0.3" "langium@3.3.1" ];
    description = "Turn agent responses into reviewable HTML artifacts";
  };
  quota-axi = mkAxi {
    pname = "quota-axi";
    version = "0.1.68";
    srcHash = "sha256-y0/qtt9kt46ZbRsCv1uiBl2n2wYfjVR+8Nu51Swd9Ho=";
    depsHash = "sha256-4iAS1TcOzgMexlcMMREhiq+RUC81sv7lm6tFdERYdOI=";
    entry = "dist/bin/quota-axi.js";
    description = "Report local AI provider quota windows";
  };
  chrome-devtools-axi = mkAxi {
    pname = "chrome-devtools-axi";
    version = "0.1.45";
    srcHash = "sha256-Hn1K7G3L6Xg6yY62NCLfVYSnIetcZMDRdrncmk19Dzs=";
    depsHash = "sha256-MhpAmNmUAB8M0p8AlJpw80iRgWIdvKOjv88XAjFqYaU=";
    entry = "dist/bin/chrome-devtools-axi.js";
    description = "Control a Chrome session through Chrome DevTools for AI agents";
  };
}

{ lib, stdenv, fetchFromGitHub, nodejs, pnpm_10, fetchPnpmDeps, pnpmConfigHook, makeWrapper }:

stdenv.mkDerivation (finalAttrs: {
  pname = "gh-axi";
  version = "0.1.44";

  src = fetchFromGitHub {
    owner = "kunchenguid";
    repo = "gh-axi";
    tag = "gh-axi-v${finalAttrs.version}";
    hash = "sha256-uRGzQDynPe5k6jfi6l24XbxPvfFr1VFnuSqtrXLL6UE=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-Ps93wg2mN1g1Rq4SY1FuNh8g9CF3o1WjCtioBWLcogU=";
  };

  nativeBuildInputs = [ nodejs pnpm_10 pnpmConfigHook makeWrapper ];

  buildPhase = ''
    runHook preBuild
    pnpm exec tsc
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/gh-axi $out/bin
    cp -r dist package.json $out/lib/gh-axi/
    pnpm prune --prod --ignore-scripts
    cp -r node_modules $out/lib/gh-axi/
    makeWrapper ${nodejs}/bin/node $out/bin/gh-axi \
      --add-flags $out/lib/gh-axi/dist/bin/gh-axi.js
    runHook postInstall
  '';

  meta = {
    description = "AXI-compliant gh CLI wrapper for AI agents";
    homepage = "https://github.com/kunchenguid/gh-axi";
    license = lib.licenses.mit;
    mainProgram = "gh-axi";
  };
})

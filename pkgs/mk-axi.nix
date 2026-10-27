# Builds one of kunchenguid's npm-only "*-axi" CLIs from its GitHub release tag.
# pnpm_10 on purpose: the default pnpm 11.9 is killed in the macOS build sandbox.
{ lib, stdenv, fetchFromGitHub, nodejs, pnpm_10, fetchPnpmDeps, pnpmConfigHook, makeWrapper }:

{ pname, version, srcHash, depsHash, entry, description, build ? "pnpm exec tsc" }:

stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "kunchenguid";
    repo = pname;
    tag = "${pname}-v${version}";
    hash = srcHash;
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = depsHash;
  };

  nativeBuildInputs = [ nodejs pnpm_10 pnpmConfigHook makeWrapper ];

  buildPhase = ''
    runHook preBuild
    ${build}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/${pname} $out/bin
    cp -r dist package.json $out/lib/${pname}/
    pnpm prune --prod --ignore-scripts
    cp -r node_modules $out/lib/${pname}/
    makeWrapper ${nodejs}/bin/node $out/bin/${pname} \
      --add-flags $out/lib/${pname}/${entry}
    runHook postInstall
  '';

  meta = {
    inherit description;
    homepage = "https://github.com/kunchenguid/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
  };
})

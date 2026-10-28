# Builds one of kunchenguid's npm-only "*-axi" CLIs from its GitHub release tag.
# Pinned to pnpm_11: pnpm_10 is marked insecure in current Nixpkgs, and pnpm 11.9
# was killed in the macOS build sandbox (11.27 builds fine).
{ lib, stdenv, fetchFromGitHub, applyPatches, nodejs, pnpm_11, fetchPnpmDeps, pnpmConfigHook, makeWrapper }:

{ pname, version, srcHash, depsHash, entry, description, build ? "pnpm exec tsc"
# Packages whose pnpm trustPolicy check must be skipped; each one needs a stated reason at the call site.
, trustPolicyExclude ? [ ]
}:

stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src =
    let
      upstream = fetchFromGitHub {
        owner = "kunchenguid";
        repo = pname;
        tag = "${pname}-v${version}";
        hash = srcHash;
      };
    in
    if trustPolicyExclude == [ ] then upstream else applyPatches {
      src = upstream;
      # Shared by the dependency fetch and the build, so both see the same policy.
      postPatch = ''
        {
          echo "trustPolicyExclude:"
          ${lib.concatMapStringsSep "\n" (e: "echo \"  - '${e}'\"") trustPolicyExclude}
        } >> pnpm-workspace.yaml
      '';
    };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 3;
    hash = depsHash;
  };

  nativeBuildInputs = [ nodejs pnpm_11 pnpmConfigHook makeWrapper ];

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

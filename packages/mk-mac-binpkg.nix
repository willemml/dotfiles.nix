pkgs: {
  src,
  version,
  pname,
  appName,
  srcsubdir ? ".",
  ...
}:
pkgs.stdenv.mkDerivation {
  inherit version src;

  name = pname;

  nativeBuildInputs = [pkgs.undmg pkgs.unzip pkgs.makeWrapper];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications

    cp -r "${srcsubdir}/${appName}.app" $out/Applications

    # wrap executable to $out/bin
    mkdir -p $out/bin
    makeWrapper "$out/Applications/${appName}.app/Contents/MacOS/${appName}" "$out/bin/${pname}"

    runHook postInstall
  '';
}

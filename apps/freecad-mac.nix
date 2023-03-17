{
  definition = lib: pkgs:
    let
      version = "0.20.2";
      date = "2022-12-27";
      appName = "FreeCAD";
      pname = "freecad";

      src = pkgs.fetchurl {
        url =
          "https://github.com/FreeCAD/FreeCAD/releases/download/${version}/FreeCAD_${version}-${date}-conda-macOS-x86_64-py310.dmg";
        sha256 = "sha256-OAi98HUacHcLHVYSadnQFPnEhutJvE4YfRBtPSZk00c=";
      };
    in
    pkgs.stdenv.mkDerivation {
      inherit version src;

      name = pname;

      nativeBuildInputs = [ pkgs.makeWrapper ];

      dontUnpack = true;

      installPhase = ''
        export tempdir=$(mktemp -d -p /tmp)

        cp $src freecad.dmg
        /usr/bin/hdiutil attach -mountpoint "$tempdir" freecad.dmg

        mkdir -p $out/Applications

        cp -r "$tempdir/${appName}.app" $out/Applications

        /usr/bin/hdiutil detach "$tempdir"

        mkdir -p $out/bin
        makeWrapper "$out/Applications/${appName}.app/Contents/MacOS/${appName}" "$out/bin/${pname}"

        runHook postInstall
      '';
      meta = with pkgs.lib; {
        homepage = "https://www.freecadweb.org/";
        description = "General purpose Open Source 3D CAD/MCAD/CAx/CAE/PLM modeler";
        longDescription = ''
          FreeCAD is an open-source parametric 3D modeler made primarily to design
          real-life objects of any size. Parametric modeling allows you to easily
          modify your design by going back into your model history and changing its
          parameters.
          FreeCAD allows you to sketch geometry constrained 2D shapes and use them
          as a base to build other objects. It contains many components to adjust
          dimensions or extract design details from 3D models to create high quality
          production ready drawings.
          FreeCAD is designed to fit a wide range of uses including product design,
          mechanical engineering and architecture. Whether you are a hobbyist, a
          programmer, an experienced CAD user, a student or a teacher, you will feel
          right at home with FreeCAD.
        '';
        license = licenses.lgpl2Plus;
        platforms = platforms.darwin;
      };
    };
  systems = [ "aarch64-darwin" "x86_64-darwin" ];
}

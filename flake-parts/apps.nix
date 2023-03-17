{ lib, self, inputs, withSystem, ... }: {
  flake =
    let
      buildProgram = system: definition: (withSystem system ({ pkgs, self', ... }: definition self.lib pkgs));
      createApp = { definition, system }: { type = "app"; program = lib.getExe (buildProgram system definition); };
      defineApp = system: name: definition: { ${system}.${name} = createApp { definition = definition; system = system; }; };
      appsDir = self.lib.importDirToAttrs ../apps;
      builtApps = lib.mapAttrsToList (name: value: (lib.forEach value.systems (system: defineApp system name value.definition))) appsDir;
      flattened = lib.flatten builtApps;
      assembled = builtins.foldl' (a: b: lib.recursiveUpdate a b) { } flattened;
    in
    {
      apps = assembled;
    };
}

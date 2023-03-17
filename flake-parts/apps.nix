{ lib, self, inputs, withSystem, ... }: {
  flake =
    let
      buildProgram = system: definition: (withSystem system ({ pkgs, self', ... }: definition self.lib pkgs));
      defineProgram = system: name: definition: { ${system}.${name} = buildProgram system definition; };
      appsDir = self.lib.importDirToAttrs ../apps;
      builtPrograms = lib.mapAttrsToList (name: value: (lib.forEach value.systems (system: defineProgram system name value.definition))) appsDir;
      flattenedPrograms = lib.flatten builtPrograms;
      assembledPrograms = builtins.foldl' (a: b: lib.recursiveUpdate a b) { } flattenedPrograms;
      assembledApps = lib.mapAttrsRecursiveCond (as: !(as ? "type" && as.type == "derivation")) (path: value: { type = "app"; program = lib.getExe value; }) assembledPrograms;
    in
    {
      apps = assembledApps;
      programs = assembledPrograms;
    };
}

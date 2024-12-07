{
  inputs,
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        # language-servers = ["nixd-lsp"];
        formatter = {command = "${pkgs.alejandra}/bin/alejandra";};
      }
    ];
    # languages.language-server.nixd-lsp.command = "${inputs.nixd.packages.${pkgs.system}.default}/bin/nixd";
    settings.editor.line-number = "relative";
    settings.keys = {
      normal = {
        space.w = ":w";
        space.q = ":q";

        /*
        remap for colemak
        */
        n = "move_line_down";
        N = "keep_selections";
        k = "search_next";
        K = "search_prev";
        # E <=> J (swap actions)
        j = "move_next_word_end";
        J = "move_next_long_word_end";
        e = "move_line_up";
        E = "join_selections";
        # ILU loop
        # I => L
        i = "move_char_right";
        I = "no_op";
        # U => I (QWERTY position)
        u = "insert_mode";
        U = "insert_at_line_start";
        # L => U (QWERTY position)
        l = "undo";
        L = "redo";
        /*
        end colemak remap
        */
      };
    };
  };
}

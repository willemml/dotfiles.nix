{
  inputs,
  pkgs,
  lib,
  ...
}: {
  programs.helix = {
    enable = true;
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter = {command = "${pkgs.alejandra}/bin/alejandra";};
      }
    ];
    settings.editor.line-number = "relative";
    settings.editor.true-color = true;
    settings.theme = lib.mkForce "gruvbox_dark_hard";
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

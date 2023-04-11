{lib, ...}: {
  # Global Emacs keybindings
  targets.darwin.keybindings = {
    "^l" = "centerSelectionInVisibleArea:";
    "^/" = "undo:";
    "^_" = "undo:";
    "^ " = "setMark:";
    "^\@" = "setMark:";
    "^w" = "deleteToMark:";
    "~f" = "moveWordForward:";
    "~b" = "moveWordBackward:";
    "~<" = "moveToBeginningOfDocument:";
    "~>" = "moveToEndOfDocument:";
    "~v" = "pageUp:";
    "~/" = "complete:";
    "~c" = [
      "capitalizeWord:"
      "moveForward:"
      "moveForward:"
    ];
    "~u" = [
      "uppercaseWord:"
      "moveForward:"
      "moveForward:"
    ];
    "~l" = [
      "lowercaseWord:"
      "moveForward:"
      "moveForward:"
    ];
    "~d" = "deleteWordForward:";
    "^~h" = "deleteWordBackward:";
    "~\U007F" = "deleteWordBackward:";
    "~t" = "transposeWords:";
    "~\@" = [
      "setMark:"
      "moveWordForward:"
      "swapWithMark"
    ];
    "~h" = [
      "setMark:"
      "moveToEndOfParagraph:"
      "swapWithMark"
    ];
    "^x" = {
      "u" = "undo:";
      "k" = "performClose:";
      "^f" = "openDocument:";
      "^x" = "swapWithMark:";
      "^m" = "selectToMark:";
      "^s" = "saveDocument:";
      "^w" = "saveDocumentAs:";
    };
  };

  home.activation.configureDarwinKeyboard = let
    userKeyMapping = [
      {
        HIDKeyboardModifierMappingSrc = 30064771303; # remap right command to right control.
        HIDKeyboardModifierMappingDst = 30064771300;
      }
    ];
  in
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      $VERBOSE_ECHO "Configuring Darwin keyboard mappings."
      $DRY_RUN_CMD /usr/bin/hidutil property --set '{"UserKeyMapping":${builtins.toJSON userKeyMapping}}' > /dev/null
    '';
}

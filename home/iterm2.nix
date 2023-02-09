{ pkgs, lib, ... }:

let
  dracula_plus = {
    "Ansi 0 Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.172549;
      "Color Space" = "sRGB";
      "Green Component" = 0.133333;
      "Red Component" = 0.129412;
    };
    "Ansi 1 Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.333333;
      "Color Space" = "sRGB";
      "Green Component" = 0.333333;
      "Red Component" = 1;
    };
    "Ansi 10 Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.580392;
      "Color Space" = "sRGB";
      "Green Component" = 1;
      "Red Component" = 0.411765;
    };
    "Ansi 11 Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.419608;
      "Color Space" = "sRGB";
      "Green Component" = 0.796078;
      "Red Component" = 1;
    };
    "Ansi 12 Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 1;
      "Color Space" = "sRGB";
      "Green Component" = 0.67451;
      "Red Component" = 0.839216;
    };
    "Ansi 13 Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.87451;
      "Color Space" = "sRGB";
      "Green Component" = 0.572549;
      "Red Component" = 1;
    };
    "Ansi 14 Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 1;
      "Color Space" = "sRGB";
      "Green Component" = 1;
      "Red Component" = 0.643137;
    };
    "Ansi 15 Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.94902;
      "Color Space" = "sRGB";
      "Green Component" = 0.972549;
      "Red Component" = 0.972549;
    };
    "Ansi 2 Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.482353;
      "Color Space" = "sRGB";
      "Green Component" = 0.980392;
      "Red Component" = 0.313726;
    };
    "Ansi 3 Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.419608;
      "Color Space" = "sRGB";
      "Green Component" = 0.796078;
      "Red Component" = 1;
    };
    "Ansi 4 Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 1;
      "Color Space" = "sRGB";
      "Green Component" = 0.666667;
      "Red Component" = 0.509804;
    };
    "Ansi 5 Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.917647;
      "Color Space" = "sRGB";
      "Green Component" = 0.572549;
      "Red Component" = 0.780392;
    };
    "Ansi 6 Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.992157;
      "Color Space" = "sRGB";
      "Green Component" = 0.913725;
      "Red Component" = 0.545098;
    };
    "Ansi 7 Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.94902;
      "Color Space" = "sRGB";
      "Green Component" = 0.972549;
      "Red Component" = 0.972549;
    };
    "Ansi 8 Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.329412;
      "Color Space" = "sRGB";
      "Green Component" = 0.329412;
      "Red Component" = 0.329412;
    };
    "Ansi 9 Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.431373;
      "Color Space" = "sRGB";
      "Green Component" = 0.431373;
      "Red Component" = 1;
    };
    "Background Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.129412;
      "Color Space" = "sRGB";
      "Green Component" = 0.129412;
      "Red Component" = 0.129412;
    };
    "Badge Color" = {
      "Alpha Component" = 0.5;
      "Blue Component" = 0.321569;
      "Color Space" = "sRGB";
      "Green Component" = 0.258824;
      "Red Component" = 0.231373;
    };
    "Bold Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 1;
      "Color Space" = "sRGB";
      "Green Component" = 1;
      "Red Component" = 0.999996;
    };
    "Cursor Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.956863;
      "Color Space" = "sRGB";
      "Green Component" = 0.937255;
      "Red Component" = 0.92549;
    };
    "Cursor Guide Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.211765;
      "Color Space" = "sRGB";
      "Green Component" = 0.219608;
      "Red Component" = 0.235294;
    };
    "Cursor Text Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.156863;
      "Color Space" = "sRGB";
      "Green Component" = 0.156863;
      "Red Component" = 0.156863;
    };
    "Foreground Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.94902;
      "Color Space" = "sRGB";
      "Green Component" = 0.972549;
      "Red Component" = 0.972549;
    };
    "Link Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 1;
      "Color Space" = "sRGB";
      "Green Component" = 1;
      "Red Component" = 0.996078;
    };
    "Selected Text Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.329412;
      "Color Space" = "sRGB";
      "Green Component" = 0.329412;
      "Red Component" = 0.329412;
    };
    "Selection Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.94902;
      "Color Space" = "sRGB";
      "Green Component" = 0.972549;
      "Red Component" = 0.972549;
    };
    "Tab Color" = {
      "Alpha Component" = 1;
      "Blue Component" = 0.321569;
      "Color Space" = "sRGB";
      "Green Component" = 0.258824;
      "Red Component" = 0.231373;
    };
  };
  profile_defaults = {
    "ASCII Anti Aliased" = true;
    "Ambiguous Double Width" = false;
    "BM Growl" = true;
    "Background Image Location" = "";
    "Blinking Cursor" = false;
    "Blur" = false;
    "Character Encoding" = 4;
    "Close Sessions On End" = true;
    "Flashing Bell" = false;
    "Horizontal Spacing" = 1;
    "Idle Code" = 0;
    "Jobs to Ignore" = [ "rlogin" "ssh" "slogin" "telnet" ];
    "Keyboard Map" = null;
    "Mouse Reporting" = true;
    "Non Ascii Font" = "Monaco 12";
    "Non-ASCII Anti Aliased" = true;
    "Normal Font" = "MesloLGS-NF-Regular 12";
    "Option Key Sends" = 2;
    "Prompt Before Closing 2" = false;
    "Right Option Key Sends" = 0;
    "Scrollback Lines" = 0;
    "Send Code When Idle" = false;
    "Silence Bell" = false;
    "Sync Title" = false;
    "Terminal Type" = "xterm-256color";
    "Transparency" = 0;
    "Unlimited Scrollback" = true;
    "Use Bold Font" = true;
    "Use Bright Bold" = true;
    "Use Italic Font" = true;
    "Use Non-ASCII Font" = false;
    "Vertical Spacing" = 1;
    "Visual Bell" = true;
    "Window Type" = 0;
  } // dracula_plus;
in
{
  targets.darwin.defaults."com.googlecode.iterm2" = lib.mkIf pkgs.stdenv.isDarwin {
    "AlternateMouseScroll" = true;
    "Default Bookmark Guid" = "30FFD0AB-B2EB-4635-9469-D089C1D9E106";
    "HotkeyMigratedFromSingleToMulti" = true;
    "LeftCommand" = 7;
    "LeftOption" = 2;
    "ShowFullScreenTabBar" = false;
    "SoundForEsc" = false;
    "SUEnableAutomaticChecks" = false;
    "SUHasLaunchedBefore" = true;
    "VisualIndicatorForEsc" = false;
    "New Bookmarks" = [
      ({
        "Columns" = 120;
        "Command" = "";
        "Custom Command" = "No";
        "Custom Directory" = "No";
        "Default Bookmark" = "Yes";
        "Description" = "Default";
        "Guid" = "30FFD0AB-B2EB-4635-9469-D089C1D9E106";
        "Name" = "Primary";
        "Rows" = 30;
        "Screen" = -1;
        "Tags" = [ ];
        "Working Directory" = "/Users/willem";
      } // profile_defaults)
      ({
        "Columns" = 120;
        "Command" = "";
        "Custom Command" = "No";
        "Custom Directory" = "No";
        "Default Bookmark" = "No";
        "Description" = "Default";
        "Disable Window Resizing" = true;
        "Guid" = "00A17AC2-1885-4AE2-B941-A47A5D8C36B4";
        "Has Hotkey" = true;
        "HotKey Activated By Modifier" = false;
        "HotKey Alternate Shortcuts" = { };
        "HotKey Characters Ignoring Modifiers" = " ";
        "HotKey Characters" = " ";
        "HotKey Key Code" = 49;
        "HotKey Modifier Activation" = 3;
        "HotKey Modifier Flags" = 1048576;
        "HotKey Window Animates" = false;
        "HotKey Window AutoHides" = true;
        "HotKey Window Dock Click Action" = 0;
        "HotKey Window Floats" = true;
        "HotKey Window Reopens On Activation" = false;
        "Name" = "Hotkey Window";
        "Rows" = 25;
        "Screen" = -1;
        "Space" = -1;
        "Tags" = [ ];
        "Working Directory" = "/Users/willem";
      } // profile_defaults)
    ];
  };
}

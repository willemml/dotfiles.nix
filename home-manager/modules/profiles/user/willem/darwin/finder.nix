{
  pkgs,
  lib,
  ...
}: let
  columnSettings = {
    name = {
      visible = true;
      width = 300;
      index = 1;
    };
    dateModified = {
      visible = true;
      width = 150;
      index = 2;
    };
    dateCreated = {
      visible = true;
      width = 150;
      index = 3;
    };
    size = {
      visible = true;
      index = 4;
      width = 100;
    };
    dateLastOpened = {
      visible = true;
      width = 150;
      index = 5;
    };
    kind = {
      visible = true;
      width = 100;
      index = 6;
    };
    comments = {
      visible = false;
      width = 200;
      index = 7;
    };
    label = {
      visible = false;
      width = 50;
      index = 8;
    };
    version = {
      visible = false;
      width = 50;
      index = 9;
    };
  };

  listviewsettings = {
    calculateAllSizes = true;
    showIconPreview = true;
    iconSize = 16;
    textSize = 13;
    sortColumn = "name";
    useRelativeDates = true;
    viewOptionsVersion = 1;
  };

  default-view-settings = {
    ExtendedListViewSettingsV2 =
      {
        columns = builtins.sort (a: b: a.index < b.index) (map
          (name:
            (name: value: {
              identifier = "${name}";
              visible = value.visible;
              width = value.width;
              index = value.index;
            })
            name
            columnSettings.${name})
          (builtins.attrNames columnSettings));
      }
      // listviewsettings;
    ListViewSettings = {columns = columnSettings;} // listviewsettings;
  };

  dvs-with-ws =
    {
      WindowState = {
        ContainerShowSidebar = true;
        ShowStatusBar = true;
        ShowSidebar = true;
        ShowToolbar = true;
        ShowTabView = true;
      };
    }
    // default-view-settings;
in {
  targets.darwin.defaults."com.apple.finder" = {
    AppleShowAllExtensions = true;

    ComputerViewSettings = dvs-with-ws;

    CreateDesktop = false;

    DesktopViewSettings = {GroupBy = "Kind";};

    FinderSpawnTab = false;

    FK_DefaultListViewSettingsV2 =
      default-view-settings.ExtendedListViewSettingsV2;

    FK_StandardViewSettings =
      {
        SettingsType = "FK_StandardViewSettings";
      }
      // default-view-settings;

    FK_iCloudListViewSettingsV2 =
      default-view-settings.ExtendedListViewSettingsV2;

    FXArrangeGroupViewBy = "Name";

    FXDefaultSearchScope = "SCsp";

    FXEnableExtensionChangeWarning = false;

    FXEnableRemoveFromICloudDriveWarning = false;

    FXICloudDriveDocuments = true;

    FXICloudDriveEnabled = true;

    FXPreferredGroupBy = "Kind";

    FXPreferredViewStyle = "Nlsv";

    GoToField = "~/Library/";

    ICloudViewSettings = dvs-with-ws;

    NetworkViewSettings = dvs-with-ws;

    NSDocumentSaveNewDocumentsToCloud = false;

    NSTableViewDefaultSizeMode = 1;

    PackageViewSettings = dvs-with-ws;

    RecentsArrangeGroupViewBy = "Date Last Opened";

    SearchViewSettings = dvs-with-ws;

    ShowExternalHardDrivesOnDesktop = false;

    ShowHardDrivesOnDesktop = false;

    ShowPathbar = true;

    ShowRemovableMediaOnDesktop = false;

    ShowSidebar = true;

    showWindowTitlebarIcons = false;

    SidebarWidth = 135;

    SidebarZoneOrder1 = ["icloud_drive" "favorites" "devices" "tags"];

    StandardViewSettings =
      {
        SettingsType = "StandardViewSettings";
      }
      // default-view-settings;

    TrashViewSettings = dvs-with-ws;

    WarnOnEmptyTrash = false;

    _FXShowPosixPathInTitle = true;

    _FXSortFoldersFirst = true;

    _FXSortFoldersFirstOnDesktop = true;
  };
}

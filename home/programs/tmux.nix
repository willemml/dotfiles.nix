{pkgs, ...}: {
  programs.tmux = {
    enable = true;

    clock24 = true;

    mouse = true;

    prefix = "C-s";

    customPaneNavigationAndResize = true;
    keyMode = "emacs";

    terminal = "xterm-256color";

    extraConfig = ''
      set -g window-style 'bg=default'
      set -ag terminal-overrides ",*256col*:RGB"
      set -s escape-time 0

      bind-key r source-file ~/.config/tmux/tmux.conf \; display "Reloaded from ~/.config/tmux/tmux.conf"

      bind | split-window -h
      bind ? split-window -v

      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      bind -n M-h select-pane -L
      bind -n M-n select-pane -D
      bind -n M-e select-pane -U
      bind -n M-i select-pane -R
    '';
  };
}

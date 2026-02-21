* {
  font-family: JetBrainsMono Nerd Font;
  font-size: {{WAYBAR_FONT_SIZE}};
  letter-spacing: 0.8px;
}

.modules-right, .modules-left, .modules-center {
  margin: 4px;
}

.modules-right > * > *, .modules-left, .modules-center {
  border-radius: 2px;
}

.modules-right > * > * {
  padding: 0px 12px;
  font-weight: bold;
  background-color: {{SURFACE}};
  margin-left: 4px;
}

#tray {
  padding: 0px 12px;
}

window#waybar {
  background-color: {{BG}};
  color: {{FG}};
  font-weight: bold;
  border: solid 4px {{BG}};
}

.modules-left {
  background-color: {{SURFACE}};
}

#window {
  background-color: {{SURFACE}};
  border-radius: 2px;
  padding: 0px 12px;
  color: {{FG}};
}

window#waybar.empty #window {
  background-color: transparent;
}

#workspaces button {
  font-weight: bold;
  padding: 2px 6px;
  background: none;
  border: none;
  border-radius: 2px;
  color: {{FG}};
  border: solid 2px {{SURFACE}};
}

#workspaces button.focused, #workspaces button.active {
  background-color: {{SURFACE}};
  color: {{FG}};
  border: solid 2px {{SURFACE}};
  border-bottom: 2px solid {{ACCENT}};
}

#mpris {
  padding: 2px 6px;
  background-color: {{ACCENT}};
  color: {{BG}};
  font-weight: bold;
}

#mpris.spotifyd, #mpris.spotify {
  background-color: {{ACCENT}};
  color: {{BG}};
  border-radius: 2px;
  padding: 0px 12px;
}

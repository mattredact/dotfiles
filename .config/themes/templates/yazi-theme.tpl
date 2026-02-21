[mgr]
cwd = { fg = "{{FG}}", italic = true }

# Hovered
hovered = { bg = "{{SURFACE}}" }
preview_hovered = { bg = "{{SURFACE}}" }

# Find
find_keyword = { fg = "{{BG}}", bg = "{{ACCENT}}", bold = true }
find_position = { fg = "{{ACCENT}}", bg = "{{SURFACE}}", bold = true }

# Marker
marker_copied = { fg = "{{COLOR_PURPLE}}", bg = "{{COLOR_PURPLE}}" }
marker_cut = { fg = "{{COLOR_RED}}", bg = "{{COLOR_RED}}" }
marker_marked = { fg = "{{ACCENT}}", bg = "{{ACCENT}}" }
marker_selected = { fg = "{{BG}}", bg = "{{ACCENT}}" }

# Tab
tab_active = { fg = "{{FG}}", bg = "{{SURFACE}}" }
tab_inactive = { fg = "{{DIM}}", bg = "{{BG}}" }
tab_width = 1

# Count
count_copied = { fg = "{{FG}}", bg = "{{COLOR_PURPLE}}" }
count_cut = { fg = "{{FG}}", bg = "{{COLOR_RED}}" }
count_selected = { fg = "{{FG}}", bg = "{{SURFACE}}" }

# Border
border_symbol = "│"
border_style = { fg = "{{ACCENT}}" }

[status]
sep_left = { open = "", close = "" }
sep_right = { open = "", close = "" }

progress_label = { fg = "{{FG}}", bold = true }
progress_normal = { fg = "{{BG}}" }
progress_error = { fg = "{{COLOR_RED}}" }

# Permissions
permissions_t = { fg = "{{ACCENT}}" }
permissions_r = { fg = "{{DIM}}" }
permissions_w = { fg = "{{DIM}}" }
permissions_x = { fg = "{{COLOR_PURPLE}}" }
permissions_s = { fg = "{{SURFACE}}" }

[mode]
normal_main = { fg = "{{BG}}", bg = "{{ACCENT}}", bold = true }
normal_alt = { fg = "{{FG}}", bg = "{{SURFACE}}" }

select_main = { fg = "{{BG}}", bg = "{{COLOR_PURPLE}}", bold = true }
select_alt = { fg = "{{FG}}", bg = "{{SURFACE}}" }

unset_main = { fg = "{{BG}}", bg = "{{COLOR_RED}}", bold = true }
unset_alt = { fg = "{{FG}}", bg = "{{SURFACE}}" }

[select]
border = { fg = "{{ACCENT}}" }
active = { fg = "{{FG}}", bg = "{{SURFACE}}" }
inactive = { fg = "{{FG}}" }

[input]
border = { fg = "{{ACCENT}}" }
title = {}
value = { fg = "{{ACCENT}}" }
selected = { bg = "{{SURFACE}}" }

[completion]
border = { fg = "{{ACCENT}}" }
active = { fg = "{{FG}}", bg = "{{SURFACE}}" }
inactive = { fg = "{{FG}}" }

[tasks]
border = { fg = "{{ACCENT}}" }
title = {}
hovered = { fg = "{{FG}}", bg = "{{SURFACE}}" }

[which]
cols = 3
mask = { bg = "{{BG}}" }
cand = { fg = "{{ACCENT}}" }
rest = { fg = "{{DIM}}" }
desc = { fg = "{{DIM}}" }
separator = "  "
separator_style = { fg = "{{SURFACE}}" }

[notify]
title_info = { fg = "{{ACCENT}}" }
title_warn = { fg = "{{DIM}}" }
title_error = { fg = "{{COLOR_RED}}" }

[help]
on = { fg = "{{COLOR_PURPLE}}" }
run = { fg = "{{ACCENT}}" }
hovered = { bg = "{{SURFACE}}" }
footer = { fg = "{{FG}}", bg = "{{BG}}" }

[icon]
prepend_conds = [
  { if = "dir", text = "", fg = "{{ACCENT}}" },
]

[filetype]
prepend_rules = [
  # Media
  { mime = "{audio,video,image}/*", fg = "{{COLOR_PURPLE}}" },

  # Archives
  { mime = "application/*zip", fg = "{{COLOR_RED}}" },
  { mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}", fg = "{{COLOR_RED}}" },

  # Documents
  { mime = "application/{pdf,doc,rtf,vnd.*}", fg = "{{ACCENT}}" },

  # Special files
  { name = "*", is = "link", fg = "{{DIM}}" },
  { name = "*/", is = "link", fg = "{{DIM}}" },
  { name = "*", is = "orphan", bg = "{{COLOR_RED}}" },
  { name = "*", is = "exec", fg = "{{COLOR_PURPLE}}" },

  # Fallback
  { name = "*/", fg = "{{FG}}" },
]

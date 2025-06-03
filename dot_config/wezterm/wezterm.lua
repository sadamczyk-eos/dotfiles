local wezterm = require 'wezterm';
local act = wezterm.action;
local config = {}

-- Helper functions
function mergeTable(result, toBeMerged)
  for _, v in pairs(toBeMerged) do
    table.insert(result, v)
  end
end

-- Appearance
  -- Automatically switch colorscheme based on OS appearance
  -- https://wezfurlong.org/wezterm/config/lua/wezterm.gui/get_appearance.html
  -- wezterm.gui is not available to the mux server, so take care to
  -- do something reasonable when this config is evaluated by the mux
function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Light' then
    return "Solarized (light) (terminal.sexy)"
  else
    return "Solarized (dark) (terminal.sexy)"
  end
end

config.color_scheme = scheme_for_appearance(get_appearance())
config.font = wezterm.font 'DejaVu Sans Mono'
config.font_size = 11
-- config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' } -- Disables ligatures, yuck.
config.initial_cols = 500
config.initial_rows = 500


-- WezTerm GUI
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  default_prog = {"wsl.exe", "--exec", "/usr/bin/fish"}
elseif wezterm.target_triple == "x86_64-apple-darwin" then
  default_prog = {"/usr/local/bin/fish"}
else
  default_prog = {"fish"}
end
config.default_prog = default_prog
config.prefer_to_spawn_tabs = true
config.clean_exit_codes = {130} -- For ^D afer ^C. https://wezfurlong.org/wezterm/config/lua/config/clean_exit_codes.html
config.window_close_confirmation = "NeverPrompt"


-- Terminal
  -- Hyperlinks
config.hyperlink_rules = wezterm.default_hyperlink_rules()
    -- JIRA
table.insert(config.hyperlink_rules, {
  regex = [[[A-Z]{1}[A-Z0-9]{1,7}-\d{2,6}]],
  format = 'https://evenonsunday.atlassian.net/browse/$0',
})


-- Mouse
config.mouse_bindings = {
  {
    event = { Down = { streak = 4, button = 'Left' } },
    action = act.SelectTextAtMouseCursor 'SemanticZone',
    mods = 'NONE',
  },
  {
    event = { Up = { streak = 4, button = 'Left' } },
    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
    mods = 'NONE',
  },
}


-- Keymap
config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 3000 }
config.keys = {
  -- Simple hotkeys
  {key="w", mods="CTRL|SHIFT", action=act.CloseCurrentTab{confirm=false}}, -- Don't confirm closing tabs
  {key="d", mods="CTRL|SHIFT", action=act.SplitHorizontal{domain = 'CurrentPaneDomain'}},
  {key="d", mods="CTRL|SHIFT|ALT", action=act.SplitVertical{domain = 'CurrentPaneDomain'}},
    -- The default is much too slow, only moves by 1px each time.
  {key="LeftArrow", mods="CTRL|SHIFT|ALT", action=act.AdjustPaneSize{'Left', 5}},
  {key="RightArrow", mods="CTRL|SHIFT|ALT", action=act.AdjustPaneSize{'Right', 5}},
  {key="UpArrow", mods="CTRL|SHIFT|ALT", action=act.AdjustPaneSize{'Up', 5}},
  {key="DownArrow", mods="CTRL|SHIFT|ALT", action=act.AdjustPaneSize{'Down', 5}},
    -- Requires shell integration for semantic zones to work. 2 because of multiline prompt.
  {key="PageUp", mods="CTRL|SHIFT", action=act.ScrollToPrompt(-2)},
  {key="PageDown", mods="CTRL|SHIFT", action=act.ScrollToPrompt(2)},

  -- Custom functions
  {key="h", mods="CTRL|SHIFT", action=act.SendString 'bin/console c:j:l '},
  {key="j", mods="CTRL|SHIFT", action=act.QuickSelectArgs {
    label = 'paste',
    patterns = {
      [[Eos\\Package\\Cron\\Model\\ServiceSchedule#[0-9]+]]
    },
    action = wezterm.action_callback(function(window, pane)
      local selection = 'bin/console c:j:e -vvv -iseb "' .. window:get_selection_text_for_pane(pane) .. '" '
      pane:send_text(selection)
    end)
  }},
}

copy_mode = wezterm.gui.default_key_tables().copy_mode
mergeTable(
  copy_mode,
  {
    { key = 'v', mods = 'ALT', action = act.CopyMode { SetSelectionMode = 'SemanticZone' } },
    { key = 'K', mods = 'NONE', action = act.CopyMode { MoveBackwardZoneOfType = 'Input' } },
    { key = 'J', mods = 'NONE', action = act.CopyMode { MoveForwardZoneOfType = 'Input' } },
  }
)
config.key_tables = {
  copy_mode = copy_mode,
}

return config

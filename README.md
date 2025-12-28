# logan's camera suite

logan's camera suite is a modular roblox freecam and ui toggle system designed for content creators. it provides a complete toolkit for capturing clean gameplay footage with smooth camera movement and customizable visibility controls.

## features

- **freecam** - smooth camera movement with adjustable velocity, pan, and fov
- **hide players** - hides other players, their characters, nametags, and healthbars
- **hide billboards** - hides overhead name tags and billboards
- **hide chat bubbles** - hides chat bubbles above players
- **hide ui** - toggles screen guis on/off
- **fullscreen mode** - makes all screen guis fullscreen by ignoring safe area insets
- **multi-input support** - works with keyboard, mouse, and gamepad
- **modular architecture** - easy to extend with new features

## usage

execute the following in your roblox executor:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/zqiv/LogansCameraSuite/refs/heads/main/main.lua"))()
```

### controls

- **z** - toggle camera suite on/off (activates all enabled features)

## project structure

```
LogansCameraSuite/
├── main.lua                    main entry point and feature loader
├── config.lua                  configuration and feature definitions
├── features/
│   ├── freecam.lua             smooth freecam system
│   ├── hideUI.lua              screen gui visibility toggle
│   ├── hidePlayers.lua         player visibility control
│   ├── hideBillboards.lua      billboard hiding
│   ├── hideChatBubbles.lua     chat bubble control
│   └── ignoreGuiInset.lua      fullscreen mode for all guis
└── README.md
```

## for developers

### adding new features

1. create a new feature file in `/features/` that exports `enable()` and `disable()` functions:

```lua
-- features/yourFeature.lua
return {
    enable = function()
        -- your feature logic here
    end,
    
    disable = function()
        -- cleanup logic here
    end
}
```

2. add your feature to `config.lua`:

```lua
{
    id = "yourFeature",
    name = "Your Feature",
    description = "What your feature does",
    path = "features/yourFeature.lua",
    enabled = true
}
```

3. your feature will automatically load and integrate with the suite

## roadmap

- [ ] ui menu for feature toggling (rightshift)
- [ ] camera path recording and playback
- [ ] fov presets and quick toggles
- [ ] camera position bookmarks
- [ ] depth of field effects
- [ ] time controls (slow motion)
- [ ] composition overlays (rule of thirds, grids)

## version

**beta 0.1** - initial modular release

## notes

this tool is intended for use in private servers and content creation. please respect game rules and other players when using camera suite features.

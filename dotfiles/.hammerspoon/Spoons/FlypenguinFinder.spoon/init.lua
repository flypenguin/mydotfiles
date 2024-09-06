--- === FlypenguinFinder ===
---
--- Personal shit-fix for constantly changing Finder keyboard bindings in Apple's control panel
---

local obj={}
obj.__index = obj

-- Metadata
obj.name = "FlypenguinFinder"
obj.version = "0.1"
obj.author = "Axel Bock <ab@a3b3.de>"
obj.homepage = "https://flypenguin.de"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- --------------------------------------------------------------------------
-- ======================================================================= --
-- --------------------------------------------------------------------------

-- https://is.gd/CI0LER
hs.grid.setGrid'6x6'


-- MUUUUCH better :)
-- https://github.com/Hammerspoon/hammerspoon/issues/2943#issuecomment-2105644391
for _, app in pairs(hs.application.runningApplications()) do
    local name = app:name()
    if name and (name:match(" Web Content$") or app:bundleID() == "com.apple.WebKit.WebContent") then
        hs.window.filter.ignoreAlways[name] = true
    end
end


wf = hs.window.filter
local finderWindows = wf.new(false):setAppFilter('Finder',{currentSpace=true, visible=true})


local function finder_collect_and_open()
    local windows = finderWindows:getWindows()
    if #windows == 0 then
        local done = hs.application.launchOrFocus("Finder")
        if done then
            windows = finderWindows.getWindows()
        end
    end
    local _, window = next(windows)
    local app = window:application()
    window:focus()
    done = app:selectMenuItem(".+ zusammenführen", true)

    screen = hs.screen'-500,0 2x2'
    hs.grid.set(window, '2,0 4x6', screen)
end


local function bind_hotkeys()
    hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "return", finder_collect_and_open)
end


function obj:init()
    bind_hotkeys()
end

return obj

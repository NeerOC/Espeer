local GUI = require("gui")
local TrackingManager = require("src.tracking_manager")

local function main_render()
    if not get_local_player() then return end

    if not GUI.elements.main_toggle:get() then
        return
    end

    if TrackingManager:track_all(GUI) then
        return
    end
end

on_render(main_render)
on_render_menu(GUI.render)

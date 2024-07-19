local gui = {}
local plugin_label = "espeer"

gui.elements = {
    main_tree = tree_node:new(0),
    main_toggle = checkbox:new(false, get_hash(plugin_label .. "_main_toggle")),
    monsters_tree = tree_node:new(1),
    track_common_toggle = checkbox:new(false, get_hash(plugin_label .. "_track_common_toggle")),
    track_champion_toggle = checkbox:new(false, get_hash(plugin_label .. "_track_champion_toggle")),
    track_elite_toggle = checkbox:new(false, get_hash(plugin_label .. "_track_elite_toggle")),
    track_boss_toggle = checkbox:new(false, get_hash(plugin_label .. "_track_boss_toggle")),
    draw_monster_lines_toggle = checkbox:new(false, get_hash(plugin_label .. "_draw_monster_lines_toggle")),
    chests_tree = tree_node:new(2),
    track_normal_chests_toggle = checkbox:new(false, get_hash(plugin_label .. "_track_normal_chests_toggle")),
    track_resplendent_chests_toggle = checkbox:new(false, get_hash(plugin_label .. "_track_resplendent_chests_toggle")),
    draw_chests_lines_toggle = checkbox:new(false, get_hash(plugin_label .. "_draw_chests_lines_toggle")),
    misc_tree = tree_node:new(3),
    track_objectives_toggle = checkbox:new(false, get_hash(plugin_label .. "_track_objectives_toggle")),
    track_shrines_toggle = checkbox:new(false, get_hash(plugin_label .. "_track_shrines_toggle")),
    track_resources_toggle = checkbox:new(false, get_hash(plugin_label .. "_track_resources_toggle")),
    draw_misc_lines_toggle = checkbox:new(false, get_hash(plugin_label .. "_draw_misc_lines_toggle")),
}

function gui:render()
    if not gui.elements.main_tree:push("Espeer") then
        return
    end

    gui.elements.main_toggle:render("Enable", "Toggle the script")
    if not gui.elements.main_toggle:get() then
        gui.elements.main_tree:pop()
        return
    end

    if gui.elements.monsters_tree:push("Monsters") then
        gui.elements.track_common_toggle:render("Common", "Normal Monsters")
        gui.elements.track_champion_toggle:render("Champion", "Mini elites, often drops gem fragments.")
        gui.elements.track_elite_toggle:render("Elite", "Elites...")
        gui.elements.track_boss_toggle:render("Boss", "Everything needs an option nowadays...")
        gui.elements.draw_monster_lines_toggle:render("Draw Lines", "Do you want to draw lines to the tracked monsters?")
        gui.elements.monsters_tree:pop()
    end

    if gui.elements.chests_tree:push("Chests") then
        gui.elements.track_normal_chests_toggle:render("Normal", "Track Normal Chests")
        gui.elements.track_resplendent_chests_toggle:render("Resplendent", "Track Resplendent Chests")
        gui.elements.draw_chests_lines_toggle:render("Draw Lines", "Do you want to draw lines to the tracked chests?")
        gui.elements.chests_tree:pop()
    end

    if gui.elements.misc_tree:push("Misc") then
        gui.elements.track_objectives_toggle:render("Objectives", "Track Quest Objectives / Dungeon Objectives")
        gui.elements.track_shrines_toggle:render("Shrines", "Track Shrines")
        gui.elements.track_resources_toggle:render("Resources", "Track Harvest nodes / Resources")
        gui.elements.draw_misc_lines_toggle:render("Draw Lines", "Draw lines to tracked objectives and shrines")
        gui.elements.misc_tree:pop()
    end


    gui.elements.main_tree:pop()
end

return gui

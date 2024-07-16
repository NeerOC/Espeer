local Utils = require("utils.utils")
local Data = require("data.custom_objects")
local colors = require("data.colors")

local TrackingManager = {
    visited_objects = {},
    last_reset_time = 0,
    reset_interval = 300 -- Let's do a reset every 5 min
}

function TrackingManager:add_visited_object(id)
    self.visited_objects[id] = true
end

function TrackingManager:is_shrine(actor)
    local name = actor:get_skin_name()
    local actor_id = actor:get_id()
    if string.find(name, "Shrine") and not self.visited_objects[actor_id] then
        return true
    end
    return false
end

function TrackingManager:is_chest(actor)
    local chest_types = { "Chest_Common", "Basic_Chest" }
    local name = actor:get_skin_name()

    for _, chest_type in ipairs(chest_types) do
        if string.find(name, chest_type) then
            local actor_id = actor:get_id()
            if not self.visited_objects[actor_id] then
                return true
            end
        end
    end

    return false
end

function TrackingManager:is_resplendent_chest(actor)
    local chest_types = { "Chest_Rare", "LootChest", "Rare_Chest" }
    local name = actor:get_skin_name()

    for _, chest_type in ipairs(chest_types) do
        if string.find(name, chest_type) then
            local actor_id = actor:get_id()
            if not self.visited_objects[actor_id] then
                return true
            end
        end
    end

    return false
end

function TrackingManager:is_quest_objective(actor)
    local name = actor:get_skin_name()
    local actor_id = actor:get_id()
    if Data.quest_objectives[name] and not self.visited_objects[actor_id] then
        return true
    end
    return false
end

function TrackingManager:track_monsters(actor, gui)
    if gui.elements.track_common_toggle:get() and target_selector.is_valid_enemy(actor) and not actor:is_elite() and not actor:is_champion() and not actor:is_boss() then
        graphics.circle_3d(actor:get_position(), 1, colors.common_monsters, 1)
        if gui.elements.draw_monster_lines_toggle:get() then
            graphics.line(get_player_position(), actor:get_position(), colors.common_monsters, 1)
        end
    elseif gui.elements.track_champion_toggle:get() and actor:is_champion() then
        graphics.circle_3d(actor:get_position(), 1, colors.champion_monsters, 1)
        if gui.elements.draw_monster_lines_toggle:get() then
            graphics.line(get_player_position(), actor:get_position(), colors.champion_monsters, 1)
        end
    elseif gui.elements.track_elite_toggle:get() and actor:is_elite() then
        graphics.circle_3d(actor:get_position(), 1, colors.elite_monsters, 1)
        if gui.elements.draw_monster_lines_toggle:get() then
            graphics.line(get_player_position(), actor:get_position(), colors.elite_monsters, 1)
        end
    elseif gui.elements.track_boss_toggle:get() and actor:is_boss() then
        graphics.circle_3d(actor:get_position(), 1, colors.boss_monsters, 1)
        if gui.elements.draw_monster_lines_toggle:get() then
            graphics.line(get_player_position(), actor:get_position(), colors.boss_monsters, 1)
        end
    end
end

function TrackingManager:track_chests(actor, gui)
    local distance = Utils.distance_to(actor)
    local actor_id = actor:get_id()

    if distance < 2 then
        self:add_visited_object(actor_id)
        return
    end

    if gui.elements.track_normal_chests_toggle:get() and self:is_chest(actor) then
        graphics.circle_3d(actor:get_position(), 1, colors.chests, 1)
        graphics.text_3d("Chest", actor:get_position(), 12, color_white(255))
        if gui.elements.draw_chests_lines_toggle:get() then
            graphics.line(get_player_position(), actor:get_position(), colors.chests, 1)
        end
    elseif gui.elements.track_resplendent_chests_toggle:get() and self:is_resplendent_chest(actor) then
        graphics.circle_3d(actor:get_position(), 0.8, colors.resplendent_chests, 3)
        graphics.text_3d("Resplendent Chest", actor:get_position(), 14, color_white(255))
        if gui.elements.draw_chests_lines_toggle:get() then
            graphics.line(get_player_position(), actor:get_position(), colors.resplendent_chests, 1)
        end
    end
end

function TrackingManager:track_objectives(actor, gui)
    local distance = Utils.distance_to(actor)
    local actor_id = actor:get_id()

    if distance < 2 then
        self:add_visited_object(actor_id)
        return
    end

    if gui.elements.track_objectives_toggle:get() and self:is_quest_objective(actor) then
        graphics.circle_3d(actor:get_position(), 1, colors.objectives, 1)
        graphics.text_3d("Objective", actor:get_position(), 12, colors.objectives)
        if gui.elements.draw_objectives_lines_toggle:get() then
            graphics.line(get_player_position(), actor:get_position(), colors.objectives, 1)
        end
    end
end

function TrackingManager:track_shrines(actor, gui)
    local distance = Utils.distance_to(actor)
    local actor_id = actor:get_id()

    if distance < 2 then
        self:add_visited_object(actor_id)
        return
    end

    if gui.elements.track_shrines_toggle:get() and self:is_shrine(actor) then
        graphics.circle_3d(actor:get_position(), 1, colors.shrines, 1)
        graphics.text_3d("Shrine", actor:get_position(), 12, color_white(255))
        if gui.elements.draw_misc_lines_toggle:get() then
            graphics.line(get_player_position(), actor:get_position(), colors.shrines, 1)
        end
    end
end

function TrackingManager:track_all(gui)
    local current_time = get_time_since_inject()

    -- Let's reset on timer
    if current_time - self.last_reset_time > self.reset_interval then
        self.visited_objects = {}
        self.last_reset_time = current_time
    end

    local actors = actors_manager:get_all_actors()
    for _, actor in pairs(actors) do
        self:track_monsters(actor, gui)
        self:track_chests(actor, gui)
        self:track_objectives(actor, gui)
        self:track_shrines(actor, gui)
    end
end

return TrackingManager

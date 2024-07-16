local Utils = require("utils.utils")
local Data = require("data.custom_objects")
local colors = require("data.colors")


local TrackingManager = {
    visited_positions = {},
    last_reset_time = 0,
    reset_interval = 300,  -- Reset interval
    position_threshold = 3 -- Distance threshold to consider a position as visited
}

function TrackingManager:add_visited_position(position)
    table.insert(self.visited_positions, position)
end

function TrackingManager:is_position_visited(position)
    for _, visited_pos in ipairs(self.visited_positions) do
        if position:dist_to(visited_pos) < self.position_threshold then
            return true
        end
    end
    return false
end

function TrackingManager:is_shrine(actor)
    local name = actor:get_skin_name()
    local position = actor:get_position()
    if string.find(name, "Shrine") and not self:is_position_visited(position) then
        return true
    end
    return false
end

function TrackingManager:is_chest(actor)
    local chest_types = { "Chest_Common", "Basic_Chest" }
    local name = actor:get_skin_name()
    local position = actor:get_position()

    for _, chest_type in ipairs(chest_types) do
        if string.find(name, chest_type) and not self:is_position_visited(position) then
            return true
        end
    end

    return false
end

function TrackingManager:is_resplendent_chest(actor)
    local chest_types = { "Chest_Rare", "LootChest", "Rare_Chest" }
    local name = actor:get_skin_name()
    local position = actor:get_position()

    for _, chest_type in ipairs(chest_types) do
        if string.find(name, chest_type) and not self:is_position_visited(position) then
            return true
        end
    end

    return false
end

function TrackingManager:is_quest_objective(actor)
    local name = actor:get_skin_name()
    local position = actor:get_position()
    if Data.quest_objectives[name] and not self:is_position_visited(position) then
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
    local position = actor:get_position()

    if distance < 2 then
        if self:is_chest(actor) or self:is_resplendent_chest(actor) then
            self:add_visited_position(position)
        end
        return
    end

    if gui.elements.track_normal_chests_toggle:get() and self:is_chest(actor) then
        graphics.circle_3d(position, 1, colors.chests, 1)
        graphics.text_3d("Chest", position, 12, color_white(255))
        if gui.elements.draw_chests_lines_toggle:get() then
            graphics.line(get_player_position(), position, colors.chests, 1)
        end
    elseif gui.elements.track_resplendent_chests_toggle:get() and self:is_resplendent_chest(actor) then
        graphics.circle_3d(position, 0.8, colors.resplendent_chests, 3)
        graphics.text_3d("Resplendent Chest", position, 14, color_white(255))
        if gui.elements.draw_chests_lines_toggle:get() then
            graphics.line(get_player_position(), position, colors.resplendent_chests, 1)
        end
    end
end

function TrackingManager:track_objectives(actor, gui)
    local distance = Utils.distance_to(actor)
    local position = actor:get_position()

    if distance < 2 then
        if self:is_quest_objective(actor) then
            self:add_visited_position(position)
        end
        return
    end

    if gui.elements.track_objectives_toggle:get() and self:is_quest_objective(actor) then
        graphics.circle_3d(position, 1, colors.objectives, 1)
        graphics.text_3d("Objective", position, 14, colors.objectives)
        if gui.elements.draw_misc_lines_toggle:get() then
            graphics.line(get_player_position(), position, colors.objectives, 1)
        end
    end
end

function TrackingManager:track_shrines(actor, gui)
    local distance = Utils.distance_to(actor)
    local position = actor:get_position()

    if distance < 2 then
        if self:is_shrine(actor) then
            self:add_visited_position(position)
        end
        return
    end

    if gui.elements.track_shrines_toggle:get() and self:is_shrine(actor) then
        graphics.circle_3d(position, 1, colors.shrines, 1)
        graphics.text_3d("Shrine", position, 16, color_white(255))
        if gui.elements.draw_misc_lines_toggle:get() then
            graphics.line(get_player_position(), position, colors.shrines, 1)
        end
    end
end

function TrackingManager:track_all(gui)
    local current_time = get_time_since_inject()

    -- Let's reset on timer
    if current_time - self.last_reset_time > self.reset_interval then
        self.visited_positions = {}
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

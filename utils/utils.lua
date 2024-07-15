local Utils = {}

function Utils.distance_to(object)
    return get_player_position():dist_to(object:get_position())
end

return Utils

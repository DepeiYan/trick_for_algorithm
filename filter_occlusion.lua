local function filter_occlusion(input_objects)
    local filter_occlusion_res = {}
    local location_cluster = {{},{},{},{},{},
                              {},{},{},{},{},
                              {},{},{},{},{}}
    for id, obs_info in pairs(input_objects) do
        local orientation = math.atan2(obs_info[1], obs_info[2])
        local location    = math.floor(orientation / 0.21) + 1
        location_cluster[location][id] = input_objects[id]
    end

    for loc, objs in pairs(location_cluster) do
        local cloest_x  = 10000
        local cloest_id = -1
        for id, obs_info in pairs(objs) do
            if obs_info[1] < cloest_x then
                cloest_x  = obs_info[1]
                cloest_id = id
            end
        end
        if cloest_id ~= -1 then
            filter_occlusion_res[cloest_id] = input_objects[cloest_id]
        end
    end
    return filter_occlusion_res
end
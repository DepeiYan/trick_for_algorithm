local function caculate_score(obs_1, obs_2)
    local distance_score  = 0
    local iou_cover_score = 0
    x_1, y_1, length_1, width_1, heading_1 = obs_1[1], obs_1[2], obs_1[3], obs_1[4], obs_1[5]
    x_2, y_2, length_2, width_2, heading_2 = obs_2[1], obs_2[2], obs_2[3], obs_2[4], obs_2[5]

    local distance = math.sqrt((x_1 - x_2) * (x_1 - x_2) + (y_1 - y_2) * (y_1 - y_2))
    if distance < 3 then
        distance_score = 1
    else
        distance_score = 3 / distance
    end

    -- box 1
    area_1          = width_1 * length_1
    cos_1           = math.cos(heading_1)
    sin_1           = math.sin(heading_1)
    half_width_1    = width_1 / 2
    half_length_1   = length_1 / 2
    left_up_x_1     = half_length_1 * cos_1 - half_width_1 * sin_1 + x_1
    left_up_y_1     = half_length_1 * sin_1 + half_width_1 * cos_1 + y_1
    right_down_x_1  = -half_length_1 * cos_1 + half_width_1 * sin_1 + x_1
    right_down_y_1  = -half_length_1 * sin_1 - half_width_1 * cos_1 + y_1

    -- box 2
    area_2          = width_2 * length_2
    cos_2           = math.cos(heading_2)
    sin_2           = math.sin(heading_2)
    half_width_2    = width_2 / 2
    half_length_2   = length_2 / 2
    left_up_x_2     = half_length_2 * cos_2 - half_width_2 * sin_2 + x_2
    left_up_y_2     = half_length_2 * sin_2 + half_width_2 * cos_2 + y_2
    right_down_x_2  = -half_length_2 * cos_2 + half_width_2 * sin_2 + x_2
    right_down_y_2  = -half_length_2 * sin_2 - half_width_2 * cos_2 + y_2

    -- iou area
    iou_area        = 0
    left_up_x       = math.min(left_up_x_1, left_up_x_2)
    left_up_y       = math.min(left_up_y_1, left_up_y_2)
    right_down_x    = math.max(right_down_x_1, right_down_x_2)
    right_down_y    = math.max(right_down_y_1, right_down_y_2)
    if (right_down_x >= left_up_x or right_down_y >= left_up_y) then
        iou_area = 0
    else
        iou_area = (left_up_x - right_down_x) * (left_up_y - right_down_y)
    end

    local iou_cover_1 = iou_area / area_1
    local iou_cover_2 = iou_area / area_2
    iou_cover_score = math.max(iou_cover_1, iou_cover_2)

    return (iou_cover_score * 0.5 + distance_score * 0.5)
end
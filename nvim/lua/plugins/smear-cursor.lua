return {
  "sphamba/smear-cursor.nvim",

  opts = {
    smear_insert_mode = false,
    smear_to_cmd = true,
    normal_bg = "#242B38",
    smear_between_buffers = true,
    never_draw_over_target = true,
    hide_target_hack = true,
    --
    particles_enabled = false,
    particle_max_num = 200,
    -- particles_per_length = 2.0,
    stiffness = 0.8,
    trailing_stiffness = 0.4,
    trailing_exponent = 5,
    damping = 0.8,
    gradient_exponent = 0,
    --
    -- stiffness = 0.8,
    -- trailing_stiffness = 0.6,
    -- -- trailing_exponent = 0.8,
    -- damping = 0.8,
    -- distance_stop_animating = 0.5,
  },
}

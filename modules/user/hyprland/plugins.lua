-- if hl.plugin.hyprglass then
--   ---@param rgb string
--   ---@param alpha number
--   ---@return string? rgba
--   local function tint(rgb, alpha)
--     local hex = rgb:match '^rgb%(([0-9a-fA-F]+)%)$'
--     if not hex or #hex ~= 6 then
--       return nil
--     end

--     alpha = alpha or 1.0
--     alpha = math.max(0, math.min(1, alpha))

--     return ('0x%s%02X'):format(hex:upper(), math.floor(alpha * 255 + 0.5))
--   end

--   local hg = hl.plugin.hyprglass

--   hg.preset('apple', {
--     blur_strength = 1.3,
--     blur_iterations = 2,
--     refraction_strength = 0.75,
--     chromatic_aberration = 0.18,
--     fresnel_strength = 0.55,
--     specular_strength = 0.95,
--     glass_opacity = 0.88,
--     edge_thickness = 0.09,
--     lens_distortion = 0.7,

--     dark = {
--       tint_color = tint(colors.surface, 0.12),
--       brightness = 0.92,
--       contrast = 0.95,
--       saturation = 0.90,
--       vibrancy = 0.22,
--       adaptive_dim = 0.25,
--     },
--     light = {
--       tint_color = tint(colors.surface, 0.4),
--       brightness = 1.18,
--       contrast = 0.96,
--       saturation = 0.95,
--       vibrancy = 0.18,
--       adaptive_boost = 0.30,
--     },
--   })

--   hg.preset('glass', {
--     blur_strength = 2,
--     blur_iterations = 1,
--     chromatic_aberration = 0.3,
--     freshnel_strength = 0.8,
--     edge_thickness = 0.08,
--     tint_color = tint(colors.surface, 0.12),
--     lens_distortion = 0.8,
--     brightness = 1.0,
--     contrast = 1.7,
--     saturation = 1,
--     vibrancy = 0.8,
--     vibrancy_darkness = 1,
--     adaptive_boost = 0.5,
--   })

--   hg.config {
--     enabled = enable_effect,
--     default_preset = 'glass',
--     default_theme = 'dark',
--     layers = { enabled = false },
--   }
-- end

if hl.plugin.dynamic_cursors then
  hl.config {
    plugin = {
      dynamic_cursors = {
        mode = 'stretch',
        shake = {
          base = 2.5,
          effects = true,
        },
      },
    },
  }
end

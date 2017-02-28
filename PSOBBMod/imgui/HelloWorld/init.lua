local init = function()
  print('This code will run on initialization. Open the Lua Log to see it.')
  return {
    name = "HelloWorld",
    version = "1.0",
    author = "Eidolon"
  }
end

local selected = false;

local difficulties = {
  "Normal", "Hard", "Very Hard", "Ultimate"
}

local ep1_areas = {
 "Pioneer 2", "Forest 1", "Forest 2", "Caves 1", "Caves 2", "Caves 3",
 "Mines 1", "Mines 2", "Ruins 1", "Ruins 2", "Ruins 3",
 "Dragon", "De Rol Le", "Vol Opt", "Dark Falz",
 "Lobby", "Temple", "Spaceship"
}

local ep2_areas = {
  "Pioneer 2", "VR Temple Alpha", "VR Temple Beta", "VR Spaceship Alpha",
  "VR Spaceship Beta", "Central Control Area", "Jungle Area North",
  "Jungle Area East", "Mountain Area", "Seaside Area", "Seabed Upper Levels",
  "Seabed Lower Levels", "Gal Gryphon", "Olga Flow", "Barba Ray", "Gol Dragon",
  "Seaside Area", "Tower"
}

local ep4_areas = {
  "Pioneer 2", "Crater East", "Crater West", "Crater South", "Crater North",
  "Crater Interior", "Desert 1", "Desert 2", "Desert 3", "Saint Milion"
}

local first_player_ptr = 0x00A94254

local get_difficulty = function()
  local d = pso.read_u8(0x00A9CD68);
  local s
  if d == 0 then
    s = "Normal"
  elseif d == 1 then
    s = "Hard"
  elseif d == 2 then
    s = "Very Hard"
  elseif d == 3 then
    s = "Ultimate"
  else
    s = "Unknown"
  end
  return s
end

local _do_plot_graph = function()
  local values = { 0, 32, 64, 32, 64, 32, 0 }
  -- The Plot Lines function only needs 3 arguments, the rest are optional.
  -- See the dear imgui header for more info
  -- arguments that take a ImVec2 are flattened into 2 arguments, 3 to 3 args, so on so forth
  imgui.PlotLines("PlotLines Example", values, #values, 0, nil, 0, 64, 128, 64)
end

local mem_buffer = {}

local function clear_table(t)
  local next = next
  local k = next(t)
  while k ~= nil do
    t[k] = nil
    k = next(t, k)
  end
end

local function array_to_string(t)
  local buf = "{ "
  for i,v in ipairs(t) do
    buf = buf .. tostring(v) .. ", "
  end
  return buf .. " }"
end

local present = function()
  local status

  imgui.Begin("HelloWorld Addon")
  imgui.Text("Hello world! This is an example.")
  if imgui.Selectable("Selectable", selected) then
    selected = not selected
  end
  if selected then
    imgui.TextUnformatted("ASCII Version String: " .. pso.read_cstr(0x96E220, 40))
  else
    imgui.Text("...")
  end
  if imgui.Button("Reload") then
    pso.reload()
  end
  _do_plot_graph()
  imgui.TextUnformatted("Difficulty: " .. difficulties[pso.read_u8(0x00A9CD68) + 1] or "")
  imgui.TextUnformatted("Area: " .. ep1_areas[pso.read_u8(0x00AC9D58) + 1])
  imgui.TextUnformatted("Lobby: " .. pso.read_u8(0x00AAB204))
  clear_table(mem_buffer)
  imgui.TextWrapped("Player 1 mem: " .. tostring(array_to_string(pso.read_mem(mem_buffer, first_player_ptr, 256))))
  imgui.End()
end

local key_pressed = function(keycode)
  if keycode == 0x20 then
    print('spacebar was pressed!')
  end
end

local key_released = function(keycode)
  if keycode == 0x20 then
    print('spacebar was released!')
  end
end

pso.on_init(init)
pso.on_present(present)
pso.on_key_pressed(key_pressed)
pso.on_key_released(key_released)

-- This isn't necessary, but may be useful if you want to use another addons'
-- code; you can retrieve an addon's module with require('AddonName').
return {
  init = init,
  present = present,
  key_pressed = key_pressed
}
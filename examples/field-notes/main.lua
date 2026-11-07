local window = ui.window({ id = "notes", title = "Field Notes", width = 220 })

local saved = storage.load() or {}
local tab = saved.tab or "dex"
local last_caught = saved.last_caught
local clock, sky

local function keep()
	storage.save({ tab = tab, closed = saved.closed, last_caught = last_caught })
end

local function time_text()
	local time = game.state("time")
	if time == nil then
		return "The clock hasn't started yet."
	end
	return string.format("%02d:%02d, %s", time.hour, time.minute, time.phase)
end

local function weather_text()
	local weather = game.state("weather")
	return if weather then `Weather: {weather.kind}` else ""
end

local function dex_tab()
	local dex = game.state("dex")
	if dex == nil then
		window:label("Waiting for your dex...")
		return
	end
	local seen, caught, shiny = 0, 0, 0
	for _, entry in dex do
		seen += if entry.seen then 1 else 0
		caught += if entry.caught then 1 else 0
		shiny += if entry.shiny then 1 else 0
	end
	window:label(`Seen {seen}   Caught {caught}   Shiny {shiny}`)
	if last_caught then
		local row = window:row()
		local note = row:label("Last caught. Press it for its name.")
		row:monster(last_caught):on_press(function()
			local species = data.species(last_caught)
			note:set_text(if species then species.name else "Unknown")
		end)
	end
end

local function world_tab()
	clock = window:label(time_text())
	sky = window:label(weather_text())
	local client = game.state("client")
	if client then
		window:label(`Revision {client.revision} on {client.platform}`)
	end
end

local rebuild

local function open_tab(name)
	tab = name
	keep()
	rebuild()
end

function rebuild()
	window:clear()
	clock, sky = nil, nil
	local tabs = window:row()
	tabs:button("Dex", function() open_tab("dex") end):set_selected(tab == "dex")
	tabs:button("World", function() open_tab("world") end):set_selected(tab == "world")
	if tab == "dex" then
		dex_tab()
	else
		world_tab()
	end
end

game.on("ready", rebuild)
game.on("dex_loaded", rebuild)
game.on("dex_changed", function()
	if tab == "dex" then
		rebuild()
	end
end)
game.on("caught", function(catch)
	last_caught = catch.species
	keep()
	if tab == "dex" then
		rebuild()
	end
end)
game.on("time_changed", function()
	if clock then
		clock:set_text(time_text())
	end
end)
game.on("weather_changed", function()
	if sky then
		sky:set_text(weather_text())
	end
end)

window:on_close(function()
	saved.closed = true
	keep()
end)
window:on_open(function()
	saved.closed = false
	keep()
end)

if not saved.closed then
	window:show()
end

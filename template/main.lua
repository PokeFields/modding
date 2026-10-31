local window = ui.window({ id = "main", title = "My Addon" })
local where = window:label("Waiting...")

game.on("location_changed", function(location)
	where:set_text(`{location.area} ({location.x}, {location.y})`)
end)

window:show()

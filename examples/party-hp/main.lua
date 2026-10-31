local window = ui.window({ id = "party", title = "Party HP", width = 220 })

local function rebuild()
	window:clear()
	local party = game.state("party")
	if party == nil or #party == 0 then
		window:label("No monsters yet.")
		return
	end
	for _, mon in party do
		if mon.egg then
			window:label("Egg")
			continue
		end
		local row = window:row()
		row:monster(mon.species)
		local status = if mon.status ~= "" then `  ({mon.status})` else ""
		row:label(`{mon.name}  Lv. {mon.level}{status}`)
		window:bar(mon.hp, mon.max_hp)
	end
end

game.on("ready", rebuild)
game.on("party_changed", rebuild)

window:show()

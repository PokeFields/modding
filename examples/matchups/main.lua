local window = ui.window({ id = "matchups", title = "Matchups", width = 240 })

local ally: number? = nil
local foe: number? = nil

local function verdict(multiplier: number): string
	if multiplier == 0 then
		return "no effect"
	elseif multiplier < 1 then
		return `x{multiplier} not very effective`
	elseif multiplier > 1 then
		return `x{multiplier} super effective`
	end
	return "x1"
end

local function in_party(species: number)
	for _, mon in game.state("party") or {} do
		if mon.species == species and not mon.egg then
			return mon
		end
	end
	return nil
end

local function refresh()
	window:clear()
	local target = if foe then data.species(foe) else nil
	if target == nil then
		window:label("Waiting for a foe...")
		return
	end
	window:label(`{target.name} ({table.concat(target.types, "/")})`)

	local mon = if ally then in_party(ally) else nil
	if mon == nil then
		return
	end
	for _, slot in mon.moves do
		local move = data.move(slot.id)
		if move and move.category ~= "status" then
			local row = window:row()
			row:label(move.name)
			row:label(verdict(data.effectiveness(move.type, target.types)))
		end
	end
end

game.on("battle_started", function(battle)
	ally = nil
	foe = if #battle.foes > 0 then battle.foes[1].species else nil
	refresh()
	window:show()
end)

game.on("battle_switched", function(monster)
	if monster.side == "ally" then
		ally = monster.species
	else
		foe = monster.species
	end
	refresh()
end)

game.on("battle_ended", function()
	window:hide()
end)

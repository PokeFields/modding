-- Saved data comes back from JSON, so species are keyed by strings.
type Counts = { total: number, shinies: number, species: { [string]: number } }

local SHOWN = 5

local function empty(): Counts
	return { total = 0, shinies = 0, species = {} }
end

local counts: Counts = storage.load() or empty()
local window = ui.window({ id = "counter", title = "Encounters", width = 200 })

local function refresh()
	window:clear()
	window:label(`Wild encounters: {counts.total}`)
	window:label(`Shinies: {counts.shinies}`)

	local seen = {}
	for id, n in counts.species do
		table.insert(seen, { species = tonumber(id), n = n })
	end
	table.sort(seen, function(a, b)
		return a.n > b.n
	end)
	for i = 1, math.min(SHOWN, #seen) do
		local row = window:row()
		row:monster(seen[i].species)
		row:label(`x{seen[i].n}`)
	end

	window:button("Reset", function()
		counts = empty()
		storage.save(counts)
		refresh()
	end)
end

game.on("battle_started", function(battle)
	if battle.kind ~= "wild" then
		return
	end
	for _, foe in battle.foes do
		local key = tostring(foe.species)
		counts.total += 1
		counts.species[key] = (counts.species[key] or 0) + 1
		if foe.shiny then
			counts.shinies += 1
		end
	end
	storage.save(counts)
	refresh()
end)

refresh()
window:show()

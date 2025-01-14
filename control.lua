SpiderNames = {"spidertron", "spidertronmk2", "spidertronmk3"}

function AddSpider(spider)
	local regNum = script.register_on_entity_destroyed(spider)
	global.Spiders[regNum] = spider
end

script.on_init(function()
	local spiders = {}
	for SpiderName in SpiderNames do 
		spiders.insert(game.surfaces.nauvis.find_entities_filtered{name=SpiderName})
	end
	global.Spiders = {}
	for _, spider in pairs(spiders) do
		AddSpider(spider)
	end
end)

function OnTick()
	for _, spider in pairs(global.Spiders) do
		local inventory = spider.get_inventory(defines.inventory.spider_trunk)
		inventory.sort_and_merge()
	end
end

script.on_nth_tick(60, OnTick)

script.on_event(defines.events.on_built_entity, function(event)
	for _, name in pairs(SpiderNames) do
		if event.created_entity.name == name
		then
			AddSpider(event.created_entity)
		end
	end
end)

script.on_event(defines.events.on_entity_destroyed, function (event)
	global.Spiders[event.registration_number] = nil
end)

local mineFilters = {}
for _, Name in pairs(SpiderNames) do
	table.insert(mineFilters, {filter = "name", name = Name})
end

script.on_event(
	defines.events.on_player_mined_entity,
	function(event)
		for key, spider in pairs(global.Spiders) do
			if spider == event.entity then
				global.Spiders[key] = nil
			end
		end
	end,
	mineFilters
)
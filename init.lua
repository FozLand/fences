local load_time_start = os.clock()

fences = {}

function fences.register_fence(name, def)
	minetest.register_craft({
		output = name .. " 6",
		recipe = {
			{def.material, def.material, def.material},
			{def.material, def.material, def.material},
		}
	})

	local fence_texture = def.texture .. "^fences_overlay.png^[makealpha:255,126,126"
	-- Allow almost everything to be overridden
	local default_fields = {
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "connected",
			fixed = {{-1/8, -1/2, -1/8, 1/8, 1/2, 1/8}},
			-- connect_top =
			-- connect_bottom =
			connect_front = {{-1/16,3/16,-1/2,1/16,5/16,-1/8},
				{-1/16,-5/16,-1/2,1/16,-3/16,-1/8}},
			connect_left = {{-1/2,3/16,-1/16,-1/8,5/16,1/16},
				{-1/2,-5/16,-1/16,-1/8,-3/16,1/16}},
			connect_back = {{-1/16,3/16,1/8,1/16,5/16,1/2},
				{-1/16,-5/16,1/8,1/16,-3/16,1/2}},
			connect_right = {{1/8,3/16,-1/16,1/2,5/16,1/16},
				{1/8,-5/16,-1/16,1/2,-3/16,1/16}},
		},
		connects_to = {"group:fence", "group:wood", "group:tree"},
		inventory_image = fence_texture,
		wield_image = fence_texture,
		tiles = {def.texture},
		sunlight_propagates = true,
		is_ground_content = false,
		groups = {},
	}
	for k, v in pairs(default_fields) do
		if not def[k] then
			def[k] = v
		end
	end

	-- Always add to the fence group, even if no group provided
	def.groups.fence = 1

	def.texture = nil
	def.material = nil

	minetest.register_node(name, def)
end

local morefences = {
	{
		name = 'cobble',
		description = 'Cobblestone Fence',
		texture = 'default_cobble.png',
		groups = {cracky=3, stone=2}
	},
	{
		name = 'desert_cobble',
		description = 'Desert Cobblestone Fence',
		texture = 'default_desert_cobble.png',
		groups = {cracky=3, stone=2}
	},
	{
		name = 'sandstone',
		description = 'Sandstone Fence',
		texture = 'default_sandstone.png',
		groups = {crumbly=2, cracky=3}
	},
	{
		name = 'stonebrick',
		description = 'Stone Brick Fence',
		texture = 'default_stone_brick.png',
		groups = {cracky=2, stone=1}
	},
	{
		name = 'sandstonebrick',
		description = 'Sandstone Brick Fence',
		texture = 'default_sandstone_brick.png',
		groups = {cracky=2}
	},
	{
		name = 'desert_stonebrick',
		description = 'Desert Stone Brick Fence',
		texture = 'default_desert_stone_brick.png',
		groups = {cracky=2, stone=1}
	},
}

for _,t in pairs(morefences) do
	fences.register_fence('fences:' .. t.name, {
		description = t.description,
		texture = t.texture,
		material = 'default:' .. t.name,
		groups = t.groups,
		sounds = default.node_sound_stone_defaults(),
	})
end

-- Pine and Acacia have been moved to default.
minetest.register_alias("fences:pine",   "default:fence_pine_wood")
minetest.register_alias("fences:acacia", "default:fence_acacia_wood")

-- Make default fence gate's usable as fuel
local default_fence_wood = {
	'wood',
	'acacia_wood',
	'junglewood',
	'pine_wood',
	'aspen_wood',
}

for _,wood in pairs(default_fence_wood) do
	minetest.register_craft({
		type = 'fuel',
		recipe = 'doors:gate_' .. wood,
		burntime = 40 -- Same burn time gain as tree to fence.
	})
end

if core.get_modpath('moretrees') then
	local morewood = {
		{name='beech',       desc = 'Beech',         mod = 'moretrees'},
		{name='apple_tree',  desc = 'Apple',         mod = 'moretrees'},
		{name='oak',         desc = 'Oak',           mod = 'moretrees'},
		{name='sequoia',     desc = 'Giant Sequoia', mod = 'moretrees'},
		{name='birch',       desc = 'Birch',         mod = 'moretrees'},
		{name='palm',        desc = 'Palm',          mod = 'moretrees'},
		{name='spruce',      desc = 'Spruce',        mod = 'moretrees'},
		{name='willow',      desc = 'Willow',        mod = 'moretrees'},
		{name='rubber_tree', desc = 'Rubber',        mod = 'moretrees'},
		{name='fir',         desc = 'Douglas Fir',   mod = 'moretrees'},
	}
	for _,t in pairs(morewood) do
		default.register_fence('fences:' .. t.name, {
			description = t.desc .. 'Fence',
			texture = t.mod .. '_' .. t.name .. '_wood.png',
			material = t.mod .. ":" .. t.name .. '_planks',
			groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2},
			sounds = default.node_sound_wood_defaults(),
		})

		minetest.register_craft({
			type = 'fuel',
			recipe = 'fences:' .. t.name,
			burntime = 15,
		})

		doors.register_fencegate('fences:gate_' .. t.name, {
			description = t.desc .. ' Fence Gate',
			texture = t.mod .. '_' .. t.name .. '_wood.png',
			material = t.mod .. ":" .. t.name .. '_planks',
			groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2},
		})

		minetest.register_craft({
			type = 'fuel',
			recipe = 'fences:gate_' .. t.name .. '_closed',
			burntime = 40 -- Same burn time gain as tree to fence.
		})
	end
end

minetest.log(
	'action',
	string.format(
		'['..minetest.get_current_modname()..'] loaded in %.3fs',
		os.clock() - load_time_start
	)
)

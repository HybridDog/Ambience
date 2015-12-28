--------------------------------------------------------------------------------------------------------
--Ambience Configuration for version .34
--Added Faraway & Ethereal by Amethystium

--Working on:
--removing magic leap when not enough air under feet.


--find out why wind stops while flying
--add an extra node near feet to handle treading water as a special case, and don't have to use node under feet. which gets
	--invoked when staning on a ledge near water.
--reduce redundant code (stopplay and add ambience to list)

local max_frequency_all = 1000 --the larger you make this number the lest frequent ALL sounds will happen recommended values between 100-2000.

--for frequencies below use a number between 0 and max_frequency_all
--for volumes below, use a number between 0.0 and 1, the larger the number the louder the sounds
local night_frequency = 20  --owls, wolves
local night_volume = 0.8
local night_frequent_frequency = 150  --crickets
local night_frequent_volume = 0.8
local day_frequency = 80  --crow, bluejay, cardinal
local day_volume = 0.5
local day_frequent_frequency = 250  --crow, bluejay, cardinal
local day_frequent_volume = 0.18
local cave_frequency = 10  --bats
local cave_volume = 0.8
local cave_frequent_frequency = 70  --drops of water dripping
local cave_frequent_volume = 0.8
local beach_frequency = 20  --seagulls
local beach_volume = 0.8
local beach_frequent_frequency = 1000  --waves
local beach_frequent_volume = 0.8
local water_frequent_frequency = 1000  --water sounds
local water_frequent_volume = 0.8
local desert_frequency = 20  --coyote
local desert_volume = 0.8
local desert_frequent_frequency = 700  --desertwind
local desert_frequent_volume = 0.8
local swimming_frequent_frequency = 1000  --swimming splashes
local swimming_frequent_volume = 0.8
local water_surface_volume = 0.8   -- sloshing water
local lava_volume = 0.8 --lava
local flowing_water_volume = .1  --waterfall
local splashing_water_volume = 1
local music_frequency = 4  --music (suggestion: keep this one low like around 6)
local music_volume = 0.3

--End of Config
----------------------------------------------------------------------------------------------------
local counter=0--*****************
local SOUNDVOLUME = 1
local MUSICVOLUME = 0.4
local sound_vol = 1
local last_x_pos = 0
local last_y_pos = 0
local last_z_pos = 0
local node_under_feet, node_at_upper_body, node_at_lower_body, node_3_under_feet
local played_on_start = false



local sounds_data = {

	night = {
		handler = {},
		frequency = night_frequency,
		{name="horned_owl", length=3, gain=night_volume},
		{name="Wolves_Howling", length=11,  gain=night_volume},
		{name="ComboWind", length=17,  gain=night_volume}
	},

	night_frequent = {
		handler = {},
		frequency = night_frequent_frequency,
		{name="Crickets_At_NightCombo", length=69, gain=night_frequent_volume}
	},

	day = {
		handler = {},
		frequency = day_frequency,
		{name="Best Cardinal Bird", length=4, gain=day_volume},
		{name="craw", length=3, gain=day_volume},
		{name="bluejay", length=18, gain=day_volume},
		{name="ComboWind", length=17,  gain=day_volume}
	},

	day_frequent = {
		handler = {},
		frequency = day_frequent_frequency,
		{name="robin2", length=16, gain=day_frequent_volume},
		{name="birdsongnl", length=13, gain=day_frequent_volume},
		{name="bird", length=30, gain=day_frequent_volume},
		{name="Best Cardinal Bird", length=4, gain=day_frequent_volume},
		{name="craw", length=3, gain=day_frequent_volume},
		{name="bluejay", length=18, gain=day_frequent_volume},
		{name="ComboWind", length=17,  gain=day_frequent_volume*3}
	},
	swimming_frequent = {
		handler = {},
		frequency = day_frequent_frequency,
		{name="water_swimming_splashing_breath", length=11.5, gain=swimming_frequent_volume},
		{name="water_swimming_splashing", length=9, gain=swimming_frequent_volume}
	},

	cave = {
		handler = {},
		frequency = cave_frequency,
		{name="Bats_in_Cave", length=5, gain=cave_volume}
	},

	cave_frequent = {
		handler = {},
		frequency = cave_frequent_frequency,
		{name="drippingwater_drip_a", length=2, gain=cave_frequent_volume},
		{name="drippingwater_drip_b", length=2, gain=cave_frequent_volume},
		{name="drippingwater_drip_c", length=2, gain=cave_frequent_volume},
		{name="Single_Water_Droplet", length=3, gain=cave_frequent_volume},
		{name="Spooky_Water_Drops", length=7, gain=cave_frequent_volume}
	},

	beach = {
		handler = {},
		frequency = beach_frequency,
		{name="seagull", length=4.5, gain=beach_volume}
	},

	beach_frequent = {
		handler = {},
		frequency = beach_frequent_frequency,
		{name="fiji_beach", length=43.5, gain=beach_frequent_volume}
	},

	desert = {
		handler = {},
		frequency = desert_frequency,
		{name="coyote2", length=2.5, gain=desert_volume},
		{name="RattleSnake", length=8, gain=desert_volume}
	},

	desert_frequent = {
		handler = {},
		frequency = desert_frequent_frequency,
		{name="DesertMonolithMed", length=34.5, gain=desert_frequent_volume}
	},

	flying = {
		handler = {},
		frequency = 1000,
		on_start = "nothing_yet",
		on_stop = "nothing_yet",
		{name="ComboWind", length=17,  gain=1}
	},

	water = {
		handler = {},
		frequency = 0,--dolphins dont fit into small lakes
		{name="dolphins", length=6, gain=1},
		{name="dolphins_screaming", length=16.5, gain=1}
	},

	water_frequent = {
		handler = {},
		frequency = water_frequent_frequency,
		on_stop = "drowning_gasp",
		--on_start = "Splash",
		{name="scuba1bubbles", length=11, gain=water_frequent_volume},
		{name="scuba1calm", length=10, gain=water_frequent_volume},  --not sure why but sometimes I get errors when setting gain=water_frequent_volume here.
		{name="scuba1calm2", length=8.5, gain=water_frequent_volume},
		{name="scuba1interestingbubbles", length=11, gain=water_frequent_volume},
		{name="scuba1tubulentbubbles", length=10.5, gain=water_frequent_volume}
	},

	water_surface = {
		handler = {},
		frequency = 1000,
		on_stop = "Splash",
		on_start = "Splash",
		{name="lake_waves_2_calm", length=9.5, gain=water_surface_volume},
		{name="lake_waves_2_variety", length=13.1, gain=water_surface_volume}
	},
	splashing_water = {
		handler = {},
		frequency = 1000,
		{name="Splash", length=1.22, gain=splashing_water_volume}
	},

	flowing_water = {
		handler = {},
		frequency = 1000,
		{name="small_waterfall", length=14, gain=flowing_water_volume}
	},
	flowing_water2 = {
		handler = {},
		frequency = 1000,
		{name="small_waterfall", length=11, gain=flowing_water_volume}
	},

	lava = {
		handler = {},
		frequency = 1000,
		{name="earth01a", length=20, gain=lava_volume}
	},
	lava2 = {
		handler = {},
		frequency = 1000,
		{name="earth01a", length=15, gain=lava_volume}
	},

	music = {
		handler = {},
		frequency = music_frequency,
		is_music=true,
		{name="StrangelyBeautifulShort", length=3*60+.5, gain=music_volume*.7},
		{name="AvalonShort", length=2*60+58, gain=music_volume*1.4},
		--{name="mtest", length=4*60+33, gain=music_volume},
		--{name="echos", length=2*60+26, gain=music_volume},
		--{name="FoamOfTheSea", length=1*60+50, gain=music_volume},
		{name="eastern_feeling", length=3*60+51, gain=music_volume},
		--{name="Mass_Effect_Uncharted_Worlds", length=2*60+29, gain=music_volume},
		{name="EtherealShort", length=3*60+4, gain=music_volume*.7},
		{name="FarawayShort", length=3*60+5, gain=music_volume*.7},
		{name="dark_ambiance", length=44, gain=music_volume},
		{name="echos", length=2*60+25, gain=music_volume}
	},
}

local play_music = minetest.setting_getbool("music") or false


local function nodes_in_range(pos, search_distance, node_name)
	return #minetest.find_nodes_in_area(vector.subtract(pos, search_distance), vector.add(pos, search_distance), node_name)
end

local function atleast_nodes_in_grid(pos, search_distance, height, node_name, threshold)
	counter = counter +1
	local totalnodes = 0
	for _,ps in pairs({
		{{-search_distance, 20}, {search_distance, 20}},
		{{-search_distance, -20}, {search_distance, -20}},
		{{20, -search_distance}, {20, search_distance}},
		{{-20, -search_distance}, {-20, search_distance}},
	}) do
		local x1,z1 = unpack(ps[1])
		local x2,z2 = unpack(ps[2])
		local nodesc = #(minetest.find_nodes_in_area({x=pos.x+x1, y=height, z=pos.z+z1}, {x=pos.x+x2, y=height, z=pos.z+z2}, node_name))
		if nodesc >= threshold then
			return true
		end
		totalnodes = totalnodes + nodesc
		if totalnodes >= threshold*2 then
			return true
		end
	end
	return false
end

local function get_immediate_nodes(pos)
	pos.y = pos.y-1
	node_under_feet = minetest.get_node(pos).name
	pos.y = pos.y-3
	node_3_under_feet = minetest.get_node(pos).name
	pos.y = pos.y+3
	pos.y = pos.y+2.2
	node_at_upper_body = minetest.get_node(pos).name
	pos.y = pos.y-1.19
	node_at_lower_body = minetest.get_node(pos).name
	pos.y = pos.y+0.99
	--minetest.chat_send_all("node_under_feet(" .. nodename .. ")")
end


local function get_ambience(player)
	local player_is_climbing, player_is_descending, player_is_moving_horiz, standing_in_water
	local pos = player:getpos()
	get_immediate_nodes(pos)

	if last_x_pos ~=pos.x
	or last_z_pos ~=pos.z then
		player_is_moving_horiz = true
	end
	if pos.y > last_y_pos+.5 then
		player_is_climbing = true
	end
	if pos.y < last_y_pos-.5 then
		player_is_descending = true
	end

	last_x_pos =pos.x
	last_z_pos =pos.z
	last_y_pos =pos.y

	if string.find(node_at_upper_body, "default:water") then
		return {water=true, water_frequent=true}
	end

	local on_water = string.find(node_under_feet, "default:water")
	if node_at_upper_body == "air"
	and (
		string.find(node_at_lower_body, "default:water")
		or on_water
	) then
		--minetest.chat_send_all("bottom counted as water")
		--we found air at upperbody, and water at lower body.  Now there are 4 possibilities:
		--Key: under feet, moving or not
		--swimming 			w, m swimming
		--walking in water  nw, m splashing
		--treading water    w, nm  sloshing
		--standing in water nw, nm	beach trumps, then sloshing
		if player_is_moving_horiz then
			if on_water then
				return {swimming_frequent=true}
			end
			--didn't find water under feet: walking in water
			return {splashing_water=true}
		end
		--player is not moving: treading water
		if string.find(node_under_feet, "default:water") then
			return {water_surface=true}
		end
		--didn't find water under feet
		standing_in_water = true
	end
	--[[
--	minetest.chat_send_all("----------")
--	if not player_is_moving_horiz then
--		minetest.chat_send_all("not moving horiz")
--	else
--		minetest.chat_send_all("moving horiz")
--	end
--	minetest.chat_send_all("nub:" ..node_at_upper_body)
--	minetest.chat_send_all("nlb:" ..node_at_lower_body)
--	minetest.chat_send_all("nuf:" ..node_under_feet)
--	minetest.chat_send_all("----------")


--	if player_is_moving_horiz then
--		minetest.chat_send_all("playermoving")
--	end
--	if player_is_climbing then
--			minetest.chat_send_all("player Climbing")
--	end
--	minetest.chat_send_all("nub:" ..node_at_upper_body)
--	minetest.chat_send_all("nlb:" ..node_at_lower_body)
--	minetest.chat_send_all("nuf:" ..node_under_feet)
--	minetest.chat_send_all("n3uf:" ..node_3_under_feet)
--
	local air_or_ignore = {air=true,ignore=true}
	local minp = {x=pos.x-3,y=pos.y-4, z=pos.z-3}
	local maxp = {x=pos.x+3,y=pos.y-1, z=pos.z+3}
	local air_under_player = nodes_in_coords(minp, maxp, "air")
	local ignore_under_player = nodes_in_coords(minp, maxp, "ignore")
--	air_plus_ignore_under = air_under_player + ignore_under_player
--	minetest.chat_send_all("airUnder:" ..air_under_player)
--	minetest.chat_send_all("ignoreUnder:" ..ignore_under_player)
--	minetest.chat_send_all("a+i:" ..air_plus_ignore_under)
--	minetest.chat_send_all("counter: (" .. counter .. "-----------------)")
	--minetest.chat_send_all(air_or_ignore[node_under_feet])
--	if (player_is_moving_horiz or player_is_climbing) and air_or_ignore[node_at_upper_body] and air_or_ignore[node_at_lower_body]
--	 and air_or_ignore[node_under_feet] and air_plus_ignore_under == 196 and not player_is_descending then
	--minetest.chat_send_all("flying!!!!")
	--	if music then
		--	return {flying=flying, music=music}
	--	else
		---	return {flying}
--		end
--	end
	--minetest.chat_send_all("not flying!!!!")
	--]]

	if nodes_in_range(pos, 7, "default:lava_flowing") > 5
	or nodes_in_range(pos, 7, "default:lava_source") > 5 then
		return {lava=true, lava2=true}
	end
	if nodes_in_range(pos, 6, "default:water_flowing") > 45 then
		return {flowing_water=true, flowing_water2=true}
	end


--if we are near sea level and there is lots of water around the area
	if pos.y < 7
	and pos.y >0
	and atleast_nodes_in_grid(pos, 60, 1, "default:water_source", 51 ) then
		return {beach=true, beach_frequent=true}
	end
	if standing_in_water then
		return {water_surface=true}
	end


	if nodes_in_range(pos, 6, "default:desert_sand")+nodes_in_range(pos, 6, "default:desert_stone") >250 then
		return {desert=true, desert_frequent=true}
	end

--	pos.y = pos.y-2
--	nodename = minetest.get_node(pos).name
--	minetest.chat_send_all("Found " .. nodename .. pos.y )


	if pos.y < 0 then
		return {cave=true, cave_frequent=true}
	end

	local time = minetest.get_timeofday()
	if time > 0.2
	and time < 0.8 then
		return {day=true, day_frequent=true}
	end
	return {night=true, night_frequent=true}
end

-- override the minetest.sound_play function
local old_sound_play = minetest.sound_play
minetest.sound_play = function(sound, params, ...)
	if params
	and params.gain == 0 then
		return
	end
	return old_sound_play(sound, params, ...)
end

-- an own sound play function
local active_sounds = {}
local function sound_play(sound, params)
	local sound = minetest.sound_play(sound, params)
	local length = params and params.length
	if sound
	and length
	and length > 10 then
		local time = tonumber(os.clock())
		active_sounds[time] = sound
		minetest.after(length, function(time)
			active_sounds[time] = nil
		end, time)
	end
	return sound
end

-- start playing the sound, set the handler and delete the handler after sound is played
local function play_sound(player, list, number, is_music)
	local player_name = player:get_player_name()
	if list.handler[player_name] then
		return
	end
	local gain = list[number].gain
	if gain then
		if is_music then
			gain = gain*MUSICVOLUME
			--minetest.chat_send_all("gain music: " .. gain )
		else
			gain = gain*SOUNDVOLUME
			--minetest.chat_send_all("gain sound: " .. gain )
		end
	else
		gain = 1
	end
	local handler = sound_play(list[number].name, {to_player=player_name, gain=gain})
	if not handler then
		return
	end
	list.handler[player_name] = handler
	minetest.after(list[number].length, function(list, player_name)
		if list.handler[player_name] then
			minetest.sound_stop(list.handler[player_name])
			list.handler[player_name] = nil
		end
	end, list, player_name)
end

-- stops all sounds that are not in still_playing
local function stop_sound(still_playing, player)
	local player_name = player:get_player_name()
	for i,list in pairs(sounds_data) do
		if not still_playing[i]
		and list.handler[player_name] then
			if list.on_stop then
				sound_play(list.on_stop, {to_player=player:get_player_name(),gain=SOUNDVOLUME})
				if i == "water_surface"
				or i == "water_frequent"
				or i == "flying" then
					played_on_start = false
				end
			end
			minetest.sound_stop(list.handler[player_name])
			list.handler[player_name] = nil
		end
	end
end

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer+dtime
	if timer < 1 then
		return
	end
	timer = 0

	for _,player in pairs(minetest.get_connected_players()) do
		local ambiences = get_ambience(player)
		ambiences.music = true
		stop_sound(ambiences, player)
		local pname = player:get_player_name()
		for i in pairs(ambiences) do
			local ambience = sounds_data[i]
			if math.random(1, 1000) <= ambience.frequency then
				if ambience.on_start
				and not played_on_start then
					played_on_start = true
					sound_play(ambience.on_start, {to_player=pname, gain=SOUNDVOLUME})
				end
				play_sound(player, ambience, math.random(1, #ambience), ambience.is_music ~= nil)
			end
		end
	end
end)

minetest.register_chatcommand("svol", {
	params = "<svol>",
	description = "set volume of sounds, default 1 normal volume.",
	privs = {server=true},
	func = function(name, volume)
		volume = tonumber(volume)
		if not volume then
			minetest.chat_send_player(name, "Sound volume is "..volume)
			return
		end
		SOUNDVOLUME = volume
		minetest.chat_send_player(name, "Sound volume set to "..volume)
	end,
})

minetest.register_chatcommand("mvol", {
	params = "<mvol>",
	description = "set volume of music, default 1 normal volume.",
	privs = {server=true},
	func = function(name, volume)
		volume = tonumber(volume)
		if not volume then
			minetest.chat_send_player(name, "Music volume is "..volume)
			return
		end
		MUSICVOLUME = volume
		minetest.chat_send_player(name, "Music volume set to "..volume)
	end,
})

/*
CONTAINS:
RPD
*/

#define ATMOS_CATEGORY 0
#define DISPOSALS_CATEGORY 1
#define TRANSIT_CATEGORY 2
#define PLUMBING_CATEGORY 3

#define BUILD_MODE 1
#define WRENCH_MODE 2
#define DESTROY_MODE 4
#define PAINT_MODE 8


GLOBAL_LIST_INIT(atmos_pipe_recipes, list(
	"Pipes" = list(
		new /datum/pipe_info/pipe("Pipe",				/obj/machinery/atmospherics/pipe/simple, TRUE),
		new /datum/pipe_info/pipe("Manifold",			/obj/machinery/atmospherics/pipe/manifold, TRUE),
		new /datum/pipe_info/pipe("4-Way Manifold",		/obj/machinery/atmospherics/pipe/manifold4w, TRUE),
		new /datum/pipe_info/pipe("Layer Manifold",		/obj/machinery/atmospherics/pipe/layer_manifold, TRUE),
		new /datum/pipe_info/pipe("Multi-Deck Adapter", /obj/machinery/atmospherics/pipe/multiz, TRUE),
	),
	"Devices" = list(
		new /datum/pipe_info/pipe("Connector",			/obj/machinery/atmospherics/components/unary/portables_connector, FALSE),
		new /datum/pipe_info/pipe("Gas Pump",			/obj/machinery/atmospherics/components/binary/pump, TRUE),
		new /datum/pipe_info/pipe("Volume Pump",		/obj/machinery/atmospherics/components/binary/volume_pump, TRUE),
		new /datum/pipe_info/pipe("Gas Filter",			/obj/machinery/atmospherics/components/trinary/filter, TRUE),
		new /datum/pipe_info/pipe("Gas Mixer (M)",		/obj/machinery/atmospherics/components/trinary/mixer, TRUE),
		new /datum/pipe_info/pipe("Gas Mixer (T)",		/obj/machinery/atmospherics/components/trinary/mixer/t_mixer, FALSE, PIPE_UNARY),
		new /datum/pipe_info/pipe("Passive Gate",		/obj/machinery/atmospherics/components/binary/passive_gate, TRUE),
		new /datum/pipe_info/pipe("Injector",			/obj/machinery/atmospherics/components/unary/outlet_injector, TRUE),
		new /datum/pipe_info/pipe("Scrubber",			/obj/machinery/atmospherics/components/unary/vent_scrubber, TRUE),
		new /datum/pipe_info/pipe("Unary Vent",			/obj/machinery/atmospherics/components/unary/vent_pump, TRUE),
		new /datum/pipe_info/pipe("Passive Vent",		/obj/machinery/atmospherics/components/unary/passive_vent, TRUE),
		new /datum/pipe_info/pipe("Manual Valve",		/obj/machinery/atmospherics/components/binary/valve, TRUE),
		new /datum/pipe_info/pipe("Digital Valve",		/obj/machinery/atmospherics/components/binary/valve/digital, TRUE),
		new /datum/pipe_info/pipe("Pressure Valve",		/obj/machinery/atmospherics/components/binary/pressure_valve, TRUE),
		new /datum/pipe_info/meter("Meter"),
	),
	"Heat Exchange" = list(
		new /datum/pipe_info/pipe("Temperature Gate",	/obj/machinery/atmospherics/components/binary/temperature_gate, TRUE),
		new /datum/pipe_info/pipe("Temperature Pump",	/obj/machinery/atmospherics/components/binary/temperature_pump, TRUE),
		new /datum/pipe_info/pipe("Pipe",				/obj/machinery/atmospherics/pipe/heat_exchanging/simple, FALSE),
		new /datum/pipe_info/pipe("Manifold",			/obj/machinery/atmospherics/pipe/heat_exchanging/manifold, FALSE),
		new /datum/pipe_info/pipe("4-Way Manifold",		/obj/machinery/atmospherics/pipe/heat_exchanging/manifold4w, FALSE),
		new /datum/pipe_info/pipe("Junction",			/obj/machinery/atmospherics/pipe/heat_exchanging/junction, FALSE),
		new /datum/pipe_info/pipe("Heat Exchanger",		/obj/machinery/atmospherics/components/unary/heat_exchanger, FALSE),
		
	)
))

GLOBAL_LIST_INIT(disposal_pipe_recipes, list(
	"Disposal Pipes" = list(
		new /datum/pipe_info/disposal("Pipe",			/obj/structure/disposalpipe/segment, PIPE_BENDABLE),
		new /datum/pipe_info/disposal("Junction",		/obj/structure/disposalpipe/junction, PIPE_TRIN_M),
		new /datum/pipe_info/disposal("Y-Junction",		/obj/structure/disposalpipe/junction/yjunction),
		new /datum/pipe_info/disposal("Sort Junction",	/obj/structure/disposalpipe/sorting/mail, PIPE_TRIN_M),
		new /datum/pipe_info/disposal("Rotator", 		/obj/structure/disposalpipe/rotator, PIPE_ONEDIR_FLIPPABLE),
		new /datum/pipe_info/disposal("Trunk",			/obj/structure/disposalpipe/trunk),
		new /datum/pipe_info/disposal("Deck Up",		/obj/structure/disposalpipe/trunk/multiz),
		new /datum/pipe_info/disposal("Deck Down",		/obj/structure/disposalpipe/trunk/multiz/down),
		new /datum/pipe_info/disposal("Bin",			/obj/machinery/disposal/bin, PIPE_ONEDIR),
		new /datum/pipe_info/disposal("Outlet",			/obj/structure/disposaloutlet),
		new /datum/pipe_info/disposal("Chute",			/obj/machinery/disposal/deliveryChute),
	)
))

GLOBAL_LIST_INIT(transit_tube_recipes, list(
	"Transit Tubes" = list(
		new /datum/pipe_info/transit("Straight Tube",				/obj/structure/c_transit_tube, PIPE_STRAIGHT),
		new /datum/pipe_info/transit("Straight Tube with Crossing",	/obj/structure/c_transit_tube/crossing, PIPE_STRAIGHT),
		new /datum/pipe_info/transit("Curved Tube",					/obj/structure/c_transit_tube/curved, PIPE_UNARY_FLIPPABLE),
		new /datum/pipe_info/transit("Diagonal Tube",				/obj/structure/c_transit_tube/diagonal, PIPE_STRAIGHT),
		new /datum/pipe_info/transit("Diagonal Tube with Crossing",	/obj/structure/c_transit_tube/diagonal/crossing, PIPE_STRAIGHT),
		new /datum/pipe_info/transit("Junction",					/obj/structure/c_transit_tube/junction, PIPE_UNARY_FLIPPABLE),
	),
	"Station Equipment" = list(
		new /datum/pipe_info/transit("Through Tube Station",		/obj/structure/c_transit_tube/station, PIPE_STRAIGHT),
		new /datum/pipe_info/transit("Through Tube Station (Flipped)",/obj/structure/c_transit_tube/station/flipped, PIPE_STRAIGHT),
		new /datum/pipe_info/transit("Terminus Tube Station",		/obj/structure/c_transit_tube/station/reverse, PIPE_UNARY),
		new /datum/pipe_info/transit("Terminus Tube Station (Flipped)",/obj/structure/c_transit_tube/station/reverse/flipped, PIPE_UNARY),
		new /datum/pipe_info/transit("Transit Tube Pod",			/obj/structure/c_transit_tube_pod, PIPE_ONEDIR),
		new /datum/pipe_info/transit("Transit Tube Cargo Pod",		/obj/structure/c_transit_tube_pod/cargo, PIPE_ONEDIR),
	)
))

GLOBAL_LIST_INIT(fluid_duct_recipes, list(
	"Fluid Ducts" = list(
		new /datum/pipe_info/plumbing("Duct",				/obj/machinery/duct, PIPE_ONEDIR),
		new /datum/pipe_info/plumbing/multilayer("Duct Layer-Manifold",/obj/machinery/duct/multilayered, PIPE_STRAIGHT)
	)
))

/datum/pipe_info
	var/name
	var/icon_state
	var/id = -1
	var/dirtype = PIPE_BENDABLE
	var/all_layers

/datum/pipe_info/proc/Render(dispenser)
	var/dat = "<li><a href='byond://?src=[REF(dispenser)]&[Params()]'>[name]</a></li>"

	// Stationary pipe dispensers don't allow you to pre-select pipe directions.
	// This makes it impossble to spawn bent versions of bendable pipes.
	// We add a "Bent" pipe type with a preset diagonal direction to work around it.
	if(istype(dispenser, /obj/machinery/pipedispenser) && (dirtype == PIPE_BENDABLE || dirtype == /obj/item/pipe/binary/bendable))
		dat += "<li><a href='byond://?src=[REF(dispenser)]&[Params()]&dir=[NORTHEAST]'>Bent [name]</a></li>"

	return dat

/datum/pipe_info/proc/Params()
	return ""

/datum/pipe_info/proc/get_preview(selected_dir)
	var/list/dirs
	switch(dirtype)
		if(PIPE_STRAIGHT, PIPE_BENDABLE)
			dirs = list("[NORTH]" = "Vertical", "[EAST]" = "Horizontal")
			if(dirtype == PIPE_BENDABLE)
				dirs += list("[NORTHWEST]" = "West to North", "[NORTHEAST]" = "North to East",
							 "[SOUTHWEST]" = "South to West", "[SOUTHEAST]" = "East to South")
		if(PIPE_TRINARY)
			dirs = list("[NORTH]" = "West South East", "[EAST]" = "North West South",
						"[SOUTH]" = "East North West", "[WEST]" = "South East North")
		if(PIPE_TRIN_M)
			dirs = list("[NORTH]" = "North East South", "[EAST]" = "East South West",
						"[SOUTH]" = "South West North", "[WEST]" = "West North East",
						"[SOUTHEAST]" = "West South East", "[NORTHEAST]" = "South East North",
						"[NORTHWEST]" = "East North West", "[SOUTHWEST]" = "North West South")
		if(PIPE_UNARY)
			dirs = list("[NORTH]" = "North", "[EAST]" = "East", "[SOUTH]" = "South", "[WEST]" = "West")
		if(PIPE_ONEDIR)
			dirs = list("[SOUTH]" = name)
		if(PIPE_UNARY_FLIPPABLE)
			dirs = list("[NORTH]" = "North", "[NORTHEAST]" = "North Flipped", "[EAST]" = "East", "[SOUTHEAST]" = "East Flipped",
						"[SOUTH]" = "South", "[SOUTHWEST]" = "South Flipped", "[WEST]" = "West", "[NORTHWEST]" = "West Flipped")
		if(PIPE_ONEDIR_FLIPPABLE)
			dirs = list("[SOUTH]" = name, "[SOUTHEAST]" = "[name] Flipped")


	var/list/rows = list()
	var/list/row = list("previews" = list())
	var/i = 0
	for(var/dir in dirs)
		var/numdir = text2num(dir)
		var/flipped = ((dirtype == PIPE_TRIN_M) || (dirtype == PIPE_UNARY_FLIPPABLE) || (dirtype == PIPE_ONEDIR_FLIPPABLE)) && (ISDIAGONALDIR(numdir))
		row["previews"] += list(list("selected" = (numdir == selected_dir), "dir" = dir2text(numdir), "dir_name" = dirs[dir], "icon_state" = icon_state, "flipped" = flipped))
		if(i++ || dirtype == PIPE_ONEDIR)
			rows += list(row)
			row = list("previews" = list())
			i = 0

	return rows

/datum/pipe_info/pipe/New(label, obj/machinery/atmospherics/path, use_five_layers, difdirtype)
	name = label
	id = path
	all_layers = use_five_layers
	icon_state = initial(path.pipe_state)
	var/obj/item/pipe/c = initial(path.construction_type)
	dirtype = initial(c.RPD_type)
	if(difdirtype)
		dirtype = difdirtype

/datum/pipe_info/pipe/Params()
	return "makepipe=[id]&type=[dirtype]"

/datum/pipe_info/meter
	icon_state = "meter"
	dirtype = PIPE_ONEDIR

/datum/pipe_info/meter/New(label)
	name = label

/datum/pipe_info/meter/Params()
	return "makemeter=[id]&type=[dirtype]"

/datum/pipe_info/disposal/New(label, obj/path, dt=PIPE_UNARY)
	name = label
	id = path

	icon_state = initial(path.icon_state)
	if(ispath(path, /obj/structure/disposalpipe))
		icon_state = "con[icon_state]"

	dirtype = dt

/datum/pipe_info/disposal/Params()
	return "dmake=[id]&type=[dirtype]"

/datum/pipe_info/transit/New(label, obj/path, dt=PIPE_UNARY)
	name = label
	id = path
	dirtype = dt
	icon_state = initial(path.icon_state)
	if(dt == PIPE_UNARY_FLIPPABLE)
		icon_state = "[icon_state]_preview"

/datum/pipe_info/plumbing/New(label, obj/path, dt=PIPE_UNARY)
	name = label
	id = path
	icon_state = initial(path.icon_state)
	dirtype = dt

/datum/pipe_info/plumbing/multilayer //exists as identifier so we can see the difference between multi_layer and just ducts properly later on


/obj/item/pipe_dispenser
	name = "Rapid Pipe Dispenser (RPD)"
	desc = "A device used to rapidly pipe things."
	icon = 'icons/obj/tools.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	icon_state = "rpd"
	flags_1 = CONDUCT_1
	force = 10
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	materials = list(/datum/material/iron=75000, /datum/material/glass=37500)
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 50)
	resistance_flags = FIRE_PROOF
	var/datum/effect_system/spark_spread/spark_system
	var/working = 0
	var/p_dir = NORTH
	var/p_flipped = FALSE
	var/paint_color = "grey"
	var/atmos_build_speed = 2 DECISECONDS
	var/disposal_build_speed = 2 DECISECONDS
	var/transit_build_speed = 2 DECISECONDS
	var/plumbing_build_speed = 2 DECISECONDS
	var/destroy_speed = 2 DECISECONDS
	var/paint_speed = 2 DECISECONDS
	var/category = ATMOS_CATEGORY
	var/piping_layer = PIPING_LAYER_DEFAULT
	var/ducting_layer = DUCT_LAYER_DEFAULT
	var/datum/pipe_info/recipe
	var/static/datum/pipe_info/first_atmos
	var/static/datum/pipe_info/first_disposal
	var/static/datum/pipe_info/first_transit
	var/static/datum/pipe_info/first_plumbing
	var/mode = BUILD_MODE | PAINT_MODE | DESTROY_MODE | WRENCH_MODE
	var/locked = FALSE //wheter we can change categories. Useful for the plumber
	/// The owner of this RCD. It can be a mech or a player.
	var/owner

/obj/item/pipe_dispenser/Initialize(mapload)
	. = ..()
	spark_system = new
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	if(!first_atmos)
		first_atmos = GLOB.atmos_pipe_recipes[GLOB.atmos_pipe_recipes[1]][1]
	if(!first_disposal)
		first_disposal = GLOB.disposal_pipe_recipes[GLOB.disposal_pipe_recipes[1]][1]
	if(!first_transit)
		first_transit = GLOB.transit_tube_recipes[GLOB.transit_tube_recipes[1]][1]

	recipe = first_atmos

/obj/item/pipe_dispenser/Destroy()
	qdel(spark_system)
	spark_system = null
	return ..()

/obj/item/pipe_dispenser/examine(mob/user)
	. = ..()
	. += "You can scroll your mouse wheel to change the piping layer."

/obj/item/pipe_dispenser/equipped(mob/user, slot, initial)
	. = ..()
	RegisterSignal(user, COMSIG_MOUSE_SCROLL_ON, PROC_REF(mouse_wheeled))

/obj/item/pipe_dispenser/dropped(mob/user, silent)
	UnregisterSignal(user, COMSIG_MOUSE_SCROLL_ON)
	return ..()

/obj/item/pipe_dispenser/attack_self(mob/user)
	ui_interact(user)

/obj/item/pipe_dispenser/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] points the end of the RPD down [user.p_their()] throat and presses a button! It looks like [user.p_theyre()] trying to commit suicide..."))
	playsound(get_turf(user), 'sound/machines/click.ogg', 50, 1)
	playsound(get_turf(user), 'sound/items/deconstruct.ogg', 50, 1)
	return(BRUTELOSS)

/obj/item/pipe_dispenser/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/pipes),
	)

/obj/item/pipe_dispenser/ui_host(mob/user)
	return owner || ..()

/obj/item/pipe_dispenser/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		var/datum/asset/assets = get_asset_datum(/datum/asset/spritesheet/pipes)
		assets.send(user)

		ui = new(user, src, "RapidPipeDispenser", name)
		ui.open()

/obj/item/pipe_dispenser/ui_data(mob/user)
	var/list/data = list(
		"category" = category,
		"piping_layer" = piping_layer,
		"ducting_layer" = ducting_layer,
		"preview_rows" = recipe.get_preview(p_dir),
		"categories" = list(),
		"selected_color" = paint_color,
		"paint_colors" = GLOB.pipe_paint_colors,
		"mode" = mode,
		"locked" = locked,
	)

	var/list/recipes
	switch(category)
		if(ATMOS_CATEGORY)
			recipes = GLOB.atmos_pipe_recipes
		if(DISPOSALS_CATEGORY)
			recipes = GLOB.disposal_pipe_recipes
		if(TRANSIT_CATEGORY)
			recipes = GLOB.transit_tube_recipes
		if(PLUMBING_CATEGORY)
			recipes = GLOB.fluid_duct_recipes
	for(var/c in recipes)
		var/list/cat = recipes[c]
		var/list/r = list()
		for(var/i in 1 to cat.len)
			var/datum/pipe_info/info = cat[i]
			r += list(list("pipe_name" = info.name, "pipe_index" = i, "selected" = (info == recipe), "all_layers" = info.all_layers))
		data["categories"] += list(list("cat_name" = c, "recipes" = r))

	return data

/obj/item/pipe_dispenser/ui_act(action, params)
	. = ..()
	if(.)
		return

	var/playeffect = TRUE
	switch(action)
		if("color")
			paint_color = params["paint_color"]
		if("category")
			category = text2num(params["category"])
			switch(category)
				if(DISPOSALS_CATEGORY)
					recipe = first_disposal
				if(ATMOS_CATEGORY)
					recipe = first_atmos
				if(TRANSIT_CATEGORY)
					recipe = first_transit
				if(PLUMBING_CATEGORY)
					recipe = first_plumbing
			p_dir = NORTH
			playeffect = FALSE
		if("piping_layer")
			piping_layer = text2num(params["piping_layer"])
			playeffect = FALSE
		if("ducting_layer")
			ducting_layer = text2num(params["ducting_layer"])
			playeffect = FALSE
		if("pipe_type")
			var/static/list/recipes
			if(!recipes)
				recipes = GLOB.disposal_pipe_recipes + GLOB.atmos_pipe_recipes + GLOB.transit_tube_recipes + GLOB.fluid_duct_recipes
			recipe = recipes[params["category"]][text2num(params["pipe_type"])]
			p_dir = NORTH
		if("setdir")
			p_dir = text2dir(params["dir"])
			p_flipped = text2num(params["flipped"])
			playeffect = FALSE
		if("mode")
			var/n = text2num(params["mode"])
			if(mode & n)
				mode &= ~n
			else
				mode |= n

	if(playeffect)
		spark_system.start()
		playsound(get_turf(src), 'sound/effects/pop.ogg', 50, 0)
	return TRUE

/obj/item/pipe_dispenser/pre_attack(atom/A, mob/user)
	if(!user.IsAdvancedToolUser() || istype(A, /turf/open/space/transit))
		return ..()

	//So that changing the menu settings doesn't affect the pipes already being built.
	var/queued_p_type = recipe.id
	var/queued_p_dir = p_dir
	var/queued_p_flipped = p_flipped

	//make sure what we're clicking is valid for the current category
	var/static/list/make_pipe_whitelist
	if(!make_pipe_whitelist)
		make_pipe_whitelist = typecacheof(list(/obj/structure/lattice, /obj/structure/girder, /obj/item/pipe, /obj/structure/window, /obj/structure/grille, /obj/machinery/atmospherics/pipe))
	var/can_make_pipe = (isturf(A) || is_type_in_typecache(A, make_pipe_whitelist))

	. = TRUE

	if((mode & DESTROY_MODE) && istype(A, /obj/item/pipe) || istype(A, /obj/structure/disposalconstruct) || istype(A, /obj/structure/c_transit_tube) || istype(A, /obj/structure/c_transit_tube_pod) || istype(A, /obj/item/pipe_meter))
	// yogs start - disposable check
		if(istype(A, /obj/item/pipe))
			var/obj/item/pipe/P = A
			if(!P.disposable)
				to_chat(usr, span_warning("[src] is too valuable to dispose of!"))
				return
	// yogs end
		to_chat(user, span_notice("You start destroying a pipe..."))
		playsound(get_turf(src), 'sound/machines/click.ogg', 50, 1)
		if(do_after(user, destroy_speed, A))
			activate()
			qdel(A)
		return

	if (mode & PAINT_MODE)
		if(istype(A, /obj/machinery/atmospherics/pipe) && !istype(A, /obj/machinery/atmospherics/pipe/layer_manifold))
			var/obj/machinery/atmospherics/pipe/P = A
			to_chat(user, span_notice("You start painting \the [P] [paint_color]..."))
			playsound(get_turf(src), 'sound/machines/click.ogg', 50, 1)
			if(do_after(user, paint_speed, A))
				P.paint(GLOB.pipe_paint_colors[paint_color]) //paint the pipe
				user.visible_message(span_notice("[user] paints \the [P] [paint_color]."),span_notice("You paint \the [P] [paint_color]."))
			return
		var/obj/item/pipe/P = A
		if(istype(P) && findtext("[P.pipe_type]", "/obj/machinery/atmospherics/pipe") && !findtext("[P.pipe_type]", "layer_manifold"))
			to_chat(user, span_notice("You start painting \the [A] [paint_color]..."))
			playsound(get_turf(src), 'sound/machines/click.ogg', 50, 1)
			if(do_after(user, paint_speed, A))
				A.add_atom_colour(GLOB.pipe_paint_colors[paint_color], FIXED_COLOUR_PRIORITY) //paint the pipe
				user.visible_message(span_notice("[user] paints \the [A] [paint_color]."),span_notice("You paint \the [A] [paint_color]."))
			return

	if (mode & BUILD_MODE)
		if(istype(get_area(user), /area/centcom/reebe/city_of_cogs))
			to_chat(user, span_notice("You cannot build on Reebe.."))
			return

		switch(category) //if we've gotten this var, the target is valid
			if(ATMOS_CATEGORY) //Making pipes
				if(!can_make_pipe)
					return ..()

				playsound(get_turf(src), 'sound/machines/click.ogg', 50, 1)
				if (recipe.type == /datum/pipe_info/meter)
					to_chat(user, span_notice("You start building a meter..."))
					if(do_after(user, atmos_build_speed, A))
						activate()
						var/obj/item/pipe_meter/PM = new /obj/item/pipe_meter(get_turf(A))
						PM.setAttachLayer(piping_layer)
						if(mode&WRENCH_MODE)
							PM.wrench_act(user, src)
				else
					if(recipe.all_layers == FALSE && (piping_layer == 1 || piping_layer == 5))
						to_chat(user, span_notice("You can't build this object on the layer..."))
						return ..()
					to_chat(user, span_notice("You start building a pipe..."))
					if(do_after(user, atmos_build_speed, A))
						if(recipe.all_layers == FALSE && (piping_layer == 1 || piping_layer == 5))//double check to stop cheaters (and to not waste time waiting for something that can't be placed)
							to_chat(user, span_notice("You can't build this object on the layer..."))
							return ..()
						activate()
						var/obj/machinery/atmospherics/path = queued_p_type
						var/pipe_item_type = initial(path.construction_type) || /obj/item/pipe
						var/obj/item/pipe/P = new pipe_item_type(get_turf(A), queued_p_type, queued_p_dir)

						if(queued_p_flipped && istype(P, /obj/item/pipe/trinary/flippable))
							var/obj/item/pipe/trinary/flippable/F = P
							F.flipped = queued_p_flipped

						P.update()
						P.add_fingerprint(usr)
						P.set_piping_layer(piping_layer)
						if(findtext("[queued_p_type]", "/obj/machinery/atmospherics/pipe") && !findtext("[queued_p_type]", "layer_manifold"))
							P.add_atom_colour(GLOB.pipe_paint_colors[paint_color], FIXED_COLOUR_PRIORITY)
						if(mode&WRENCH_MODE)
							P.wrench_act(user, src)

			if(DISPOSALS_CATEGORY) //Making disposals pipes
				if(!can_make_pipe)
					return ..()
				var/turf/attempting_turf = get_turf(A)
				if(attempting_turf.is_blocked_turf())
					to_chat(user, span_warning("[src]'s error light flickers; there's something in the way!"))
					return
				to_chat(user, span_notice("You start building a disposals pipe..."))
				playsound(get_turf(src), 'sound/machines/click.ogg', 50, 1)
				if(do_after(user, disposal_build_speed, A))
					var/obj/structure/disposalconstruct/C = new (A, queued_p_type, queued_p_dir, queued_p_flipped)

					if(!C.can_place())
						to_chat(user, span_warning("There's not enough room to build that here!"))
						qdel(C)
						return

					activate()

					C.add_fingerprint(usr)
					C.update_appearance(UPDATE_ICON)
					if(mode&WRENCH_MODE)
						C.wrench_act(user, src)
					return

			if(TRANSIT_CATEGORY) //Making transit tubes
				if(!can_make_pipe)
					return ..()
				var/turf/attempting_turf = get_turf(A)
				if(attempting_turf.is_blocked_turf())
					to_chat(user, span_warning("[src]'s error light flickers; there's something in the way!"))
					return
				to_chat(user, span_notice("You start building a transit tube..."))
				playsound(get_turf(src), 'sound/machines/click.ogg', 50, 1)
				if(do_after(user, transit_build_speed, A))
					activate()
					if(queued_p_type == /obj/structure/c_transit_tube_pod)
						var/obj/structure/c_transit_tube_pod/pod = new /obj/structure/c_transit_tube_pod(A)
						pod.add_fingerprint(usr)
						if(mode&WRENCH_MODE)
							pod.wrench_act(user, src)

					else
						var/obj/structure/c_transit_tube/tube = new queued_p_type(A)
						tube.setDir(queued_p_dir)

						if(queued_p_flipped)
							tube.setDir(turn(queued_p_dir, 45))
							tube.simple_rotate_flip()

						tube.add_fingerprint(usr)
						if(mode&WRENCH_MODE)
							tube.wrench_act(user, src)
					return
			if(PLUMBING_CATEGORY) //Making pancakes
				if(!can_make_pipe)
					return ..()
				var/turf/attempting_turf = get_turf(A)
				if(attempting_turf.is_blocked_turf())
					to_chat(user, span_warning("[src]'s error light flickers; there's something in the way!"))
					return
				to_chat(user, span_notice("You start building a fluid duct..."))
				playsound(get_turf(src), 'sound/machines/click.ogg', 50, 1)
				if(do_after(user, plumbing_build_speed, A))
					var/obj/machinery/duct/D
					if(recipe.type == /datum/pipe_info/plumbing/multilayer)
						var/temp_connects = NORTH + SOUTH
						if(queued_p_dir == EAST)
							temp_connects = EAST + WEST
						D = new queued_p_type (A, TRUE, GLOB.pipe_paint_colors[paint_color], ducting_layer, temp_connects)
					else
						D = new queued_p_type (A, TRUE, GLOB.pipe_paint_colors[paint_color], ducting_layer)
					D.add_fingerprint(usr)
					if(mode & WRENCH_MODE)
						D.wrench_act(user, src)

			else
				return ..()

/obj/item/pipe_dispenser/proc/activate()
	playsound(get_turf(src), 'sound/items/deconstruct.ogg', 50, 1)

/obj/item/pipe_dispenser/proc/mouse_wheeled(mob/source, atom/A, delta_x, delta_y, params)
	if(!usr.canUseTopic(src, BE_CLOSE))
		return

	if(delta_y > 0)
		piping_layer = min(PIPING_LAYER_MAX, piping_layer + 1)
	else if(delta_y < 0)
		piping_layer = max(PIPING_LAYER_MIN, piping_layer - 1)
	else
		return
	to_chat(source, span_notice("You set the layer to [piping_layer]."))

/obj/item/pipe_dispenser/exosuit
	name = "mounted pipe dispenser"
	desc = "You shouldn't be seeing this!"
	item_flags = NO_MAT_REDEMPTION | DROPDEL | NOBLUDGEON
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | UNACIDABLE // would be weird if it could somehow be destroyed inside the equipment item

/obj/item/pipe_dispenser/exosuit/ui_state(mob/user)
	return GLOB.pilot_state

// don't allow using this thing unless you're piloting the mech it's attached to
/obj/item/pipe_dispenser/exosuit/can_interact(mob/user)
	if(!(owner && ismecha(owner)))
		return FALSE
	var/obj/mecha/gundam = owner
	if(user == gundam.occupant && !gundam.equipment_disabled && gundam.selected == loc)
		return TRUE
	return FALSE

/obj/item/pipe_dispenser/plumbing
	name = "Plumberinator"
	desc = "A crude device to rapidly plumb things."
	icon_state = "plumberer"
	category = PLUMBING_CATEGORY
	locked = TRUE

/obj/item/pipe_dispenser/plumbing/Initialize(mapload)
	. = ..()
	spark_system = new
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	if(!first_plumbing)
		first_plumbing = GLOB.fluid_duct_recipes[GLOB.fluid_duct_recipes[1]][1]

	recipe = first_plumbing

#undef ATMOS_CATEGORY
#undef DISPOSALS_CATEGORY
#undef TRANSIT_CATEGORY
#undef PLUMBING_CATEGORY

#undef BUILD_MODE
#undef DESTROY_MODE
#undef PAINT_MODE
#undef WRENCH_MODE

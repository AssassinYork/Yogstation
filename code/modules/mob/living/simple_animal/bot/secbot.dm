/mob/living/simple_animal/bot/secbot
	name = "\improper Securitron"
	desc = "A little security robot. He looks less than thrilled."
	icon = 'icons/mob/aibots.dmi'
	icon_state = "secbot"
	density = FALSE
	anchored = FALSE
	health = 50
	maxHealth = 50
	damage_coeff = list(BRUTE = 0.5, BURN = 0.7, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	pass_flags = PASSMOB

	radio_key = /obj/item/encryptionkey/secbot //AI Priv + Security
	radio_channel = RADIO_CHANNEL_SECURITY //Security channel
	bot_type = SEC_BOT
	model = "Securitron"
	bot_core_type = /obj/machinery/bot_core/secbot
	window_id = "autosec"
	window_name = "Automatic Security Unit v1.6"
	allow_pai = 0
	data_hud_type = DATA_HUD_SECURITY_ADVANCED
	path_image_color = "#FF0000"

	var/baton_damage = 60
	var/baton_type = /obj/item/melee/baton
	var/mob/living/carbon/target
	var/oldtarget_name
	var/threatlevel = FALSE
	var/target_lastloc //Loc of target when arrested.
	var/last_found //There's a delay
	var/declare_arrests = TRUE //When making an arrest, should it notify everyone on the security channel?
	var/idcheck = FALSE //If true, arrest people with no IDs
	var/weaponscheck = FALSE //If true, arrest people for weapons if they lack access
	var/check_records = TRUE //Does it check security records?
	var/arrest_type = FALSE //If true, don't handcuff
	var/russian = FALSE // If true, it uses russian voice lines
	var/stuncount = 0 // The securitron will stun you until it gets tired of doing it
	var/mob/living/carbon/lastStunned // Who was stunned last?

/mob/living/simple_animal/bot/secbot/beepsky
	name = "Commander Beepsky"
	desc = "It's Commander Beepsky! Officially the superior officer of all bots on station, Beepsky remains as humble and dedicated to the law as the day he was first fabricated."
	idcheck = FALSE
	weaponscheck = FALSE
	auto_patrol = TRUE
	commissioned = TRUE

/mob/living/simple_animal/bot/secbot/beepsky/jr
	name = "Officer Pipsqueak"
	desc = "It's Commander Beepsky's smaller, just-as aggressive cousin, Pipsqueak."
	commissioned = FALSE

/mob/living/simple_animal/bot/secbot/beepsky/jr/Initialize(mapload)
	. = ..()
	resize = 0.8
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)
	update_transform()

/mob/living/simple_animal/bot/secbot/apply_damage(damage, damagetype, def_zone, blocked, wound_bonus, bare_wound_bonus, sharpness, attack_direction)
	return ..(max(damage - 6, 0), damagetype, def_zone, blocked, wound_bonus, bare_wound_bonus, sharpness, attack_direction) // has 6 innate flat damage reduction

/mob/living/simple_animal/bot/secbot/beepsky/explode()
	lastStunned = null
	var/atom/Tsec = drop_location()
	new /obj/item/stock_parts/cell/potato(Tsec)
	var/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass/S = new(Tsec)
	S.reagents.add_reagent(/datum/reagent/consumable/ethanol/whiskey, 15)
	S.on_reagent_change(ADD_REAGENT)
	..()

/mob/living/simple_animal/bot/secbot/pingsky
	name = "Officer Pingsky"
	desc = "It's Officer Pingsky! Delegated to satellite guard duty for harbouring anti-human sentiment."
	radio_channel = RADIO_CHANNEL_AI_PRIVATE

/mob/living/simple_animal/bot/secbot/Initialize(mapload)
	. = ..()
	update_appearance(UPDATE_ICON)
	var/datum/job/detective/J = new/datum/job/detective
	access_card.access += J.get_access()
	prev_access = access_card.access

	//SECHUD
	var/datum/atom_hud/secsensor = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	secsensor.show_to(src)

	if(prob(5))
		russian = TRUE // imported from Russia

/mob/living/simple_animal/bot/secbot/update_icon_state()
	. = ..()
	if(mode == BOT_HUNT)
		icon_state = "[initial(icon_state)]-c"

/mob/living/simple_animal/bot/secbot/turn_off()
	..()
	mode = BOT_IDLE

/mob/living/simple_animal/bot/secbot/bot_reset()
	..()
	target = null
	oldtarget_name = null
	anchored = FALSE
	walk_to(src,0)
	last_found = world.time

/mob/living/simple_animal/bot/secbot/set_custom_texts()

	text_hack = "You overload [name]'s target identification system."
	text_dehack = "You reboot [name] and restore the target identification."
	text_dehack_fail = "[name] refuses to accept your authority!"

/mob/living/simple_animal/bot/secbot/get_controls(mob/user)
	var/dat
	dat += hack(user)
	dat += showpai(user)
	dat += text({"
<TT><B>Securitron v1.6 controls</B></TT><BR><BR>
Status: []<BR>
Behaviour controls are [locked ? "locked" : "unlocked"]<BR>
Maintenance panel panel is [open ? "opened" : "closed"]"},

"<A href='byond://?src=[REF(src)];power=1'>[on ? "On" : "Off"]</A>" )

	if(!locked || issilicon(user) || IsAdminGhost(user))
		dat += text({"<BR>
Arrest Unidentifiable Persons: []<BR>
Arrest for Unauthorized Weapons: []<BR>
Arrest for Warrant: []<BR>
Operating Mode: []<BR>
Report Arrests[]<BR>
Auto Patrol: []"},

"<A href='byond://?src=[REF(src)];operation=idcheck'>[idcheck ? "Yes" : "No"]</A>",
"<A href='byond://?src=[REF(src)];operation=weaponscheck'>[weaponscheck ? "Yes" : "No"]</A>",
"<A href='byond://?src=[REF(src)];operation=ignorerec'>[check_records ? "Yes" : "No"]</A>",
"<A href='byond://?src=[REF(src)];operation=switchmode'>[arrest_type ? "Detain" : "Arrest"]</A>",
"<A href='byond://?src=[REF(src)];operation=declarearrests'>[declare_arrests ? "Yes" : "No"]</A>",
"<A href='byond://?src=[REF(src)];operation=patrol'>[auto_patrol ? "On" : "Off"]</A>" )

	return	dat

/mob/living/simple_animal/bot/secbot/Topic(href, href_list)
	if(..())
		return TRUE

	if(!issilicon(usr) && !IsAdminGhost(usr) && !(bot_core.allowed(usr) || !locked))
		return TRUE

	switch(href_list["operation"])
		if("idcheck")
			idcheck = !idcheck
			update_controls()
		if("weaponscheck")
			weaponscheck = !weaponscheck
			update_controls()
		if("ignorerec")
			check_records = !check_records
			update_controls()
		if("switchmode")
			arrest_type = !arrest_type
			update_controls()
		if("declarearrests")
			declare_arrests = !declare_arrests
			update_controls()

/mob/living/simple_animal/bot/secbot/proc/retaliate(mob/living/carbon/human/H)
	var/judgement_criteria = judgement_criteria()
	threatlevel = H.assess_threat(judgement_criteria, weaponcheck=CALLBACK(src, PROC_REF(check_for_weapons)))
	threatlevel += 6
	if(threatlevel >= 4)
		target = H
		mode = BOT_HUNT

/mob/living/simple_animal/bot/secbot/proc/judgement_criteria()
    var/final = FALSE
    if(idcheck)
        final = final|JUDGE_IDCHECK
    if(check_records)
        final = final|JUDGE_RECORDCHECK
    if(weaponscheck)
        final = final|JUDGE_WEAPONCHECK
    if(emagged == 2)
        final = final|JUDGE_EMAGGED
    return final

/mob/living/simple_animal/bot/secbot/proc/special_retaliate_after_attack(mob/user) //allows special actions to take place after being attacked.
	return

/mob/living/simple_animal/bot/secbot/attack_hand(mob/living/carbon/human/H, modifiers)
	if(H.combat_mode || (modifiers && modifiers[RIGHT_CLICK]))
		retaliate(H)
		if(special_retaliate_after_attack(H))
			return

	return ..()

/mob/living/simple_animal/bot/secbot/attackby(obj/item/W, mob/user, params)
	..()
	if(W.tool_behaviour == TOOL_WELDER && !user.combat_mode) // Non-combat mode will heal, so we shouldn't get angry.
		return
	if(W.tool_behaviour != TOOL_SCREWDRIVER && (W.force) && (!target) && (W.damtype != STAMINA) ) // Added check for welding tool to fix #2432. Welding tool behavior is handled in superclass.
		retaliate(user)
		if(special_retaliate_after_attack(user))
			return

/mob/living/simple_animal/bot/secbot/emag_act(mob/user, obj/item/card/emag/emag_card)
	. = ..()
	if(emagged == 2)
		if(user)
			to_chat(user, span_danger("You short out [src]'s target assessment circuits."))
			oldtarget_name = user.name
		audible_message(span_danger("[src] buzzes oddly!"))
		declare_arrests = FALSE
		update_appearance(UPDATE_ICON)

/mob/living/simple_animal/bot/secbot/bullet_act(obj/projectile/Proj)
	if(istype(Proj , /obj/projectile/beam)||istype(Proj, /obj/projectile/bullet))
		if((Proj.damage_type == BURN) || (Proj.damage_type == BRUTE))
			if(!Proj.nodamage && Proj.damage < src.health && ishuman(Proj.firer))
				retaliate(Proj.firer)
	return ..()

/mob/living/simple_animal/bot/secbot/UnarmedAttack(atom/A)
	if(!on)
		return
	if(iscarbon(A))
		var/mob/living/carbon/C = A
		if((C.getStaminaLoss() < C.maxHealth || arrest_type) && stuncount < 30)
			stun_attack(A)
			if(lastStunned && lastStunned == A)
				stuncount++
			else
				stuncount = 0
			lastStunned = A
		else if(C.canBeHandcuffed() && !C.handcuffed)
			stuncount = 0
			cuff(A)
	else
		..()

/mob/living/simple_animal/bot/secbot/hitby(atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	if(istype(AM, /obj/item))
		var/obj/item/I = AM
		if(I.throwforce < src.health && I.thrownby && ishuman(I.thrownby))
			var/mob/living/carbon/human/H = I.thrownby
			retaliate(H)
	..()

/mob/living/simple_animal/bot/secbot/proc/cuff(mob/living/carbon/C)
	mode = BOT_ARREST
	playsound(src, 'sound/weapons/cablecuff.ogg', 30, TRUE, -2)
	C.visible_message(span_danger("[src] is trying to put zipties on [C]!"),\
						span_userdanger("[src] is trying to put zipties on you!"))
	addtimer(CALLBACK(src, PROC_REF(attempt_handcuff), C), 60)

/mob/living/simple_animal/bot/secbot/proc/attempt_handcuff(mob/living/carbon/C)
	if( !on || !Adjacent(C) || !isturf(C.loc) ) //if he's in a closet or not adjacent, we cancel cuffing.
		return
	if(!C.handcuffed)
		C.set_handcuffed(new /obj/item/restraints/handcuffs/cable/zipties/used(C))
		C.update_handcuffed()
		playsound(src, russian ? "law_russian" : "law", 50, 0)
		back_to_idle()

/mob/living/simple_animal/bot/secbot/proc/stun_attack(mob/living/carbon/C)
	var/judgement_criteria = judgement_criteria()
	playsound(src, 'sound/weapons/egloves.ogg', 50, TRUE, -1)
	icon_state = "secbot-c"
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/, update_icon)), 2)
	var/threat = 5
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		threat = H.assess_threat(judgement_criteria, weaponcheck=CALLBACK(src, PROC_REF(check_for_weapons)))
		if(H.check_shields(src, baton_damage, "[src]'s baton", MELEE_ATTACK, damage_type = STAMINA))
			return
	else
		threat = C.assess_threat(judgement_criteria, weaponcheck=CALLBACK(src, PROC_REF(check_for_weapons)))
	C.apply_damage(baton_damage, STAMINA, BODY_ZONE_CHEST, C.run_armor_check(BODY_ZONE_CHEST, ENERGY)) // baton runs off of the tiny bot's power instead of an actual cell, not enough to work at full capacity
	log_combat(src,C,"stunned")
	if(declare_arrests)
		var/area/location = get_area(src)
		speak("[arrest_type ? "Detaining" : "Arresting"] level [threat] scumbag <b>[C]</b> in [location].", radio_channel)
	C.visible_message(
		span_danger("[src] has stunned [C]!"),
		span_userdanger("[src] has stunned you!")
	)
/mob/living/simple_animal/bot/secbot/handle_automated_action()
	if(!..())
		return

	switch(mode)

		if(BOT_IDLE)		// idle

			walk_to(src,0)
			look_for_perp()	// see if any criminals are in range
			if(!mode && auto_patrol)	// still idle, and set to patrol
				mode = BOT_START_PATROL	// switch to patrol mode

		if(BOT_HUNT)		// hunting for perp

			// if can't reach perp for long enough, go idle
			if(frustration >= 8)
				walk_to(src,0)
				back_to_idle()
				return

			if(target)		// make sure target exists
				if(Adjacent(target) && isturf(target.loc))	// if right next to perp
					stun_attack(target)

					mode = BOT_PREP_ARREST
					anchored = TRUE
					target_lastloc = target.loc
					return

				else								// not next to perp
					var/turf/olddist = get_dist(src, target)
					walk_to(src, target,1,4)
					if((get_dist(src, target)) >= (olddist))
						frustration++
					else
						frustration = 0
			else
				back_to_idle()

		if(BOT_PREP_ARREST)		// preparing to arrest target

			// see if he got away. If he's no no longer adjacent or inside a closet or about to get up, we hunt again.
			if( !Adjacent(target) || !isturf(target.loc) ||  target.getStaminaLoss() < target.maxHealth)
				back_to_hunt()
				return

			if(iscarbon(target) && target.canBeHandcuffed())
				if(!arrest_type)
					if(!target.handcuffed)  //he's not cuffed? Try to cuff him!
						cuff(target)
					else
						back_to_idle()
						return
			else
				back_to_idle()
				return

		if(BOT_ARREST)
			if(!target)
				anchored = FALSE
				mode = BOT_IDLE
				last_found = world.time
				frustration = 0
				return

			if(target.handcuffed) //no target or target cuffed? back to idle.
				back_to_idle()
				return

			if(!Adjacent(target) || !isturf(target.loc) || (target.loc != target_lastloc && target.getStaminaLoss() < target.maxHealth)) //if he's changed loc and about to get up or not adjacent or got into a closet, we prep arrest again.
				back_to_hunt()
				return
			else //Try arresting again if the target escapes.
				mode = BOT_PREP_ARREST
				anchored = FALSE

		if(BOT_START_PATROL)
			look_for_perp()
			start_patrol()

		if(BOT_PATROL)
			look_for_perp()
			bot_patrol()


	return

/mob/living/simple_animal/bot/secbot/proc/back_to_idle()
	anchored = FALSE
	mode = BOT_IDLE
	target = null
	last_found = world.time
	frustration = 0
	INVOKE_ASYNC(src, PROC_REF(handle_automated_action))

/mob/living/simple_animal/bot/secbot/proc/back_to_hunt()
	anchored = FALSE
	frustration = 0
	mode = BOT_HUNT
	INVOKE_ASYNC(src, PROC_REF(handle_automated_action))
// look for a criminal in view of the bot

/mob/living/simple_animal/bot/secbot/proc/look_for_perp()
	anchored = FALSE
	var/judgement_criteria = judgement_criteria()
	for (var/mob/living/carbon/C in view(7,src)) //Let's find us a criminal
		if((C.stat) || (C.handcuffed))
			continue

		if((C.name == oldtarget_name) && (world.time < last_found + 100))
			continue

		threatlevel = C.assess_threat(judgement_criteria, weaponcheck=CALLBACK(src, PROC_REF(check_for_weapons)))

		if(!threatlevel)
			continue

		else if(threatlevel >= 4)
			target = C
			oldtarget_name = C.name
			speak("Level [threatlevel] infraction alert!")
			if(russian)
				playsound(loc, pick('sound/voice/beepsky_russian/criminal.ogg', 'sound/voice/beepsky_russian/justice.ogg', 'sound/voice/beepsky_russian/freeze.ogg'), 50, FALSE)
			else
				playsound(loc, pick('sound/voice/beepsky/criminal.ogg', 'sound/voice/beepsky/justice.ogg', 'sound/voice/beepsky/freeze.ogg'), 50, FALSE)
			visible_message("<b>[src]</b> points at [C.name]!")
			mode = BOT_HUNT
			INVOKE_ASYNC(src, PROC_REF(handle_automated_action))
			break
		else
			continue

/mob/living/simple_animal/bot/secbot/proc/check_for_weapons(obj/item/slot_item)
	if(slot_item && (slot_item.item_flags & NEEDS_PERMIT))
		return TRUE
	return FALSE

/mob/living/simple_animal/bot/secbot/explode()

	walk_to(src,0)
	visible_message(span_boldannounce("[src] blows apart!"))
	var/atom/Tsec = drop_location()

	var/obj/item/bot_assembly/secbot/Sa = new (Tsec)
	Sa.build_step = 1
	Sa.add_overlay("hs_hole")
	Sa.created_name = name
	new /obj/item/assembly/prox_sensor(Tsec)
	drop_part(baton_type, Tsec)

	if(prob(50))
		drop_part(robot_arm, Tsec)

	do_sparks(3, TRUE, src)

	new /obj/effect/decal/cleanable/oil(loc)
	..()

/mob/living/simple_animal/bot/secbot/attack_alien(mob/living/carbon/alien/user as mob)
	..()
	if(!isalien(target))
		target = user
		mode = BOT_HUNT

/mob/living/simple_animal/bot/secbot/proc/on_entered(datum/source, atom/movable/AM, ...)
	if(has_gravity() && ismob(AM) && target)
		var/mob/living/carbon/C = AM
		if(!istype(C) || !C || in_range(src, target))
			return
		knock_over(C)
		return

/obj/machinery/bot_core/secbot
	req_access = list(ACCESS_SECURITY)

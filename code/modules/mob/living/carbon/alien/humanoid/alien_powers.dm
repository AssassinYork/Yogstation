/*NOTES:
These are general powers. Specific powers are stored under the appropriate alien creature type.
*/

/*Alien spit now works like a taser shot. It won't home in on the target but will act the same once it does hit.
Doesn't work on other aliens/AI.*/


/datum/action/cooldown/alien
	name = "Alien Power"
	panel = "Alien"
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"
	button_icon = 'icons/mob/actions/actions_xeno.dmi'
	button_icon_state = "spell_default"
	check_flags = AB_CHECK_IMMOBILE | AB_CHECK_CONSCIOUS | AB_CHECK_INCAPACITATED
	melee_cooldown_time = 0 SECONDS

	/// How much plasma this action uses.
	var/plasma_cost = 0

/datum/action/cooldown/alien/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(!iscarbon(owner))
		return FALSE
	var/mob/living/carbon/carbon_owner = owner
	if(carbon_owner.getPlasma() < plasma_cost)
		return FALSE
	
	return TRUE

/datum/action/cooldown/alien/PreActivate(atom/target)
	// Parent calls Activate(), so if parent returns TRUE,
	// it means the activation happened successfuly by this point
	. = ..()
	if(!.)
		return FALSE
	// Xeno actions like "evolve" may result in our action (or our alien) being deleted
	// In that case, we can just exit now as a "success"
	if(QDELETED(src) || QDELETED(owner))
		return TRUE

	var/mob/living/carbon/carbon_owner = owner
	carbon_owner.adjustPlasma(-plasma_cost)
	// It'd be really annoying if click-to-fire actions stayed active,
	// even if our plasma amount went under the required amount.
	if(click_to_activate && carbon_owner.getPlasma() < plasma_cost)
		owner.balloon_alert(owner, "not enough plasma!")
		unset_click_ability(owner, refund_cooldown = FALSE)

	return TRUE

/datum/action/cooldown/alien/set_statpanel_format()
	. = ..()
	if(!islist(.))
		return

	.[PANEL_DISPLAY_STATUS] = "PLASMA - [plasma_cost]"

/datum/action/cooldown/alien/make_structure
	/// The type of structure the action makes on use
	var/obj/structure/made_structure_type

/datum/action/cooldown/alien/make_structure/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(!isturf(owner.loc) || isspaceturf(owner.loc))
		return FALSE

	return TRUE

/datum/action/cooldown/alien/make_structure/PreActivate(atom/target)
	if(!check_for_duplicate())
		return FALSE

	if(!check_for_vents())
		return FALSE

	return ..()

/datum/action/cooldown/alien/make_structure/Activate(atom/target)
	new made_structure_type(owner.loc)
	return TRUE

/// Checks if there's a duplicate structure in the owner's turf
/datum/action/cooldown/alien/make_structure/proc/check_for_duplicate()
	var/obj/structure/existing_thing = locate(made_structure_type) in owner.loc
	if(existing_thing)
		owner.balloon_alert(owner, "space occupied by \a [existing_thing]!")
		return FALSE

	return TRUE

/// Checks if there's an atmos machine (vent) in the owner's turf
/datum/action/cooldown/alien/make_structure/proc/check_for_vents()
	var/obj/machinery/atmospherics/components/unary/atmos_thing = locate() in owner.loc
	if(atmos_thing)
		var/are_you_sure = tgui_alert(owner, "Laying eggs and shaping resin here would block access to [atmos_thing]. Do you want to continue?", "Blocking Atmospheric Component", list("Yes", "No"))
		if(are_you_sure != "Yes")
			return FALSE
		if(QDELETED(src) || QDELETED(owner) || !check_for_duplicate())
			return FALSE

	return TRUE

/datum/action/cooldown/alien/make_structure/plant_weeds
	name = "Plant Weeds"
	desc = "Plants some alien weeds."
	button_icon_state = "alien_plant"
	plasma_cost = 50
	made_structure_type = /obj/structure/alien/weeds/node

/datum/action/cooldown/alien/make_structure/plant_weeds/Activate(atom/target)
	owner.visible_message(span_alertalien("[owner] plants some alien weeds!"))
	return ..()

/datum/action/cooldown/alien/whisper
	name = "Whisper"
	desc = "Whisper to someone."
	button_icon_state = "alien_whisper"
	plasma_cost = 10

/datum/action/cooldown/alien/whisper/Activate(atom/target)
	var/list/possible_recipients = list()
	for(var/mob/living/recipient in oview(owner))
		possible_recipients += recipient

	if(!length(possible_recipients))
		to_chat(owner, span_noticealien("There's no one around to whisper to."))
		return FALSE

	var/mob/living/chosen_recipient = tgui_input_list(owner, "Select whisper recipient", "Whisper", sortUsernames(possible_recipients))
	if(!chosen_recipient)
		return FALSE

	var/to_whisper = tgui_input_text(owner, title = "Alien Whisper")
	if(QDELETED(chosen_recipient) || QDELETED(src) || QDELETED(owner) || !IsAvailable(feedback = FALSE) || !to_whisper)
		return FALSE
	if(chosen_recipient.can_block_magic(MAGIC_RESISTANCE_MIND, charge_cost = 0))
		to_chat(owner, span_warning("As you reach into [chosen_recipient]'s mind, you are stopped by a mental blockage. It seems you've been foiled."))
		return FALSE

	log_directed_talk(owner, chosen_recipient, to_whisper, LOG_SAY, tag = "alien whisper")
	to_chat(chosen_recipient, "[span_noticealien("You hear a strange, alien voice in your head...")][to_whisper]")
	to_chat(owner, span_noticealien("You said: \"[to_whisper]\" to [chosen_recipient]"))
	for(var/mob/dead_mob as anything in GLOB.dead_mob_list)
		if(!isobserver(dead_mob))
			continue
		var/follow_link_user = FOLLOW_LINK(dead_mob, owner)
		var/follow_link_whispee = FOLLOW_LINK(dead_mob, chosen_recipient)
		to_chat(dead_mob, "[follow_link_user] [span_name("[owner]")] [span_alertalien("Alien Whisper --> ")] [follow_link_whispee] [span_name("[chosen_recipient]")] [span_noticealien("[to_whisper]")]")

	return TRUE

/datum/action/cooldown/alien/transfer
	name = "Transfer Plasma"
	desc = "Transfer Plasma to another alien."
	plasma_cost = 0
	button_icon_state = "alien_transfer"

/datum/action/cooldown/alien/transfer/Activate(atom/target)
	var/mob/living/carbon/carbon_owner = owner
	var/list/mob/living/carbon/aliens_around = list()
	for(var/mob/living/carbon/alien in view(owner))
		if(alien.getPlasma() == -1 || alien == owner)
			continue
		aliens_around += alien

	if(!length(aliens_around))
		to_chat(owner, span_noticealien("There are no other aliens around."))
		return FALSE

	var/mob/living/carbon/donation_target = tgui_input_list(owner, "Target to transfer to", "Plasma Donation", sortUsernames(aliens_around))
	if(!donation_target)
		return FALSE

	var/amount = tgui_input_number(owner, "Amount", "Transfer Plasma to [donation_target]", max_value = carbon_owner.getPlasma())
	if(QDELETED(donation_target) || QDELETED(src) || QDELETED(owner) || !IsAvailable(feedback = FALSE) || isnull(amount) || amount <= 0)
		return FALSE

	if(get_dist(owner, donation_target) > 1)
		owner.balloon_alert(owner, "too far!")
		return FALSE
	
	
	donation_target.adjustPlasma(amount)
	carbon_owner.adjustPlasma(-amount)

	to_chat(donation_target, span_noticealien("[owner] has transferred [amount] plasma to you."))
	to_chat(owner, span_noticealien("You transfer [amount] plasma to [donation_target]."))
	return TRUE

/datum/action/cooldown/alien/acid
	click_to_activate = TRUE
	unset_after_click = FALSE

/datum/action/cooldown/alien/acid/corrosion
	name = "Corrosive Acid"
	desc = "Drench an object in acid, destroying it over time."
	button_icon_state = "alien_acid"
	plasma_cost = 200
	ranged_mousepointer = 'icons/effects/mouse_pointers/acid.dmi'

/datum/action/cooldown/alien/acid/corrosion/set_click_ability(mob/on_who)
	. = ..()
	if(!.)
		return

	owner.balloon_alert(owner, "acid glands ready!")
	on_who.update_icons()

/datum/action/cooldown/alien/acid/corrosion/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	. = ..()
	if(!.)
		return

	if(refund_cooldown)
		owner.balloon_alert(owner, "acid glands relaxed")
	on_who.update_icons()

/datum/action/cooldown/alien/acid/corrosion/PreActivate(atom/target)
	if(get_dist(owner, target) > 1)
		owner.balloon_alert(owner, "too far!")
		return FALSE

	return ..()

/datum/action/cooldown/alien/acid/corrosion/Activate(atom/target)
	if(!target.acid_act(200, 1000))
		owner.balloon_alert(owner, "cannot disolve")
		return FALSE
	owner.visible_message(
		span_alertalien("[owner] vomits globs of vile stuff all over [target]. It begins to sizzle and melt under the bubbling mess of acid!"),
		span_noticealien("You vomit globs of acid over [target]. It begins to sizzle and melt."),
	)
	return TRUE

/datum/action/cooldown/alien/acid/neurotoxin
	name = "Spit Neurotoxin"
	desc = "Spits neurotoxin at someone, paralyzing them for a short time."
	button_icon_state = "alien_neurotoxin_0"
	plasma_cost = 50

/datum/action/cooldown/alien/acid/neurotoxin/IsAvailable(feedback = FALSE)
	return ..() && isturf(owner.loc)

/datum/action/cooldown/alien/acid/neurotoxin/set_click_ability(mob/on_who)
	. = ..()
	if(!.)
		return

	owner.balloon_alert(owner, "neurotoxin glands ready!")

	button_icon_state = "alien_neurotoxin_1"
	build_all_button_icons()
	on_who.update_icons()

/datum/action/cooldown/alien/acid/neurotoxin/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	. = ..()
	if(!.)
		return
	if(refund_cooldown)
		owner.balloon_alert(owner, "neurotoxin glands relaxed")
	
	button_icon_state = "alien_neurotoxin_0"
	build_all_button_icons()
	on_who.update_icons()

// We do this in InterceptClickOn() instead of Activate()
// because we use the click parameters for aiming the projectile
// (or something like that)
/datum/action/cooldown/alien/acid/neurotoxin/InterceptClickOn(mob/living/caller_but_not_a_byond_built_in_proc, params, atom/target)
	. = ..()
	if(!.)
		unset_click_ability(caller_but_not_a_byond_built_in_proc, refund_cooldown = FALSE)
		return FALSE

//	var/modifiers = params2list(params)
	caller_but_not_a_byond_built_in_proc.visible_message(
		span_danger("[caller_but_not_a_byond_built_in_proc] spits neurotoxin!"),
		span_alertalien("You spit neurotoxin."),
	)

	var/obj/projectile/reagent/neurotoxin/neurotoxin = new /obj/projectile/reagent/neurotoxin(caller_but_not_a_byond_built_in_proc.loc)
	neurotoxin.preparePixelProjectile(target, caller_but_not_a_byond_built_in_proc, params)
	neurotoxin.firer = caller_but_not_a_byond_built_in_proc
	neurotoxin.fire()
	caller_but_not_a_byond_built_in_proc.newtonian_move(get_dir(target, caller_but_not_a_byond_built_in_proc))
	return TRUE

// Has to return TRUE, otherwise is skipped.
/datum/action/cooldown/alien/acid/neurotoxin/Activate(atom/target)
	return TRUE

/datum/action/cooldown/alien/make_structure/resin
	name = "Secrete Resin"
	desc = "Secrete tough malleable resin."
	button_icon_state = "alien_resin"
	plasma_cost = 55
	/// A list of all structures we can make.
	var/list/structures = list(
		"resin wall" = /obj/structure/alien/resin/wall,
		"resin membrane" = /obj/structure/alien/resin/membrane,
		"resin nest" = /obj/structure/bed/nest)

// Snowflake to check for multiple types of alien resin structures
/datum/action/cooldown/alien/make_structure/resin/check_for_duplicate()
	for(var/blocker_name in structures)
		var/obj/structure/blocker_type = structures[blocker_name]
		if(locate(blocker_type) in owner.loc)
			to_chat(owner, span_warning("There is already a resin structure there!"))
			return FALSE

	return TRUE

/datum/action/cooldown/alien/make_structure/resin/Activate(atom/target)
	var/choice = show_radial_menu(owner, owner, structures, radius = 36)
	if(isnull(choice) || QDELETED(src) || QDELETED(owner) || !check_for_duplicate() || !IsAvailable(feedback = FALSE))
		return FALSE

	var/obj/structure/choice_path = structures[choice]
	if(!ispath(choice_path))
		return FALSE

	owner.visible_message(
		span_notice("[owner] vomits up a thick purple substance and begins to shape it."),
		span_notice("You shape a [choice] out of resin."),
	)
	new choice_path(owner.loc)
	return TRUE

/datum/action/cooldown/alien/sneak
	name = "Sneak"
	desc = "Blend into the shadows to stalk your prey."
	button_icon_state = "alien_sneak"
	/// The alpha we go to when sneaking.
	var/sneak_alpha = 75

/datum/action/cooldown/alien/sneak/Remove(mob/living/remove_from)
	if(HAS_TRAIT(remove_from, TRAIT_ALIEN_SNEAK))
		remove_from.alpha = initial(remove_from.alpha)
		REMOVE_TRAIT(remove_from, TRAIT_ALIEN_SNEAK, name)

	return ..()

/datum/action/cooldown/alien/sneak/Activate(atom/target)
	if(HAS_TRAIT(owner, TRAIT_ALIEN_SNEAK))
		// It's safest to go to the initial alpha of the mob.
		// Otherwise we get permanent invisbility exploits.
		owner.alpha = initial(owner.alpha)
		owner.balloon_alert(owner, "you reveal yourself!")
		REMOVE_TRAIT(owner, TRAIT_ALIEN_SNEAK, name)
	
	else
		owner.alpha = sneak_alpha
		owner.balloon_alert(owner, "you blend into the shadows...")
		ADD_TRAIT(owner, TRAIT_ALIEN_SNEAK, name)

	return TRUE

/// Gets the plasma level of this carbon's plasma vessel, or -1 if they don't have one
/mob/living/carbon/proc/getPlasma()
	var/obj/item/organ/alien/plasmavessel/vessel = getorgan(/obj/item/organ/alien/plasmavessel)
	if(!vessel)
		return -1
	return vessel.stored_plasma

/// Adjusts the plasma level of the carbon's plasma vessel if they have one
/mob/living/carbon/proc/adjustPlasma(amount)
	var/obj/item/organ/alien/plasmavessel/vessel = getorgan(/obj/item/organ/alien/plasmavessel)
	if(!vessel)
		return FALSE
	vessel.stored_plasma = max(vessel.stored_plasma + amount,0)
	vessel.stored_plasma = min(vessel.stored_plasma, vessel.max_plasma) //upper limit of max_plasma, lower limit of 0
	for(var/datum/action/cooldown/alien/ability in actions)
		ability.build_all_button_icons()
	return TRUE

/mob/living/carbon/alien/adjustPlasma(amount)
	. = ..()
	updatePlasmaDisplay()

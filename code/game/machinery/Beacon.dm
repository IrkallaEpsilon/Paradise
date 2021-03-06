/obj/machinery/bluespace_beacon
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beaconf"
	name = "Bluespace Gigabeacon"
	desc = "A device that draws power from bluespace and creates a permanent tracking beacon."
	level = 1		// underfloor
	layer = 2.5
	anchored = 1
	use_power = 1
	idle_power_usage = 0
	var/syndicate = 0
	var/obj/item/radio/beacon/Beacon
	var/enabled = TRUE

/obj/machinery/bluespace_beacon/New()
	..()
	create_beacon()

/obj/machinery/bluespace_beacon/proc/create_beacon()
	var/turf/T = loc
	Beacon = new /obj/item/radio/beacon
	Beacon.invisibility = INVISIBILITY_MAXIMUM
	Beacon.loc = T
	Beacon.syndicate = syndicate
	hide(T.intact)

/obj/machinery/bluespace_beacon/proc/destroy_beacon()
	QDEL_NULL(Beacon)

/obj/machinery/bluespace_beacon/proc/toggle()
	enabled = !enabled
	return enabled

/obj/machinery/bluespace_beacon/Destroy()
	destroy_beacon()
	return ..()

/obj/machinery/bluespace_beacon/hide(var/intact)
	invisibility = intact ? 101 : 0
	update_icon()

// update the icon_state
/obj/machinery/bluespace_beacon/update_icon()
	var/state="floor_beacon"
	if(invisibility)
		icon_state = "[state]f"
	else
		icon_state = "[state]"

/obj/machinery/bluespace_beacon/process()
	if(enabled)
		if(Beacon)
			if(Beacon.loc != loc)
				Beacon.loc = loc
		else
			create_beacon()
			update_icon()
	else
		if(Beacon)
			destroy_beacon()
			update_icon()


/obj/machinery/bluespace_beacon/syndicate
	syndicate = TRUE
	enabled = FALSE
	var/obj/machinery/computer/syndicate_depot/teleporter/mycomputer

/obj/machinery/bluespace_beacon/syndicate/New()
	..()
	if(!GAMEMODE_IS_NUCLEAR && prob(50))
		enabled = TRUE

/obj/machinery/bluespace_beacon/syndicate/Destroy()
	if(mycomputer)
		mycomputer.mybeacon = null
	return ..()
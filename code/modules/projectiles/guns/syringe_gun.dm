/obj/item/weapon/gun/syringe
	name = "syringe gun"
	desc = "A spring loaded rifle designed to fit syringes, used to incapacitate unruly patients from a distance."
	icon_state = "syringegun"
	item_state = "syringegun"
	w_class = 3
	throw_speed = 3
	throw_range = 7
	force = 4
	stamina_percentage = 0.6
	materials = list(MAT_METAL=2000)
	clumsy_check = 0
	fire_sound = 'sound/items/syringeproj.ogg'
	var/list/syringes = list()
	var/max_syringes = 1

/obj/item/weapon/gun/syringe/New()
	..()
	chambered = new /obj/item/ammo_casing/syringegun(src)

/obj/item/weapon/gun/syringe/proc/newshot()
	if(!syringes.len) return

	var/obj/item/weapon/reagent_containers/syringe/S = syringes[1]

	if(!S) return

	chambered.BB = new /obj/item/projectile/bullet/dart/syringe(src)
	S.reagents.trans_to(chambered.BB, S.reagents.total_volume)
	chambered.BB.name = S.name
	syringes.Remove(S)

	qdel(S)
	return

/obj/item/weapon/gun/syringe/process_chamber()
	return

/obj/item/weapon/gun/syringe/afterattack(atom/target as mob|obj|turf, mob/living/user as mob|obj, params)
	if(target == loc)
		return
	newshot()
	..()

/obj/item/weapon/gun/syringe/examine(mob/user)
	..()
	user << "Can hold [max_syringes] syringe\s. Has [syringes.len] syringe\s remaining."

/obj/item/weapon/gun/syringe/attack_self(mob/living/user)
	if(!syringes.len)
		user << "<span class='warning'>[src] is empty!</span>"
		return 0

	var/obj/item/weapon/reagent_containers/syringe/S = syringes[syringes.len]

	if(!S) return 0
	S.loc = user.loc

	syringes.Remove(S)
	user << "<span class='notice'>You unload [S] from \the [src].</span>"

	return 1

/obj/item/weapon/gun/syringe/attackby(obj/item/A, mob/user, params, show_msg = 1)
	if(istype(A, /obj/item/weapon/reagent_containers/syringe))
		if(syringes.len < max_syringes)
			if(!user.unEquip(A))
				return
			user << "<span class='notice'>You load [A] into \the [src].</span>"
			syringes.Add(A)
			A.loc = src
			return 1
		else
			usr << "<span class='warning'>[src] cannot hold more syringes!</span>"
	return 0

/obj/item/weapon/gun/syringe/rapidsyringe
	name = "rapid syringe gun"
	desc = "A modification of the syringe gun design, using a rotating cylinder to store up to six syringes."
	icon_state = "rapidsyringegun"
	max_syringes = 6

/obj/item/weapon/gun/syringe/syndicate
	name = "dart pistol"
	desc = "A small spring-loaded sidearm that functions identically to a syringe gun."
	icon_state = "syringe_pistol"
	item_state = "gun" //Smaller inhand
	w_class = 2
	origin_tech = "combat=2;syndicate=2"
	force = 2 //Also very weak because it's smaller
	stamina_percentage = 0.7
	suppressed = 1 //Softer fire sound
	can_unsuppress = 0 //Permanently silenced

note
	description: "Heroes that can heal other beings and are more powerful in a battle."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HERO

inherit
	ARMY_BEING

create
	make

feature -- Access
	type: STRING is "Hero"

	maximum_power: INTEGER is 10

	max_hit_points: INTEGER is 200

	creation_time: INTEGER is 30
			-- Hero training time

	maximum_movement_speed: INTEGER is 2

feature -- Besic operation
	heal_being (b: BEING) is
			-- Heal some being
		do
			io.put_string (out + " is healing " + b.out + "%N")
			b.increase_hit_points (3)
		end

end

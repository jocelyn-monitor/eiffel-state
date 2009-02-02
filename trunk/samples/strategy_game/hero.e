note
	description: "Heroes that can heal other beings."
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

	power: INTEGER is 10

	max_hit_points: INTEGER is 200

feature -- Besic operation
	heal_being (b: BEING) is
			-- Heal some being
		do
			io.put_string (out + " is healing " + b.out + "%N")
			b.increase_hit_points (3)
		end

end

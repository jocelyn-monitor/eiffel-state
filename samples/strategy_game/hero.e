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

	creation_time: DOUBLE is 10.0
			-- Hero training time

	maximum_movement_speed: DOUBLE is 1.5

	maximum_accuracy: DOUBLE is 0.8

feature -- Besic operation
	heal_being (b: BEING): DOUBLE is
			-- Heal some being
		do
			io.put_string (out + " is healing " + b.out + "%N")
			Result := b.heal_this
		end

end

note
	description: "Doctor can heal other beings"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DOCTOR

inherit
	BEING

create
	make

feature -- Access
	type: STRING is "Doctor"

	creation_time: DOUBLE is 3.0
			-- Hero training time

	maximum_movement_speed: DOUBLE is 2.0

feature -- Basic operations
	heal_being (b: BEING): DOUBLE is
			-- Heal some BEING
		do
			io.put_string (out + " is healing " + b.out + "%N")
			Result := b.improve_health
		end

end

note
	description: "Barracks that train soldiers."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BARRACK

inherit
	BUILDING

create {WORKER}
	make

feature -- Access
	type: STRING is "Barrack"

	last_soldier: SOLDIER
			-- Last trained soldier

	creation_time: INTEGER is 300

feature -- Basic operations
	train_soldier: INTEGER is
		do
			create last_soldier.make (position)
			Result := Result + (last_soldier.creation_time / sd_ability_decrease.item ([], health_state)).ceiling
			io.put_string (last_soldier.out + " was trained%N")
		ensure
			last_soldier_exists: last_soldier /= Void
		end
end

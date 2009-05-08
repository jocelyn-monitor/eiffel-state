note
	description: "Soldiers."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOLDIER

inherit
	ARMY_BEING

create
	make

feature -- Access
	type: STRING is "Soldier"

	creation_time: INTEGER is 20
			-- Soldier training time

	maximum_movement_speed: INTEGER is 1

	maximum_accuracy: DOUBLE is 0.8

end

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

	maximum_power: INTEGER is 5

	max_hit_points: INTEGER is 100

	creation_time: INTEGER is 20
			-- Soldier training time

	maximum_movement_speed: INTEGER is 1

end

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

	power: INTEGER is 5

	max_hit_points: INTEGER is 100

end

note
	description: "Living beings that can move."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BEING

inherit
	UNIT

feature -- Access
	maximum_movement_speed: DOUBLE is
		deferred
		end

feature -- State dependent: Access
	movement_speed: DOUBLE is
			-- Movement speed according to hp level
		do
			Result := maximum_movement_speed * sd_ability_reduction.item ([], health_state)
		end

feature -- Element change
	move (new_position: POSITION): DOUBLE is
			-- Time which is taken by changing `position' to `new_position'
		do
			position := new_position
			io.put_string (out + " has moved to " + new_position.out + "%N")
		ensure
			position_set: position.equals (new_position)
		end
end

note
	description: "Living beings that can move."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BEING

inherit
	UNIT

feature -- Element change
	move (new_position: POSITION) is
			-- Change `position' to `new_position'
		do
			io.put_string (out + " has moved to " + new_position.out + "%N")
			position := new_position
		ensure
			position_set: position = new_position
		end
end

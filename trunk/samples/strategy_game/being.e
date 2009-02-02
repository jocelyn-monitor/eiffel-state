note
	description: "Summary description for {BEING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BEING

inherit
	UNIT

feature -- Element change
	move(new_position : POSITION) is
			-- Change position of being
		do
			io.put_string (to_string + " has moved to " + new_position.to_string + "%N")
			position := new_position
		end

end

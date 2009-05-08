note
	description: "Buildings that cannot move."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BUILDING

inherit
	UNIT
		rename
			is_healthy as is_repaired
		end

feature -- Access
	creation_time: INTEGER is
			-- Time required for constructing some Building
		deferred
		end

end

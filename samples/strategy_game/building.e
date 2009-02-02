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
	max_hit_points: INTEGER is 100

end

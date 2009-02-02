note
	description: "Summary description for {BUILDING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BUILDING

inherit
	UNIT

feature -- Access
	is_repaired : BOOLEAN is
			-- Is this building repaired?
		do
			Result := hit_points = maximum_hp
		end

feature {NONE} -- Initialization
	make(place : POSITION) is
			-- Constructing building at target place
		do
			position := place
			from
				hit_points := 0
			until
				is_repaired
			loop
				increase_hp (5)
			end
		ensure
			is_repaired
		end

end

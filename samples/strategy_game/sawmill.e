note
	description: "Sawmills that produce lamber from trees."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAWMILL

inherit
	PRODUCTION
		rename
			last_resource as last_lumber
		redefine
			last_lumber
		end

create {WORKER}
	make

feature -- Access
	type : STRING is "Sawmill"

	last_lumber: LUMBER

	max_hit_points: INTEGER is 150

feature -- Basic operation
	produce: INTEGER is
			-- Produce resource and store it into `last_resource'
		do
			create last_lumber
			Result := last_lumber.creation_time
		end
end

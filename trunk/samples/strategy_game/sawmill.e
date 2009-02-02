note
	description: "Sawmills that produce lamber."
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

feature -- Basic operation
	produce is
			-- Produce resource and store it into `last_resource'
		do
			create last_lumber
		end
end

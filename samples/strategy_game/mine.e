note
	description: "Mines that produce gold."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MINE

inherit
	PRODUCTION
		rename
			last_resource as last_gold
		redefine
			last_gold
		end

create {WORKER}
	make

feature -- Access
	type : STRING is "Mine"

	last_gold: GOLD

feature -- Basic operation
	produce is
			-- Produce resource and store it into `last_resource'
		do
			create last_gold
		end
end

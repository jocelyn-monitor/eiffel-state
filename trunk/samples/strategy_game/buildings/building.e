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
			is_healthy as is_repaired,
			heal_this as repair_this
		end
end

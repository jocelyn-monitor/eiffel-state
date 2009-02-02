note
	description: "Summary description for {SOLDIER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOLDIER

inherit
	ARMYBEING

create
	make

feature -- Access
	get_type : STRING is
		do
			Result := "Soldier"
		end


feature {NONE} -- Initialization
	make (place : POSITION) is
			-- Creating new soldier
		do
			maximum_hp := 100
			hit_points := maximum_hp
			power := 5
			position := place
		end
end

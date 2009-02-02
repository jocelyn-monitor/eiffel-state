note
	description: "Summary description for {HERO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HERO

inherit
	ARMYBEING

create
	make

feature -- Access
	get_type : STRING is
		do
			Result := "Hero"
		end

	heal_being (human : BEING) is
			-- Heal some being
		do
			io.put_string (to_string + " is healing " + human.to_string + "%N")
			human.increase_hp (3)
		end


feature {NONE} -- Initialization
	make (place : POSITION) is
			-- Creating new hero
		do
			maximum_hp := 200
			hit_points := maximum_hp
			position := place
			power := 10
		end
end

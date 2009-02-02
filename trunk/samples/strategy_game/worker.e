note
	description: "Summary description for {WORKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WORKER

inherit
	BEING

create
	make

feature {NONE} -- Initialization
	make (place : POSITION) is
		do
			maximum_hp := 25;
			hit_points := maximum_hp
			position := place
		end

feature -- Access
	 get_type : STRING is
		do
			Result := "Worker"
		end

	repair (building : BUILDING) is
			-- Repair some building
		do
			move (building.get_position)
			from
			until
				building.is_repaired
			loop
				building.increase_hp (5)
			end
			io.put_string (to_string + " has repaired building%N")
		end

	build_hall (place : POSITION) : BUILDING is
			-- Construct hall
		local
			hall : HALL
		do
			move (place)
			create hall.make (place)
			Result := hall
			io.put_string (Result.to_string + " was just constructed%N")
		ensure
			Result /= Void
		end

	build_mine (place : POSITION) : BUILDING is
			-- Construct mine near gold
		local
			mine : MINE
		do
			move (place)
			create mine.make (place)
			Result := mine
			io.put_string (Result.to_string + " was just constructed%N")
		end

	build_sawmill (place : POSITION) : BUILDING is
			-- Construct sawmill to process lumber
		local
			sawmill : SAWMILL
		do
			move (place)
			create sawmill.make (place)
			Result := sawmill
			io.put_string (Result.to_string + " was just constructed%N")
		end

	build_barrack (place : POSITION) : BUILDING is
			-- Construct barrack to train soldiers
		local
			barrack : BARRACK
		do
			move (place)
			create barrack.make (place)
			Result := barrack
			io.put_string (Result.to_string + " was just constructed%N")
		end

	collect_lumber (tree_position : POSITION; sawmill : SAWMILL) : RESOURCE is
			-- Cut trees and collect lumber
		local
			lumber : LUMBER
		do
			move (tree_position)
			create lumber.make
			io.put_string (to_string + " has just cut a tree%N")
			move (sawmill.get_position)
			Result := lumber
			io.put_string (to_string + " collected lumber%N")
		end

	collect_gold (mine : MINE) : RESOURCE is
			-- Cut trees and collect lumber
		local
			gold : GOLD
		do
			move (mine.get_position)
			io.put_string (to_string + " is searching for gold in " + mine.to_string + "%N")
			create gold.make
			Result := gold
			io.put_string (to_string + " have found gold in " + mine.to_string + "%N")
		end

end

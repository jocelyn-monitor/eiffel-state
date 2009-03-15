note
	description: "Summary description for {WORKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WORKER

inherit
	BEING
		redefine
			make
		end

create
	make

feature -- Access
	type : STRING is "Worker"

	last_mine: MINE

	last_sawmill: SAWMILL

	last_hall: HALL

	last_barrack: BARRACK

	creation_time: INTEGER is 10
			-- Worker training time

	maximum_movement_speed: INTEGER is 1

	maximum_repair_rate: INTEGER is 5
			-- Worker can repair `repair_rate' hp during one time period

	resource_in_knapsack: RESOURCE
			-- Resource which was collected by worker and wasn't transported to its destination yet

feature -- State dependent: Access
	repair_rate: INTEGER is
			-- Repair rate which depends on hp level of worker
		do
			Result := (maximum_repair_rate * sd_ability_decrease.item ([], hp_state)).rounded
		end

feature -- Basic operations
	repair (b: BUILDING) : INTEGER is
			-- Repair some building returning time needed
		require
			b_exists: b /= Void
			worker_is_free: is_free
		do
			accessibility_state := Busy
			Result := Result + move (b.position)
			from
			until
				b.is_repaired
			loop
				b.increase_hit_points (repair_rate)
				Result := Result + 1
			end
			io.put_string (out + " has repaired building%N")
			accessibility_state := Free
		ensure
			is_repaired: b.is_repaired
			worker_is_free: is_free
		end

	build_mine (p: POSITION): INTEGER is
			-- Construct mine and store it in `last_mine'
		require
			p_exists: p /= Void
		do
			accessibility_state := Busy
			Result := Result + move (p)
			create last_mine.make (p)
			Result := Result + last_mine.creation_time
			io.put_string (last_mine.out + " was just constructed%N")
			accessibility_state := Free
		ensure
			last_mine_exists: last_mine /= Void
			worker_is_free: is_free
		end

	build_sawmill (p: POSITION): INTEGER is
			-- Construct sawmill and store it in `last_sawmill'
		require
			p_exists: p /= Void
		do
			accessibility_state := Busy
			Result := Result + move (p)
			create last_sawmill.make (p)
			Result := Result + last_sawmill.creation_time
			io.put_string (last_sawmill.out + " was just constructed%N")
			accessibility_state := Free
		ensure
			last_sawmill_exists: last_sawmill /= Void
			worker_is_free: is_free
		end

	build_barrack (p: POSITION): INTEGER is
			-- Construct barrack and store it in `last_barrack'
		require
			p_exists: p /= Void
		do
			accessibility_state := Busy
			Result := Result + move (p)
			create last_barrack.make (p)
			Result := Result + last_barrack.creation_time
			io.put_string (last_barrack.out + " was just constructed%N")
			accessibility_state := Free
		ensure
			last_barrack_exists: last_barrack /= Void
			worker_is_free: is_free
		end

	build_hall (p: POSITION): INTEGER is
			-- Construct hall and store it in `last_hall'
		require
			p_exists: p /= Void
		do
			accessibility_state := Busy
			Result := Result + move (p)
			create last_hall.make (p)
			Result := Result + last_hall.creation_time
			io.put_string (last_barrack.out + " was just constructed%N")
			accessibility_state := Free
		ensure
			last_hall_exists: last_hall /= Void
			worker_is_free: is_free
		end

	collect_lumber (tree_position: POSITION; sawmill: SAWMILL): INTEGER is
			-- Cut trees at `tree_position' and produce lumber with the help of `sawmill'
			-- Time requered is returned
		require
			position_exists: position /= Void
			sawmill_exists: sawmill /= Void
		do
			accessibility_state := Busy
			Result := Result + move (tree_position)
			resource_in_knapsack := create {FELLED_TREE}
			Result := Result + resource_in_knapsack.creation_time
			io.put_string (out + " has just cut a tree at " + tree_position.out + "%N")

			Result := Result + move (sawmill.position)
			Result := Result + sawmill.produce
			io.put_string (out + " collected lumber%N")
			accessibility_state := Free
		ensure
			worker_is_free: is_free
		end

	collect_gold (mine: MINE): INTEGER is
			-- Cut gold at `mine', function returns time spent
		require
			mine_exists: mine /= Void
		do
			accessibility_state := Busy
			Result := Result + move (mine.position)
			io.put_string (out + " is searching for gold in " + mine.out + "%N")
			Result := Result + mine.produce
			resource_in_knapsack := create {GOLD}
			Result := Result + resource_in_knapsack.creation_time
			io.put_string (out + " collected gold in " + mine.out + "%N")
			accessibility_state := Free
		ensure
			worker_is_free: is_free
		end

feature -- Initialization
	make (p: POSITION) is
		do
			Precursor {BEING} (p)
			accessibility_state := Free
		end

feature -- State dependent: Access
	is_free: BOOLEAN is
			-- Is worker free
		do
			Result := accessibility_state = Free
		end

feature {NONE} -- Implementation
	max_hit_points: INTEGER is 25

	Free: STATE is once create Result.make ("Free") end
	Busy: STATE is once create Result.make ("Busy") end

	accessibility_state: STATE
end

note
	description: "Workers can build and repair mines, sawmills, barracks, halls."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WORKER

inherit
	BEING
		redefine
			make,
			actions
		end

create
	make

feature -- Access
	type : STRING is "Worker"

	creation_time: DOUBLE is 10.0
			-- Worker training time

	last_building: BUILDING
			-- Last builded mine, or sawmill, etc

	maximum_movement_speed: DOUBLE is 1.0

	resource_in_knapsack: RESOURCE
			-- Resource which was collected by worker and wasn't transported to its destination yet

	actions: LIST [ACTION [TUPLE]] is
		do
			Result := Precursor {BEING}
			Result.extend (create {ACTION [TUPLE [BUILDING]]}.make (agent repair, "repair"))
			Result.extend (create {ACTION [TUPLE [POSITION]]}.make (agent build_mine, "build mine"))
			Result.extend (create {ACTION [TUPLE [POSITION]]}.make (agent build_sawmill, "build sawmill"))
			Result.extend (create {ACTION [TUPLE [POSITION]]}.make (agent build_barrack, "build barrack"))
			Result.extend (create {ACTION [TUPLE [POSITION]]}.make (agent build_hall, "build hall"))
			Result.extend (create {ACTION [TUPLE [POSITION, SAWMILL]]}.make (agent collect_lumber, "collect lumber"))
			Result.extend (create {ACTION [TUPLE [MINE]]}.make (agent collect_gold, "collect gold"))
		end

feature -- Basic operations
	repair (b: BUILDING) is
			-- Repair some building
		require
			b_exists: b /= Void
			worker_is_free: is_free
		do
			accessibility_state := Busy
			move (b.position)
			from
			until
				not b.is_repaired
			loop
				b.repair
			end
			io.put_string (out + " has repaired building%N")
			accessibility_state := Free
		ensure
			is_repaired: b.is_repaired
			worker_is_free: is_free
		end

	build_mine (p: POSITION) is
			-- Builds mine and stores it in `last_building'
		require
			p_exists: p /= Void
		do
			accessibility_state := Busy
			move (p)
			last_building := create {MINE}.make (p, team_name)
			io.put_string (last_building.out + " was just constructed%N")
			accessibility_state := Free
		ensure
			worker_is_free: is_free
		end

	build_sawmill (p: POSITION) is
			-- Builds sawmill and stores it in `last_building'
		require
			p_exists: p /= Void
		do
			accessibility_state := Busy
			move (p)
			last_building := create {SAWMILL}.make (p, team_name)
			io.put_string (last_building.out + " was just constructed%N")
			accessibility_state := Free
		ensure
			worker_is_free: is_free
		end

	build_storehouse (p: POSITION) is
			-- Builds storehouse and stores it in `last_building'
		require
			p_exists: p /= Void
		do
			accessibility_state := Busy
			move (p)
			last_building := create {STOREHOUSE}.make (p, team_name)
			io.put_string (last_building.out + " was just constructed%N")
			accessibility_state := Free
		ensure
			worker_is_free: is_free
		end

	build_barrack (p: POSITION) is
			-- Builds barrack and stores it in `last_building'
		require
			p_exists: p /= Void
		do
			accessibility_state := Busy
			move (p)
			last_building := create {BARRACK}.make (p, team_name)
			io.put_string (last_building.out + " was just constructed%N")
			accessibility_state := Free
		ensure
			worker_is_free: is_free
		end

	build_hall (p: POSITION) is
			-- Builds hall and stores it in `last_building'
		require
			p_exists: p /= Void
		do
			accessibility_state := Busy
			move (p)
			last_building := create {HALL}.make (p, team_name)
			io.put_string (last_building.out + " was just constructed%N")
			accessibility_state := Free
		ensure
			worker_is_free: is_free
		end

	collect_lumber (tree_position: POSITION; sawmill: SAWMILL) is
			-- Cut trees at `tree_position' and produce lumber with the help of `sawmill'
		require
			position_exists: position /= Void
			sawmill_exists: sawmill /= Void
		do
			accessibility_state := Busy
			move (tree_position)
			resource_in_knapsack := create {FELLED_TREE}
			io.put_string (out + " has just cut a tree at " + tree_position.out + "%N")

			move (sawmill.position)
			resource_in_knapsack := sawmill.produce
			io.put_string (out + " collected lumber%N")
			accessibility_state := Free
		ensure
			worker_is_free: is_free
		end

	collect_gold (mine: MINE) is
			-- Cut gold at `mine', function returns time spent
		require
			mine_exists: mine /= Void
		do
			accessibility_state := Busy
			move (mine.position)
			io.put_string (out + " is searching for gold in " + mine.out + "%N")
			resource_in_knapsack := mine.produce
			io.put_string (out + " collected gold in " + mine.out + "%N")
			accessibility_state := Free
		ensure
			worker_is_free: is_free
		end

feature -- Initialization
	make (p: POSITION; team: STRING) is
		do
			Precursor {BEING} (p, team)
			accessibility_state := Free
		end

feature -- State dependent: Access
	is_free: BOOLEAN is
			-- Is worker free
		do
			Result := accessibility_state = Free
		end

feature {NONE} -- Implementation

	Free: STATE is once create Result.make ("Free") end
	Busy: STATE is once create Result.make ("Busy") end

	accessibility_state: STATE
end

note
	description: "This class manages all units in game."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UNIT_MANAGER

create
	make

feature -- Basic operations
	execute_script is
			-- Creation of several units as an example of manager's job
		local
			hall: HALL
			barrack: BARRACK
			mine: MINE
			storehouse: STOREHOUSE
			buildings: LIST [BUILDING]

			workers: ARRAY [WORKER]
			worker: WORKER
			soldiers: ARRAY [SOLDIER]
			soldier: SOLDIER
			powerful_hero: HERO
			doctor: DOCTOR
			resources: LINKED_LIST [RESOURCE]

			i: INTEGER

			list: LIST [ACTION [TUPLE]]
		do
			x_coordinate := 1
            create hall.make(map_manager.position (0, 0), "Red")
            process_unit (hall)

            powerful_hero := hall.train_hero
			process_unit (powerful_hero)

            doctor := hall.train_doctor
			process_unit (doctor)

            create workers.make (1, 3)
            from
                i := 1
            until
                i = workers.count + 1
            loop
            	worker := hall.train_worker
                workers.put (worker, i)
                process_unit (worker)
                i := i + 1
            end

			buildings := create {LINKED_LIST [BUILDING]}.make
			workers.item (1).build_barrack (map_manager.position (0, 1))
			barrack ?= workers.item (1).last_building
			buildings.extend (workers.item (1).last_building)
            process_unit (workers.item (1).last_building)

            create soldiers.make (1, 5)
            from
                i := 1
            until
                i = soldiers.count + 1
            loop
            	soldier := barrack.train_soldier
                soldiers.put (soldier, i)
                list := soldier.actions
                process_unit (soldier)
                i := i + 1
            end

			workers.item (2).build_mine (map_manager.position (0, 2))
			mine ?= workers.item (2).last_building
			buildings.extend (workers.item (2).last_building)
            process_unit (workers.item (2).last_building)

			workers.item (3).build_sawmill (map_manager.position (0, 3))
			buildings.extend (workers.item (3).last_building)
            process_unit (workers.item (3).last_building)

           	workers.item (2).build_storehouse (map_manager.position (0, 4))
			storehouse ?= workers.item (2).last_building
			buildings.extend (workers.item (2).last_building)
            process_unit (workers.item (2).last_building)

			create resources.make
            from
                i := 1
            until
                i = workers.count + 1
            loop
            	workers.item (i).collect_gold (mine)
                resources.extend (workers.item (i).resource_in_knapsack)
                i := i + 1
            end

            from
            	i := 1
            until
            	i = workers.count + 1
            loop
            	workers.item (i).move (map_manager.position (i + 1, 0))
            	i := i + 1
            end

            powerful_hero.attack (workers.item (1))

            doctor.heal (powerful_hero)
		end

	process_unit (unit: UNIT) is
			-- Adds `unit' in `units' list and moves it to the next position in the row.
			-- Example of moving units
		local
			being: BEING
				-- if `unit' is `BEING' then it can be moved
		do
			units.extend (unit)
			being ?= unit
			if (being /= Void) then
				being.move (map_manager.position (x_coordinate, 0))
				x_coordinate := x_coordinate + 1
			end
		end

feature -- Access
	units: LIST [UNIT]
			-- All units in game are stored in this list

	select_units (x, y: INTEGER_INTERVAL): LIST [UNIT] is
			-- Select units in given rectangle,
			-- return list containing all of them
		do
			Result := create {LINKED_LIST [UNIT]}.make
			from
				units.start
			until
				units.after
			loop
				if (x.has (units.item.position.x) and y.has (units.item.position.y)) then
					units.item.select_
--					io.put_string (units.item.out + " ")
					Result.extend (units.item)
				else
					units.item.deselect
				end
				units.forth
					-- Iterate over all units
			end
--			io.put_new_line
		end


feature -- Initialization
	make (m: MAP_MANAGER) is
			-- Memorize pointer to `MAP_MANAGER' object
			-- and execute list of actions
		require
			map_manager_exists: m /= Void
		do
			map_manager := m
			units := create {LINKED_LIST [UNIT]}.make
			execute_script
		ensure
			units_created: units.count > 0
		end

feature {NONE} -- Implementation

	map_manager: MAP_MANAGER
			-- Pointer to map manager of the game

	x_coordinate: INTEGER
			-- Current coordinate for unit in the row

invariant
	units /= Void
	positive_coordinate: x_coordinate > 0
end

note
	description: "This class manages all units in game"
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
			sawmill: SAWMILL

			workers: ARRAY [WORKER]
			worker: WORKER
			soldiers: ARRAY [SOLDIER]
			soldier: SOLDIER
			powerful_hero: HERO
			doctor: DOCTOR
			resources: LINKED_LIST [RESOURCE]

			i: INTEGER
		do
			x_coordinate := 1
            create hall.make(map_manager.position (0, 0), "Red")
            process_unit (hall)

			time := time + hall.train_hero
            powerful_hero ?= hall.last_trained
			process_unit (powerful_hero)

			time := time + hall.train_doctor
            doctor ?= hall.last_trained
			process_unit (doctor)

            create workers.make (1, 3)
            from
                i := 1
            until
                i = workers.count + 1
            loop
            	time := time + hall.train_worker
            	worker ?= hall.last_trained
                workers.put (worker, i)
                process_unit (worker)
                i := i + 1
            end

			time := time + workers.item (1).build_barrack (map_manager.position (0, 1))
            barrack := workers.item (1).last_barrack
            process_unit (barrack)

            create soldiers.make (1, 5)
            from
                i := 1
            until
                i = soldiers.count + 1
            loop
            	time := time + barrack.train_soldier
            	soldier := barrack.last_soldier
                soldiers.put (soldier, i)
                process_unit (soldier)
                i := i + 1
            end

			time := time + workers.item (2).build_mine (map_manager.position (0, 2))
            mine := workers.item (2).last_mine
            process_unit (mine)

			time := time + workers.item (3).build_sawmill (map_manager.position (0, 3))
            sawmill := workers.item (3).last_sawmill
            process_unit (sawmill)

			create resources.make
            from
                i := 1
            until
                i > 3
            loop
            	time := time + workers.item (i).collect_gold (mine)
                resources.extend (mine.last_gold)
                i := i + 1
            end

            time := time + powerful_hero.attack (workers.item (1))

            time := time + doctor.heal_being (powerful_hero)
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
				time := time + being.move (map_manager.position (x_coordinate, 0))
				x_coordinate := x_coordinate + 1
			end
		end

feature -- Access
	units: LINKED_LIST [UNIT]
			-- All units in game are stored in this list

	select_units (x, y: INTEGER_INTERVAL): LINKED_LIST [UNIT] is
			-- Select units in given rectangle,
			-- return list containing all of them
		do
			create Result.make
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
			create units.make
			execute_script
		ensure
			units_created: units.count > 0
		end

feature {NONE} -- Implementation

	map_manager: MAP_MANAGER
			-- Pointer to map manager of the game

	x_coordinate: INTEGER
			-- Current coordinate for unit in the row

	time : DOUBLE
			-- Time elapsed from the very beginning

invariant
	positive_time: time >= 0
	units /= Void
	positive_coordinate: x_coordinate > 0
end

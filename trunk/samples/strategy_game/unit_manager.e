note
	description: "Summary description for {UNIT_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UNIT_MANAGER

create
	make

feature -- Access

	execute_script is
			-- Some actions list
		local
			hall : HALL
			barrack : BARRACK
			mine : MINE
			sawmill : SAWMILL

			workers : ARRAY [WORKER]
			soldiers : ARRAY [SOLDIER]
			powerful_hero : HERO
			resources : LINKED_LIST [RESOURCE]

			i: INTEGER
		do
			x_coordinate := 1
            create hall.make(map_manager.position_at (0, 0), "Red")
            process_unit (hall)

			time := time + hall.train_hero
            powerful_hero := hall.last_hero
			process_unit (powerful_hero)

            create workers.make (1, 3)
            from
                i := 1
            until
                i = workers.count + 1
            loop
            	time := time + hall.train_worker
                workers.put (hall.last_worker, i)
                process_unit (hall.last_worker)
                i := i + 1
            end

			time := time + workers.item (1).build_barrack (map_manager.position_at (0, 1))
            barrack := workers.item (1).last_barrack
            process_unit (barrack)

            create soldiers.make (1, 5)
            from
                i := 1
            until
                i = soldiers.count + 1
            loop
            	time := time + barrack.train_soldier
                soldiers.put (barrack.last_soldier, i)
                process_unit (barrack.last_soldier)
                i := i + 1
            end

			time := time + workers.item (2).build_mine (map_manager.position_at (0, 2))
            mine := workers.item (2).last_mine
            process_unit (mine)

			time := time + workers.item (3).build_sawmill (map_manager.position_at (0, 3))
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

            --time := time + powerful_hero.attack (workers.item (1))
		end

	process_unit (unit: UNIT) is
			-- Adds `unit' in `units' list and moves it to the next position in the row
		local
			being: BEING
				-- if `unit' is `BEING' then it can be moved
		do
			units.extend (unit)
			being ?= unit
			if (being /= Void) then
				time := time + being.move (map_manager.position_at (x_coordinate, 0))
				x_coordinate := x_coordinate + 1
			end
		end

feature -- Access
	units: LINKED_LIST [UNIT]
		-- All units in game are stored there

feature -- Initialization
	make (manager: MAP_MANAGER) is
		do
			map_manager := manager
			create units.make
			execute_script
		end

feature {NONE} -- Implementation

	map_manager: MAP_MANAGER
		-- Pointer to map manager of the game

	x_coordinate: INTEGER
		-- Current coordinate for unit in the row

	time : DOUBLE
		-- Time elapsed from the very beginning

end

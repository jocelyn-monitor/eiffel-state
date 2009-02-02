indexing
    description : "Strategy Game application root class"
    date        : "$Date: 2008-09-19 11:33:35 -0700 (Fri, 19 Sep 2008) $"
    revision    : "$Revision: 74752 $"

class
    APPLICATION

inherit
    ARGUMENTS

create
    make

feature {NONE} -- Initialization

    make () is
            -- Run application.
        local
            hall : HALL
            barrack : BARRACK
            mine : MINE
            sawmill : SAWMILL

            hall_position : POSITION
            barrack_position : POSITION
            mine_position : POSITION
            sawmill_position : POSITION
            forest_coordinates : POSITION

            workers : ARRAY[WORKER]
            soldiers : ARRAY[SOLDIER]
            powerful_hero : HERO

            resources : ARRAY[RESOURCE]

            counter : INTEGER
        do
            create hall_position.make (0.0, 0.0)
            create hall.make(hall_position)

            powerful_hero := hall.train_hero

            create workers.make (0, 2)
            from
                counter := 0
            until
                counter = 3
            loop
                workers.put (hall.train_worker, counter)
                counter := counter + 1
            end

            create barrack_position.make (1.0, 0.0)
            barrack ?= workers.item (0).build_barrack (barrack_position)

            create soldiers.make (0, 10)
            from
                counter := 0
            until
                counter = 11
            loop
                soldiers.put (barrack.train_soldier, counter)
                counter := counter + 1
            end

            create mine_position.make (1.0, 1.0)
            mine ?= workers.item (1).build_mine (mine_position)

            create sawmill_position.make (0.0, 1.0)
            sawmill ?= workers.item (2).build_sawmill (sawmill_position)

            create forest_coordinates.make (-2.0, 0.0)

            create resources.make (0, 1)
            from
                counter := 0
            until
                counter = 3
            loop
                resources.put (workers.item (counter).collect_lumber (forest_coordinates, sawmill), 0)
                counter := counter + 1
            end

            from
                counter := 0
            until
                counter = 3
            loop
                resources.put (workers.item (counter).collect_gold (mine), 1)
                counter := counter + 1
            end
        end

end

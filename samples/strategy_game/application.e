indexing
    description : "Strategy Game application root class"
    date        : "$Date: 2008-09-19 11:33:35 -0700 (Fri, 19 Sep 2008) $"
    revision    : "$Revision: 74752 $"

class
    APPLICATION

create
    make

feature {NONE} -- Initialization

    make is
            -- Run application.
        local
            hall : HALL
            barrack : BARRACK
            mine : MINE
            sawmill : SAWMILL

            workers : ARRAY [WORKER]
            soldiers : ARRAY [SOLDIER]
            powerful_hero : HERO
            resources : LINKED_LIST [RESOURCE]

			forest_position: POSITION
            i: INTEGER
            time : INTEGER
        do
            create hall.make_at_origin

			time := time + hall.train_hero
            powerful_hero := hall.last_hero

            create workers.make (1, 3)
            from
                i := 1
            until
                i > 3
            loop
            	time := time + hall.train_worker
                workers.put (hall.last_worker, i)
                i := i + 1
            end

			time := time + workers.item (1).build_barrack (create {POSITION}.make (1,0))
            barrack := workers.item (1).last_barrack

            create soldiers.make (1, 10)
            from
                i := 1
            until
                i > 10
            loop
            	time := time + barrack.train_soldier
                soldiers.put (barrack.last_soldier, i)
                i := i + 1
            end

			time := time + workers.item (2).build_mine (create {POSITION}.make (1, 1))
            mine := workers.item (2).last_mine

			time := time + workers.item (3).build_sawmill (create {POSITION}.make (0, 1))
            sawmill := workers.item (3).last_sawmill

            create forest_position.make (-2, 0)

            create resources.make
            from
                i := 1
            until
                i > 3
            loop
            	time := time + workers.item (i).collect_lumber (forest_position, sawmill)
                resources.extend (sawmill.last_lumber)
                i := i + 1
            end

            from
                i := 1
            until
                i > 3
            loop
            	time := time + workers.item (i).collect_gold (mine)
                resources.extend (mine.last_gold)
                i := i + 1
            end
        end

end

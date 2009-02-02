note
	description: "City halls that train workers and heroes."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HALL

inherit
	BUILDING
		rename
			make as make_with_position
		end
create
	make

feature -- Initialization
	make is
			-- Create hall at origin
		do
			make_with_position (create {POSITION}.make_origin)
		end

feature -- Access
	type: STRING is "Hall"

	last_worker: WORKER
			-- Last trained worker

	last_hero: HERO
			-- Last trained hero

feature -- Basic operations
	train_worker is
			-- Train worker and store him in `last_worker'
		do
			create last_worker.make (position)
			io.put_string (last_worker.out + " has just been trained%N")
		ensure
			last_worker_exists: last_worker /= Void
		end

	train_hero is
			-- Train hero and store him in `last_hero'
		do
			create last_hero.make (position)
			io.put_string (last_hero.out + " has just been trained%N")
		ensure
			last_hero_exists: last_hero /= Void
		end

end

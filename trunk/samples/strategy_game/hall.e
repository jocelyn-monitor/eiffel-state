note
	description: "City halls that train workers and heroes."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HALL

inherit
	BUILDING

create
	make, make_at_origin

feature -- Initialization
	make_at_origin is
			-- Create hall at origin
		do
			make (create {POSITION}.make_origin)
		end

feature -- Access
	type: STRING is "Hall"

	last_worker: WORKER
			-- Last trained worker

	last_hero: HERO
			-- Last trained hero

	creation_time: INTEGER is 500

feature -- Basic operations
	train_worker: INTEGER is
			-- Train worker and store him in `last_worker'
		do
			create last_worker.make (position)
			Result := Result + last_worker.creation_time
			io.put_string (last_worker.out + " has just been trained%N")
		ensure
			last_worker_exists: last_worker /= Void
		end

	train_hero: INTEGER is
			-- Train hero and store him in `last_hero'
		do
			create last_hero.make (position)
			Result := Result + last_hero.creation_time
			io.put_string (last_hero.out + " has just been trained%N")
		ensure
			last_hero_exists: last_hero /= Void
		end

end

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
	make

feature -- Access
	type: STRING is "Hall"

	last_worker: WORKER
			-- Last trained worker

	last_hero: HERO
			-- Last trained hero

	creation_time: DOUBLE is 50.0

feature -- Basic operations
	train_worker: DOUBLE is
			-- Train worker and store him in `last_worker'
		do
			create last_worker.make (position)
			Result := Result + last_worker.creation_time
			io.put_string (last_worker.out + " has just been trained%N")
		ensure
			last_worker_exists: last_worker /= Void
		end

	train_hero: DOUBLE is
			-- Train hero and store him in `last_hero'
		do
			create last_hero.make (position)
			Result := Result + last_hero.creation_time
			io.put_string (last_hero.out + " has just been trained%N")
		ensure
			last_hero_exists: last_hero /= Void
		end

end

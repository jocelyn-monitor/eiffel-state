note
	description: "City halls that train workers, heroes and doctors."
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

	last_trained: BEING
			-- Last trained `BEING'

	creation_time: DOUBLE is 50.0
			-- Time required to build hall

feature -- Basic operations
	train_worker: DOUBLE is
			-- Train worker and store him in `last_trained'
		do
			last_trained := create {WORKER}.make (position, team_name)
			Result := train_being
		end

	train_hero: DOUBLE is
			-- Train hero and store him in `last_trained'
		do
			last_trained := create {HERO}.make (position, team_name)
			Result := train_being
		end

	train_doctor: DOUBLE is
			-- Train doctor and store him in `last_trained'
		do
			last_trained := create {DOCTOR}.make (position, team_name)
			Result := train_being
		end

feature {NONE} -- Implementation

	train_being: DOUBLE is
			-- Train some being
		do
			Result := last_trained.creation_time
			io.put_string (last_trained.out + " has just been trained%N")
		ensure
			last_trained_exists: last_trained /= Void
		end


end

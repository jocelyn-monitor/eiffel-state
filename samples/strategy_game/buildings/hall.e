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

	creation_time: DOUBLE is 50.0
			-- Time required to build hall

	actions: LIST [ACTION [TUPLE]] is
		do
			Result := Void
		end

feature -- Basic operations
	train_worker: WORKER is
			-- Train worker
		do
			create Result.make (position, team_name)
		end

	train_hero: HERO is
			-- Train hero
		do
			create Result.make (position, team_name)
		end

	train_doctor: DOCTOR is
			-- Train doctor
		do
			create Result.make (position, team_name)
		end
end

note
	description: "Barracks that train soldiers."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BARRACK

inherit
	BUILDING

create {WORKER}
	make

feature -- Access
	type: STRING is "Barrack"

	creation_time: DOUBLE is 30.0

	actions: LIST [ACTION [TUPLE]] is
		do
			Result := Void
		end

feature -- Basic operations
	train_soldier: SOLDIER is
		do
			create Result.make (position, team_name)
			io.put_string (Result.out + " was trained%N")
		end

end

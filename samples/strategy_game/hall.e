note
	description: "Summary description for {HALL}."
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
	get_type : STRING is
		do
			Result := "Hall"
		end

	train_worker : WORKER is
			-- Train worker from this hall
		do
			create Result.make (get_position)
			io.put_string (Result.to_string + " has just been trained%N")
		end

	train_hero : HERO is
			-- Train hero
		do
			create Result.make (get_position)
			io.put_string (Result.to_string + " has just been trained%N")
		end

end

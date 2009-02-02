note
	description: "Summary description for {BARRACK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BARRACK

inherit
	BUILDING

create
	make

feature -- Access
	get_type : STRING is
		do
			Result := "Barrack"
		end

	train_soldier : SOLDIER is
		do
			create Result.make (get_position)
			io.put_string (Result.to_string + " was trained%N")
		end
end

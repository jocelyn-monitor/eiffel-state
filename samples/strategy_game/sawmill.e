note
	description: "Summary description for {SAWMILL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAWMILL

inherit
	BUILDING

create
	make

feature -- Access
	get_type : STRING is
		do
			Result := "Sawmill"
		end

end

note
	description: "Summary description for {MINE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MINE

inherit
	BUILDING

create
	make

feature -- Access
	get_type : STRING is
		do
			Result := "Mine"
		end

end

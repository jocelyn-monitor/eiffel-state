indexing
	description: "Summary description for {STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATE

create
	make

feature {NONE} -- Initialization

	make (init_state_id: INTEGER; init_state_name: STRING) is
			-- Initialization for `Current'.
		do
			state_id := init_state_id
			state_name := init_state_name
		end

	state_id: INTEGER -- id of the state
	state_name: STRING -- name of the state

feature -- Access

	get_state_id: INTEGER is
			-- returns id of the state
		do
			Result := state_id
		end

	get_state_name: STRING is
			-- returns name of the state
		do
			Result := state_name
		end

end

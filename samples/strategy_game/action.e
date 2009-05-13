note
	description: "Actions can be carried out by units in the game."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ACTION [ARGS -> TUPLE]

inherit
	ANY
		redefine
			out
		end

create
	make

feature -- Access
	out: STRING is
			-- String identifier
		do
			Result := type
		end

	hash_code: INTEGER is
			-- Hash code
		do
			Result := type.hash_code
		end


feature -- Basic operations
	carry_out (target: ANY; args: ARGS) is
			-- Carry out the action
		do
			procedure.set_target (target)
			procedure.call (args)
		end


feature -- Initialization
	make (proc: PROCEDURE [ANY, ARGS]; action_type: STRING) is
			-- Create action with given name and behavior
		do
			procedure := proc
			type := action_type
		end


feature {NONE} -- Implementation
	procedure: PROCEDURE [ANY, ARGS]
	type: STRING

invariant
	procedure_set: procedure /= Void
	not_empty_type: not type.is_empty

end

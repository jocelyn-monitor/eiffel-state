indexing
	description: "Automated objects."
	author: "Author"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUTOMATED

feature {NONE} -- Implementation
	state : STATE
			-- Current control state

	otherwise: BOOLEAN is
			-- Always true
		do
			Result := True
		ensure
			Result = True
		end

end

indexing
	description	: "Root class for this application."
	author		: ""
	date		: "$Date: 2009/2/5 11:31:7 $"
	revision	: "1.0.0"

class
	APPLICATION


create
	make

feature {NONE} -- Initialization

	make is
			-- Initialize and launch application
		do
		end

feature {NONE}
a: AUTOMATED
b: STATE
c: STATE_DEPENDENT_FUNCTION [STRING]
d: STATE_DEPENDENT_PROCEDURE [TUPLE]

end -- class APPLICATION

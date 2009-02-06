indexing
	description: "Summary description for {STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATE

inherit
	HASHABLE

create
	make

feature -- Initialization
	make (s: STRING) is
			--
		do
			name := s
		end

feature -- Access
	name: STRING

	hash_code: INTEGER is
			--
		do
			Result := name.hash_code
		end
end

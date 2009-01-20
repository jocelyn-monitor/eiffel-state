indexing
	description: "Summary description for {GAME_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_FIELD

create
	make

feature {NONE} -- Initialization

	make is
			-- Initialization for `Current'.
		local
			i: INTEGER
			j: INTEGER
			array: ARRAY[INTEGER]
		do
			create field_items.make (0, 2)
			from
				i := 0
			until
				i = 3
			loop

				create array.make (0, 2)
				field_items.item(i) := array
				from
					j := 0
				until
					j = 3
				loop
					field_items.item (i).item (j) := Empty_id
					j := j + 1
				end
				i := i + 1
			end
		end

feature
	get(i: INTEGER; j: INTEGER): INTEGER  is
			-- returns value of element i, j
		require
			i >= 0 and i <= 2 and j >= 0 and j <= 2
		do
			result := field_items.item (i).item (j)
		end

feature
	set(i: INTEGER; j: INTEGER; value: INTEGER) is
			-- sets value for element i, j
	require
		i >= 0 and i <= 2 and j >= 0 and j <= 2
		and (value = Empty_id or value = Cross_id or value = Circle_id)
	do
		field_items.item (i).item (j) := value
	end


feature {NONE} -- Variables

	field_items : ARRAY[ARRAY[INTEGER]]

feature -- Constants
    Cross_id : INTEGER is -1
    Circle_id : INTEGER is 1
    Empty_id : INTEGER is 0

feature {NONE} -- Implementation

end

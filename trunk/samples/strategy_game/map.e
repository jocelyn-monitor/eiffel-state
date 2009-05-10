note
	description: "Game map"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MAP

create
	create_random

feature -- Measurement
	width: INTEGER
		-- Width of map

	height: INTEGER

feature -- Initialization
	create_random (seed: INTEGER) is
			-- Creates random map using pseudo-random generator
		local
			i, j: INTEGER
			relief_generator: RANDOM
			cur_arr: ARRAY [POSITION]
			pos: POSITION
			cur_relief: INTEGER
		do
			width := 20
			height := 20
			
			create relief_generator.make
			cur_relief := seed
			create relief.make (0, width - 1)
			from
				i := 0
			until
				i >= width
			loop
				create cur_arr.make (0, height - 1)
				relief.put (cur_arr, i)
				from
					j := 0
				until
					j >= height
				loop
					cur_relief := relief_generator.next_random (cur_relief)
					create pos.make (i, j, cur_relief \\ {POSITION}.relief_types + 1)
					cur_arr.put (pos, j)
					j := j + 1
				end
				i := i + 1
			end
		end

feature {MAP_MANAGER} -- Implementation
	relief: ARRAY [ARRAY [POSITION]]

end

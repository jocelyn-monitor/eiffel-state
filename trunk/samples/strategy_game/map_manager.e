note
	description: "Summary description for {MAP_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MAP_MANAGER

inherit
	ANY
		redefine
			default_create
		end

create
	default_create

feature -- Access
	width: INTEGER is 20

	height: INTEGER is 20

	Cell_size: INTEGER is 30
			-- Size of every relief cell

	position_at (x, y: INTEGER): POSITION is
			-- Returns `POSITION' object, which contains (x, y) relief
		require
			coordinates_in_bounds: x >= 0 and x < width and y >= 0 and y < height
		do
			Result := relief @ x @ y
		ensure
			Result /= Void
		end

	position_of_relief (relief_type: INTEGER): POSITION is
			-- Returns first position with `relief_type' relief
		local
			i, j: INTEGER
			p: POSITION
		do
			from
				i := 0
				j := 0
			until
				i >= width or Result /= Void
			loop
				p := position_at (i, j)
				if (p.relief_name(relief_type).is_equal (p.relief)) then
					Result := p
				end
				j := j + 1
				if (j >= height) then
					j := 0
					i := i + 1
				end
			end
		end

	draw_map (drawable: EV_DRAWABLE) is
			-- Draws the whole map in the window using `drawable'
		local
			color: EV_COLOR
			i, j: INTEGER
		do
			from
				i := 0
				j := 0
			until
				i >= width
			loop
				color := position_at (i, j).color
				drawable.set_foreground_color (color)
				drawable.fill_rectangle (i * Cell_size, j * Cell_size, Cell_size, Cell_size)
				j := j + 1
				if (j >= height) then
					j := 0
					i := i + 1
				end
			end
		end

	cell_center_coordinates (p: POSITION): ARRAY [INTEGER]
			-- x and y coordinates of center of given `p'
		do
			Result := <<p.x * Cell_size + Cell_size // 2, p.y * Cell_size + Cell_size // 2>>
		end

feature {NONE} -- Initialization
	default_create is
			-- Initialize map relief
		do
			create_random_map(1)
		end

	create_random_map (seed: INTEGER) is
			-- Generates random map using pseudo-random generator
		local
			i, j: INTEGER
			relief_generator: RANDOM
			cur_arr: ARRAY [POSITION]
			pos: POSITION
			cur_relief: INTEGER
		do
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

feature {NONE} -- Implementation
	relief: ARRAY [ARRAY [POSITION]]

end

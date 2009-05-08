note
	description: "Positions in the game world."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POSITION

inherit
	AUTOMATED
		redefine
			out
		end

create
	make,
	make_origin

feature -- Initialization
	make (new_x, new_y: INTEGER) is
			-- Set `x' to `new_x' and `y' to `new_y'
		do
			x := new_x
			y := new_y
			state := Forest
		ensure
			x_set: x = new_x
			y_set: y = new_y
		end

	make_origin is
			-- Create an origin point
		do
			x := 0
			y := 0
			state := Forest
		ensure
			x_set: x = 0
			y_set: y = 0
		end

feature -- Access
	x: INTEGER

	y: INTEGER

	Origin: POSITION is
			-- Origin of the world
		once
			create Result.make_origin
		end

feature -- Status report
	equals (other: POSITION) : BOOLEAN is
			-- Are these two positions equal?
		do
			Result := x = other.x and y = other.y
		end

feature -- State dependent: Status report
	crossing_time: INTEGER is
			-- It takes `crossing_time' to cross cell with this coordinates according to its relief
			do
				Result := sd_crossing_time.item ([], state)
			end

feature -- Output
	out: STRING is
			-- String representation in form (`x', `y', `Relief')
		do
			Result := "(" + x.out + ", " + y.out + ", " + state.name + ")"
		end

feature {NONE}
	Forest: STATE is once create Result.make ("Forest") end
	Field: STATE is once create Result.make ("Field") end
	River: STATE is once create Result.make ("River") end
	Jungle: STATE is once create Result.make ("Jungle") end
	Mountain: STATE is once create Result.make ("Mountain") end

	sd_crossing_time: STATE_DEPENDENT_FUNCTION [TUPLE, INTEGER] is
			-- State-dependent function for `crossing_time'
		once
			create Result.make(5)
			Result.add_result (Forest, agent : BOOLEAN do Result := True end, 100)
			Result.add_result (Jungle, agent : BOOLEAN do Result := True end, 150)
			Result.add_result (Field, agent : BOOLEAN do Result := True end, 50)
			Result.add_result (River, agent : BOOLEAN do Result := True end, 200)
			Result.add_result (Mountain, agent : BOOLEAN do Result := True end, 300)
		end

end

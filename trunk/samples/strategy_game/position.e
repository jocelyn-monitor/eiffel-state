note
	description: "Positions in the game world."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POSITION

inherit
	ANY
		redefine
			out
		end

create
	make,
	make_origin

feature -- Initialization
	make (new_x, new_y: DOUBLE) is
			-- Set `x' to `new_x' and `y' to `new_y'
		require
			not_too_far: (new_x - Origin.x) ^ 2 + (new_y - Origin.y) ^ 2 <= Radius
		do
			x := new_x
			y := new_y
		ensure
			x_set: x = new_x
			y_set: y = new_y
		end

	make_origin is
			-- Create an origin point
		do
		ensure
			x_set: x = 0.0
			y_set: y = 0.0
		end

feature -- Access
	x : DOUBLE

	y : DOUBLE

	Origin: POSITION is
			-- Origin of the world
		once
			create Result.make_origin
		end

	Radius: DOUBLE is 1000.0
			-- World radius


feature -- Output
	out: STRING is
			-- String representation in form (`x', `y')
		do
			Result := "(" + x.out + ", " + y.out + ")"
		end

invariant
	not_too_far: (x - Origin.x) ^ 2 + (y - Origin.y) ^ 2 <= Radius
end

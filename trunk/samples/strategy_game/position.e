note
	description: "Summary description for {POSITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POSITION

create
	make

feature -- Access
	get_x : DOUBLE is
		do
			Result := x
		ensure
			equal_values : Result = x
		end

	get_y : DOUBLE is
		do
			Result := y
		ensure
			equal_values : Result = y
		end

	to_string : STRING is
			-- String in form (x, y)
		do
			Result := "(" + x.out + ", " + y.out + ")"
		end

feature -- Element change
	set_x(new_x : DOUBLE) is
		do
			x := new_x
		end

	set_y(new_y : DOUBLE) is
		do
			y := new_y
		end

feature {NONE} -- Implementation
	x : DOUBLE
	y : DOUBLE

feature {NONE} -- Initialization
	make (x_val : DOUBLE; y_val : DOUBLE) is
			-- Create POSITION object with given value
		do
			x := x_val
			y := y_val
		end

invariant
	point_not_far_from_main_hall : get_x * get_x + get_y * get_y < 1000.0

end

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
	make

feature -- Initialization
	make (new_x, new_y: INTEGER) is
			-- Set `x' to `new_x' and `y' to `new_y'
		local
			random_value: INTEGER
		do
			x := new_x
			y := new_y
			random_value := (create {RANDOM}.make).item \\ 5
			inspect
				random_value
			when 0 then
				state := Field
			when 1 then
				state := Forest
			when 2 then
				state := Jungle
			when 3 then
				state := River
			when 4 then
				state := Mountain
			end
		ensure
			x_set: x = new_x
			y_set: y = new_y
		end

feature -- Access
	x: INTEGER
	y: INTEGER

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
	Field: STATE is once create Result.make ("Field") end
	Forest: STATE is once create Result.make ("Forest") end
	Jungle: STATE is once create Result.make ("Jungle") end
	River: STATE is once create Result.make ("River") end
	Mountain: STATE is once create Result.make ("Mountain") end

	sd_crossing_time: STATE_DEPENDENT_FUNCTION [TUPLE, INTEGER] is
			-- State-dependent function for `crossing_time'
		once
			create Result.make(5)
			Result.add_result (Field, agent : BOOLEAN do Result := True end, 50)
			Result.add_result (Forest, agent : BOOLEAN do Result := True end, 100)
			Result.add_result (Jungle, agent : BOOLEAN do Result := True end, 150)
			Result.add_result (River, agent : BOOLEAN do Result := True end, 200)
			Result.add_result (Mountain, agent : BOOLEAN do Result := True end, 300)
		end

end

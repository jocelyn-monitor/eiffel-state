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
	make (new_x, new_y, relief_type: INTEGER) is
			-- Set `x' to `new_x' and `y' to `new_y', set state value according to `relief_type'
		do
			x := new_x
			y := new_y
			state := relief_state (relief_type)
		ensure
			x_set: x = new_x
			y_set: y = new_y
			state_set: state /= Void
		end

feature -- Access
	x: INTEGER
	y: INTEGER

	relief_types: INTEGER is 5

	relief_name (relief_type: INTEGER): STRING is
			-- Returns name of relief corresponding to `relief_type' type
		do
			Result := relief_state(relief_type).name
		end

	relief: STRING is
		do
			Result := state.name
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

	color: EV_COLOR is
			-- Draws current cell, using its' relief
		do
			Result := sd_color.item ([], state)
		end

feature -- Output
	out: STRING is
			-- String representation in form (`x', `y', `relief')
		do
			Result := "(" + x.out + ", " + y.out + ", " + relief + ")"
		end

feature {NONE} -- Implementation

	sd_crossing_time: STATE_DEPENDENT_FUNCTION [TUPLE, INTEGER] is
			-- State-dependent function for `crossing_time'
		local
			i: INTEGER
		once
			create Result.make(States.count)
			from
				i := 1
			until
				i = States.count + 1
			loop
				Result.add_result (States @ i, agent : BOOLEAN do Result := True end, Crossing_times @ i)
				i := i + 1
			end
		end

	sd_color: STATE_DEPENDENT_FUNCTION [TUPLE, EV_COLOR] is
			-- State-dependent function for `crossing_time'
		local
			i: INTEGER
		once
			create Result.make(States.count)
			from
				i := 1
			until
				i = States.count + 1
			loop
				Result.add_result (States @ i, agent : BOOLEAN do Result := True end, Colors @ i)
				i := i + 1
			end
		end

	relief_state (relief_type: INTEGER): STATE is
			-- Returns name of relief corresponding to `relief_type' type
		do
			Result := States @ relief_type
		end

	States: ARRAY [STATE] is
		once
			Result := <<
				create {STATE}.make ("Field"),
				create {STATE}.make ("Forest"),
				create {STATE}.make ("Jungle"),
				create {STATE}.make ("Water"),
				create {STATE}.make ("Mountain")
			>>
		end

	Crossing_times: ARRAY[INTEGER] is
			-- Returns times required to cross cells
		once
			Result := <<50, 100, 150, 200, 300>>
		end

	Colors: ARRAY[EV_COLOR] is
			-- Color to fill cell in the window
		once
			Result := <<
				create {EV_COLOR}.make_with_rgb (1, 1, 0),
				create {EV_COLOR}.make_with_rgb (0.28, 0.72, 0.3),
				create {EV_COLOR}.make_with_rgb (0.14, 1, 0.07),
				create {EV_COLOR}.make_with_rgb (0.11, 0.73, 0.89),
				create {EV_COLOR}.make_with_rgb (0.56, 0.5, 0.44)
			>>
		end


end

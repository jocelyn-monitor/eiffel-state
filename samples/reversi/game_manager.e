indexing
	description: "Summary description for {GAME_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_MANAGER
inherit
	ENVIRONMENT
	AUTOMATED
		rename
			state as turn_state
		redefine
			default_create
		select
			default_create
		end

create
	default_create

feature -- Access
	markers: ARRAY [ARRAY [MARKER]]

	dimension: INTEGER is 8

feature -- Change status
	make_move (x, y: INTEGER) is
			-- Put new marker at given position and repaint some markers
		local
			new_marker: MARKER
		do
			if (markers.item (x).item (y) = Void) then
				create new_marker.make (x, y, sd_is_white_turn.item ([], turn_state))
				if (flip (new_marker, x, y)) then
					markers.item (x).put (new_marker, y)
					gui_manager.repaint (x, y)
					sd_turn_made.call ([], turn_state)
					turn_state := sd_turn_made.next_state
					update_status
				end
			end
		end

	flip (new_marker: MARKER; x, y: INTEGER): BOOLEAN is
			-- Flips markers when new marker was put at (x, y) or returns false if none can be flipped
		local
			dx, dy: ARRAY [INTEGER] -- delta x and delta y
			possible_markers: LIST [MARKER] -- Markers of opposite color, which can be flipped
			i, j, k: INTEGER
		do
			possible_markers := create {LINKED_LIST [MARKER]}.make
			dx := << -1, -1, -1, 0, 0, 0, 1, 1, 1 >>
			dy := << -1, 0, 1, -1, 0, 1, -1, 0, 1 >>
			Result := false
			from
				i := 1
			until
				i = dx.count + 1
			loop
				from
					j := 1
				until
					(not is_valid_position (x + dx.item (i) * j, y + dy.item (i) * j)) or
						markers.item (x + dx.item (i) * j).item (y + dy.item (i) * j) = Void or
						new_marker.is_same_color (markers.item (x + dx.item (i) * j).item (y + dy.item (i) * j))
				loop
					j := j + 1
				end
				if (is_valid_position (x + dx.item (i) * j, y + dy.item (i) * j)) and
					markers.item (x + dx.item (i) * j).item (y + dy.item (i) * j) /= Void and
					new_marker.is_same_color (markers.item (x + dx.item (i) * j).item (y + dy.item (i) * j)) then
					from
						k := 1
					until
						k = j
					loop
						possible_markers.extend (markers.item (x + dx.item (i) * k).item (y + dy.item (i) * k))
						k := k + 1
					end
				end
				i := i + 1
			end
			if (possible_markers.is_empty) then
				Result := false
			else
				from
					possible_markers.start
				until
					possible_markers.after
				loop
					possible_markers.item.change_color
					possible_markers.forth
				end
				Result := true
			end
		end

	is_valid_position (x, y: INTEGER): BOOLEAN is
		do
			Result := (x >= 0) and (x < dimension) and (y >= 0) and (y < dimension)
		end



feature -- Initialization
	default_create is
		do
			initialize_markers
			turn_state := Black_turn
			update_status
		end

	initialize_markers is
			-- Create data structure for markers and add starting 4 markers
		local
			i: INTEGER
		do
			create markers.make (0, dimension - 1)
			from
				i := 0
			until
				i = dimension
			loop
				markers.put (create {ARRAY [MARKER]}.make (0, dimension), i)
				i := i + 1
			end
			markers.item (3).put (create {MARKER}.make (3, 3, true), 3)
			markers.item (3).put (create {MARKER}.make (3, 4, false), 4)
			markers.item (4).put (create {MARKER}.make (4, 3, false), 3)
			markers.item (4).put (create {MARKER}.make (4, 4, true), 4)
		end

	update_status is
			-- Update status in status bar
		do
			gui_manager.set_status (turn_state.name)
		end



feature {NONE} -- State dependent implementation

	White_turn: STATE is once create Result.make ("It's white turn now...") end
	Black_turn: STATE is once create Result.make ("It's black turn now...") end

	sd_is_white_turn: STATE_DEPENDENT_FUNCTION [TUPLE, BOOLEAN] is
			-- Returns color of marker, according to its state
		once
			create Result.make(2)
			Result.add_result (White_turn, agent true_agent, true)
			Result.add_result (Black_turn, agent true_agent, false)
		end

	sd_turn_made: STATE_DEPENDENT_PROCEDURE [TUPLE] is
		once
			create Result.make (2)
			Result.add_behavior (White_turn, agent true_agent, agent do end, Black_turn)
			Result.add_behavior (Black_turn, agent true_agent, agent do end, White_turn)
		end

end

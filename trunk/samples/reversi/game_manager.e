indexing
	description: "Summary description for {GAME_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_MANAGER
inherit
	ENVIRONMENT
		undefine
			default_create
		end
	AUTOMATED
		rename
			state as turn_state
		redefine
			default_create
		end

create
	default_create

feature -- Access
	markers: ARRAY [ARRAY [MARKER]]

	dimension: INTEGER is 8

	white_markers: INTEGER

	black_markers: INTEGER

feature -- Change status
	restart is
			-- Restarts game
		do
			sd_restart.call ([], turn_state)
			turn_state := sd_restart.next_state
		end


	make_move (x, y: INTEGER) is
			-- Put new marker at given position and repaint some markers
		local
			flipped: LIST [MARKER]
			new_marker: MARKER
		do
			if (markers.item (x).item (y) = Void) then
				create new_marker.make (x, y, sd_is_white_turn.item ([], turn_state))
				flipped := flipped_markers (new_marker, x, y)
				if (not flipped.is_empty) then
					from
						flipped.start
					until
						flipped.after
					loop
						flipped.item.change_color
						flipped.forth
					end
					if (sd_is_white_turn.item ([], turn_state)) then
						white_markers := white_markers + 1 + flipped.count
						black_markers := black_markers - flipped.count
					else
						black_markers := black_markers + 1 + flipped.count
						white_markers:= white_markers - flipped.count
					end
					markers.item (x).put (new_marker, y)
					gui_manager.repaint (x, y)
					sd_turn_made.call ([], turn_state)
					turn_state := sd_turn_made.next_state
					update_status

					-- Checking if player could make next move.
					sd_check_turn.call ([], turn_state)
					turn_state := sd_check_turn.next_state
					update_status
				end
			end
		end

	can_move: BOOLEAN is
			-- Can player make a move
		do
			Result := not valid_moves (sd_is_white_turn.item ([], turn_state)).is_empty
		end

	can_opp_move: BOOLEAN is
			-- Can opponent make a move
		do
			Result := not valid_moves (not sd_is_white_turn.item ([], turn_state)).is_empty
		end

	cant_move_but_opp_can: BOOLEAN is
		do
			Result := not can_move and can_opp_move
		end

	is_game_over: BOOLEAN is
		do
			Result := not can_move and not can_opp_move
		end


	valid_moves (is_white: BOOLEAN): LIST [POSITION] is
			-- Returns valid moves in current game situation
		local
			i, j :INTEGER
			flipped: LIST [MARKER]
			new_marker: MARKER
		do
			Result := create {LINKED_LIST [POSITION]}.make
			from
				i := 0
			until
				i = dimension
			loop
				from
					j := 0
				until
					j = dimension
				loop
					if (markers.item (i).item (j) = Void) then
						create new_marker.make (i, j, is_white)
						flipped := flipped_markers (new_marker, i, j)
						if (not flipped.is_empty) then
							Result.extend (create {POSITION}.make (i, j))
						end
					end
					j := j + 1
				end
				i := i + 1
			end
		end


	flipped_markers (new_marker: MARKER; x, y: INTEGER): LIST [MARKER] is
			-- Returns markers which would be flipped if new marker is put at (x, y)
		local
			dx, dy: ARRAY [INTEGER] -- delta x and delta y
			i, j, k: INTEGER
		do
			Result := create {LINKED_LIST [MARKER]}.make
			dx := << -1, -1, -1, 0, 0, 1, 1, 1 >>
			dy := << -1, 0, 1, -1, 1, -1, 0, 1 >>
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
						Result.extend (markers.item (x + dx.item (i) * k).item (y + dy.item (i) * k))
						k := k + 1
					end
				end
				i := i + 1
			end
		end

	is_valid_position (x, y: INTEGER): BOOLEAN is
		do
			Result := (x >= 0) and (x < dimension) and (y >= 0) and (y < dimension)
		end

feature -- Initialization
	default_create is
		do
			turn_state := Black_turn
			initialize_markers
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
			white_markers := 2
			black_markers := 2
		end

	update_status is
			-- Update status in status bar
		local
			msg: STRING
		do
			create msg.make_empty
			msg.append (turn_state.name)
			msg.append (". Score: ")
			msg.append (black_markers.out)
			msg.append (":")
			msg.append (white_markers.out)
			gui_manager.set_status (msg)
		end

feature {NONE} -- State dependent implementation

	White_turn: STATE is once create Result.make ("White turn") end
	Black_turn: STATE is once create Result.make ("Black turn") end
	White_cant_move: STATE is once create Result.make ("White cant move") end
	Black_cant_move: STATE is once create Result.make ("Black cant move") end
	Game_over: STATE is once create Result.make ("Game over") end

	sd_is_white_turn: STATE_DEPENDENT_FUNCTION [TUPLE, BOOLEAN] is
			-- Returns color of marker, according to its state
		once
			create Result.make(3)
			Result.add_result (White_turn, agent true_agent, true)
			Result.add_result (Black_turn, agent true_agent, false)
			Result.add_result (Game_over, agent true_agent, false)
		end

	sd_restart: STATE_DEPENDENT_PROCEDURE [TUPLE] is
		once
			create Result.make (3)
			Result.add_behavior (White_turn, agent true_agent, agent do initialize_markers update_status end, Black_turn)
			Result.add_behavior (Black_turn, agent true_agent, agent do initialize_markers end, Black_turn)
			Result.add_behavior (Game_over, agent true_agent, agent do initialize_markers update_status end, Black_turn)
		end

	sd_check_turn: STATE_DEPENDENT_PROCEDURE [TUPLE] is
			-- If white or black can make move then nothing happens. But if current color can't make move then color is changing.
		once
			create Result.make (4)
			Result.add_behavior (White_turn, agent can_move, agent do_nothing, White_turn)
			Result.add_behavior (Black_turn, agent can_move, agent do_nothing, Black_turn)
			Result.add_behavior (White_turn, agent cant_move_but_opp_can, agent do_nothing, Black_turn)
			Result.add_behavior (Black_turn, agent cant_move_but_opp_can, agent do_nothing, White_turn)
			Result.add_behavior (White_turn, agent is_game_over, agent gui_manager.show_game_over_dialog, Game_over)
			Result.add_behavior (Black_turn, agent is_game_over, agent gui_manager.show_game_over_dialog, Game_over)
		end

	sd_turn_made: STATE_DEPENDENT_PROCEDURE [TUPLE] is
			-- After current player has made his move turn_state is updated
		once
			create Result.make (2)
			Result.add_behavior (White_turn, agent true_agent, agent do_nothing, Black_turn)
			Result.add_behavior (Black_turn, agent true_agent, agent do_nothing, White_turn)
		end

end

indexing
	description	: "Main window for this application"
	author		: "Dmitry Kochelaev"
	date		: "$Date$"
	revision	: "$Revision$"

class
	MAIN_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			initialize,
			is_in_default_state
		end

	INTERFACE_NAMES
		export
			{NONE} all
		undefine
			default_create, copy
		end

create
	default_create

feature {NONE} -- Initialization

	initialize is
			-- Build the interface for this window.
		do
			Precursor {EV_TITLED_WINDOW}

			build_main_container
			extend (main_container)

				-- Execute `request_close_window' when the user clicks
				-- on the cross in the title bar.
			close_request_actions.extend (agent request_close_window)

				-- Set the title of the window
			set_title (Window_title)

				-- Set the initial size of the window
			set_size (Window_width, Window_height)
		end

	is_in_default_state: BOOLEAN is
			-- Is the window in its default state
			-- (as stated in `initialize')
		do
			Result := (width = Window_width) and then
				(height = Window_height) and then
				(title.is_equal (Window_title))
		end

feature {NONE} -- Game over checks

	check_horizontal: INTEGER is
			-- Check if there is winning combination on horizontal line
		require
			game_field /= Void
		local
			i: INTEGER
			j: INTEGER
			value: INTEGER
			did_not_win: BOOLEAN
		do
			result := game_field.Empty_id

			from
				i := 0
			until
				i = 3
			loop
				value := game_field.get (i, 0)
				did_not_win := false
				from
					j := 1
				until
					j = 3
				loop
					if value /= game_field.get (i, j) or value = game_field.Empty_id then
						did_not_win := true
						j := 2
					end
					j := j + 1
				end

				if did_not_win = false then
					result := value
					i := 2
				end
				i := i + 1
			end
		end

	check_vertical: INTEGER is
			-- Check if there is winning combination on vertical line
		require
			game_field /= Void
		local
			i: INTEGER
			j: INTEGER
			value: INTEGER
			did_not_win: BOOLEAN
		do
			result := game_field.Empty_id

			from
				i := 0
			until
				i = 3
			loop
				value := game_field.get (0, i)
				did_not_win := false
				from
					j := 1
				until
					j = 3
				loop
					if value /= game_field.get (j, i) or value = game_field.Empty_id then
						did_not_win := true
						j := 2
					end
					j := j + 1
				end
				if did_not_win = false then
					result := value
					i := 2
				end
				i := i + 1
			end
		end

	check_diagonals: INTEGER is
			-- Check if there is winning combination on diagonals line
		require
			game_field /= Void
		local
			i: INTEGER
			value: INTEGER
			did_not_win: BOOLEAN
		do
			result := game_field.Empty_id

			value := game_field.get (0, 0)
			did_not_win := false
			from
				i := 1
			until
				i = 3
			loop
				if value /= game_field.get (i, i) or value = game_field.Empty_id then
					did_not_win := true
					i := 2
				end
				i := i + 1
			end
			if did_not_win = false then
				result := value
			end
			value := game_field.get (0, 2)
			did_not_win := false
			from
				i := 1
			until
				i = 3
			loop
				if value /= game_field.get (i, 2 - i) or value = game_field.Empty_id then
					did_not_win := true
					i := 2
				end
				i := i + 1
			end
			if did_not_win = false then
				result := value
			end
		end

	check_draw: INTEGER is
			-- Check if there is winning combination on diagonals line
		require
			game_field /= Void
		local
			i: INTEGER
			j: INTEGER
			did_not_win: BOOLEAN
		do
			result := game_field.Empty_id

			did_not_win := false
			from
				i := 0
			until
				i = 3
			loop
				from
					j := 1
				until
					j = 3
				loop
					if game_field.get (j, i) = game_field.Empty_id then
						did_not_win := true
						j := 2
					end
					j := j + 1
				end
				if did_not_win = true then
					i := 2
				end
				i := i + 1
			end
			if did_not_win = false then
				result := -2 --draw
			end
		end

	is_game_over is
			-- Checks if game is over and shows request to start a new one
		require
			game_field /= Void
		local
			won: INTEGER
		do

			won := game_field.Empty_id
			-- check horizontal
			if won = game_field.Empty_id  then
				won := check_horizontal
			end
			-- check vertical
			if won = game_field.Empty_id  then
				won := check_vertical
			end
			-- check diagonals
			if won = game_field.Empty_id  then
				won := check_diagonals
			end
			-- check draw
			if won = game_field.Empty_id  then
				won := check_draw
			end
			-- check if somebody won
			if won /= game_field.Empty_id then
				request_new_game
			end
		end

	request_new_game is
			-- The user ended the game
		local
			question_dialog: EV_CONFIRMATION_DIALOG
			i: INTEGER
			j: INTEGER
		do
			create question_dialog.make_with_text (Label_confirm_new_game)
			question_dialog.show_modal_to_window (Current)

			if question_dialog.selected_button.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_ok) then
				from
					i := 0
				until
					i = 3
				loop
					from
						j := 0
					until
						j = 3
					loop
						buttons.item (i).item (j).set_text ("");
						j := j + 1
					end
					i := i + 1
				end

				create game_field.make
			else
				destroy;
				(create {EV_ENVIRONMENT}).application.destroy
			end
		end



feature {NONE} -- Implementation, Close event

	request_close_window is
			-- The user wants to close the window
		local
			question_dialog: EV_CONFIRMATION_DIALOG
		do
			create question_dialog.make_with_text (Label_confirm_close_window)
			question_dialog.show_modal_to_window (Current)

			if question_dialog.selected_button.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_ok) then
					-- Destroy the window
				destroy;

				(create {EV_ENVIRONMENT}).application.destroy
			end
		end

feature {NONE} -- Implementation

	main_container: EV_HORIZONTAL_BOX
			-- Main container (contains all widgets displayed in this window)

	vertical_boxes: ARRAY[EV_VERTICAL_BOX]

	buttons: ARRAY[ARRAY[EV_BUTTON]]

	game_field: GAME_FIELD

	current_turn: INTEGER



	on_button_click(i: INTEGER; j: INTEGER) is
			-- Process i j button click
		require
			i >= 0 and i <= 2 and j >= 0 and j <= 2 and
			game_field /= Void
		do
			if game_field.get(i, j) = game_field.Empty_id then
				if current_turn = game_field.Cross_id then
					buttons.item (i).item (j).set_text ("X")
					game_field.set(i, j, game_field.Cross_id)
					current_turn := game_field.Circle_id
				else
					buttons.item (i).item (j).set_text ("0")
					game_field.set(i, j, game_field.Circle_id)
					current_turn := game_field.Cross_id
				end
				is_game_over
			end

		end

	build_main_container is
			-- Create and populate `main_container'.
		require
			main_container_not_yet_created: main_container = Void
	    local
	    	i: INTEGER
	    	j: INTEGER
	    	buttons_column: ARRAY[EV_BUTTON]
	    	button: EV_BUTTON
		do
			current_turn := -1

			create main_container

			create vertical_boxes.make (0, 2)
			create buttons.make (0, 2)

			from
				i := 0
			until
				i = 3
			loop
				create buttons_column.make (0, 2)
				buttons.item (i) := buttons_column

				vertical_boxes.put (create {EV_VERTICAL_BOX}, i)
				main_container.extend (vertical_boxes.item (i))
				from
					j := 0
				until
					j = 3
				loop
					create button
					buttons.item (i).item (j) := button
					button.select_actions.extend (agent on_button_click (i, j))
					vertical_boxes.item (i).extend (buttons.item (i).item (j))
					j := j + 1
				end
				i := i + 1
			end

			create game_field.make
		ensure
			main_container_created: main_container /= Void
		end

feature {NONE} -- Implementation / Constants

	Window_title: STRING is "Tic Tac Toe sample. Implemented in traditional way."
			-- Title of the window.

	Window_width: INTEGER is 400
			-- Initial width for this window.

	Window_height: INTEGER is 400
			-- Initial height for this window.

end -- class MAIN_WINDOW

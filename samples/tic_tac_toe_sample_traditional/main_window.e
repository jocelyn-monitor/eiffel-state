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

					-- End the application
					--| TODO: Remove this line if you don't want the application
					--|       to end when the first window is closed..
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

	is_game_over is
			-- Checks if game is over and shows request to start a new one
		require
			game_field /= Void
		local
			question_dialog: EV_CONFIRMATION_DIALOG
			i: INTEGER
			j: INTEGER
			value: INTEGER
			did_not_win: BOOLEAN
			won: INTEGER
		do
			won := game_field.Empty_id
			-- check horizontal
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
					won := value
					i := 2
				end
				i := i + 1
			end
			-- check vertical
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
					won := value
					i := 2
				end
				i := i + 1
			end
			-- check diagonals
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
				won := value
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
				won := value
			end
			-- check draw
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
				won := -2 --draw
			end
			-- check if somebody won
			if won /= game_field.Empty_id then
				create question_dialog.make_with_text ("Game is over. Play again?")
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
		end

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


	on_0_0_button_click is
			-- Process 0 0 button click		
		do
			on_button_click (0, 0)
		end

	on_0_1_button_click is
			-- Process 0 1 button click
		do
			on_button_click (0, 1)
		end

	on_0_2_button_click is
			-- Process 0 2 button click
		do
			on_button_click (0, 2)
		end

	on_1_0_button_click is
			-- Process 1 0 button click
		do
			on_button_click (1, 0)
		end

	on_1_1_button_click is
			-- Process 1 1 button click
		do
			on_button_click (1, 1)
		end

	on_1_2_button_click is
			-- Process 1 2 button click
		do
			on_button_click (1, 2)
		end

	on_2_0_button_click is
			-- Process 2 0 button click
		do
			on_button_click (2, 0)
		end

	on_2_1_button_click is
			-- Process 2 1 button click
		do
			on_button_click (2, 1)
		end

	on_2_2_button_click is
			-- Process 2 2 button click
		do
			on_button_click (2, 2)
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
				from
					j := 0
				until
					j = 3
				loop
					create button
					buttons.item (i).item (j) := button
					j := j + 1
				end
				i := i + 1
			end

			from
				i := 0
			until
				i = 3
			loop
				vertical_boxes.put (create {EV_VERTICAL_BOX}, i)
				main_container.extend (vertical_boxes.item (i))
				from
					j := 0
				until
					j = 3
				loop
					vertical_boxes.item (i).extend (buttons.item (i).item (j))
					j := j + 1
				end
				i := i + 1;
		    end

			buttons.item (0).item (0).select_actions.extend (agent on_0_0_button_click)
			buttons.item (0).item (1).select_actions.extend (agent on_0_1_button_click)
			buttons.item (0).item (2).select_actions.extend (agent on_0_2_button_click)
			buttons.item (1).item (0).select_actions.extend (agent on_1_0_button_click)
			buttons.item (1).item (1).select_actions.extend (agent on_1_1_button_click)
			buttons.item (1).item (2).select_actions.extend (agent on_1_2_button_click)
			buttons.item (2).item (0).select_actions.extend (agent on_2_0_button_click)
			buttons.item (2).item (1).select_actions.extend (agent on_2_1_button_click)
			buttons.item (2).item (2).select_actions.extend (agent on_2_2_button_click)
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

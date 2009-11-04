indexing
	description: "GUI manager."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GUI_MANAGER
inherit
	AUTOMATED
		redefine
			default_create
		end
	ENVIRONMENT
		undefine
			default_create
		end

create
	default_create

feature -- Access
	background: EV_COLOR is
		do
			create Result.make_with_rgb (0.2, 0.8, 0.2)
		end

	lighter_background: EV_COLOR is
			-- Color which is slightly lighter then background
		do
			create Result.make_with_rgb (0.25, 1, 0.25)
		end

	darker_background: EV_COLOR is
			-- Color which is slightly darker then background
		do
			create Result.make_with_rgb (0.15, 0.6, 0.15)
		end

	cell_size: INTEGER is
		do
			Result := field_size // game_manager.dimension
		end

	drawable_widget: EV_DRAWING_AREA

feature -- Status setting
	set_status (text: STRING_GENERAL)
		do
			first_window.set_status_bar_text (text)
		end

	show_message (msg: STRING) is
		local
			dialog: EV_INFORMATION_DIALOG
		do
			create dialog.make_with_text (msg)
			dialog.show_modal_to_window (first_window)
		end

	show_first_window is
		do
			first_window.show
		end

	draw (arg1, arg2, arg3, arg4: INTEGER) is
			-- Draw field and all markers on it
		local
			i, j: INTEGER
		do
			drawable_widget.set_foreground_color (background)
			drawable_widget.fill_rectangle (0, 0, field_size, field_size)
			drawable_widget.set_foreground_color (create {EV_COLOR}.make_with_rgb (0, 0, 0))
			from
				i := 0
			until
				i = game_manager.dimension + 1
			loop
				drawable_widget.draw_segment (i * field_size // game_manager.dimension, 0, i * field_size // game_manager.dimension, field_size)
				drawable_widget.draw_segment (0, i * field_size // game_manager.dimension, field_size, i * field_size // game_manager.dimension)
				i := i + 1
			end
			from
				i := 0
			until
				i = game_manager.markers.count
			loop
				from
					j := 0
				until
					j = game_manager.markers.item (i).count
				loop
					game_manager.markers.item (i).item (j).draw (drawable_widget, field_size // game_manager.dimension)
					j := j + 1
				end
				i := i + 1
			end
		end

feature {NONE} -- Initialization
	default_create is
			-- Prepare the first window to be displayed.
		do
			create drawable_widget

			drawable_widget.pointer_button_press_actions.extend (agent widget_button_press)

			drawable_widget.expose_actions.extend (agent draw)

				-- create and initialize the first window.
			create first_window.make (field_size + 11, field_size + 72, drawable_widget)

				-- Show the first window.
			first_window.show
		end

feature {NONE} -- Implementation
	first_window: MAIN_WINDOW
			-- Main window.

	widget_button_press (x, y, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; screen_x, screen_y: INTEGER) is
			-- A pointer button press event has occurred on the test widget
		do
			game_manager.make_move (x // (field_size // game_manager.dimension), y // (field_size // game_manager.dimension))
		end

	field_size: INTEGER is 400

end

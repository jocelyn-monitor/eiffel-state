note
	description: "GUI manager react to user's actions."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GUI_MANAGER

inherit
	AUTOMATED
		rename
			state as user_state
		redefine
			default_create
		select
			default_create
		end
	ENVIRONMENT

create
	default_create

feature -- Access
	drawable_widget: EV_DRAWING_AREA

	show_window is
			-- Shows main window on the screen and draws map and units on it
		do
			main_window.show
			draw
		end

feature {NONE} -- Initialization
	default_create is
			-- Initialize `main_window'
		local
			map_index: INTEGER
		do
			create drawable_widget
			drawable_widget.pointer_button_press_actions.extend (agent widget_button_press)
			drawable_widget.pointer_motion_actions.extend (agent widget_motion)
			drawable_widget.pointer_button_release_actions.extend (agent widget_button_release)
			drawable_widget.expose_actions.extend (agent draw_again)
			is_selecting_mode := False

			map_index := (create {TIME}.make_now).compact_time \\ map_manager.maps_number + 1
			io.put_string ("Map with number " + map_index.out + " was selected%N")
			map_manager.set_game_map (map_index)

			create main_window.make (
				map_manager.width * map_manager.Cell_size + horizontal_border_thickness,
				map_manager.height * map_manager.Cell_size + vertical_border_thickness,
				drawable_widget
			)

			user_state := Watching
		end

feature {NONE} -- Implementation

	draw is
			-- Draws map and units on it
		do
			map_manager.draw_map
			draw_units
		end

	draw_again (arg1, arg2, arg3, arg4: INTEGER) is
			-- Calls `draw' function
		do
			draw
		end

--	draw_rect_part (x, y: INTEGER_INTERVAL) is
--			-- Draws rectangle part of map,
--			-- bounded by given intervals
--		do
--			map_manager.draw_map_rect_part (drawable_widget, x, y)
--		end


	draw_units is
			-- Draws all units using `drawable_widget'
			-- Implemented by iteration over units list `LINKED_LIST [UNITS]'
		do
			from
				unit_manager.units.start
			until
				unit_manager.units.after
			loop
				unit_manager.units.item.draw
				unit_manager.units.forth
			end
		end

	draw_selected is
			-- Draws selecting rectangle and units under it
		local
			x, y: INTEGER_INTERVAL
			press, cur: POSITION
				-- Absolute mouse press and current positions
		do
			press := map_manager.position_at (mouse_press_x, mouse_press_y)
			cur := map_manager.position_at (mouse_x, mouse_y)
			create x.make (press.x.min (cur.x), press.x.max (cur.x))
			create y.make (press.y.min (cur.y), press.y.max (cur.y))

			if (not is_just_pressed) then
				drawable_widget.draw_rectangle (
					mouse_press_x.min (prev_mouse_x),
					mouse_press_y.min (prev_mouse_y),
					(mouse_press_x - prev_mouse_x).abs,
					(mouse_press_y - prev_mouse_y).abs
				)
				drawable_widget.set_copy_mode
			else
				is_just_pressed := False
			end

			if (is_selecting_mode) then
				selected_units := unit_manager.select_units (x, y)

				drawable_widget.set_foreground_color (create {EV_COLOR}.make_with_rgb (1, 1, 1))
				drawable_widget.set_xor_mode
				drawable_widget.draw_rectangle (
					mouse_press_x.min (mouse_x),
					mouse_press_y.min (mouse_y),
					(mouse_press_x - mouse_x).abs,
					(mouse_press_y - mouse_y).abs
				)
			end
		end

	main_window: MAIN_WINDOW

	horizontal_border_thickness: INTEGER is 11
	vertical_border_thickness: INTEGER is 33
			-- Borders' thickness which are used in setting window dimension
			-- TODO: delete this code and try to set native width and height

	widget_button_press (x, y, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; screen_x, screen_y: INTEGER) is
			-- A pointer button press event has occurred on the test widget
		do
			is_selecting_mode := True
			mouse_press_x := x
			mouse_x := x
			mouse_press_y := y
			mouse_y := y
			is_just_pressed := True
			draw_selected
		end

	widget_motion (x, y: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; screen_x, screen_y: INTEGER) is
			-- A pointer button press event has occurred on the test widget
		do
			if (is_selecting_mode) then
				prev_mouse_x := mouse_x
				mouse_x := x
				prev_mouse_y := mouse_y
				mouse_y := y
				draw_selected
			end
		end

	widget_button_release (x, y, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; screen_x, screen_y: INTEGER) is
			-- A pointer button release event has occurred on the test widget
		do
			if (is_selecting_mode) then
				is_selecting_mode := False
				prev_mouse_x := mouse_x
				mouse_x := x
				prev_mouse_y := mouse_y
				mouse_y := y
				draw_selected
			end
		end

	mouse_press_x: INTEGER
	mouse_press_y: INTEGER
	mouse_x: INTEGER
	mouse_y: INTEGER
	prev_mouse_x: INTEGER
	prev_mouse_y: INTEGER
	is_just_pressed: BOOLEAN
	is_selecting_mode: BOOLEAN

	selected_units: LIST [UNIT]

feature {NONE} -- Implementation: States
	Watching: STATE is once create Result.make ("Watching") end
	Started_selecting_units: STATE is once create Result.make ("Started_selecting_units") end
	Selecting_units: STATE is once create Result.make ("Selecting_units") end
	Finished_selecting_units: STATE is once create Result.make ("Finished_selecting_units") end
	Choosing_action : STATE is once create Result.make ("Choosing action") end

invariant
	main_window /= Void
end

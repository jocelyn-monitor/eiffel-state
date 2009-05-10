note
	description: "Summary description for {GUI_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GUI_MANAGER

inherit
	ANY
		redefine
			default_create
		end

create
	default_create

feature -- Access
	draw is
			-- Draws map and units on it
		do
			map_manager.draw_map (drawable_widget)
			draw_units (unit_manager.units)
		end

	draw_rect_part (x, y: INTEGER_INTERVAL) is
			-- Draws rectangle part of map,
			-- bounded by given intervals
		do
			map_manager.draw_map_rect_part (drawable_widget, x, y)
		end


	draw_units (units_list: LINKED_LIST [UNIT]) is
			-- Draws all units using `drawable_widget'
			-- Implemented by iteration over units list `LINKED_LIST [UNITS]'
		local
			unit: UNIT
			unit_coordinates: ARRAY [INTEGER]
				-- Absolute coordinates got from `map_manager'
		do
			from
				units_list.start
			until
				units_list.after
			loop
				unit := units_list.item
				unit_coordinates := map_manager.cell_center_coordinates (unit.position)
				unit.draw (unit_coordinates @ 1, unit_coordinates @ 2, map_manager.cell_size, drawable_widget)
				units_list.forth
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

--			io.put_string ("[" + x.lower.out + ".." + x.upper.out + "]x[" + y.lower.out + ".." + y.upper.out + "]%N")

			selected_units := unit_manager.select_units (x, y)
			draw

			if (is_selecting_mode) then
				drawable_widget.set_foreground_color (create {EV_COLOR}.make_with_rgb (1, 0, 0))
				drawable_widget.draw_rectangle (
					mouse_press_x.min (mouse_x),
					mouse_press_y.min (mouse_y),
					(mouse_press_x - mouse_x).abs,
					(mouse_press_y - mouse_y).abs
				)
			end
		end


feature {NONE} -- Initialization
	default_create is
			-- Initialize `main_window' and shows it on the screen
		local
			map_index: INTEGER
		do
			create map_manager
			map_index := (create {TIME}.make_now).compact_time \\ map_manager.maps_number + 1
			io.put_string ("Map with number " + map_index.out + " was selected%N")
			map_manager.set_game_map (map_index)

			create unit_manager.make (map_manager)

			create drawable_widget
			drawable_widget.pointer_button_press_actions.extend (agent widget_button_press)
			drawable_widget.pointer_motion_actions.extend (agent widget_motion)
			drawable_widget.pointer_button_release_actions.extend (agent widget_button_release)
			is_selecting_mode := False

			create main_window.make (
				map_manager.width * map_manager.Cell_size + horizontal_border_thickness,
				map_manager.height * map_manager.Cell_size + vertical_border_thickness,
				drawable_widget,
				agent draw
			)
			main_window.show

			draw
		end


feature {NONE} -- Implementation

	main_window: MAIN_WINDOW

	horizontal_border_thickness: INTEGER is 11
	vertical_border_thickness: INTEGER is 33
			-- Borders' thickness which are used in setting window dimension
			-- TODO: delete this code and try to set native width and height

	drawable_widget: EV_DRAWING_AREA

	map_manager: MAP_MANAGER

	unit_manager: UNIT_MANAGER

	widget_button_press (x, y, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; screen_x, screen_y: INTEGER) is
			-- A pointer button press event has occurred on the test widget
		do
			if (button = 1) then
				is_selecting_mode := True
				mouse_press_x := x;
				mouse_press_y := y;
			end
		end

	widget_motion (x, y: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; screen_x, screen_y: INTEGER) is
			-- A pointer button press event has occurred on the test widget
		do
			if (is_selecting_mode) then
				mouse_x := x
				mouse_y := y
				draw_selected
			end
		end

	widget_button_release (x, y, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; screen_x, screen_y: INTEGER) is
			-- A pointer button release event has occurred on the test widget
		do
			if (button = 1 and is_selecting_mode) then
				is_selecting_mode := False
				draw_selected
			end
		end

	mouse_press_x: INTEGER
	mouse_press_y: INTEGER
	mouse_x: INTEGER
	mouse_y: INTEGER
	is_selecting_mode: BOOLEAN

	selected_units: LINKED_LIST [UNIT]
invariant
	unit_manager /= Void
	map_manager /= Void
	main_window /= Void
end

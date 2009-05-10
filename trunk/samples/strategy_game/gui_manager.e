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
		do
			map_manager.draw_map (drawable_widget)
			draw_units
		end

	draw_units is
			-- Draws all units using `drawable_widget'
		local
			cur_unit: UNIT
			unit_c: ARRAY [INTEGER]
		do
			from
				unit_manager.units.start
			until
				unit_manager.units.after
			loop
				cur_unit := unit_manager.units.item
				unit_c := map_manager.cell_center_coordinates (cur_unit.position)
				cur_unit.draw (unit_c @ 1, unit_c @ 2, map_manager.cell_size, drawable_widget)
				unit_manager.units.forth
			end
		end


feature {NONE} -- Initialization
	default_create is
			-- Initialize `main_window' and shows it on the screen
		do
			create map_manager
			create unit_manager.make (map_manager)
			create drawable_widget
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

	drawable_widget: EV_DRAWING_AREA

	map_manager: MAP_MANAGER

	unit_manager: UNIT_MANAGER

end

indexing
	description: "Summary description for {MARKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MARKER
inherit
	ENVIRONMENT
create
	make

feature -- Status
	is_same_color (marker: MARKER): BOOLEAN is
		require
			marker_not_null: marker /= Void
		do
			Result := color_state.name = marker.color_state.name
		end

feature {GAME_MANAGER} -- Change status
	change_color is
			-- Change color of marker if it was flipped
		do
			sd_change_color.call ([], color_state)
			color_state := sd_change_color.next_state
			gui_manager.repaint (x, y)
		end


feature -- Initialization
	make (xc, yc: INTEGER; is_white: BOOLEAN) is
			-- Create marker given its coordinates
		do
			x := xc
			y := yc
			if (is_white) then
				color_state := White
			else
				color_state := Black
			end
		end

feature -- Output
	draw (widget: EV_DRAWABLE; cell_size: INTEGER) is
			-- Draw marker on the board
		do
			widget.set_foreground_color (sd_color.item([], color_state))
			widget.fill_ellipse (x * cell_size + 3, y * cell_size + 3, cell_size - 5, cell_size - 5)
		end

feature {MARKER} -- State dependent features
	color_state: STATE

	White: STATE is once create Result.make ("White") end
	Black: STATE is once create Result.make ("Black") end

	sd_color: STATE_DEPENDENT_FUNCTION [TUPLE, EV_COLOR] is
			-- Returns color of marker, according to its state
		once
			create Result.make (2)
			Result.add_result (White, agent true_agent, create {EV_COLOR}.make_with_rgb (1, 1, 1))
			Result.add_result (Black, agent true_agent, create {EV_COLOR}.make_with_rgb (0, 0, 0))
		end

	sd_change_color: STATE_DEPENDENT_PROCEDURE [TUPLE] is
		once
			create Result.make (2)
			Result.add_behavior (White, agent true_agent, agent do_nothing, Black)
			Result.add_behavior (Black, agent true_agent, agent do_nothing, White)
		end

feature {NONE} -- Implementation
	x, y: INTEGER -- Coordinates of marker

end

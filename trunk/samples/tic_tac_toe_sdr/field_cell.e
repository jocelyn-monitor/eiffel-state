indexing
	description: "Summary description for {FIELD_CELL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FIELD_CELL

inherit
	AUTOMATED
		redefine
			default_create,
			out
		end

feature {NONE} -- Initialization
	default_create is
			-- Create an empty cell
		do
			state := Empty
		ensure then
			is_empty: is_empty
		end

feature -- State dependent: Element change
	put_cross is
			-- Put cross into the cell
		do
			call (sd_put_cross, [])
		end

	put_circle is
			-- Put circle into the cell
		do
			call (sd_put_circle, [])
		end

feature -- State dependent: Indicators
	is_empty: BOOLEAN is
			-- Is the cell empty?
		do
			Result := is_in (<<Empty>>)
		end

	is_cross: BOOLEAN is
			-- Is the cell cross?
		do
			Result := is_in (<<Cross>>)
		end

	is_circle: BOOLEAN is
			-- Is the cell circle?
		do
			Result := is_in (<<Circle>>)
		end

feature -- State dependent: Output
	out: STRING is
			-- String representation of the cell
		do
			Result := sd_out.item ([], state)
		end

feature {NONE} -- Automaton
	Empty: STATE is once create Result.make ("Empty") end

	Cross: STATE is once create Result.make ("Cross") end

	Circle: STATE is once create Result.make ("Circle") end

	sd_put_cross: STATE_DEPENDENT_PROCEDURE is
			-- State dependent procedure for `put_cross'
		once
			create Result.make (1)
			Result.add_behavior (Empty,
				agent otherwise,
				agent do_nothing,
				Cross)
		end

	sd_put_circle: STATE_DEPENDENT_PROCEDURE is
			-- State dependent procedure for `put_circle'
		once
			create Result.make (1)
			Result.add_behavior (Empty,
				agent otherwise,
				agent do_nothing,
				Circle)
		end

	sd_out: STATE_DEPENDENT_FUNCTION [STRING] is
			-- State dependent function for `out'
		once
			create Result.make (3)
			Result.add_result (Empty, agent otherwise, "")
			Result.add_result (Cross, agent otherwise, "X")
			Result.add_result (Circle, agent otherwise, "O")
		end

end

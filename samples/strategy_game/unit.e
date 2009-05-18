note
	description: "Units that can be created by the players."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	UNIT

inherit
	AUTOMATED
		rename
			state as health_state
		redefine
			out
		end

feature -- Initialization
	make (p: POSITION; team: STRING) is
			-- Create nonselected unit at position `p',
			-- set his `team_name' to `team' and health to maximum
		require
			p_exists: p /= Void
		do
			team_name := team
			create team_state.make(team)
			health_state := Alive
			selection_state := Nonselected
			position := p
		ensure
			position_set: position = p
			team_state_set: team_state /= Void
		end

feature -- Access
	creation_time: DOUBLE is
			-- Time required to create current unit
		deferred
		end

	team_name: STRING

	position: POSITION
			-- Current position of the unit in the game world

	type: STRING is
			-- Type of the unit
		deferred
		end

	true_agent: BOOLEAN is
			-- Function which returns true always
		do
			Result := True
		end

	actions: LIST [ACTION [TUPLE]]
			-- Returns actions, which current unit can carry out.
			-- TODO: make this STATE_DEPENDENT
		deferred
		ensure
			Result /= Void
		end

feature -- Output
	draw (x, y, size: INTEGER; drawable: EV_DRAWABLE) is
			-- Draw unit with (x, y) as its center position using `drawable'
		require
			drawable_set: drawable /= Void
			positive_size: size > 0
		do
			sd_draw.call ([x, y, size, drawable], selection_state)
		end

	draw_nonselected (x, y, size: INTEGER; drawable: EV_DRAWABLE) is
			-- Draw unit when it isn't selected
		do
			drawable.set_foreground_color (create {EV_COLOR}.make_with_rgb (0, 0, 0))
			common_draw (x, y, size, drawable)
		ensure
			color_set: drawable.foreground_color /= Void
		end

	draw_selected (x, y, size: INTEGER; drawable: EV_DRAWABLE) is
			-- Draw unit when it is selected
		do
			drawable.set_foreground_color (create {EV_COLOR}.make_with_rgb (1, 0, 0))
			common_draw (x, y, size, drawable)
		ensure
			color_set: drawable.foreground_color /= Void
		end

	out: STRING is
			-- String representation
		do
			Result := type + "[" + team_name + "]"
		end

feature -- Status report
	is_healthy: BOOLEAN is
			-- Does the unit have maximum amount of hit points?
		do
			Result := health_state = Alive
		end

feature -- Basic operations
	reduce_health is
			-- Reduce health when unit is under attack
		do
			sd_reduce_health.call([], health_state)
			health_state := sd_reduce_health.next_state
		ensure
			health_state /= Void
		end

	improve_health is
			-- Improve health when unit is healed
			-- and return time needed for this operation
		do
			sd_improve_health.call([], health_state)
			health_state := sd_improve_health.next_state
		ensure
			health_state /= Void
		end

	select_ is
			-- Change unit's `selected_state' when unit was selected
		do
			sd_select.call ([], selection_state)
			selection_state := sd_select.next_state
		end

	deselect is
			-- Change unit's `selected_state' when unit was deselected
		do
			sd_deselect.call ([], selection_state)
			selection_state := sd_deselect.next_state
		end

feature {NONE} -- Output
	common_draw (x, y, size: INTEGER; drawable: EV_DRAWABLE) is
			-- Draws text in the cell where unit is situated
		do
			drawable.set_font (
				create {EV_FONT}.make_with_values ({EV_FONT_CONSTANTS}.Family_roman,
												   {EV_FONT_CONSTANTS}.Weight_bold,
												   {EV_FONT_CONSTANTS}.Shape_regular,
												   8)
			)
			drawable.draw_text (x - size // 2, y + 2, type)
			drawable.draw_ellipse (x - size // 2, y - size // 2, size, size)
		ensure
			drawable.font /= Void
		end

feature {NONE} -- States
	Alive: STATE is once create Result.make ("Alive") end
	Injured: STATE is once create Result.make ("Injured") end
	Seriously_injured: STATE is once create Result.make ("Seriously injured") end
	Dead: STATE is once create Result.make ("Dead") end

	selection_state: STATE
			-- Is this unit selected in the game?
	Selected: STATE is once create Result.make ("Selected") end
	Nonselected: STATE is once create Result.make ("Nonselected") end

	team_state: STATE
			-- This unit belongs to `team_state'

feature {NONE} -- State dependent implementation

	sd_improve_health: STATE_DEPENDENT_PROCEDURE [TUPLE] is
			-- State dependent procedure which changes state when unit is being healed
		once
			create Result.make (3)

			Result.add_behavior (Alive, agent true_agent, agent do_nothing, Alive)
			Result.add_behavior (Injured, agent true_agent, agent do_nothing, Alive)
			Result.add_behavior (Seriously_injured, agent true_agent, agent do_nothing, Injured)
		end

	sd_reduce_health: STATE_DEPENDENT_PROCEDURE [TUPLE] is
			-- State dependent procedure which changes state when unit is under attack
		once
			create Result.make(3)
			Result.add_behavior (Alive, agent: BOOLEAN do Result := True end, agent do end, Injured)
			Result.add_behavior (Injured, agent: BOOLEAN do Result := True end, agent do end, Seriously_injured)
			Result.add_behavior (Seriously_injured, agent: BOOLEAN do Result := True end, agent do end, Dead)
		end

	sd_draw: STATE_DEPENDENT_PROCEDURE [TUPLE] is
			-- Draws unit according to his `selected_state'
		do
			create Result.make (2)
			Result.add_behavior (Selected, agent: BOOLEAN do Result := True end, agent draw_selected, Selected)
			Result.add_behavior (Nonselected, agent: BOOLEAN do Result := True end, agent draw_nonselected, Nonselected)
		end

	sd_select: STATE_DEPENDENT_PROCEDURE [TUPLE] is
		once
			create Result.make (1)
			Result.add_behavior (Nonselected, agent: BOOLEAN do Result := True end, agent do end, Selected)
		end

	sd_deselect: STATE_DEPENDENT_PROCEDURE [TUPLE] is
		once
			create Result.make (1)
			Result.add_behavior (Selected, agent: BOOLEAN do Result := True end, agent do end, Nonselected)
		end

	sd_ability_reduction: STATE_DEPENDENT_FUNCTION [TUPLE, DOUBLE] is
			-- State-dependent function which changes abilities of beings: movement speed, attack accuracy
		once
			create Result.make(4)
			Result.add_result (Alive, agent: BOOLEAN do Result := True end, 1.0)
			Result.add_result (Injured, agent: BOOLEAN do Result := True end, 0.7)
			Result.add_result (Seriously_injured, agent: BOOLEAN do Result := True end, 0.3)
			Result.add_result (Dead, agent: BOOLEAN do Result := True end, 0.0)
		end

invariant
	position_exists: position /= Void
	type_exists: type /= Void
	type_nonempty: not type.is_empty
	health_state_exists: health_state /= Void
	team_state_exists: team_state /= Void
	selected_state_exists: selection_state /= Void
end

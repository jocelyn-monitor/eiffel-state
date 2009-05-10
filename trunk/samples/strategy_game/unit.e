note
	description: "Units that can be created by the player."
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
			-- Create a unit at `p' with maximum hit points
		do
			team_name := team
			Create team_state.make(team)
			health_state := Alive
			selected_state := Nonselected
			position := p
		ensure
			position_set: position = p
		end

feature -- Access
	creation_time: DOUBLE is
		deferred
		end

	team_name: STRING

	position: POSITION
			-- Current position of the unit in the game world

	type: STRING is
			-- Type of the unit
		deferred
		end

feature -- Output
	draw (x, y, size: INTEGER; drawable: EV_DRAWABLE) is
			-- Draw unit with center position (x, y) using `drawable'
		do
			sd_draw.call ([x, y, size, drawable], selected_state)
		end

	draw_nonselected (x, y, size: INTEGER; drawable: EV_DRAWABLE) is
			-- Draw unit when it isn't selected
		do
			drawable.set_foreground_color (create {EV_COLOR}.make_with_rgb (0, 0, 0))
			common_draw (x, y, size, drawable)
		end

	draw_selected (x, y, size: INTEGER; drawable: EV_DRAWABLE) is
			-- Draw unit when it is selected
		do
			drawable.set_foreground_color (create {EV_COLOR}.make_with_rgb (1, 0, 0))
			common_draw (x, y, size, drawable)
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
	attack_this is
			-- Decrease health when unit is under attack
		do
			sd_attacked.call([], health_state)
			health_state := sd_attacked.next_state
		end

	heal_this: DOUBLE is
			-- Increase health when unit is healed
		do
			sd_healed.call([], health_state)
			health_state := sd_healed.next_state
			Result := creation_time / 4
		end

feature -- Change state
	change_selected_state is
		do
			sd_change_selected_state.call ([], selected_state)
		end

feature {NONE} -- Output
	common_draw (x, y, size: INTEGER; drawable: EV_DRAWABLE) is
		do
			drawable.set_font (
				create {EV_FONT}.make_with_values ({EV_FONT_CONSTANTS}.Family_roman,
												   {EV_FONT_CONSTANTS}.Weight_bold,
												   {EV_FONT_CONSTANTS}.Shape_regular,
												   8)
			)
			drawable.draw_text (x - size // 2, y + size // 2, type)
		end

feature {NONE} -- States

	team_state: STATE
			-- This unit belongs to `team_state'
	Alive: STATE is once create Result.make ("Alive") end
	Injured: STATE is once create Result.make ("Injured") end
	Seriously_injured: STATE is once create Result.make ("Seriously injured") end
	Dead: STATE is once create Result.make ("Dead") end

	selected_state: STATE
			-- Is this unit selected in the game?
	Selected: STATE is once create Result.make ("Selected") end
	Nonselected: STATE is once create Result.make ("Nonselected") end

feature {NONE} -- State dependent implementation

	sd_healed: STATE_DEPENDENT_PROCEDURE [TUPLE] is
			-- State dependent procedure which changes state when unit is being healed
		once
			create Result.make (3)
			Result.add_behavior (Alive, agent: BOOLEAN do Result := True end, agent do end, Alive)
			Result.add_behavior (Injured, agent: BOOLEAN do Result := True end, agent do end, Alive)
			Result.add_behavior (Seriously_injured, agent: BOOLEAN do Result := True end, agent do end, Injured)
		end

	sd_attacked: STATE_DEPENDENT_PROCEDURE [TUPLE] is
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

	sd_change_selected_state: STATE_DEPENDENT_PROCEDURE [TUPLE] is
		once
			create Result.make (2)
			Result.add_behavior (Selected, agent: BOOLEAN do Result := True end, agent do end, Nonselected)
			Result.add_behavior (Nonselected, agent: BOOLEAN do Result := True end, agent do end, Selected)
		end

	sd_ability_decrease: STATE_DEPENDENT_FUNCTION [TUPLE, DOUBLE] is
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
end

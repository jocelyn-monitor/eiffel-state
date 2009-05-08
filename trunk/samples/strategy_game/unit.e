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
	make (p: POSITION) is
			-- Create a unit at `p' with maximum hit points
		do
			health_state := Alive
			position := p
		ensure
			position_set: position = p
		end

feature -- Access
	position: POSITION
			-- Current position of the unit in the game world

	type: STRING is
			-- Type of the unit
		deferred
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

	heal_this is
			-- Increase health when unit is healed
		do
			sd_healed.call([], health_state)
			health_state := sd_healed.next_state
		end

feature -- Output
	out: STRING is
			-- String representation
		do
			Result := type + " " + position.out
		end

feature {NONE}
	Alive: STATE is once create Result.make ("Alive") end
	Injured: STATE is once create Result.make ("Injured") end
	Seriously_injured: STATE is once create Result.make ("Seriously injured") end
	Dead: STATE is once create Result.make ("Dead") end

	sd_healed: STATE_DEPENDENT_PROCEDURE [TUPLE] is
			-- State dependent procedure which changes state when unit is being healed
		once
			create Result.make(3)
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

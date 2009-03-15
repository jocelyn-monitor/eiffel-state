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
			state as hp_state
		redefine
			out
		end

feature -- Initialization
	make (p: POSITION) is
			-- Create a unit at `p' with maximum hit points
		do
			position := p
			hit_points := max_hit_points
			update_hp_state
		ensure
			position_set: position = p
			is_healthy: is_healthy
		end

feature -- Access
	position: POSITION
			-- Current position of the unit in the game world

	type: STRING is
			-- Type of the unit
		deferred
		end

	hit_points: INTEGER
			-- Current amount of hit points

	max_hit_points: INTEGER is
			-- Maximum amount of hit points
		deferred
		end

	creation_time: INTEGER is
			-- Time required for creating resource, building hall, training worker etc
		deferred
		end

feature -- Status report
	is_healthy: BOOLEAN is
			-- Does the unit have maximum amount of hit points?
		do
			Result := hp_state = Alive
		ensure
			Result = (hit_points = max_hit_points)
		end

feature -- Basic operations
	decrease_hit_points (value: INTEGER) is
			-- Decrease hit points by `value' when unit is under attack
		require
			value_non_negative: value >= 0
		do
			hit_points := hit_points - value
			if (hit_points < 0) then
				hit_points := 0
			end
			update_hp_state
		ensure
			non_increasing_hit_points : hit_points <= old hit_points
			subtracted_value_or_zero: hit_points = (old hit_points + value).max (0)
		end

	increase_hit_points (value: INTEGER) is
			-- Increase hit points when unit is healed
		require
			value_non_negative: value >= 0
		do
			hit_points := hit_points + value
			if (hit_points > max_hit_points) then
				hit_points := max_hit_points
			end
			update_hp_state
		ensure
			non_decreasing_hp : hit_points >= old hit_points
			added_value_or_max: hit_points = (old hit_points + value).min (max_hit_points)
		end

	update_hp_state is
			-- Change state according to hit points amount
		do
			if (hit_points = max_hit_points) then
				hp_state := Alive
			elseif (hit_points > max_hit_points / 2) then
				hp_state := Injured
			elseif (hit_points > 0) then
				hp_state := Seriously_injured
			else
				hp_state := Dead
			end
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

	sd_ability_decrease: STATE_DEPENDENT_FUNCTION [DOUBLE] is
			-- State-dependent function which changes abilities of beings: attack power, movement speed, repair rate etc
		once
			create Result.make(4)
			Result.add_result (Alive, agent otherwise, 1.0)
			Result.add_result (Injured, agent otherwise, 0.7)
			Result.add_result (Seriously_injured, agent otherwise, 0.3)
			Result.add_result (Dead, agent otherwise, 0.0)
		end

invariant
	hit_points_non_negative: hit_points >= 0
	hit_points_not_too_many: hit_points <= max_hit_points
	position_exists: position /= Void
	type_exists: type /= Void
	type_nonempty: not type.is_empty
end

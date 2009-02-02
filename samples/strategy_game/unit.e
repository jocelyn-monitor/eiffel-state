note
	description: "Units that can be created by the player."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	UNIT

inherit
	ANY
		redefine
			out
		end

feature -- Initialization
	make (p: POSITION) is
			-- Create a unit at `p' with maximum hit points
		do
			position := p
			hit_points := max_hit_points
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

feature -- Status report
	is_healthy: BOOLEAN is
			-- Does the unit have maximum amount of hit points?
		do
			Result := hit_points = max_hit_points
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
		ensure
			non_decreasing_hp : hit_points >= old hit_points
			added_value_or_max: hit_points = (old hit_points + value).min (max_hit_points)
		end

feature -- Output
	out: STRING is
			-- String representation
		do
			Result := type + " " + position.out
		end

invariant
	hit_points_non_negative: hit_points >= 0
	hit_points_not_too_many: hit_points <= max_hit_points
	position_exists: position /= Void
	type_exists: type /= Void
	type_nonempty: not type.is_empty
end

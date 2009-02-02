note
	description: "Summary description for {UNIT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	UNIT

feature -- Access
	get_position : POSITION is
		do
			Result := position
		end

	to_string : STRING is
			-- String which describes object
		do
			Result := get_type + get_position.to_string
		end

	get_type : STRING is
			-- Type of an object
		deferred
		end


feature -- Element change
	decrease_hp (value : INTEGER) is
			-- Decrease hp when object is under attack
		do
			hit_points := hit_points - value
			if (hit_points < 0) then
				hit_points := 0
			end
		ensure
			non_increasing_hp : hit_points <= old hit_points
		end

	increase_hp (value : INTEGER) is
			-- Decrease hp when object is under attack
		do
			hit_points := hit_points + value
			if (hit_points > maximum_hp) then
				hit_points := maximum_hp
			end
		ensure
			non_decreasing_hp : hit_points >= old hit_points
		end

feature {NONE} -- Implementation
	hit_points : INTEGER
	position : POSITION
	maximum_hp : INTEGER

invariant
	non_negative_hp : hit_points >= 0 -- Number of hit-points mustn't be negative
	non_exceeding_maximum : hit_points <= maximum_hp

end

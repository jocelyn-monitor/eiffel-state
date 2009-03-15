note
    description: "Unit of the army."
    author: ""
    date: "$Date$"
    revision: "$Revision$"

deferred class
    ARMY_BEING

inherit
    BEING

feature -- Access
    maximum_power: INTEGER is
    		-- Unit's attack power
    	deferred
    	end

feature -- State dependent: Access
	power: INTEGER is
			-- Power can be reduced by pains
		do
			Result := (power * sd_ability_decrease.item([], hp_state)).floor
		end

feature -- Basic operation
    attack (target: UNIT): INTEGER is
            -- Attack some unit
        do
            io.put_string ("Attacking " + target.out + "%N")
            Result := Result + move (target.position)
            target.decrease_hit_points (power)
            Result := Result + 1 -- It takes one period of time to attack
        end
end

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
    maximum_accuracy: DOUBLE is
    		-- Probability that being will successfully attack some other being
    	deferred
    	end

feature -- State dependent: Access
	accuracy: DOUBLE is
			-- Power can be reduced by pains
		do
			Result := maximum_accuracy * sd_ability_decrease.item([], health_state)
		end

feature -- Basic operation
    attack (target: UNIT): INTEGER is
            -- Attack some unit
		local
			random_value: DOUBLE
			random: RANDOM
        do
            io.put_string ("Attacking " + target.out + "%N")
            Result := Result + move (target.position)
            create random.make
            random_value := random.double_item
            if random_value > accuracy then
            	-- If being succeded
            	target.attack_this
            end
            Result := Result + 1 -- It takes one period of time to attack
        end
end

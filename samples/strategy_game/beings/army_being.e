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
			Result := maximum_accuracy * sd_ability_reduction.item([], health_state)
		end

feature -- Basic operations
    attack (target: UNIT): DOUBLE is
            -- Attack some unit
		local
			random_value: DOUBLE
			random: RANDOM
        do
        	if (team_name = target.team_name) then
        		io.put_string (target.out + " can't attack his ally " + target.out + "%N")
        	else
	            io.put_string ("Attacking " + target.out + "%N")
	            Result := Result + move (target.position)
	            create random.make
	            random_value := random.double_item
	            if random_value > accuracy then
	            	-- If ARMY_BEING succeded
	            	target.reduce_health
	            end
	            Result := Result + 1.0 -- It takes one period of time to attack
			end
        end
end

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
    power: INTEGER is
    		-- Unit's attack power
    	deferred
    	end

feature -- Basic operation
    attack (target: UNIT) is
            -- Attack some unit
        do
            io.put_string ("Attacking " + target.out + "%N")
            move (target.position)
            target.decrease_hit_points (power)
        end
end

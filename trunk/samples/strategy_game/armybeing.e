note
	description: "Summary description for {ARMYBEING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred
class
	ARMYBEING

inherit
	BEING

feature -- Element change
	attack(target : UNIT) is
			-- Attack some unit
		do
			io.put_string ("Attacking " + target.to_string + "%N")
			move (target.get_position)
			target.decrease_hp (power)
		end

feature {NONE} -- Implementation
	power : INTEGER
end

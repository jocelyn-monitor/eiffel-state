note
	description: "Mines that produce gold."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MINE

inherit
	PRODUCTION
		rename
			last_resource as last_gold
		redefine
			last_gold, make
		end

create {WORKER}
	make

feature -- Initialization
	make (p: POSITION) is
			-- creates mine at `p' position
		do
			Precursor {PRODUCTION} (p)
			gold_amount := maximum_gold_amount
			update_used_state
		end

feature -- Access
	type: STRING is "Mine"

	last_gold: GOLD

	creation_time: INTEGER is 200

	gold_amount: INTEGER

	maximum_gold_amount: INTEGER is 1000

feature -- Basic operations
	update_used_state is
			-- Updates state of mine
		do
			if (gold_amount > (maximum_gold_amount / 2).floor) then
				exhausted_state := Weakly_used
			elseif (gold_amount /= 0) then
				exhausted_state := Heavily_used
			else
				exhausted_state := Depleted
			end
		end

feature -- State dependent: Access
	collecting_time: INTEGER is
			-- Time required for collecting one gold bar
		do
			Result := sd_collecting_time.item([], exhausted_state)
		end

feature -- Basic operation
	produce: INTEGER is
			-- Produce resource and store it into `last_gold'
		do
			create last_gold
			if (exhausted_state /= Depleted) then
				gold_amount := gold_amount - 1
			end
			Result := collecting_time + last_gold.creation_time
		end

feature {NONE}
	Weakly_used: STATE is once create Result.make ("Weakly used") end
	Heavily_used: STATE is once create Result.make ("Heavily used") end
	Depleted: STATE is once create Result.make ("Depleted") end

	sd_collecting_time: STATE_DEPENDENT_FUNCTION [TUPLE, INTEGER] is
			-- State-dependent function for `collecting_time'
		once
			create Result.make(3)
			Result.add_result (Weakly_used, agent : BOOLEAN do Result := True end, 1)
			Result.add_result (Heavily_used, agent : BOOLEAN do Result := True end, 2)
			Result.add_result (Depleted, agent : BOOLEAN do Result := True end, 1000)
		end

	exhausted_state: STATE
end

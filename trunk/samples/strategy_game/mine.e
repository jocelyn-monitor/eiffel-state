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
			exhausted_state := Weak_depreciation
		end

feature -- Access
	type: STRING is "Mine"

	last_gold: GOLD

	creation_time: DOUBLE is 20.0

	gold_mined: INTEGER

	middle_depreciation_level: INTEGER is 1000

	heavy_depreciation_level: INTEGER is 3000

feature -- State dependent: Access
	collecting_time: DOUBLE is
			-- Time required for collecting one gold bar
		do
			Result := sd_collecting_time.item([], exhausted_state)
		end

feature -- Basic operation
	produce: DOUBLE is
			-- Produce bar of gold and store it into `last_gold'
		do
			create last_gold
			Result := collecting_time + last_gold.creation_time
			gold_mined := gold_mined + 1
			sd_produce.call ([], exhausted_state)
		end

feature {NONE}
	Weak_depreciation: STATE is once create Result.make ("Weak depreciation") end
	Medium_depreciation: STATE is once create Result.make ("Medium depreciation") end
	Heavy_depreciation: STATE is once create Result.make ("Heavy depreciation") end

	is_heavily_used: BOOLEAN
		do
			Result := True
		end

	sd_collecting_time: STATE_DEPENDENT_FUNCTION [TUPLE, DOUBLE] is
			-- State-dependent function for `collecting_time'
		once
			create Result.make(3)
			Result.add_result (Weak_depreciation, agent: BOOLEAN do Result := True end, 1.0)
			Result.add_result (Medium_depreciation, agent: BOOLEAN do Result := True end, 3.0)
			Result.add_result (Heavy_depreciation, agent: BOOLEAN do Result := True end, 15.0)
		end

	sd_produce: STATE_DEPENDENT_PROCEDURE [TUPLE] is
			-- State-dependent procedure for `produce'
		once
			create Result.make(2)
			Result.add_behavior (Weak_depreciation, agent: BOOLEAN do Result := True end, agent do end, Medium_depreciation)
			Result.add_behavior (Medium_depreciation, agent: BOOLEAN do Result := True end, agent do end, Heavy_depreciation)
		end

	exhausted_state: STATE
end

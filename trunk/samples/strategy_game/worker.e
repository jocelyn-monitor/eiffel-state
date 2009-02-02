note
	description: "Summary description for {WORKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WORKER

inherit
	BEING

create
	make

feature -- Access
	type : STRING is "Worker"

	last_mine: MINE

	last_sawmill: SAWMILL

	last_barrack: BARRACK

feature -- Basic operations
	repair (b: BUILDING) is
			-- Repair some building
		require
			b_exists: b /= Void
		do
			move (b.position)
			from
			until
				b.is_repaired
			loop
				b.increase_hit_points (5)
			end
			io.put_string (out + " has repaired building%N")
		ensure
			is_repaired: b.is_repaired
		end

	build_mine (p: POSITION) is
			-- Construct mine and store it in `last_mine'
		require
			p_exists: p /= Void
		do
			move (p)
			create last_mine.make (p)
			io.put_string (last_mine.out + " was just constructed%N")
		ensure
			last_mine_exists: last_mine /= Void
		end

	build_sawmill (p: POSITION) is
			-- Construct sawmill and store it in `last_sawmill'
		require
			p_exists: p /= Void
		do
			move (p)
			create last_sawmill.make (p)
			io.put_string (last_sawmill.out + " was just constructed%N")
		ensure
			last_sawmill_exists: last_sawmill /= Void
		end

	build_barrack (p: POSITION) is
			-- Construct barrack and store it in `last_barrack'
		require
			p_exists: p /= Void
		do
			move (p)
			create last_barrack.make (p)
			io.put_string (last_barrack.out + " was just constructed%N")
		ensure
			last_barrack_exists: last_barrack /= Void
		end

	collect_lumber (tree_position: POSITION; sawmill: SAWMILL) is
			-- Cut trees at `tree_position' and produce lumber with the help of `sawmill'
		require
			position_exists: position /= Void
			sawmill_exists: sawmill /= Void
		do
			move (tree_position)
			io.put_string (out + " has just cut a tree%N")
			move (sawmill.position)
			sawmill.produce
			io.put_string (out + " collected lumber%N")
		end

	collect_gold (mine: MINE) is
			-- Cut gold at `mine'
		require
			mine_exists: mine /= Void
		do
			move (mine.position)
			io.put_string (out + " is searching for gold in " + mine.out + "%N")
			mine.produce
			io.put_string (out + " has found gold in " + mine.out + "%N")
		end

feature {NONE} -- Implementation
	max_hit_points: INTEGER is 25

end

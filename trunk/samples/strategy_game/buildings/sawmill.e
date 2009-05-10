note
	description: "Sawmills that produce LUMBER from FELLED_TREE"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAWMILL

inherit
	PRODUCTION
		rename
			last_resource as last_lumber
		redefine
			last_lumber
		end

create {WORKER}
	make

feature -- Access
	type : STRING is "Sawmill"

	last_lumber: LUMBER

	creation_time: DOUBLE is 20.0

	felled_tree_amount: INTEGER

feature -- Basic operations
	deliver_felled_tree (tree: FELLED_TREE) is
			-- Worker should deliver `FELLED_TREE' before producing `LUMBER'
		do
			felled_tree_amount := felled_tree_amount + 1
		end

	produce: DOUBLE is
			-- Produce resource and store it into `last_lumber'
		require else
			felled_tree_amount >= 0
		do
			create last_lumber
			Result := last_lumber.creation_time
			felled_tree_amount := felled_tree_amount - 1
		end

end

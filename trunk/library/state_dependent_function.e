indexing
	description: "Functions whose behavior depends on the control state."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATE_DEPENDENT_FUNCTION  [ARGS -> TUPLE, RES]

create
	make

feature {NONE} -- Initialization
	make (n: INTEGER) is
			-- Create a procedure valid for at least `n' states
		require
			n_positive: n > 0
		do
			create behaviors.make (n)
			behaviors.compare_objects
			create results.make (n)
			results.compare_objects
		end

feature -- Basic operations
	add_behavior (state: STATE; guard: PREDICATE [ANY, ARGS]; function: FUNCTION [ANY, ARGS, RES]) is
			-- Make function return the result of `function' when called in `state' and `guard' holds
		local
			list: LINKED_LIST [TUPLE [guard: PREDICATE [ANY, ARGS]; function: FUNCTION [ANY, ARGS, RES]]]
		do
			behaviors.search (state)
			if behaviors.found then
				behaviors.found_item.put_front ([guard, function])
			else
				create list.make
				list.put_front ([guard, function])
				behaviors.extend (list, state)
			end
		end

	add_result (state: STATE; guard: PREDICATE [ANY, ARGS]; res: RES) is
			-- Make function return `r' when called in `state' and `guard' holds
		local
			list: LINKED_LIST [TUPLE [guard: PREDICATE [ANY, ARGS]; res: RES]]
		do
			results.search (state)
			if results.found then
				results.found_item.extend ([guard, res])
			else
				create list.make
				list.put_front ([guard, res])
				results.extend (list, state)
			end
		end

	item (args: ARGS; state: STATE): RES is
			-- Function result in `state' with `args' (default value if no specific behavior defined)
		require
			results.has (state) or behaviors.has (state) --check if function is defined in this state
		local
			found: BOOLEAN
		do
			results.search (state)
			if results.found then
				from
					results.found_item.start
				until
					results.found_item.after or found
				loop
					if results.found_item.item.guard.item (args) then
						found := True
						Result := results.found_item.item.res
					end
					results.found_item.forth
				end
			end
			behaviors.search (state)
			if behaviors.found and not found then
				from
					behaviors.found_item.start
				until
					behaviors.found_item.after or found
				loop
					 if behaviors.found_item.item.guard.item (args) then
						 found := True
						 Result := behaviors.found_item.item.function.item (args)
					 end
					behaviors.found_item.forth
				end
			end
		end

feature -- Implementation
	behaviors: HASH_TABLE [LINKED_LIST [TUPLE [guard: PREDICATE [ANY, ARGS]; function: FUNCTION [ANY, ARGS, RES]]], STATE]
			-- Function behaviors in different states, when different guards hold

	results: HASH_TABLE [LINKED_LIST [TUPLE [guard: PREDICATE [ANY, ARGS]; res: RES]], STATE]
			-- Function results in different states, when different guards hold

invariant
	behaviors_exists: behaviors /= Void
	results_exists: results /= Void
end

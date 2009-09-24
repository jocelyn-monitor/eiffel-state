indexing
    description : "Application class."
    date        : "$Date: 2008-09-19 11:33:35 -0700 (Fri, 19 Sep 2008) $"
    revision    : "$Revision: 74752 $"

class
    APPLICATION

inherit
	EV_APPLICATION
		select
			default_create,
			copy
		end
	ENVIRONMENT
		rename
			copy as env_copy
		end

create
	make_and_launch

feature {NONE} -- Initialization
	make_and_launch is
			-- Initialize and launch application
		local
			set: BINARY_SEARCH_TREE_SET [ACTION [TUPLE]]
			a, b: ACTION [TUPLE]
		do
			default_create
			create set.make
			create a.make (Void, "la")
			create b.make (Void, "la")
			set.extend (a)
			set.extend (b)
			set.extend (create {ACTION [TUPLE]}.make (Void, "la"))
			set.extend (create {ACTION [TUPLE]}.make (Void, "la"))
			io.put_boolean (a < b)
			io.put_new_line
			io.put_boolean (b < a)
			io.put_new_line
			io.put_integer (set.count)
			io.put_new_line
			gui := gui_manager
			units := unit_manager
			unit_manager.sample_units_script
			gui.show_window
			launch
		end

feature {NONE} -- Implementation
	gui: GUI_MANAGER
	units: UNIT_MANAGER

end

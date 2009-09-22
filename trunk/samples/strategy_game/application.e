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
		do
			default_create
			gui := gui_manager
			gui.show_window
			launch
		end

feature {NONE} -- Implementation
	gui: GUI_MANAGER

end

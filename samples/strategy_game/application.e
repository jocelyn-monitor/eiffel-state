indexing
    description : "Strategy Game application root class"
    date        : "$Date: 2008-09-19 11:33:35 -0700 (Fri, 19 Sep 2008) $"
    revision    : "$Revision: 74752 $"

class
    APPLICATION

inherit
	EV_APPLICATION

create
	make_and_launch

feature {NONE} -- Initialization

	make_and_launch is
			-- Initialize and launch application
		do
			default_create
			create gui_manager
			launch
		end

feature {NONE} -- Implementation

	gui_manager: GUI_MANAGER

end

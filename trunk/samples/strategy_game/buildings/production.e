note
	description: "Buildings that produce resources."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PRODUCTION

inherit
	BUILDING

feature -- Access
	last_resource: RESOURCE

feature -- Basic operations
	produce: DOUBLE is
			-- Produce resource and store it into `last_resource', return time required
		deferred
		ensure
			last_resource /= Void
		end

end

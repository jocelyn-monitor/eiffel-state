indexing
	description: "Game managers that let players to take first turn interchangeably."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INTERCHANGE_MANAGER

inherit
	GAME_MANAGER
		redefine
			default_create
		end

feature -- Initialization
	default_create is
			-- Create a manager with first turn cross
		do
			first_turn := {GAME}.Cross_code
		end

feature -- State dependent: basic operations
	start_new_game is
			-- Start a new game
		do
			create current_game.make (first_turn)
			if first_turn = {GAME}.Cross_code then
				first_turn := {GAME}.Circle_code
			else
				first_turn := {GAME}.Cross_code
			end
		end
end

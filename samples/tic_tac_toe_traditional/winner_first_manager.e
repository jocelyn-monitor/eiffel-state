indexing
	description: "Game managers that let the winner of the previous game do the first turn and change the first player in case of draw."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WINNER_FIRST_MANAGER

inherit
	GAME_MANAGER
		redefine
			default_create
		end

feature -- Initialization
	default_create is
			-- Create a manager with first turn cross
		do
			first_turn := {GAME}.Circle_code
		end

feature -- State dependent: basic operations
	start_new_game is
			-- Start a new game
		do
			if current_game /= Void and then current_game.winner /= {GAME}.Empty_code then
				first_turn := current_game.winner
			elseif first_turn = {GAME}.Cross_code then
				first_turn := {GAME}.Circle_code
			else
				first_turn := {GAME}.Cross_code
			end
			create current_game.make (first_turn)
		end
end

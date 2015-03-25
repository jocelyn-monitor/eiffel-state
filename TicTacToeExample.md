# Introduction #

Tic-Tac-Toe a step-by-step game for two players. It is played on 3x3 field (also may be any square field). The aim of the game is to put three O or three X in a row, column or diagonal.

We designed the game in traditional object-oriented style and then in automata-based style an used different approaches to implement the latter.

In both versions of the design there is a clear separation between "model" and "view" (interface). The interface part is the same in both versions and not particularly interesting, so we omit its description.

# Traditional design #

In the traditional design we introduced the following classes:
  * GAME that stores the game field, keeps track of the current turn (X or O) and defines the ending conditions. Values in the cells are stored as integers. On creation a game receives the first turn as an argument.
  * GAME\_MANAGER that defines the inter-game logic. It is a deferred class that can be viewed both as a factory and a strategy. It's main purpose is to create games, supplying the first turn to them (however, potentially it may also store some statistics of the game series and so on). Different descendants of GAME can define their own strategies to determine the first turn.
  * INTERCHANGE\_MANAGER: descendant of GAME\_MANAGER that makes first turns interchange from one game to another.
  * WINNER\_FIRST\_MANAGER: descendant of GAME\_MANAGER that gives the first turn to a winner of the last game unless there was a draw, in which case the first turn is different from the last game.

# Automata-based design #

In automata-based version we made the above listed classes automated and added one more:
  * FIELD\_CELL represents cells of the game field. Has 3 control states: Empty, Cross and Circle and two state-dependent commands "put\_cross" and "put\_circle" with obvious effects.
  * GAME has 5 control states: Cross\_turn, Circle\_turn, Cross\_win, Circle\_win and Draw. Field is now stored as a 2D array of FIELD\_CELL objects.
  * GAME\_MANAGER has 2 control states: First\_turn\_cross and First\_turn\_circle. Different descendants define their own transitions between these states.

## Implementation ##

### First implementation: questions and problems ###
  1. In traditional approach conditions can be checked _after_ performing some action. In our approach conditions ("predicates", "input variables") are checked first, and then actions are executed. Combined with the fact that there are no epsilon-transitions in our model and predicates should be pure, this leads to strange predicates such as "will there be a winning combination after cross is put in cell (i, j)?" **Possible solutions**: 1) leave everything as is and hope for the best 2) allow epsilon-transitions (hate'em!) or 3) simulate them with calls to secret procedures (e.g., make\_turn always triggers put\_something action _and_ check\_game\_over action, which is itself state-dependent; check\_game\_over then uses normal predicates to calculate the new state).
  1. Clients often need to know the control state of the automated object (examples: functions is\_empty, is\_cross, is\_circle in FIELD\_CELL; is\_over, cross\_won, circle\_won in GAME). I decided for hiding the state from clients anyway and introducing functions for these purposes, but it may seem like a big overhead (especially in the case of FIELD\_CELL above). The question is whether we want to make control state public instead? My answer will be no, because in the end control states won't be just regular attributes, there will be a special notation for them; so they cannot be used as regular attributes, but instead we should include the possibility of control state exchange into diagrams if we want to make them public. Another possibility is to automate somehow in our future tool the generation of such functions.
  1. Overall about state-dependent functions. As we see from the example, state dependent functions proved useful. However, I think, we should impose the restriction, that such functions cannot be used in transition conditions. One more thing: though these functions are state-dependent, they never change the control state (being side-effect free, like all Eiffel functions). So, in my opinion, they should not be depicted in state-transition diagram, as they just pollute diagrams with many redundant loops. We should find another notation for them.
  1. Precise STD notation should be discussed. Writing full pieces of code on transitions might be inconvenient, so we probably need abbreviations in Shalyto style or something like that. Note that we don't want to make the programmer introduce a separate feature for each action or predicate. E.g. in start\_new\_game of WINNER\_FIRST\_MANAGER the actions look like "create current\_game.make\_first\_cross" and the predicates like "current\_game /= Void and then current\_game.cross\_won". We would probably want to allow arbitrary boolean expression as a predicate and arbitrary compound as an action. Then we would need some "abbreviation table", where the programmer can introduce abbreviations and code pieces that correspond to them. I think it's psychologically easier for a programmer to introduce a new abbreviation, than to introduce a new feature for each predicate and action.

### Implementation approaches ###
**Static**
  * Switch-like
Here the output function and the transition function of an automaton are described through conditional or multi-choice instructions of the language. As we already have the property that features of an automated class correspond to "events" in the automaton, event-dispatch is done through calling different features and only the state-dispatch is done explicitly.

_Advantages_: simple for coding by hand, no overhead in code size and efficiency, flexible description of transitions (number, order, structure, etc.)

_Disadvantages_: states are integers (?), flexible description of transitions (if writing by hand may cause errors), some people find it ugly (?), no library needed
  * State pattern-like (between static and dynamic)
For every automated class we have one more class for each of its states + one class for abstract state with the same interface. Output and transition functions are encoded in the features of state classes.

_Advantages_: very object-oriented (classes for states, dynamic binding used for dispatch)

_Disadvantages_: big code size overhead (difficult to write by hand), no library needed

**Dynamic**
  * States as tables, agent-based
Class state contains a table, indexed by events (routines of the automated class), represented as agents. For each event there is a list of transitions, each containing a guarding condition (again an agent), an action (one more agent) and a target state.
If the automaton is not supposed to change during execution (which is almost always the case), actual states can be represented inside the automated class as once functions:
```
empty: STATE is
		-- State Empty
	once
		create Result
		Result.add_transition (agent put_cross, agent trivially_true, agent do_nothing, cross)
		Result.add_transition (agent put_circle, agent trivially_true, agent do_nothing, circle)
	end
```

State-dependent procedures are all implemented in a similar way:
```
put_cross is
		-- Put cross into the cell
	do
		state.make_transition (agent put_cross)
		state := state.next_state
	end
```

Note that inline agents can be used for predicates and actions, thus there is no need to introduce a feature for each of them, which is nice.

This approach is not completely straightforward at handling arguments (but I think it should be possible) and type-safety. Special care is needed for state-dependent queries to handle their results in a type-safe way.

_Advantages_: fancy agent stuff (?)

_Disadvantages_: repeated event dispatch, problems with type-safety, some runtime overhead, is it really readable?

  * State-dependent routines as objects
We can introduce a class representing state-dependent routine, which will have feature "call (args: TUPLE; state: STATE)", making a transition, executing its action and storing new state in an attribute. Inside it will contain a table, indexed by states. For each state there will be a list of transitions, each represented by guard condition (agent), action (agent) and target state.

Class state in this approach doesn't play a particular role, it can be something with name inside; or it can be even an integer. In case we use a hash table of transitions, it should be hashable.

Particular state-dependent routines can be again represented with once routines, as in:
```
sdr_put_cross: STATE_DEPENDENT_ROUTINE is
	once
		create Result
		Result.add_transition (Empty, agent trivially_true, agent do_nothing, Cross)
	end
```
Note: this works only for computational state-independent guarding predicates and actions (otherwise, Current in agents is bound to the first created object of a particular class and routines are not invoked properly for all objects, except the first one that was created). For computational state-dependent guarding predicates and actions, use either agents with Current as argument, or store state-dependent routines in attributes and initialize them upon creation.

The implementations of state-dependent routines themselves in this case look like:
```
put_cross is
		-- Put cross into the cell
	do
		call (sdr_put_cross, [])
	end
```
where "call" is defined in class AUTOMATED, from which all automated classes inherit:
```
deferred class
	AUTOMATED

feature {NONE} -- Implementation
	call (sdr: STATE_DEPENDENT_ROUTINE; args: TUPLE) is
			--
		do
			sdr.call (args, state)
			state := sdr.next_state
		end

feature {NONE} -- States
	state: STATE

feature {NONE} -- Predicates
	trivially_true: BOOLEAN is
			--
		do
			Result := True
		end
end
```

With this approach it is easier to pass arguments to the predicate and action and easier to achieve type safety. In particular, we can also define STATE\_DEPENDENT\_FUNCTION and parametrize it with result type.

_Advantages_: no repeated event dispatch, (relative) type safety, easy argument passing, nice abstractions (IMHO)

_Disadvantages_: some runtime overhead, ?
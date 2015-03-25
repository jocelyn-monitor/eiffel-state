#EiffelState library design and implementation.

# Design #

For EiffelState library we have chosen to adopt _state-dependent routines_ (SDR) arrroach. In this approach the central abstraction is state-dependent routine, which is very similar to Eiffel ROUTINE abstraction in the sense that it can be called with some arguments, but is different in that its execution also depends on control state.

Inside state-dependent routine stores a table, indexed by control states. Each state corresponds to several transitions, each characterized by a guarding condition, an action and a target state. A guarding condition and an action are represented as agents. In case of state-dependent procedure an action is also a procedure, in case of function it is a function of the same type.

Class state is only used to identify control states and doesn't contain any crucial features.

In common situation when no dynamic modification is needed, particular states and state-dependent routines in an automated class can be represented with once functions.

We also suggest to introduce class `AUTOMATED` as an ancestor of all automated objects. This class can contain widely-used predicates (e.g. predicate that is always true, predicates that are true if the object is in certain control state), the current control state variable, etc.

# Implementation #

Prototype implementation is available under http://code.google.com/p/eiffel-state/source/browse/#svn/trunk/samples/tic_tac_toe_sdr.

## Suggested changes to prototype implementation ##
  1. To achieve type safety in argument passing, parametrize `STATE_DEPENDENT_PROCEDURE` and `STATE_DEPENDENT_FUNCTION` with `ARGS` (like in `PROCEDURE` and `FUNCTION`). Note, that it will disallow to use `call` from `AUTOMATED`. I don't think it makes sense to parametrize them also with `BASE_TYPE`.
  1. Think of inheriting `STATE_DEPENDENT_PROCEDURE` and `STATE_DEPENDENT_FUNCTION` from `STATE_DEPENDENT_ROUTINE` (in the same way as `PROCEDURE` and `FUNCTION` inherit from `ROUTINE`, with `call`, `last_result` and `item`). Also think of inheriting `STATE_DEPENDENT_ROUTINE` from `ROUTINE` and so on. Do it only if doesn't cause much trouble.
  1. If predicates and actions are computational-state-dependent, think of two alternatives: 1) Make an SRD an attribute instead of once-function and initialize it in creation procedure 2) Make it a once function and pass Current as argument. The second is more consistent, but verbose.
  1. Think of defining predicate combiners like "and", "or", "not". Think if it is more convenient than using inline agents.
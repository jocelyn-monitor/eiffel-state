# Introduction #

When extending an existing class you might want to add new feature (either state-dependent or state-independent) or to override existing feature (it can be state-dependent or state-independent as well).


# State-independent features #

You can add or override state-independent feature as if it was an ordinary class.


# Adding state-dependent features #

Here the process is the same as for adding state-dependent feature to a new class.


# Overriding state-dependent features #

This section will cover STATE\_DEPENDENT\_PROCEDURE, however, overriding of STATE\_DEPENDENT\_FUNCTION is done in the same manner.
First of all let's mention that there're two things which can be overridden:
  1. Actions executed on some of the transitions;
  1. Set of transitions;
For overriding actions the traditional approach can be used if agents passed to add\_behavior by parent were separate featured (not inline). In case of overriding inline methods the same technique as for changing transitions' set can be used.
So the main question is how to modify set of transitions and action which were inline agents.
To add new transition we should call add\_behavior method of STATE\_DEPENDENT\_PROCEDURE instance. There aren't any problems in case we add transition from new state. Here new state stands for state which didn't have any outgoing transitions for this procedure. However, there can be ambiguity if we talk about transition from one of the states which were already utilized by parent. For instance, there was one transition from state S1 to S2 with guard (x > 0) and one transition to S3 with guard (x <= 0). Child class introduces new variable y and new transition to S4 with guard (y > 10 and x > 0). When x = 1 and y = 11 new state is undefined, actually we can select either S2 or S4. Here when it said "transition" both transition and action on it are mentioned, yet it doesn't matter.
As far as guards are agents we cannot do any kind of analysis. Currently implemented solution that can be assumed when extending automated classes is priority of transitions. Transitions which were added later are prior to earlier added transitions and will be checked first. So in described example a transition will be performed to state S4. Transitions of children are prior to parent's transitions because they can introduce new variable in guards. The last remark: to change action on transition a new transition with the same guard and initial state can be added, it will override old transition.
# Introduction #

**Object-oriented Automata-based programming** is an approach to O-O software construction, in which entities with _complex_ (_state-dependent_) behavior are represented with _automated classes_.

<a href='Hidden comment: 
Main idea of Automata-based programming approach is following: there are controlled objects with states. State of object can be changed on some event fired in the system. This event can be fired as a reaction on user input, as well as a subsequent event fired while previous event is processed.
'></a>

# Complex behavior #

Entities with _simple_ behavior always have the same _reaction_ to a certain _input_. In O-O world a class is a model of an entity with simple behavior: inputs correspond to feature names, reactions correspond to feature bodies.

In contrast, an entity with complex behavior can react differently to the same input, depending on the history. To capture this dependency, the notion of _control state_ is introduced. In presence of this notion the reaction of an entity with complex behavior depends only on the input and on current control state. Reaction as function of input and state together with transitions between states is best expressed in a form of a _finite state transducer_ (finite automaton with output).

Entities with complex behavior are common in control and reactive systems, but there are also many examples from other kinds of software: network protocols, GUI elements, NPC in computer games and other AI-like problems, etc.

The idea behind Object-oriented Automata-based programming is to introduce a model for an entity with complex behavior, which will be just like a regular class from the client's point of view, but inside it will contain a finite state transducer to dispatch the calls of the same features to different "feature bodies", depending on the current control state.

# Control states vs. computational states #

Every class has a set of _computational states_, which is the set of all combinations of its attributes values. This set, though essentially finite, is in most cases immensely large. Computational states typically differ from each other only quantitavely; we can say that the result of a feature call depends on the computational state, but not the action (the algorithm) that is being executed.

In Automata-based programming for each entity with complex behavior in addition to the set of computational states, the set of control states is defined. As opposed to computational states, control states are typically few, and thus defined by enumeration. Each of them has a certain meaning and qualitatively differs from all the others. Control state defines an action that is performed as a reaction to a certain input, not only the result of this action.

Abstract machines that are used in the theory of formal languages (Push-down automaton, Turing machine) give good examples of distinguishing between control and computational states: control states in this case are the states of their finite-state controllers and the computational states are the states of the stack or the tape.

The distinction between control and computational states is rather informal, it is "in the eyes of the programmer". The choice of appropriate set of control states is one of the main design decisions when implementing an automated class; it is made individually for each entity with complex behavior.

Mathematically, control states can be either predicates on computational states or be orthogonal (add some new information). As an example of the first possibility, consider a bounded stack. It behaves differently, depending on whether it is 1) empty 2) full 3) neither empty nor full - so these could be its three control states. These states can be expressed as predicates on attributes "count" and "capacity", which are components of stack's computational state.

As an example of the second possibility, consider alarmed clock, which has three control states: "Alarm off", "Alarm setting" and "Alarm on". Computational states of the clock is defined by current time, alarm time and whether the bell is ringing. From these attributes one cannot determine, whether the alarm is on, off, or is being set.

# Automated control object #

In Object-oriented Automata-based programming the description of complex behavior is decomposed into _logic_ and _semantics_. Logic part includes control states, reaction as a function of input and control states, transitions between control states and is described by a finite-state transducer.

Semantics includes the set of computational states and specification of actions that an entity performs. Our approach also allows reactions and transitions depend on the values of predicates on the computational state. Thus, semantic part also includes specification of these predicates. The semantic part in O-O setting is represented by a class. The set of computational states is described by means of its attributes, actions correspond to its commands and predicates are expressed as boolean expressions involving its queries.

The logic part is called the _controller_ and the semantic part - the _control object_; the whole model or an entity with complex behavior that consists of a controller and a control object is called an _automated control object_ (terms come from control theory). The implementation of an automated control object in an O-O system is called _automated class_. Thus an automated class for an automated control object is the same thing as a class for an abstract data type.

The choice of the level of abstraction for the control object is closely connected with the choice of control states. Control object that is too high-level leads to less control states, but complicates the control object itself, bringing the advantages of Automata-based programming to nothing. Control object that is too low-level results in more control states, making the controller too complex.

Automated class looks like a normal class from the client's point of view. This is a very important property, which allows integrating automata-based implementations of entities with complex behavior into an existing O-O system, rather then redesigning the whole system from scratch in automata-based style. This means that the automated class, like any normal class, has a set of features, which can be called by clients on any instance of that class. However, the exact feature body to execute will be determined not only based on the feature name, but also on the current control state.

Compared to other automata-based models, automated control object is _passive_ (that is it makes a step only when it is asked to), it is based on the _Mealy automaton_ (that is, the actions depend not only on states, but also on the inputs), it has a _feedback_ (predicates on computational state can be used in transition conditions), but it is also _open_ (unlike e.g. Turing machine, in which the controller only receives information from the control object, automated control object receives inputs from its clients).

# Design process #

To make seamless integration with existing O-O systems possible, automata-based-specific features are introduces only on later stages of the design process and don't cross the boundaries of individual module.

Main stages of design process can be described as follows:
  1. Object decomposition: the problem domain is decomposed into the set of interacting entities.
  1. From all the system entities, entities with complex behavior are extracted. For these entities the automata-based approach is used. All the other entities are designed and implemented by means of standard O-O techniques.
  1. For each entity with complex behavior a set of control states is identified; transitions between states are defined; for each transition a condition and an action is specified. The best way to specify the controller is the graphical approach using state-transition diagrams (STD).
  1. Control object is constructed in such a way that it offers commands that are used in transition actions and queries that are used in transition conditions. The control object can be specified and implemented using standard O-O techniques.
  1. If no tool-support is available, the controller is implemented using one of the known patterns. Otherwise, STD itself is an implementation for the controller.

# (More or less) Solved problems #

  1. Should the control object be implemented in a single separate class, or can there be multiple classes, used by the controller, or alternatively, can some features of the control object be implemented directly in the automated class? **Current implementation**: only some features of an automated class are state-dependent, others represent features of a control object.
  1. Should a transition condition be a feature name followed by arbitrary boolean expression on control object queries or should it have a more restricted form: e.g. a feature name, followed by a conjunction of boolean queries on the control objects? **Current implementation**: a guard is an agent, that can contain any boolean expression.
  1. Should a transition action be a single command on the control object, a set of commands, a sequence of commands, or even have a more general structure, e.g., contain any instructions involving command on the control object. **Current implementation**: an action is an agent, that can be either an inline agent and contain any instructions inside or be a reference to a single control object command.
  1. Can an automated class have state-independent features? **Current implementation**: yes.
  1. Can an automated class have queries? Should they be state-independent? So far we were only talking about actions on transitions that correspond to control object commands. If we allow state-dependent queries, we should introduce a special kind of "actions" that are not at all actions and correspond to queries on the control object. Furthermore, as queries should be pure, such actions may only appear on _loops_ (transitions from a state to itself). **Current implementation**: there is a separate notion of state-dependent function, that returns a result and never changes the control state.
  1. How the features with arguments should be processed? Should the arguments be passed directly to the corresponding feature of the control object or should the arguments to a control object's feature be expressions over the initial arguments and computational state? Can the arguments appear in transition conditions? **Current implementation**: arguments of state-dependent features are passed directly to guarding conditions (an thus can appear in the transition conditions) and actions.
  1. How do the automated classes interact with inheritance? **Current approach** can be seen on [Inheritance](Inheritance.md) page.

# Unsolved problems #

  1. What is the policy for handling state-dependent feature calls, if a feature is not applicable; that is if it is not defined in a state or the set of alternative guards is not complete? Should we require that applicability conditions appear in SDR precondition (makes sense, but impossible to check)? Or should we assume some default behavior? E.g. ignoring a feature call (as it is done now), transiting into "error state"?
  1. How do we write contracts for state-dependent features? Should it be something like behavioral inheritance, i.e. that the contract of the state-dependent feature is weaker than all the contracts of control object's features that can be reactions to it. Or should we rather use the similar technique as for agent calls with abstract "precondition" query that can be checked without knowing what it really is?
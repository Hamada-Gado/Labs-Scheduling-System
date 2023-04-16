/**
ta_slot_assignment(TAs,RemTAs,Name) such that:
    • TAs and RemTAs are lists of TA structures
    • Name is a name of a TA in TAs.
ta_slot_assignment/3 succeeds if RemTAs is the list of TA structures resulting
from updating the load of TA Name in TAs.
*/
ta_slot_assignment([], [], _).
ta_slot_assignment([ta(Name, Slots)|T], [ta(Name, Slots2)|T], Name) :-
    Slots2 is Slots - 1, !.
ta_slot_assignment([ta(Name1, Slots)|T1], [ta(Name1, Slots)|T2], Name2) :-
    Name1 \= Name2,
    ta_slot_assignment(T1, T2, Name2), !.


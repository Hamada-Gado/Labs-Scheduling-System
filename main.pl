/**
ta_slot_assignment(TAs,RemTAs,Name) such that:
    • TAs and RemTAs are lists of TA structures
    • Name is a name of a TA in TAs.
ta_slot_assignment/3 succeeds if RemTAs is the list of TA structures resulting
from updating the load of TA Name in TAs.
*/
ta_slot_assignment([], [], _).
ta_slot_assignment([ta(Name, Slots)|T], [ta(Name, Slots2)|T], Name) :-
    Slots > 1,
    Slots2 is Slots - 1, !.
ta_slot_assignment([ta(Name1, Slots)|T1], [ta(Name1, Slots)|T2], Name2) :-
    Name1 \= Name2,
    ta_slot_assignment(T1, T2, Name2), !.

/**
slot_assignment(LabsNum,TAs,RemTAs,Assignment) such that:
    • LabsNum is a number representing the amount of parallel labs in this slot.
    • TAs is a list of TAs structures.
    • RemTAs is the updated list of TAs structures after the assignment to this slot.
    • Assignment is a list of the names of TAs in TAs assigned to this slot.
slot_assignment/4 succeeds if Assignment is a possible assignment to a single
slot with LabsNum labs and RemTAs is the list of modified TAs after the assignment.
*/
slot_assignment(0, TAs, TAs, []).
slot_assignment(LabsNum, [ta(Name, Slot1)|T1], [ta(Name, Slot2)|T2], [Name|Assignment]) :-
    New_LabsNum is LabsNum - 1,
    ta_slot_assignment([ta(Name, Slot1)|T1], [ta(Name, Slot2)|_], Name),
    slot_assignment(New_LabsNum, T1, T2, Assignment), !.

/**
max_slots_per_day(DaySched,Max) such that:
    • DaySched is a day schedule showing the assignment of the TAs in every slot.
    • Max is a number showing the maximum amount of labs a TA can be assignedin a day.
max_slots_per_day/2 succeeds if no TA is assigned more than Max labs in DaySched.

max_ta_slot_per_day(DaySched, Name, Max) such that:
    • DaySched is a day schedule showing the assignment of the TAs in every slot.
    • Name is the name of the ta to count how many slots he/she is having.
    • Max is a number showing the maximum amount of labs a TA can be assignedin a day.
max_ta_slots_per_day/3 succeds if TA with Name is assigned less or equal than Max labs in DaySched.
*/
max_slots_per_day([], _).
max_slots_per_day([[]|T], Max) :- max_slots_per_day(T, Max).
max_slots_per_day([[Name|T1]|T2], Max) :-
    max_ta_slots_per_day([[Name|T1]|T2], Name, Max),
    max_slots_per_day([T1|T2], Max).

max_ta_slots_per_day(DaySched, Name, Max) :- max_ta_slots_per_day(DaySched, Name, 0, Max).
max_ta_slots_per_day([], _, Count, Max) :- Count =< Max.
max_ta_slots_per_day([Assignment|Rest], Name, Count, Max) :-
    member(Name, Assignment),
    New_Count is Count + 1,
    max_ta_slots_per_day(Rest, Name, New_Count, Max), !.
max_ta_slots_per_day([Assignment|Rest], Name, Count, Max) :-
    \+member(Name, Assignment),
    max_ta_slots_per_day(Rest, Name, Count, Max), !.

/**
day_schedule(DaySlots,TAs,RemTAs,Assignment) such that:
    • DaySlots is a list of 5 numbers representing the number of parallel labs in the
    5 slots of the day.
    • TAs and RemTAs are lists of TA structures.
    • Assignment is a list of lists of TA names in TAs representing the assignment
    of the day.
day_schedule/4 succeeds if Assignment is a possible day assignment given the
available DaySlots and list of course TAs, while RemTAs is the list of updated TA structures after the day assignment.
*/
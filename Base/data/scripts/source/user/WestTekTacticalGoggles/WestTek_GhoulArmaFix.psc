Scriptname WestTekTacticalGoggles:WestTek_GhoulArmaFix extends ObjectReference
{Ghouls use HumanRace for armor race, so I need a workaround for ghouls to use this without clipping.}

Race Property GhoulRace Auto

Actor playerREF


Event OnInit()
	playerREF = Game.GetPlayer()
EndEvent


Auto State InitialEquipState

	Event OnEquipped(Actor akActor)
		
		If(akActor != playerREF && akActor.GetRace() == GhoulRace)
		
		EndIf
		
	EndEvent

	Event OnUnequipped(Actor akActor)
	
	EndEvent

EndState

State SwapModState

	Event OnEquipped(Actor akActor)
		;Do Nothing
	EndEvent

	Event OnUnequipped(Actor akActor)
		;Do Nothing
	EndEvent

EndState


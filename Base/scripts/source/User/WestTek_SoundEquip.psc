ScriptName WestTek_SoundEquip extends ObjectReference

Sound Property EquipSound Auto
Keyword Property KeywordNightVisionMod Auto
Keyword Property KeywordThermalVisionMod Auto
Actor myActor

Event OnEquipped(Actor akActor)
	myActor = akActor
	If(myActor == Game.GetPlayer() && (Self.HasKeyword(KeywordNightVisionMod) || Self.HasKeyword(KeywordThermalVisionMod)))
		EquipSound.Play(myActor)
	EndIf
EndEvent
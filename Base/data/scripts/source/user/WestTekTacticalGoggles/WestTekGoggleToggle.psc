Scriptname WestTekTacticalGoggles:WestTekGoggleToggle extends activemagiceffect
{Magic effect attached to a 'chem' to toggle West Tek goggle effects without having to unequip them.}

WestTekTacticalGoggles:WestTekGoggleControlQuest Property ControlQuest Auto

Potion Property GoggleControllerAidItem Auto
;Sound Property SwitchSound Auto Const

;Group VisionModeSpells
	;Spell Property NightVisionAbilitySpell Auto Const
	;Spell Property ThermalVisionAbilitySpell Auto Const
	;Spell Property TargetingHUDAbilitySpell Auto Const
;EndGroup

;Group VisionModeKeywords
;	Keyword Property KeywordNightVisionMod Auto Const
;	Keyword Property KeywordThermalVisionMod Auto Const
;	Keyword Property KeywordTargetingHUDMod Auto Const
;EndGroup

Actor playerREF

Event OnEffectStart(Actor akTarget, Actor akCaster)
	playerREF = Game.GetPlayer()
	playerREF.AddItem(GoggleControllerAidItem, 1, True)
	
	;Just in case someone decides to give this aid item to an NPC for whatever reason (people are... interesting.)
	;This reaches up into the controlling quest and uses a function there, which can be used via FO4 Hotkeys
	If(akTarget == playerREF)
		ControlQuest.GoggleToggle()
	EndIf
EndEvent 
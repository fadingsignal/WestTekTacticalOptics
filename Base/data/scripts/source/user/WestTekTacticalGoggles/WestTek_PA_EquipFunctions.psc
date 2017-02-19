Scriptname WestTekTacticalGoggles:WestTek_PA_EquipFunctions extends activemagiceffect
{Proxy magic effect to add and remove spells from player which can be controlled via chem or hotkey.}

;NOTE: With my goggles, I could use the OnEquipped and Unequipped events because I could directly apply scripts to the object.  I couldn't edit every power armor helmet to do the same, so this is a proxy magic effect that adds/removes the same spells the goggle onequip does.  Hooray for reusable code.

WestTekTacticalGoggles:WestTekGoggleControlQuest Property ControlQuest Auto

Sound Property EquipSound Auto Const
Sound Property PowerOffSound Auto Const

Group VisionModeSpells
	Spell Property NightVisionAbilitySpell Auto Const
	Spell Property NightVisionAbilitySpell2X Auto Const
	Spell Property NightVisionAbilitySpell3X Auto Const
	Spell Property ThermalVisionAbilitySpell Auto Const
	Spell Property ThermalVisionAbilitySpell2X Auto Const
	Spell Property TargetingHUDAbilitySpell Auto Const
EndGroup

Group VisionModeKeywords
	Keyword Property KeywordNightVisionMod Auto Const
	Keyword Property KeywordNightVisionMod2X Auto Const
	Keyword Property KeywordNightVisionMod3X Auto Const
	Keyword Property KeywordThermalVisionMod Auto Const
	Keyword Property KeywordThermalVisionMod2X Auto Const
	Keyword Property KeywordTargetingHUDMod Auto Const
	Keyword Property KeywordMultiVisionMod Auto Const
EndGroup

Actor playerREF
Spell CurrentSpell

Event OnEffectStart(Actor Target, Actor Caster)

	playerREF = Game.GetPlayer()
	ClearAllEffects()
	
	;Only attach these effects to the player, no point on NPCs
	If(Target == playerREF)

		;Cycle Vision Module
		If(playerREF.WornHasKeyword(KeywordMultiVisionMod))
			ControlQuest.RebuildVisionModeArrays()
			ControlQuest.PowerArmorVisionCycle()
			
		;Standard Module
		Else
		
			;Night Vision
			If(playerREF.WornHasKeyword(KeywordNightVisionMod))
				EquipSound.Play(playerREF)
				playerREF.AddSpell(NightVisionAbilitySpell, false)
				ControlQuest.CurrentVisualEffect = NightVisionAbilitySpell
				CurrentSpell = NightVisionAbilitySpell
			;Night Vision 2x
			ElseIf(playerREF.WornHasKeyword(KeywordNightVisionMod2X))
				EquipSound.Play(playerREF)
				playerREF.AddSpell(NightVisionAbilitySpell2X, false)
				ControlQuest.CurrentVisualEffect = NightVisionAbilitySpell2X
				CurrentSpell = NightVisionAbilitySpell2X
			;Night Vision 3x
			ElseIf(playerREF.WornHasKeyword(KeywordNightVisionMod3X))
				EquipSound.Play(playerREF)
				playerREF.AddSpell(NightVisionAbilitySpell3X, false)
				ControlQuest.CurrentVisualEffect = NightVisionAbilitySpell3X
				CurrentSpell = NightVisionAbilitySpell3X
			;Thermal Vision
			ElseIf(playerREF.WornHasKeyword(KeywordThermalVisionMod))
				EquipSound.Play(playerREF)
				playerREF.AddSpell(ThermalVisionAbilitySpell, false)
				ControlQuest.CurrentVisualEffect = ThermalVisionAbilitySpell
				CurrentSpell = ThermalVisionAbilitySpell
			;Thermal Vision 2x
			ElseIf(playerREF.WornHasKeyword(KeywordThermalVisionMod2X))
				EquipSound.Play(playerREF)
				playerREF.AddSpell(ThermalVisionAbilitySpell2X, false)
				ControlQuest.CurrentVisualEffect = ThermalVisionAbilitySpell2X
				CurrentSpell = ThermalVisionAbilitySpell2X
			ElseIf(playerREF.WornHasKeyword(KeywordTargetingHUDMod))
				EquipSound.Play(playerREF)
				playerREF.AddSpell(TargetingHUDAbilitySpell, false)
				ControlQuest.CurrentVisualEffect = TargetingHUDAbilitySpell
				CurrentSpell = TargetingHUDAbilitySpell
			EndIf
		
		EndIf

	EndIf	
	
EndEvent


Event OnEffectFinish(Actor Target, Actor Caster)
	
	If(Target == playerREF)
		ClearAllEffects() 
		ControlQuest.CurrentVisualEffect = None
		PowerOffSound.Play(playerREF)
	EndIf

EndEvent


;This is just a clean safeguard in case there's some race condition that stacks them, and ImageSpaces are nothing to trifle with (AHEM SKYRIM.)
Function ClearAllEffects()
	playerREF.RemoveSpell(NightVisionAbilitySpell)
	playerREF.RemoveSpell(NightVisionAbilitySpell2X)
	playerREF.RemoveSpell(NightVisionAbilitySpell3X)
	playerREF.RemoveSpell(ThermalVisionAbilitySpell)
	playerREF.RemoveSpell(ThermalVisionAbilitySpell2X)
	playerREF.RemoveSpell(TargetingHUDAbilitySpell)
EndFunction 
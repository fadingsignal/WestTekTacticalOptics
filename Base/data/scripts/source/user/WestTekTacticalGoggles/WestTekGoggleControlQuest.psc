Scriptname WestTekTacticalGoggles:WestTekGoggleControlQuest extends Quest
{An alternate solution to a chem, use a quest to toggle the goggles for more advanced users of FO4 Hotkeys.}

Group SoundEffects
	Sound Property SwitchSound Auto Const
	Sound Property PowerSound Auto Const
	Sound Property PowerOffSound Auto Const
	Sound Property CycleSound Auto Const
	Sound Property ErrorSound Auto Const
EndGroup

Group VisionModeSpells
	Spell Property NightVisionAbilitySpell Auto Const
	Spell Property NightVisionAbilitySpell2X Auto Const
	Spell Property NightVisionAbilitySpell3X Auto Const
	Spell Property ThermalVisionAbilitySpell Auto Const
	Spell Property ThermalVisionAbilitySpell2X Auto Const
	Spell Property TargetingHUDAbilitySpell Auto Const
	EndGroup

Group VisionModeKeywords
	Keyword Property KeywordHasEffectAny Auto Const
	Keyword Property KeywordMultiVisionMod Auto Const
	Keyword Property KeywordMultiVision_ALL Auto Const
	Keyword Property KeywordMultiVision_Standard Auto Const
	Keyword Property KeywordMultiVision_NightThermal Auto Const
EndGroup

Group GoggleReference_DoNotFill
	Spell Property CurrentVisualEffect = None Auto
	WestTekTacticalGoggles:WestTek_EquipFunctions_Pos Property CurrentGoggles = None Auto ;LEAVE THIS ALONE, this gets filled by the goggles when they are equipped, think of a fake ref alias
EndGroup


Actor playerREF

;Array of all visual effects to cycle thru for Multi-Vision mode
Spell[] arrayVisionModes
Int arrayVisionModeCurrentPosition = 0 ;default position


Event OnQuestInit()
	playerREF = Game.GetPlayer()
EndEvent

;This function is now even MORE agnostic, we reach into the currently worn object and perform the toggle functions there instead.  Having half the code here and half the code there didn't make sense.
;This is only here to have single persistent ref for the chem or hotkey to point to
Function GoggleToggle()

	;Check if we're actually wearing goggles, and there's an actual reference filled before bothering, or if we're in Power Armor or not
	
	If(playerREF.WornHasKeyword(KeywordHasEffectAny) && CurrentGoggles && !PlayerREF.IsInPowerArmor())
		CurrentGoggles.VisionToggle() ;use the toggle code within the goggle ref which has armor swapping extra code
	ElseIf(playerREF.WornHasKeyword(KeywordHasEffectAny) && PlayerREF.IsInPowerArmor())
		PowerArmorVisionToggle() ;use the simple PA toggle (it uses a magic effect proxy via enchantment so we have to do it here anyway
	Else
		ErrorSound.Play(playerREF) ;the default UI error 'click' really makes it feel like it's part of the game, very nice
	EndIf
	
EndFunction


Function PowerArmorVisionToggle()
			
		;debug.notification("PA toggle")
			
		;If the power armor module is in MULTI MODE we need to cycle
		If(playerREF.WornHasKeyword(KeywordMultiVisionMod))
			PowerArmorVisionCycle()
			
		;If not, a simple ON OFF switch is all we need
		Else
			;TURN OFF
			If(playerREF.HasSpell(CurrentVisualEffect))
				SwitchSound.Play(playerREF)
				playerREF.RemoveSpell(CurrentVisualEffect)
			;TURN ON
			Else
				playerREF.AddSpell(CurrentVisualEffect, False)
				PowerSound.Play(playerREF)
			EndIf
		
		EndIf

EndFunction

Function PowerArmorVisionCycle()

	;debug.Notification("power armor vision cycle")

	If(arrayVisionModeCurrentPosition < arrayVisionModes.Length)

		ClearAllEffects()
		CurrentVisualEffect = arrayVisionModes[arrayVisionModeCurrentPosition]
	
		playerREF.AddSpell(CurrentVisualEffect, False)
		
		If(arrayVisionModeCurrentPosition == 0)
			PowerSound.Play(playerREF)
		Else
			CycleSound.Play(playerREF)
		EndIf

		arrayVisionModeCurrentPosition += 1
	
	Else ;OFF
	
		PowerOffSound.Play(playerREF)
		ClearAllEffects()
		CurrentVisualEffect = None
		arrayVisionModeCurrentPosition = 0
		
	EndIf

EndFunction

;====================================
; RE-BUILD VISION CYCLE ARRAYS
;====================================
Function RebuildVisionModeArrays()
	;initialize vision mode arrays (that sounds cyber af to say)
	
	If(PlayerRef.WornHasKeyword(KeywordMultiVision_ALL))

		arrayVisionModes = new Spell[6]
		arrayVisionModes[0] = NightVisionAbilitySpell
		arrayVisionModes[1] = NightVisionAbilitySpell2X
		arrayVisionModes[2] = NightVisionAbilitySpell3X
		arrayVisionModes[3] = ThermalVisionAbilitySpell
		arrayVisionModes[4] = ThermalVisionAbilitySpell2X
		arrayVisionModes[5] = TargetingHUDAbilitySpell

	ElseIf(PlayerRef.WornHasKeyword(KeywordMultiVision_Standard))		
		
		arrayVisionModes = new Spell[3]
		arrayVisionModes[0] = NightVisionAbilitySpell
		arrayVisionModes[1] = ThermalVisionAbilitySpell
		arrayVisionModes[2] = TargetingHUDAbilitySpell		
		
	ElseIf(PlayerRef.WornHasKeyword(KeywordMultiVision_NightThermal))
		
		arrayVisionModes = new Spell[2]
		arrayVisionModes[0] = NightVisionAbilitySpell
		arrayVisionModes[1] = ThermalVisionAbilitySpell
		
	EndIf

EndFunction

;Safeguard to run every time we change effects because the engine likes to skip things when it goes too fast 
Function ClearAllEffects()
	playerREF.RemoveSpell(NightVisionAbilitySpell)
	playerREF.RemoveSpell(NightVisionAbilitySpell2X)
	playerREF.RemoveSpell(NightVisionAbilitySpell3X)
	playerREF.RemoveSpell(ThermalVisionAbilitySpell)
	playerREF.RemoveSpell(ThermalVisionAbilitySpell2X)
	playerREF.RemoveSpell(TargetingHUDAbilitySpell)	
EndFunction 
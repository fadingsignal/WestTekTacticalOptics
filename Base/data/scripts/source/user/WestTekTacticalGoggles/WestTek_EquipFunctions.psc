ScriptName WestTekTacticalGoggles:WestTek_EquipFunctions extends ObjectReference

WestTekTacticalGoggles:WestTekGoggleControlQuest Property ControlQuest Auto

;TO-DO add on the secondary effects to the toggle, duh!  Right now they will just stay on.

Sound Property EquipSound Auto Const

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
EndGroup

Actor playerREF
Spell CurrentSpell
ObjectMod ThisCurrentMod = None
Int ThisItemID

Event OnInit()
	;assign this an ID?
	;ThisItemID = Utility.RandomInt(0,100)
	;debug.messagebox("init " + ThisItemID)
EndEvent

Event OnEquipped(Actor akActor)

	;debug.MessageBox("OnEquipped event fired " + ThisItemID)
	
	playerREF = Game.GetPlayer()
	
		;Only attach these effects to the player, no point on NPCs or it will interfere with player's vision!
		If(akActor == playerREF)

			ClearAllEffects() ;Remove all visual spells before adding the next, in case player does something crazy like hotkey switch a hundred times a second
			;ControlQuest.ResetControlParams() ;Resets all of the controller params to default
			
			;Check the vision mod types, and apply the appropriate spell to activate it, then tell the control quest what spell to add/remove during its toggle function
			;I hate big IF/ELSE blocks but this is the simplest way right now unless I use arrays matching the keyword to the effect
			
			;Night Vision
			If(Self.HasKeyword(KeywordNightVisionMod))
				EquipSound.Play(playerREF)
				playerREF.AddSpell(NightVisionAbilitySpell, false)
				ControlQuest.CurrentVisualEffect = NightVisionAbilitySpell
				CurrentSpell = NightVisionAbilitySpell
			;Night Vision 2x
			ElseIf(Self.HasKeyword(KeywordNightVisionMod2X))
				EquipSound.Play(playerREF)
				playerREF.AddSpell(NightVisionAbilitySpell2X, false)
				ControlQuest.CurrentVisualEffect = NightVisionAbilitySpell2X
				CurrentSpell = NightVisionAbilitySpell2X
			;Night Vision 3x
			ElseIf(Self.HasKeyword(KeywordNightVisionMod3X))
				EquipSound.Play(playerREF)
				playerREF.AddSpell(NightVisionAbilitySpell3X, false)
				ControlQuest.CurrentVisualEffect = NightVisionAbilitySpell3X
				CurrentSpell = NightVisionAbilitySpell3X
			;Thermal Vision
			ElseIf(Self.HasKeyword(KeywordThermalVisionMod))
				EquipSound.Play(playerREF)
				playerREF.AddSpell(ThermalVisionAbilitySpell, false)
				ControlQuest.CurrentVisualEffect = ThermalVisionAbilitySpell
				CurrentSpell = ThermalVisionAbilitySpell
			;Thermal Vision 2x
			ElseIf(Self.HasKeyword(KeywordThermalVisionMod2X))
				EquipSound.Play(playerREF)
				playerREF.AddSpell(ThermalVisionAbilitySpell2X, false)
				ControlQuest.CurrentVisualEffect = ThermalVisionAbilitySpell2X
				CurrentSpell = ThermalVisionAbilitySpell2X
			;Targeting HUD
			ElseIf(Self.HasKeyword(KeywordTargetingHUDMod))
				EquipSound.Play(playerREF)
				playerREF.AddSpell(TargetingHUDAbilitySpell, false)
				ControlQuest.CurrentVisualEffect = TargetingHUDAbilitySpell
				CurrentSpell = TargetingHUDAbilitySpell
			EndIf
					
		EndIf
		
EndEvent

Event OnUnequipped(Actor akActor)
	playerREF = Game.GetPlayer()
	
	;debug.MessageBox("Unequipped event fired " + ThisItemID)
	
	If(akActor == playerREF)
		ClearAllEffects()
	EndIf

EndEvent 


;This is just a clean safeguard in case there's some race condition that stacks them, and ImageSpaces are nothing to trifle with.
Function ClearAllEffects()
	playerREF.RemoveSpell(NightVisionAbilitySpell)
	playerREF.RemoveSpell(NightVisionAbilitySpell2X)
	playerREF.RemoveSpell(NightVisionAbilitySpell3X)
	playerREF.RemoveSpell(ThermalVisionAbilitySpell)
	playerREF.RemoveSpell(ThermalVisionAbilitySpell2X)
	playerREF.RemoveSpell(TargetingHUDAbilitySpell)
	ControlQuest.CurrentVisualEffect = None
EndFunction 

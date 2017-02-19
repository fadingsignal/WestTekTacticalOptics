ScriptName WestTekTacticalGoggles:WestTek_EquipFunctions_Pos extends ObjectReference

WestTekTacticalGoggles:WestTekGoggleControlQuest Property ControlQuest Auto

;TO-DO move the GOGGLE UP / DOWN code into functions since there is duplicate code used in a couple places

Group SoundEffects
	Sound Property EquipSound Auto Const ;The ruffling of equipment
	Sound Property CycleSound Auto Const ;Pure switch sound
	Sound Property PowerSound Auto Const ;The power-up whine sound
	Sound Property PowerOffSound Auto Const ;Powering OFF
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
	Keyword Property KeywordNightVisionMod Auto Const
	Keyword Property KeywordNightVisionMod2X Auto Const
	Keyword Property KeywordNightVisionMod3X Auto Const
	Keyword Property KeywordThermalVisionMod Auto Const
	Keyword Property KeywordThermalVisionMod2X Auto Const
	Keyword Property KeywordTargetingHUDMod Auto Const
	Keyword Property KeywordHasEffectAny Auto Const
	Keyword Property KeywordMultiVisionMod Auto Const
	Keyword Property KeywordMultiVision_ALL Auto Const
	Keyword Property KeywordMultiVision_Standard Auto Const
	Keyword Property KeywordMultiVision_NightThermal Auto Const
EndGroup


Group RuntimeAttachKeywords
	Keyword Property KeywordLensOverride Auto Const
	Keyword Property KeywordInactivePosition_Forehead Auto Const
	Keyword Property KeywordHasForeheadModAttached Auto Const ;if the goggles have this keyword that means they're in the forehead position w/ mod (why is there no HasMod or IsModAttached function?!)
EndGroup

Group RuntimeAttachMods
	ObjectMod Property MODModelSwapInactive Auto
	ObjectMod Property MODLensRed Auto 
	ObjectMod Property MODLensGreen Auto 
	ObjectMod Property MODLensYellow Auto ;Targeting HUD
	ObjectMod Property MODLensOff Auto ;this is applied when the goggles are turned off
EndGroup

;INTERNAL VARIABLES
Actor playerREF
ObjectMod ThisCurrentMod = None
Spell CurrentVisualEffect = None
ObjectMod CurrentLensColor = None
Int ThisItemID

;Array of all visual effects to cycle thru for Multi-Vision mode
Spell[] arrayVisionModes
Int arrayVisionModeCurrentPosition = 0 ;default position

ObjectMod[] arrayLensColors

Bool CycleFunctionLocked = False

;TODO POSSIBLE BUG -- This only loads once, if I change out the mods, OnInit doesn't run again so I'll be stuck with whatever array... may need to do this OnEquip instead.
Event OnInit()

	playerREF = Game.GetPlayer()
	
EndEvent

;=====================
; STATES
; http://www.creationkit.com/fallout4/index.php?title=States_(Papyrus)
;=====================

;This state should only happen when the item is first equipped directly by the player via inventory or console, etc. NOT by the game re-equipping when mods are attached, which is the whole reason I need these at all!
Auto State InitialEquipState
		
	Event OnEquipped(Actor akActor)
	
			;debug.messagebox("normal onequipped")

			EquipSound.Play(akActor)
			
			;Only run if it's the player and the goggles have any visual effects
			If(akActor == playerREF && self.HasKeyword(KeywordHasEffectAny))
			
				ClearAllEffects()

				ControlQuest.CurrentGoggles = Self
				
				If(Self.HasKeyword(KeywordMultiVisionMod)) ;Cycle Mode
					RebuildVisionModeArrays()
					InitialEquipCycleMode()
				Else ;Standard Mode
					;Night Vision
					If(Self.HasKeyword(KeywordNightVisionMod))
						PowerSound.Play(playerREF)
						playerREF.AddSpell(NightVisionAbilitySpell, false)
						CurrentVisualEffect = NightVisionAbilitySpell
					;Night Vision 2x
					ElseIf(Self.HasKeyword(KeywordNightVisionMod2X))
						PowerSound.Play(playerREF)
						playerREF.AddSpell(NightVisionAbilitySpell2X, false)
						CurrentVisualEffect = NightVisionAbilitySpell2X
					;Night Vision 3x
					ElseIf(Self.HasKeyword(KeywordNightVisionMod3X))
						PowerSound.Play(playerREF)
						playerREF.AddSpell(NightVisionAbilitySpell3X, false)
						CurrentVisualEffect = NightVisionAbilitySpell3X
					;Thermal Vision
					ElseIf(Self.HasKeyword(KeywordThermalVisionMod))
						PowerSound.Play(playerREF)
						playerREF.AddSpell(ThermalVisionAbilitySpell, false)
						CurrentVisualEffect = ThermalVisionAbilitySpell
					;Thermal Vision 2x
					ElseIf(Self.HasKeyword(KeywordThermalVisionMod2X))
						PowerSound.Play(playerREF)
						playerREF.AddSpell(ThermalVisionAbilitySpell2X, false)
						CurrentVisualEffect = ThermalVisionAbilitySpell2X
					;Targeting HUD
					ElseIf(Self.HasKeyword(KeywordTargetingHUDMod))
						PowerSound.Play(playerREF)
						playerREF.AddSpell(TargetingHUDAbilitySpell, false)
						CurrentVisualEffect = TargetingHUDAbilitySpell					
					EndIf					
					
				EndIf

				; Do this for both normal and cycle mode
				
				;Check if the goggles are in the inactive state (on the forehead typically).  If they are, put the goggles into a state to safely attach/remove mods (the game auto unequip/re-equip and re-runs code).
				;If this is true the item is on the forehead and we need to remove the mod that does it
				
				If(Self.HasKeyword(KeywordHasForeheadModAttached))
					
					;Prevent the equip/unequip code from re-running
					GoToState("SwapModState")
					
					;Remove the mod that puts the goggles up on the forehead so they go back over the eyes -- can't do this on unequip because removing a mod re-equips the item automatically!
					Self.RemoveMod(MODModelSwapInactive)
					Utility.Wait(0.2) ;tested at 14fps and this was enough, so...
					
					;Assuming the engine's automatic unequip/equip is done, we can go back to the normal state
					GoToState("InitialEquipState")
					
				EndIf
				
				

			EndIf

	EndEvent	
	
	Event OnUnequipped(Actor akActor)
	
		EquipSound.Play(akActor)
	
		If(akActor == playerREF && self.HasKeyword(KeywordHasEffectAny))
				
			ClearAllEffects()
			CurrentVisualEffect = None
			CurrentLensColor = None
			CycleFunctionLocked = False ;unlock all functions because the Pip-Boy gets stuck for some reason
			
			;Favorite-switching between two goggles can cause a race condition here so let's only set this to NONE if the current goggles are Self
			
			If(ControlQuest.CurrentGoggles == Self)
				ControlQuest.CurrentGoggles = None
			EndIf
			
			;Another workaround -- because attaching mods equips/unequips, the sounds play rapidly atop each other. I set them to silent, and manually control the sound here.
			PowerOffSound.Play(playerREF)
			
			arrayVisionModeCurrentPosition = 0 ;reset the cycle position even if we're not using the cycle mode
			
		EndIf

	EndEvent
	
EndState

;The engine automatically unequips/re-equips an item when an OMOD is attached so I have to handle that.  This state is used to prevent any code from running when OMODS are attached here or in the parent quest.
;Dear Bethesda, WHY U DO DIS? :)  Thankfully states work for this situation!
State SwapModState

	Event OnEquipped(Actor akActor)
		;Do Nothing
	EndEvent

	Event OnUnequipped(Actor akActor)
		;Do Nothing
	EndEvent

EndState

;====================================
; RE-BUILD VISION CYCLE ARRAYS
;====================================
Function RebuildVisionModeArrays()
	;initialize vision mode arrays (that sounds cyber af to say)
	
	If(Self.HasKeyword(KeywordMultiVision_ALL))

		arrayVisionModes = new Spell[6]
		arrayVisionModes[0] = NightVisionAbilitySpell
		arrayVisionModes[1] = NightVisionAbilitySpell2X
		arrayVisionModes[2] = NightVisionAbilitySpell3X
		arrayVisionModes[3] = ThermalVisionAbilitySpell
		arrayVisionModes[4] = ThermalVisionAbilitySpell2X
		arrayVisionModes[5] = TargetingHUDAbilitySpell
		
		arrayLensColors = new ObjectMod[6]
		arrayLensColors[0] = MODLensGreen
		arrayLensColors[1] = MODLensGreen
		arrayLensColors[2] = MODLensGreen	
		arrayLensColors[3] = MODLensRed	
		arrayLensColors[4] = MODLensRed	
		arrayLensColors[5] = MODLensYellow	
		
	ElseIf(Self.HasKeyword(KeywordMultiVision_Standard))
		
		arrayVisionModes = new Spell[3]
		arrayVisionModes[0] = NightVisionAbilitySpell
		arrayVisionModes[1] = ThermalVisionAbilitySpell
		arrayVisionModes[2] = TargetingHUDAbilitySpell
		
		arrayLensColors = new ObjectMod[3]
		arrayLensColors[0] = MODLensGreen
		arrayLensColors[1] = MODLensRed
		arrayLensColors[2] = MODLensYellow	
		
	ElseIf(Self.HasKeyword(KeywordMultiVision_NightThermal))
		
		arrayVisionModes = new Spell[2]
		arrayVisionModes[0] = NightVisionAbilitySpell
		arrayVisionModes[1] = ThermalVisionAbilitySpell
		
		arrayLensColors = new ObjectMod[2]
		arrayLensColors[0] = MODLensGreen
		arrayLensColors[1] = MODLensRed
		
	EndIf

EndFunction


;====================================
; CYCLE VISION MODE - this is called internally
;====================================

;When in the pip-boy, equip and unequip events are running in two separate refs or threads or who KNOWS what the hell, so I need a separate equip mode
Function InitialEquipCycleMode()

	;debug.messagebox("Initial cycle Equip Function")
	
	If(CycleFunctionLocked==False)
		CycleFunctionLocked = True ;stops key spam
		ClearAllEffects()
		arrayVisionModeCurrentPosition = 0
		CurrentVisualEffect = arrayVisionModes[0]
		playerREF.AddSpell(CurrentVisualEffect, False)
		;debug.messagebox("right after spell code")
		PowerSound.Play(playerREF)
		arrayVisionModeCurrentPosition = 1

		If(Self.HasKeyword(KeywordLensOverride))
			Utility.Wait(0.1)
			GoToState("SwapModState")
			CurrentLensColor = arrayLensColors[0]
			Self.AttachMod(CurrentLensColor)
			Utility.Wait(0.1)
			GoToState("InitialEquipState")
		EndIf
		
		CycleFunctionLocked = False
	EndIf
EndFunction

Function CycleVisionModes()

	If(CycleFunctionLocked==False)
		CycleFunctionLocked = True ;stops key spam
		
		;MOVE TO NEXT VISION MODE
		If(arrayVisionModeCurrentPosition < arrayVisionModes.Length)
			ClearAllEffects()
			CurrentVisualEffect = arrayVisionModes[arrayVisionModeCurrentPosition]
			
			If(arrayVisionModeCurrentPosition == 0)
				PowerSound.Play(playerREF)
			Else
				CycleSound.Play(playerREF)
			EndIf
			
			playerREF.AddSpell(CurrentVisualEffect, False)
			
			If(Self.HasKeyword(KeywordLensOverride) || Self.HasKeyword(KeywordHasForeheadModAttached))
				Utility.Wait(0.1)
				GoToState("SwapModState")
				If(self.HasKeyword(KeywordLensOverride))
					CurrentLensColor = arrayLensColors[arrayVisionModeCurrentPosition]
					Self.AttachMod(CurrentLensColor)
				EndIf

				If(Self.HasKeyword(KeywordHasForeheadModAttached))	
					Self.RemoveMod(MODModelSwapInactive)
				EndIf
				
				Utility.Wait(0.1)
				GoToState("InitialEquipState")				
			EndIf
			
			arrayVisionModeCurrentPosition += 1
		
		;TURN OFF GOGGLES (end of effect list)
		Else
		
			PowerOffSound.Play(playerREF)
			ClearAllEffects()
			
			If(self.HasKeyword(KeywordLensOverride) || Self.HasKeyword(KeywordInactivePosition_Forehead))		
				Utility.Wait(0.1)
				GoToState("SwapModState")
			EndIf
			
			If(self.HasKeyword(KeywordLensOverride))
				Self.AttachMod(MODLensOff) ;remove the lens glow
				CurrentLensColor = None
			EndIf
			
			If(Self.HasKeyword(KeywordInactivePosition_Forehead))
				Self.AttachMod(MODModelSwapInactive)
			EndIf

			Utility.Wait(0.1)
			GoToState("InitialEquipState")
			
			arrayVisionModeCurrentPosition = 0 ;reset the cycle to beginning
		
		EndIf
		
		CycleFunctionLocked = False ;unlock for next keypress
		
	EndIf
EndFunction


;=========================================
; VISION TOGGLE - This is called from the parent Quest
;=========================================

Function VisionToggle()


		;=========================================
		;Special use case for multi vision mod, divert to separate function
		;VisionToggle is called from the parent quest via hotkey or chem so we have to do the split here
		;==========================================
		
		;If this has the cycle vision mode, use the different function
		If(self.HasKeyword(KeywordMultiVisionMod))
		
			CycleVisionModes()
			
		;If we're using standard 1-effect goggles, use the regular method
		ElseIf(self.HasKeyword(KeywordHasEffectAny) && CurrentVisualEffect)  ;Only bother if the goggles actually have any effects and they're actually applied
			
				;TURN OFF
				If(playerREF.HasSpell(CurrentVisualEffect))
					PowerOffSound.Play(playerREF)
					playerREF.RemoveSpell(CurrentVisualEffect)

					;Only run if the player modded the goggles to move up onto the forehead
					If(Self.HasKeyword(KeywordInactivePosition_Forehead))
						;Put goggles into safe state for mod attach/removal
						GoToState("SwapModState")
						;Attach the mod that moves the goggles up onto the forehead
						Self.AttachMod(MODModelSwapInactive)
						Utility.Wait(0.2)
						;Go back to the state where equip/unequip code runs normally
						GoToState("InitialEquipState")
					EndIf
					
				;TURN ON
				Else
					
					;Only run if the goggles actually have the forehead mod attached
					If(Self.HasKeyword(KeywordHasForeheadModAttached))					
						;Prevent the equip/unequip code from re-running
						GoToState("SwapModState")
						;Remove the mod that puts the goggles up on the forehead so they go back over the eyes -- can't do this on unequip because removing a mod re-equips the item automatically!
						Self.RemoveMod(MODModelSwapInactive)
						Utility.Wait(0.2)
						;Assuming the engine's automatic unequip/equip is done, we can go back to the normal state
						GoToState("InitialEquipState")
					EndIf
					
					playerREF.AddSpell(CurrentVisualEffect, False)
					PowerSound.Play(playerREF)
					
					
				EndIf
		Else
			ErrorSound.Play(playerREF) ;If the user starts going nutzo with equip stuff this buzzer will sound (good for bug reports) 
		EndIf

EndFunction 


Function MoveGogglesToInactivePosition()
	;stub
EndFunction

Function MoveGogglesToActivePosition()
	;stub
EndFunction


;This is just a clean safeguard in case there's some race condition that stacks them, and ImageSpaces are nothing to trifle with.
Function ClearAllEffects()
	playerREF.RemoveSpell(NightVisionAbilitySpell)
	playerREF.RemoveSpell(NightVisionAbilitySpell2X)
	playerREF.RemoveSpell(NightVisionAbilitySpell3X)
	playerREF.RemoveSpell(ThermalVisionAbilitySpell)
	playerREF.RemoveSpell(ThermalVisionAbilitySpell2X)
	playerREF.RemoveSpell(TargetingHUDAbilitySpell)
	CurrentVisualEffect = None
EndFunction 

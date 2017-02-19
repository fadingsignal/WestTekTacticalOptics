ScriptName WestTekTacticalGoggles:WestTek_OnReadEnableGoggleCrafting extends ObjectReference

;-- Properties --------------------------------------
Message Property CraftingMessage Auto
GlobalVariable Property CraftingEnabled Auto
GlobalVariable Property WestTek_SaleItemsGated Auto

;-- Functions ---------------------------------------

Event OnRead()
	If (CraftingEnabled.GetValue() as bool == False)
		CraftingMessage.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)
	EndIf
	
	CraftingEnabled.SetValue(1)
	WestTek_SaleItemsGated.SetValue(20)
EndEvent




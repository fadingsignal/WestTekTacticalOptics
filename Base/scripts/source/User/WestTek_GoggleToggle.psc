ScriptName WestTek_GoggleToggle extends ObjectReference

;When user equips, check to see if this item is already equipped
;How? Base items are not distinguished from each other, maybe "As Form" will have the formID?
;I can add a temporary keyword WestTek_CurrentlyEquipped?
;Let's try the regular way first to see if it flips Outfit

Event OnEquipped(Actor akActor)
	debug.MessageBox("equip event")
EndEvent

Event OnActivate(ObjectReference akActionRef)
	debug.MessageBox("equip event")
EndEvent


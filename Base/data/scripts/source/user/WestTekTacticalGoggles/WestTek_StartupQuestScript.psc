Scriptname WestTekTacticalGoggles:WestTek_StartupQuestScript extends Quest
{Adds tactical optics to leveled lists via script to avoid conflicts with other mods.}

;-- Properties ---------------------------------
;Gunner leveled lists
Group Lists_Vanilla
	LeveledItem Property LLI_Armor_Gunner_Outfit Auto Const
	LeveledItem Property LLI_Armor_Gunner_Outfit_Arms100 Auto Const
	LeveledItem Property LLI_Armor_Gunner_Outfit_All Auto Const
	LeveledItem Property LL_Armor_Gunner_Facegear_50 Auto Const
	LeveledItem Property LL_Armor_Piecemeal_Helmets Auto Const
	LeveledItem Property CreatureOutfit_Supermutant_Hats Auto Const
	LeveledItem Property LL_Armor_Raider_Helmets Auto Const
EndGroup

Group Lists_WestTek
	LeveledItem Property WestTek_LLI_OpticsAny_Gunner_90 Auto Const
	LeveledItem Property WestTek_LLI_OpticsRaiderSuperMutants_50 Auto Const
	LeveledItem Property WestTek_VendorList_TacticalOptics_80 Auto Const
	LeveledItem Property WestTek_LLI_Mods_Vendor Auto Const
	LeveledItem Property WestTek_LLI_Mods_PA_Vendor Auto Const
	LeveledItem Property WestTek_LLI_Optics_Chinese_100 Auto Const
EndGroup

Group Containers_Vanilla
	ObjectReference Property VendorBoSTeagan Auto Const
	ObjectReference Property VendorCaravanCricketWeapons Auto Const
	ObjectReference Property VendorCaravanLucasArmor Auto Const
	ObjectReference Property VendorGoodneighborKillorBeKilled Auto Const
	ObjectReference Property YangtzeChest Auto Const
EndGroup


;-- Functions ---------------------

Event OnInit()
	debug.Notification("West Tek Tactical Optics is installed.")
	
	;GUNNERS
	LLI_Armor_Gunner_Outfit.AddForm(LL_Armor_Gunner_Facegear_50 as Form, 1, 1)
	LLI_Armor_Gunner_Outfit_Arms100.AddForm(LL_Armor_Gunner_Facegear_50 as Form, 1, 1)
	LLI_Armor_Gunner_Outfit_All.AddForm(LL_Armor_Gunner_Facegear_50 as Form, 1, 1)
	LL_Armor_Gunner_Facegear_50.AddForm(WestTek_LLI_OpticsAny_Gunner_90 as Form, 1, 1)
	
	;RAIDERS
	LL_Armor_Piecemeal_Helmets.AddForm(WestTek_LLI_OpticsRaiderSuperMutants_50 as Form, 14, 1)
	LL_Armor_Raider_Helmets.AddForm(WestTek_LLI_OpticsRaiderSuperMutants_50 as Form, 14, 1)
	
	;SUPER MUTANTS
	CreatureOutfit_Supermutant_Hats.AddForm(WestTek_LLI_OpticsRaiderSuperMutants_50 as Form, 14, 1)
	
	;VENDORS
	VendorBoSTeagan.AddItem(WestTek_VendorList_TacticalOptics_80 as Form, 2, true)
	VendorBoSTeagan.AddItem(WestTek_LLI_Mods_PA_Vendor as Form, 2, true)
	VendorBoSTeagan.AddItem(WestTek_LLI_Mods_Vendor as Form, 2, true)
	
	VendorCaravanCricketWeapons.AddItem(WestTek_VendorList_TacticalOptics_80 as Form, 2, true)
	VendorCaravanCricketWeapons.AddItem(WestTek_LLI_Mods_Vendor as Form, 2, true)
	
	VendorCaravanLucasArmor.AddItem(WestTek_VendorList_TacticalOptics_80 as Form, 2, true)
	VendorCaravanLucasArmor.AddItem(WestTek_LLI_Mods_Vendor as Form, 2, true)
	
	VendorGoodneighborKillorBeKilled.AddItem(WestTek_VendorList_TacticalOptics_80 as Form, 2, true)
	VendorGoodneighborKillorBeKilled.AddItem(WestTek_LLI_Mods_Vendor as Form, 2, true)
	
	;YANGTZE CHEST (Chinese Optics)
	YangtzeChest.AddItem(WestTek_LLI_Optics_Chinese_100 as Form, 1, true)
	
EndEvent 

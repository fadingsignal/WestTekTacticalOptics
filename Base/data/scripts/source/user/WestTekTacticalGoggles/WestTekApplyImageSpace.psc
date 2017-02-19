Scriptname WestTekTacticalGoggles:WestTekApplyImageSpace extends activemagiceffect
{Used to apply and remove image spaces for the various vision modes.}


ImageSpaceModifier Property VisualEffectImageSpace Auto Const

;NOTE: I made this because I was previously re-using the night-eye effect which had intro/outro fades, and such, which is what I think is causing the rare "blackout" problem when people are using night vision scopes with night vision goggles.  I think the outro that starts black and fades back to normal just doesn't play, so "PopTo" may not be working right in certain scenarios.  Simple on/off switch is better for stability at the cost of cool fx.

Event OnEffectStart(Actor Target, Actor Caster)
	VisualEffectImageSpace.remove() ;just to be clean about it and not double stack
	VisualEffectImageSpace.Apply(1.0) ;full strumf
EndEvent

Event OnEffectFinish(Actor Target, Actor Caster)
	VisualEffectImageSpace.remove() ;just to be clean about it and not double stack
EndEvent 
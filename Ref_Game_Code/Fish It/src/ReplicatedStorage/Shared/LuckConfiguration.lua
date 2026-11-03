-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	CastsToMax = 12000,
	MaxPityAdditive = 30,
	Steepness = 4,
	LifetimeGate = 50,
	AFKPityRate = 0.75,
	PityRate = 1,
	MaxFreeLuckAdditive = 200,
	MaxStoredCrumbs = 50,
	ResetTierThreshold = 7,
	GoodDropTier = 6,
	Crumbs = {
		LoginGap = {
			Enabled = true,
			Uses = 15,
			GapSeconds = 172800,
			FreeLuck = 0.3,
			Value = 1.6
		},
		RobuxPurchase = {
			Enabled = true,
			Uses = 5,
			MinRobux = 400,
			FreeLuck = 0.5,
			Value = 2.2,
			Delay = NumberRange.new(30, 180)
		},
		FirstVisit = {
			Enabled = false,
			Uses = 15,
			FreeLuck = 0,
			Value = 0
		},
		DryStreak = {
			Enabled = true,
			Uses = 5,
			Threshold = 3000,
			ChancePerCast = 0.2,
			FreeLuck = 0.1,
			Value = 1.7,
			RequireLifetimeGate = false,
			LifetimeGate = 1000
		}
	}
}
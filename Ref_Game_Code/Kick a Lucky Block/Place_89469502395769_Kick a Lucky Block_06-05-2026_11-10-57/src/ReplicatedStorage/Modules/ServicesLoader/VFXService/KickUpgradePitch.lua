-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local PitchShiftSoundEffect = game:GetService("SoundService").Effects.KickUpgrade:WaitForChild("PitchShiftSoundEffect")
local v1 = nil
local v2 = 0
return {
	Apply = function() --[[ Apply | Line: 22 | Upvalues: v1 (ref), v2 (ref), PitchShiftSoundEffect (copy) ]]
		if v1 and tick() - v1 > 1 then
			v2 = 0
		end
		PitchShiftSoundEffect.Octave = math.min(v2 * 0.01 + 1, 2)
		v1 = tick()
		v2 = v2 + 1
	end,
	Reset = function() --[[ Reset | Line: 35 | Upvalues: v2 (ref), PitchShiftSoundEffect (copy) ]]
		v2 = 0
		PitchShiftSoundEffect.Octave = 1
	end
}
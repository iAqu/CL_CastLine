-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	Default = {
		Velocity = Vector3.new(1, 1, 100),
		MinSpeedMult = 0.1,
		MaxSpeedMult = 1.3,
		FadeIn = 0.8,
		FadeOut = 1,
		Resolution = 2,
		Contrast = 1.1,
		TrailLife = 1,
		NoiseStrength = function(p1) --[[ NoiseStrength | Line: 26 ]]
			return p1 ^ 2.5
		end,
		VelocityDrag = function(p1) --[[ VelocityDrag | Line: 29 ]]
			return p1
		end
	},
	Explosion = {
		Velocity = Vector3.new(1, 1, 300),
		MinSpeedMult = 0.3,
		MaxSpeedMult = 1.3,
		FadeIn = 0.8,
		FadeOut = 1,
		Resolution = 2,
		Contrast = 10,
		NoiseStrength = function(p1) --[[ NoiseStrength | Line: 42 ]]
			return p1 ^ 2
		end,
		VelocityDrag = function(p1) --[[ VelocityDrag | Line: 45 ]]
			return p1 - Vector3.new(0, 0, 10)
		end
	},
	Swirl = {
		Velocity = Vector3.new(1, 1, 300),
		MinSpeedMult = 0.3,
		MaxSpeedMult = 1.3,
		FadeIn = 0.8,
		FadeOut = 1,
		Resolution = 2,
		Contrast = 14,
		NoiseStrength = function(p1) --[[ NoiseStrength | Line: 58 ]]
			return p1 ^ 2
		end,
		VelocityDrag = function(p1) --[[ VelocityDrag | Line: 61 ]]
			return p1 - Vector3.new(0, 0, 10)
		end
	},
	Spring = {
		Velocity = Vector3.new(1, 1, 120),
		MinSpeedMult = 0.3,
		MaxSpeedMult = 1.3,
		FadeIn = 0.8,
		FadeOut = 1,
		Resolution = 2,
		Contrast = 1.1,
		NoiseStrength = function(p1) --[[ NoiseStrength | Line: 74 ]]
			return p1 ^ 5
		end,
		VelocityDrag = function(p1) --[[ VelocityDrag | Line: 77 ]]
			return p1 - Vector3.new(0, 0, 2)
		end
	},
	Line = {
		Velocity = Vector3.new(1, 1, 100),
		MinSpeedMult = 0.3,
		MaxSpeedMult = 1.3,
		FadeIn = 0.8,
		FadeOut = 1,
		Resolution = 2,
		Contrast = 1.5,
		NoiseStrength = function(p1) --[[ NoiseStrength | Line: 90 ]]
			return p1 ^ 2
		end,
		VelocityDrag = function(p1) --[[ VelocityDrag | Line: 93 ]]
			return p1
		end
	},
	LineDrag = {
		Velocity = Vector3.new(1, 1, 120),
		MinSpeedMult = 0.3,
		MaxSpeedMult = 1.3,
		FadeIn = 0.8,
		FadeOut = 1,
		Resolution = 2,
		Contrast = 1.5,
		NoiseStrength = function(p1) --[[ NoiseStrength | Line: 106 ]]
			return p1 ^ 2
		end,
		VelocityDrag = function(p1) --[[ VelocityDrag | Line: 109 ]]
			return p1 - Vector3.new(0, 0, 5)
		end
	},
	Static = {
		Velocity = Vector3.new(0, 0, 0),
		MinSpeedMult = 1,
		MaxSpeedMult = 1,
		FadeIn = 1,
		FadeOut = 1,
		Resolution = 2,
		Contrast = 1.1,
		NoiseStrength = function(p1) --[[ NoiseStrength | Line: 122 ]]
			return p1 ^ 2.5
		end,
		VelocityDrag = function(p1) --[[ VelocityDrag | Line: 125 ]]
			return p1
		end
	}
}
setmetatable(t, {
	__index = function(p1, p2) --[[ __index | Line: 132 ]]
		error(string.format("%q is not a valid member of %q", tostring(p2), script.Name), 2)
	end
})
return t
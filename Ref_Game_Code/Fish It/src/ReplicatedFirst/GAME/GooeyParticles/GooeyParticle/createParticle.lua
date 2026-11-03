-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local HttpService = game:GetService("HttpService")
local conditionalProperty = require(script.Parent.Parent.Utility.conditionalProperty)
require(script.Parent.Parent.Utility.Types)
local v1 = Random.new()
local function getParticleLifetime(p1) --[[ getParticleLifetime | Line: 12 | Upvalues: v1 (copy) ]]
	if typeof(p1) == "number" then
		return p1
	else
		return v1:NextNumber(p1.Min, p1.Max)
	end
end
local function getParticleVelocity(p1, p2) --[[ getParticleVelocity | Line: 20 | Upvalues: v1 (copy) ]]
	local v12 = v1:NextNumber(p1.Min, p1.Max)
	return Vector2.new(math.cos((math.rad(v12))) * p2, math.sin((math.rad(v12))) * p2) * 5
end
local function createParticleObject(p1, p2) --[[ createParticleObject | Line: 28 | Upvalues: conditionalProperty (copy) ]]
	local ImageLabel = Instance.new("ImageLabel")
	ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Image = p2.Image
	ImageLabel.ZIndex = p2.ZIndex
	conditionalProperty(ImageLabel, if typeof(p2.Size) == "number" then true else false, "Size", UDim2.fromOffset(p2.Size, p2.Size))
	conditionalProperty(ImageLabel, if typeof(p2.Transparency) == "number" then true else false, "ImageTransparency", p2.Transparency)
	conditionalProperty(ImageLabel, if typeof(p2.Color) == "Color3" then true else false, "ImageColor3", p2.Color)
	ImageLabel.Parent = p1
	return ImageLabel
end
return function(p1) --[[ createParticle | Line: 42 | Upvalues: HttpService (copy), v1 (copy), createParticleObject (copy) ]]
	local v12 = HttpService:GenerateGUID(false)
	local Lifetime = p1.props.Lifetime
	local v2 = if typeof(Lifetime) == "number" then Lifetime else v1:NextNumber(Lifetime.Min, Lifetime.Max)
	local t = {
		lifetime = v2,
		obj = createParticleObject(p1.container, p1.props),
		remove = function() --[[ remove | Line: 49 | Upvalues: p1 (copy), v12 (copy) ]]
			p1.particles[v12] = nil
		end,
		rotation = v1:NextNumber(p1.props.Rotation.Min, p1.props.Rotation.Max),
		spawnedAt = os.clock(),
		position = Vector2.new(0, 0)
	}
	local Spread = p1.props.Spread
	local Speed = p1.props.Speed
	local v4 = v1:NextNumber(Spread.Min, Spread.Max)
	t.velocity = Vector2.new(math.cos((math.rad(v4))) * Speed, math.sin((math.rad(v4))) * Speed) * 5
	p1.particles[v12] = t
end
local Workspace = game:GetService("Workspace")
local Config = require(script.Parent.FishingConfig)
local MutationDataUtil = require(script.Parent.MutationDataUtil)
local RainbowCastTrail = require(script.Parent.RainbowCastTrail)

local FishingMutationTrail = {}
FishingMutationTrail.__index = FishingMutationTrail

function FishingMutationTrail.new(bite, now)
	local mutation = bite.mutationId
	if bite.isEgg or (mutation ~= "Golden" and mutation ~= "Diamond" and mutation ~= "Rainbow") then
		return nil
	end
	local body = bite.fish.PrimaryPart
	local min, max = Vector3.one * math.huge, Vector3.one * -math.huge
	local found = false
	for part in pairs(bite.originals) do
		local relative = body.CFrame:ToObjectSpace(part.CFrame)
		for _, x in ipairs({ -0.5, 0.5 }) do
			for _, y in ipairs({ -0.5, 0.5 }) do
				for _, z in ipairs({ -0.5, 0.5 }) do
					local point = relative:PointToWorldSpace(part.Size * Vector3.new(x, y, z))
					min = Vector3.new(math.min(min.X, point.X), math.min(min.Y, point.Y), math.min(min.Z, point.Z))
					max = Vector3.new(math.max(max.X, point.X), math.max(max.Y, point.Y), math.max(max.Z, point.Z))
					found = true
				end
			end
		end
	end
	if not found then
		return nil
	end
	local size, settings = max - min, Config.Bite.MutationTrail
	local width = math.max(settings.MinWidth, size.X * settings.WidthRatio)
	local colors = Config.CastRainbow
	if mutation ~= "Rainbow" then
		local color = MutationDataUtil.GetLabelColor(mutation)
		colors = { { color.R * 255, color.G * 255, color.B * 255 } }
	end
	local self = setmetatable({
		bite = bite,
		center = (min + max) * 0.5 / bite.scale,
		ribbon = RainbowCastTrail.new(bite.owner.folder, {
			Width = width,
			EdgeWidth = width / settings.EdgeDivisor,
			Lifetime = settings.Lifetime,
			MaxLength = math.max(settings.MinLength, math.max(size.X, size.Y, size.Z) * settings.LengthRatio),
		}, colors),
	}, FishingMutationTrail)
	self.ribbon:Start(body.CFrame:PointToWorldSpace(self.center * bite.scale), Workspace.CurrentCamera.CFrame, now)
	return self
end

function FishingMutationTrail:Update(now, rising)
	if self.destroyed then
		return false
	end
	if not rising then
		self.ribbon:Stop(now)
	end
	local bite = self.bite
	if not bite.fish.Parent or not bite.fish.PrimaryPart then
		self:Destroy()
		return false
	end
	local position = bite.fish.PrimaryPart.CFrame:PointToWorldSpace(self.center * bite.scale)
	if not self.ribbon:Update(position, Workspace.CurrentCamera.CFrame, now) then
		self:Destroy()
		return false
	end
	return true
end

function FishingMutationTrail:Destroy()
	if self.destroyed then
		return
	end
	self.destroyed = true
	self.ribbon:Destroy()
	self.bite = nil
end

return FishingMutationTrail

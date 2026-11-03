-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Packages.Net)
local Trove = require(ReplicatedStorage.Packages.Trove)
local spr = require(ReplicatedStorage.Packages.spr)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local v1 = Net:RemoteEvent("CollisionError")
local t = {
	Boat = {
		Message = "Unable to spawn boat!",
		TextColor = {
			R = 255,
			G = 0,
			B = 0
		}
	}
}
local t2 = {}
function t2.Init(p1) --[[ Init | Line: 36 | Upvalues: v1 (copy), t2 (copy) ]]
	v1.OnClientEvent:Connect(t2._reportCollision)
end
function t2._reportCollision(p1) --[[ _reportCollision | Line: 40 | Upvalues: Trove (copy), t (copy), TextNotificationController (copy) ]]
	local v1 = p1.CustomDuration or 4
	local v2 = Trove.new()
	for i, v in ipairs(p1.Collisions) do
		v2:Add(RenderDebug(v.Size + Vector3.new(3, 3, 3), v.CFrame))
	end
	if p1.Hitbox then
		v2:Add(RenderDebug(p1.Hitbox.Size, p1.Hitbox.CFrame))
	end
	local v3 = t[p1.Type]
	if v3 then
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = v3.Message,
			TextColor = v3.TextColor,
			CustomDuration = v1
		})
	end
	task.delay(v1, function() --[[ Line: 68 | Upvalues: v2 (ref) ]]
		v2:Destroy()
		v2 = nil
	end)
end
function RenderDebug(p1, p2) --[[ RenderDebug | Line: 74 | Upvalues: spr (copy) ]]
	local Collide = Instance.new("Part")
	Collide.Name = "Collide"
	Collide.Anchored = true
	Collide.CanCollide = false
	Collide.CanQuery = false
	Collide.CanTouch = false
	Collide.CastShadow = false
	Collide.AudioCanCollide = false
	Collide.EnableFluidForces = false
	Collide.TopSurface = Enum.SurfaceType.Smooth
	Collide.BottomSurface = Enum.SurfaceType.Smooth
	Collide.CFrame = p2
	Collide.Size = p1
	Collide.Color = Color3.fromRGB(255, 0, 0)
	Collide.Material = Enum.Material.Neon
	Collide.Transparency = 0.8
	local SelectionBox = Instance.new("SelectionBox")
	SelectionBox.Color3 = Color3.fromRGB(255, 0, 0)
	SelectionBox.SurfaceTransparency = 1
	SelectionBox.Transparency = 0
	SelectionBox.LineThickness = 0.1
	SelectionBox.SurfaceColor3 = Color3.new(0/255, 0/255, 0/255)
	SelectionBox.Adornee = Collide
	SelectionBox.Parent = Collide
	Collide.Parent = workspace.CurrentCamera
	return function() --[[ Line: 103 | Upvalues: spr (ref), Collide (copy), SelectionBox (copy) ]]
		spr.target(Collide, 1, 3, {
			Transparency = 1
		})
		spr.target(SelectionBox, 1, 3, {
			Transparency = 1
		})
		spr.completed(SelectionBox, function() --[[ Line: 111 | Upvalues: SelectionBox (ref), Collide (ref) ]]
			SelectionBox:Destroy()
			Collide:Destroy()
		end)
	end
end
return t2
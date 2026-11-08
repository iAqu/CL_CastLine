-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- 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

-- https://lua.expert/
game:GetService("RunService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Info = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info")
local Effects = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Gui"):WaitForChild("Effects")
local Maid = require(Packages:WaitForChild("Maid"))

require(Info:WaitForChild("Images"))

local ArrowImage = Effects:WaitForChild("ArrowImage")
local t = {}

return function(p1) --[[ Line: 26 | Upvalues: t (copy), Maid (copy), ArrowImage (copy), TweenService (copy) ]]
	p1.DIRECTIONS = {
		BELOW = "BELOW"
	}
	function p1.AddPointArrow(p1, p2, p3, p4, p5, p6, p7) --[[ AddPointArrow | Line: 36 | Upvalues: t (ref), Maid (ref), ArrowImage (ref), TweenService (ref) ]]
		if t[p2] then
			return
		end

		t[p2] = {}
		t[p2].maid = Maid.new()

		local v1 = ArrowImage:Clone()

		v1.ImageColor3 = p6
		t[p2].arrow = v1
		v1.ZIndex = p2.ZIndex + 1
		v1.Parent = p2
		v1.Size = p4

		local v2, v3, v4

		if p7 == p1.DIRECTIONS.BELOW then
			v2 = p3 + UDim2.fromScale(0, p5)
			v3, v4 = 0, Vector2.new(0.5, 1)
		else
			v3 = nil
			v4 = nil
			v2 = nil
		end

		v1.Rotation = v3
		v1.Position = p3
		v1.AnchorPoint = v4

		local v6 = TweenService:Create(v1, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {
			Position = v2
		})

		v6:Play()
		t[p2].maid:GiveTask(function() --[[ Line: 72 | Upvalues: v6 (copy), v1 (copy) ]]
			if v6 then
				v6:Cancel()
			end

			if not v1 then
				return
			end

			v1:Destroy()
		end)
	end
	function p1.RemovePointArrow(p1, p2) --[[ RemovePointArrow | Line: 80 | Upvalues: t (ref) ]]
		if not t[p2] then
			return
		end

		t[p2].maid:Destroy()
		t[p2] = nil
	end
end
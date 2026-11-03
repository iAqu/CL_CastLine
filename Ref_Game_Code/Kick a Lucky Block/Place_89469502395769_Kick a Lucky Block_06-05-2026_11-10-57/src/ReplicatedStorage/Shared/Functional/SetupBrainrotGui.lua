-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TimerService = require(ReplicatedStorage.Modules.ServicesLoader.TimerService)
local MutationService = require(ReplicatedStorage.Shared.Services.MutationService)
local RarityData = require(ReplicatedStorage.Shared.Data.RarityData)
local MutationData = require(ReplicatedStorage.Shared.Data.MutationData)
local EntitiesData = require(ReplicatedStorage.Shared.Data.EntitiesData)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local InfiniteMath = require(ReplicatedStorage.Shared.Utility.InfiniteMath)
local EntityGUI = ReplicatedStorage.Objects.GUI.EntityGUI
local CurrentCamera = workspace.CurrentCamera
local SurfaceGUIs = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("SurfaceGUIs")
return function(p1, p2, p3, p4, p5) --[[ Line: 26 | Upvalues: EntitiesData (copy), Trove (copy), ReplicatedStorage (copy), MutationService (copy), MutationData (copy), InfiniteMath (copy), TimerService (copy), CurrentCamera (copy), RarityData (copy), SurfaceGUIs (copy) ]]
	local v1 = EntitiesData.Brainrots[p1.Name]
	if v1 then
		local v2 = Trove.new()
		local t = {}
		local CPS = v1.CPS
		local v3 = nil
		local v4 = v2:Clone(ReplicatedStorage.Objects.GUI.EntityGUI)
		local Frame = v4:WaitForChild("Frame")
		local NameLabel = Frame:WaitForChild("NameLabel")
		local Label = Frame:WaitForChild("CPSFrame"):WaitForChild("Label")
		local Label_2 = Frame:WaitForChild("TimerFrame"):WaitForChild("Label")
		local MutationLabel = Frame:WaitForChild("MutationLabel")
		local RarityLabel = Frame:WaitForChild("RarityLabel")
		NameLabel.Text = p1.Name
		local function UpdateMutations() --[[ UpdateMutations | Line: 53 | Upvalues: CPS (ref), MutationLabel (copy), MutationService (ref), p1 (copy), MutationData (ref) ]]
			if CPS then
				local v1 = MutationService:GetMutationsFromInstance(p1)
				if v1[1] then
					local v2 = v1[1]
					CPS = CPS * MutationData.Buffs[v2].Value
					MutationLabel.Text = v2
					if MutationData.LabelFunctions[v2] then
						MutationData.LabelFunctions[v2](MutationLabel)
					end
					local v3 = MutationData.Index[v2]
					if v3 then
						MutationLabel.TextColor3 = v3.Color
					end
					MutationLabel.Visible = true
				else
					MutationLabel.Visible = false
				end
			else
				MutationLabel.Visible = false
			end
		end
		local function UpdateBillboardOffset() --[[ UpdateBillboardOffset | Line: 82 | Upvalues: v4 (copy), p1 (copy) ]]
			v4.StudsOffset = Vector3.new(0, p1.Root.Size.Y / 2 + 4, 0)
		end
		local function LevelUpdated() --[[ LevelUpdated | Line: 86 | Upvalues: CPS (ref), v1 (copy), Label (copy), p2 (copy), EntitiesData (ref), InfiniteMath (ref) ]]
			if CPS then
				Label.Text = ("$%*/s"):format((InfiniteMath.floor(CPS * EntitiesData.GetMultiplierPerLevel(if p2 then p2:GetAttribute("Level") or 1 else 1))))
			elseif v1.Best then
				Label.Text = math.floor(v1.Best * 100) .. "%"
			end
		end
		local function UpdateEndTime() --[[ UpdateEndTime | Line: 103 | Upvalues: p1 (copy), v3 (ref), v2 (copy), TimerService (ref), Label_2 (copy), CurrentCamera (ref), v4 (copy), Frame (copy) ]]
			local v1 = p1:GetAttribute("EndTime")
			if v1 then
				if v3 then
					v3:UpdateEndTime(v1)
				else
					v2:Construct(TimerService.AddTimer(Label_2, v1, nil, nil, function() --[[ Line: 110 | Upvalues: p1 (ref), CurrentCamera (ref), v4 (ref) ]]
						if p1 and p1.PrimaryPart then
							return (CurrentCamera.CFrame.Position - p1.Root.Position).Magnitude <= v4.MaxDistance + 10
						else
							return false
						end
					end))
				end
				Frame.TimerFrame.Visible = true
			elseif v3 then
				Frame.TimerFrame.Visible = false
				v3:Destroy()
				v3 = nil
			end
		end
		if CPS then
			CPS = InfiniteMath.floor(CPS)
			Label.Text = ("$%*/s"):format(CPS)
		else
			Label.Text = ("%%%*"):format(v1.Best * 100)
		end
		if p3 then
			v4.MaxDistance = 75
		end
		local Rarity = v1.Rarity
		if RarityData.Index[Rarity].transform_func then
			RarityData.Index[Rarity].transform_func(RarityLabel)
		end
		RarityLabel.Text = Rarity
		Frame.TimerFrame.Visible = false
		v4.Adornee = p1.Root
		if p4 then
			v4.Parent = p1.Root
		else
			v4.Parent = SurfaceGUIs
		end
		UpdateMutations()
		v4.StudsOffset = Vector3.new(0, p1.Root.Size.Y / 2 + 4, 0)
		LevelUpdated()
		UpdateEndTime()
		v2:Connect(p1:GetAttributeChangedSignal("EndTime"), UpdateEndTime)
		v2:Connect(p1:GetAttributeChangedSignal("Mutation"), UpdateMutations)
		v2:Connect(p1.Root:GetPropertyChangedSignal("Size"), UpdateBillboardOffset)
		if p2 then
			v2:Connect(p2:GetAttributeChangedSignal("Level"), LevelUpdated)
		end
		if p5 then
			v2:Connect(p5, function(p1) --[[ Line: 171 | Upvalues: v4 (copy) ]]
				v4.Enabled = p1
			end)
		end
		return function() --[[ Line: 176 | Upvalues: t (copy), v2 (copy) ]]
			for i, v in ipairs(t) do
				v:Disconnect()
			end
			v2:Destroy()
		end
	end
end
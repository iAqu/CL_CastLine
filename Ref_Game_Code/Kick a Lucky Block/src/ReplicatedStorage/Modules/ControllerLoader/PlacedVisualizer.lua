-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientPlotService = require(ReplicatedStorage.Modules.ServicesLoader.ClientPlotService)
local ClientBalanceService = require(ReplicatedStorage.Modules.ServicesLoader.ClientBalanceService)
local TweenService = game:GetService("TweenService")
local VFXService = require(ReplicatedStorage.Modules.ServicesLoader.VFXService)
local MessagesService = require(ReplicatedStorage.Modules.ServicesLoader.MessagesService)
local InfiniteMath = require(ReplicatedStorage.Shared.Utility.InfiniteMath)
local Tags = require(ReplicatedStorage.Shared.Data.Tags)
local EntitiesData = require(ReplicatedStorage.Shared.Data.EntitiesData)
require(ReplicatedStorage.Shared.Data.MutationData)
local LoadIdleAnimations = require(ReplicatedStorage.Shared.Functional.LoadIdleAnimations)
local SetupBrainrotGui = require(ReplicatedStorage.Shared.Functional.SetupBrainrotGui)
local FormatInfNumber = require(ReplicatedStorage.Functional.FormatInfNumber)
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local Observers = require(ReplicatedStorage.Shared.Packages.Observers)
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local v1 = CFrame.new(0, -0.5, -3.1, 1, 0, 0, 0, 0.923879743, -0.38268292, 0, 0.38268292, 0.923879743)
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local v2 = PlayerGui:FindFirstChild("SurfaceGUIs") or PlayerGui:WaitForChild("SurfaceGUIs")
local t = {
	MyBrainrots = {},
	MyBrainrotsChanged = Signal.new(),
	LastBrainrot = nil,
	BrainrotPlaced = Signal.new()
}
function StealPrompt(p1) --[[ StealPrompt | Line: 45 | Upvalues: Trove (copy), ReplicatedStorage (copy), Network (copy) ]]
	local v1 = Trove.new()
	local Steal = v1:Clone(ReplicatedStorage.Objects.Prompts.CustomPrompt)
	local v2 = v1:Add(Instance.new("Attachment"))
	v2.Position = Vector3.new(0, 3, 0)
	Steal.Exclusivity = Enum.ProximityPromptExclusivity.OnePerButton
	Steal.Name = "Steal"
	Steal.HoldDuration = 0.5
	Steal.ActionText = "Steal \240\159\152\136"
	v1:Connect(Steal.Triggered, function() --[[ Line: 60 | Upvalues: Network (ref), p1 (copy) ]]
		Network.FireServer("S_Steal", p1)
	end)
	Steal.Parent = v2
	v2.Parent = p1
	return function() --[[ Line: 68 | Upvalues: v1 (copy) ]]
		v1:Clean()
	end
end
function OpenPrompt(p1, p2, p3) --[[ OpenPrompt | Line: 73 | Upvalues: Network (copy) ]]
	local v1 = p3:Clone(script.Prompt)
	local v2 = p3:Add(Instance.new("Attachment"))
	v1.ActionText = "Open"
	v2.Position = Vector3.new(0, 2.5, 0)
	v1.Parent = v2
	v2.Parent = p1
	p3:Add(v1.Triggered:Connect(function() --[[ Line: 82 | Upvalues: p2 (copy), Network (ref) ]]
		if p2 then
			Network.FireServer("LB_OpenRequest", p2)
		end
	end))
end
function HandleButton(p1, p2, p3) --[[ HandleButton | Line: 89 | Upvalues: Trove (copy), ClientPlotService (copy), ReplicatedStorage (copy), InfiniteMath (copy), TweenService (copy), FormatInfNumber (copy), LocalPlayer (copy), VFXService (copy), Network (copy) ]]
	local v1 = p1:FindFirstAncestorOfClass("Model")
	if v1 then
		local v2 = v1.Buttons:FindFirstChild((("Slot%*"):format(p2)))
		if v2 then
			local v3 = Trove.new()
			local v4 = v3:Clone(ReplicatedStorage.Objects.GUI.ButtonGUI)
			v4:WaitForChild("CoinsLabel")
			v4:WaitForChild("OfflineLabel")
			local v5 = InfiniteMath.new(0)
			local function Pop() --[[ Pop | Line: 109 | Upvalues: v4 (copy), TweenService (ref) ]]
				v4.CoinsLabel.UIScale.Scale = 1
				TweenService:Create(v4.CoinsLabel.UIScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true), {
					Scale = 1.1
				}):Play()
			end
			local function UpdateCoins(p12) --[[ UpdateCoins | Line: 114 | Upvalues: p1 (copy), InfiniteMath (ref), v4 (copy), v5 (ref), FormatInfNumber (ref) ]]
				local v1 = p1:GetAttribute("Coins") or 0
				local v3 = InfiniteMath.new(p1:GetAttribute("OfflineCoins") or 0)
				if v3:Reverse() == 0 then
					v4.OfflineLabel.Visible = false
				else
					v4.OfflineLabel.Text = ("Offline: $%*"):format(v3)
					v4.OfflineLabel.Visible = true
				end
				v5 = InfiniteMath.new(v1)
				v4.CoinsLabel.Text = ("$%*"):format((FormatInfNumber(v5)))
			end
			UpdateCoins(true)
			v3:Add(p1:GetAttributeChangedSignal("Coins"):Connect(UpdateCoins))
			v4.Parent = v2
			if v1 == ClientPlotService.Model then
				local v6 = nil
				v3:Add(v2.Touched:Connect(function(p12) --[[ Line: 140 | Upvalues: LocalPlayer (ref), v6 (ref), v5 (ref), p1 (copy), VFXService (ref), v2 (copy), Network (ref), p2 (copy) ]]
					if LocalPlayer.Character and (p12.Parent == LocalPlayer.Character and (not v6 and v5.first ~= 0)) then
						v6 = true
						task.delay(0.4, function() --[[ Line: 158 | Upvalues: v6 (ref) ]]
							v6 = false
						end)
						p1:SetAttribute("lastCollect", tick())
						VFXService.PlayVFX("buttonMoney", v2)
						VFXService.PlayVFX("CashVFX", LocalPlayer.Character, v2)
						Network.FireServer("B_Collect", p2)
					end
				end))
			end
			return function() --[[ Line: 169 | Upvalues: v3 (copy) ]]
				v3:Clean()
			end
		end
	end
end
function HandleModelScale(p1, p2) --[[ HandleModelScale | Line: 174 | Upvalues: Trove (copy), EntitiesData (copy) ]]
	local v1 = p1.Name
	local v2 = Trove.new()
	local Exclusive = EntitiesData.Brainrots[v1].Exclusive
	local v3 = EntitiesData.Brainrots[v1].Model:GetScale()
	local function UpdateScale() --[[ UpdateScale | Line: 182 | Upvalues: p2 (copy), EntitiesData (ref), Exclusive (copy), v3 (copy) ]]
		local v2 = math.clamp((p2:GetAttribute("Level") or 1) / EntitiesData.MAX_LEVEL, 0, 1)
		if Exclusive then
			v2 = 1
		end
		local v5 = math.lerp(v3, v3 * EntitiesData.MAX_SCALE_FACTOR, v2)
		local Model = p2:FindFirstChildOfClass("Model")
		if Model then
			Model:ScaleTo(v5)
			local v6 = Model.PrimaryPart or Model:FindFirstChild("Root")
			if not v6 then
				return
			end
			Model:PivotTo(p2.CFrame * CFrame.new(0, v6.Size.Y / 2, 0))
		end
	end
	UpdateScale()
	v2:Connect(p2:GetAttributeChangedSignal("Level"), UpdateScale)
	return function() --[[ Line: 207 | Upvalues: v2 (copy) ]]
		v2:Clean()
	end
end
function HandleUpgradeGUI(p1, p2, p3) --[[ HandleUpgradeGUI | Line: 212 | Upvalues: EntitiesData (copy), Trove (copy), ClientPlotService (copy), v1 (copy), ReplicatedStorage (copy), VFXService (copy), t (copy), FormatInfNumber (copy), v2 (copy), MessagesService (copy), ClientBalanceService (copy), Network (copy) ]]
	if EntitiesData.Brainrots[p3].Best then
	else
		local v12 = Trove.new()
		local v22 = p1.Parent
		local v3 = p1:IsDescendantOf(ClientPlotService.Model)
		local v4 = v22.CFrame:ToWorldSpace(v1)
		local v5 = v12:Clone(ReplicatedStorage.Objects.Plot.UpgradeSign)
		local v6 = v12:Clone(ReplicatedStorage.Objects.GUI.UpgradeGUI)
		local Button = v6:WaitForChild("Button")
		local LevelLabel = Button:WaitForChild("LevelLabel")
		local PriceLabel = Button:WaitForChild("PriceLabel")
		local v7 = p1:GetAttribute("Mutation")
		local v8 = nil
		local v9 = 1
		local v10 = nil
		local v11 = nil
		local function LevelChanged() --[[ LevelChanged | Line: 239 | Upvalues: p1 (copy), v11 (ref), EntitiesData (ref), v8 (ref), v3 (copy), VFXService (ref), v9 (ref), PriceLabel (copy), LevelLabel (copy), t (ref), v10 (ref), p3 (copy), v7 (copy), FormatInfNumber (ref) ]]
			local v1 = p1:GetAttribute("Level") or 1
			v11 = EntitiesData.MAX_LEVEL <= v1
			if v8 and v3 then
				VFXService.PlayVFX("UpgradeBrainrot", p1:FindFirstChildOfClass("Model"))
			end
			v8 = true
			v9 = v1
			if v11 then
				PriceLabel.Text = ""
				LevelLabel.Text = ("Lvl %* MAX"):format(v1)
			else
				if t.MyBrainrots[p1] then
					t.MyBrainrots[p1].Level = v1
					t.MyBrainrotsChanged:Fire()
				end
				v10 = EntitiesData.GetCostForUpgrade(p3, v1, v7)
				PriceLabel.Text = ("$%*"):format((FormatInfNumber(v10)))
				LevelLabel.Text = ("Lvl %* > Lvl %*"):format(v1, v1 + 1)
			end
		end
		LevelChanged()
		v12:Add(p1:GetAttributeChangedSignal("Level"):Connect(LevelChanged))
		if v3 then
			v6.Name = p1.Parent.Name
			v6.Adornee = v5
			v6.Parent = v2
			v12:Add(Button.Activated:Connect(function() --[[ Line: 274 | Upvalues: v11 (ref), MessagesService (ref), v10 (ref), ClientBalanceService (ref), Network (ref), p2 (copy) ]]
				if v11 then
					MessagesService:PlayMessage("Max Lvl!", "Error")
				elseif v10 and v10 <= ClientBalanceService.Balance then
					Network.FireServer("B_Upgrade", p2)
				elseif v10 then
					MessagesService:PlayMessage("Insufficient cash", "Error")
				end
			end))
		else
			v6.Parent = v5
		end
		v5.CFrame = v4
		v5.Parent = v22
		return function() --[[ Line: 294 | Upvalues: v12 (copy) ]]
			v12:Clean()
		end
	end
end
function HandleBrainrot(p1, p2, p3) --[[ HandleBrainrot | Line: 299 | Upvalues: Trove (copy), ClientPlotService (copy), t (copy), SetupBrainrotGui (copy), LoadIdleAnimations (copy), VFXService (copy) ]]
	local v1 = Trove.new()
	local v2 = p1:IsDescendantOf(ClientPlotService.Model)
	if v2 then
		t.MyBrainrots[p1] = {
			Brainrot = p3.Name,
			Level = p1:GetAttribute("Level") or 1,
			Mutation = p1:GetAttribute("Mutation")
		}
		t.BrainrotPlaced:Fire()
		t.LastBrainrot = p1
		t.MyBrainrotsChanged:Fire()
		local v3 = HandleButton(p1, p2, v2)
		if v3 then
			v1:Add(v3)
		end
	else
		v1:Add(StealPrompt(p1))
	end
	local v4 = SetupBrainrotGui(p3, p1)
	if v4 then
		v1:Add(v4)
	end
	local v5 = LoadIdleAnimations(p3)
	if v5 then
		v1:Add(v5)
	end
	local v6 = HandleUpgradeGUI(p1, p2, p3.Name)
	if v6 then
		v1:Add(v6)
	end
	v1:Add(HandleModelScale(p3, p1))
	local function PopBrainrot() --[[ PopBrainrot | Line: 340 | Upvalues: VFXService (ref), p3 (copy) ]]
		VFXService.PlayVFX("PopBrainrot", p3)
	end
	v1:Connect(p1:GetAttributeChangedSignal("lastCollect"), PopBrainrot)
	return function() --[[ Line: 346 | Upvalues: v2 (copy), t (ref), p1 (copy), v1 (copy) ]]
		if v2 then
			t.MyBrainrots[p1] = nil
			t.MyBrainrotsChanged:Fire()
		end
		v1:Clean()
	end
end
function HandleLuckyBlock(p1, p2) --[[ HandleLuckyBlock | Line: 356 | Upvalues: Trove (copy), ClientPlotService (copy) ]]
	local v1 = Trove.new()
	if p1:IsDescendantOf(ClientPlotService.Model) then
		OpenPrompt(p1, p2, v1)
	end
	return function() --[[ Line: 363 | Upvalues: v1 (copy) ]]
		v1:Clean()
	end
end
function OnNewPart(p1) --[[ OnNewPart | Line: 368 | Upvalues: Trove (copy), EntitiesData (copy) ]]
	local v1 = Trove.new()
	local v2 = v1:Extend()
	local v4 = tonumber((p1.Parent.Name:gsub("Slot", "")))
	if not v4 then
		warn((("[%*] no slot id for %*"):format(script.Name, p1.Parent and p1.Parent.Name)))
	end
	local function LoadID() --[[ LoadID | Line: 378 | Upvalues: v2 (copy), p1 (copy), EntitiesData (ref), v4 (ref) ]]
		v2:Clean()
		local v1 = p1:GetAttribute("ID")
		if v1 then
			local v22 = EntitiesData.Brainrots[v1] or EntitiesData.LuckyBlocks[v1]
			if v22 then
				local v3 = EntitiesData.GetTypeFromName(v1)
				local v42 = v2:Clone(v22.Model)
				local v5 = p1:GetAttribute("Mutation")
				if v5 then
					v42:AddTag(v5)
				end
				for i, v in ipairs(v42:GetDescendants()) do
					if v:IsA("MeshPart") or (v:IsA("BasePart") or v:IsA("Part")) then
						v.CanCollide = false
						v.CanQuery = false
						v.CanTouch = false
					end
				end
				local Root = v42:WaitForChild("Root")
				Root.CFrame = p1.Parent.CFrame * CFrame.new(0, Root.Size.Y / 2, 0)
				v42.Parent = p1
				if v3 == "LuckyBlock" then
					v2:Add(HandleLuckyBlock(p1, v4))
				elseif v3 == "Brainrot" then
					v2:Add(HandleBrainrot(p1, v4, v42))
				end
			end
		end
	end
	LoadID()
	v1:Add(p1:GetAttributeChangedSignal("ID"):Connect(LoadID))
	return function() --[[ Line: 421 | Upvalues: v1 (copy) ]]
		v1:Clean()
	end
end
function t._init() --[[ _init | Line: 426 | Upvalues: Observers (copy), Tags (copy) ]]
	Observers.observeTag(Tags.PlacedPart, OnNewPart, { workspace:WaitForChild("Plots") })
end
return t
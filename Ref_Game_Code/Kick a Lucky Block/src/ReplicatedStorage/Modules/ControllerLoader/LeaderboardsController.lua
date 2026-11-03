-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("TextService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LeaderboardServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.LeaderboardServiceClient)
local Players = game:GetService("Players")
local LeaderboardData = require(ReplicatedStorage.Shared.Data.LeaderboardData)
local Leaderboards = workspace:WaitForChild("Leaderboards")
local t = {
	LeaderboardGUIs = {},
	CachedIcons = {},
	IconQueue = {},
	IconQueueMap = {},
	IsProcessing = false
}
function LoadFrame(p1, p2) --[[ LoadFrame | Line: 25 | Upvalues: Players (copy), t (copy) ]]
	if p2 and p1 then
		p1.Frame.NameLabel.Text = ""
		task.spawn(function() --[[ Line: 33 | Upvalues: Players (ref), p2 (copy), p1 (copy) ]]
			local v1, v2 = pcall(function() --[[ Line: 34 | Upvalues: Players (ref), p2 (ref) ]]
				return Players:GetNameFromUserIdAsync((tonumber(p2.key)))
			end)
			if v1 then
				p1.Frame.NameLabel.Text = v2
			end
		end)
		local v1 = t.CachedIcons[p2.key]
		if v1 then
			p1.Frame.AvatarLabel.Image = v1
		else
			p1.Frame.AvatarLabel.Image = ""
			task.spawn(function() --[[ Line: 49 | Upvalues: Players (ref), p2 (copy), t (ref), p1 (copy) ]]
				local v1, v2 = pcall(function() --[[ Line: 50 | Upvalues: Players (ref), p2 (ref) ]]
					local HeadShot = Enum.ThumbnailType.HeadShot
					local Size60x60 = Enum.ThumbnailSize.Size60x60
					return Players:GetUserThumbnailAsync(tonumber(p2.key), HeadShot, Size60x60)
				end)
				if v1 then
					t.CachedIcons[p2.key] = v2
					p1.Frame.AvatarLabel.Image = v2
				end
			end)
		end
		p1.Frame.Value.Text = p2.value
		p1.Visible = true
	end
end
function LoadIcons() --[[ LoadIcons | Line: 69 | Upvalues: t (copy), Players (copy) ]]
	if not t.IsProcessing then
		t.IsProcessing = true
		while #t.IconQueue > 0 do
			local v1 = table.remove(t.IconQueue, 1)
			local v2 = t.IconQueueMap[v1]
			t.IconQueueMap[v1] = nil
			if v2 then
				local v3, v4 = pcall(function() --[[ Line: 81 | Upvalues: Players (ref), v1 (copy) ]]
					return Players:GetUserThumbnailAsync(tonumber(v1), Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60)
				end)
				if v3 then
					t.CachedIcons[v1] = v4
					for i, v in ipairs(v2) do
						v.Frame.AvatarLabel.Image = v4
					end
				end
			end
			task.wait(0.06666666666666667)
		end
		t.IsProcessing = false
	end
end
function OnPlacementsUpdate(p1) --[[ OnPlacementsUpdate | Line: 103 | Upvalues: LeaderboardServiceClient (copy), t (copy) ]]
	for k, v in pairs(p1) do
		for i = 1, LeaderboardServiceClient.Config.MAX_PLACEMENTS do
			if t.LeaderboardGUIs[k] then
				local v1 = t.LeaderboardGUIs[k].ScrollingFrame:FindFirstChild((("Place_%*"):format(i)))
				local v2 = v[i]
				if v1 and v2 then
					if not t.CachedIcons[v2.key] then
						if not t.IconQueueMap[v2.key] then
							t.IconQueueMap[v2.key] = {}
							table.insert(t.IconQueue, v2.key)
						end
						table.insert(t.IconQueueMap[v2.key], v1)
					end
					LoadFrame(v1, v2)
				end
				if v1 and v1.Visible then
					v1.Visible = false
				end
			end
		end
	end
	task.defer(LoadIcons)
end
function LoadModel(p1, p2) --[[ LoadModel | Line: 134 | Upvalues: LeaderboardData (copy), ReplicatedStorage (copy), LeaderboardServiceClient (copy), t (copy) ]]
	local v1 = p1:FindFirstChild("GUIPart") or p1:WaitForChild("GUIPart", 3)
	if v1 then
		local v2 = LeaderboardData.Settings[p2]
		local v3 = ReplicatedStorage.Objects.GUI.LeaderboardGUI:Clone()
		local Template = v3:WaitForChild("ScrollingFrame"):WaitForChild("Template")
		Template.Visible = false
		local Top = v3:WaitForChild("Top")
		for i, v in ipairs(Top:GetChildren()) do
			if v:IsA("TextLabel") then
				v.Text = v2.Title
			end
			if v:IsA("ImageLabel") then
				v.Image = v2.Icon
			end
		end
		for i = 1, LeaderboardServiceClient.Config.MAX_PLACEMENTS do
			local v4 = Template:Clone()
			v4:WaitForChild("Frame"):WaitForChild("Value")
			v4.Frame:WaitForChild("NameLabel")
			v4.Frame:WaitForChild("AvatarLabel")
			v4:WaitForChild("NumberLabel").Text = i
			v4.LayoutOrder = i
			if v2.ValueColor then
				v4.Frame.Value.TextColor3 = v2.ValueColor
				v4.NumberLabel.TextColor3 = v2.ValueColor
			end
			v4.Name = ("Place_%*"):format(i)
			v4.Visible = false
			v4.Parent = v3.ScrollingFrame
			local v5 = LeaderboardServiceClient.Placements[p2] and LeaderboardServiceClient.Placements[p2][i]
			if v5 then
				LoadFrame(v4, v5)
			end
		end
		v3.Parent = v1
		t.LeaderboardGUIs[p2] = v3
	end
end
function InitModels() --[[ InitModels | Line: 181 | Upvalues: Leaderboards (copy), LeaderboardData (copy) ]]
	for i, v in ipairs(Leaderboards:GetChildren()) do
		if table.find(LeaderboardData.DataStores, v.Name) then
			LoadModel(v, v.Name)
		end
	end
end
function t._init() --[[ _init | Line: 190 | Upvalues: LeaderboardServiceClient (copy) ]]
	InitModels()
	LeaderboardServiceClient.LeaderboardUpdated:Connect(OnPlacementsUpdate)
end
return t
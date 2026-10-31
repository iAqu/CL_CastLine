local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local StarterPlayer = game:GetService("StarterPlayer")
local Players = game:GetService("Players")
local SocialService = game:GetService("SocialService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local Constants = require(ReplicatedStorage.Modules.Constants)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local PlayerThumbnailUtil = require(ReplicatedStorage.Modules.PlayerThumbnailUtil)
local Timer = require(ReplicatedStorage.Packages.Timer)

local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")
local InvitePopGui = PlayerGui:WaitForChild("InvitePopGui")

local INVITE_COOLDOWN = 60*8
local AUTO_CLOSE_TIME = 20

local invitedFriends = {}		-- {userId}
local currentFriendUserId = nil

local InviteGuiController = Knit.CreateController {
    Name = "InviteGuiController",
}

local function invitedFriend(userId)
	if not userId then return end

	local inviteOptions = Instance.new("ExperienceInviteOptions")
	inviteOptions.InviteUser = userId
	inviteOptions.PromptMessage = "Play with your friend to get +10% ⚡️ boost!"
	SocialService:PromptGameInvite(localPlayer, inviteOptions)
end

local function initGui()
	InvitePopGui.Enabled = false
	InvitePopGui.Frame.Visible = true
	InvitePopGui.Frame.CloseButton.Activated:Connect(function()
		InvitePopGui.Enabled = false
		if currentFriendUserId then
			table.insert(invitedFriends, currentFriendUserId)
		end
	end)
	InvitePopGui.Frame.InviteButton.Activated:Connect(function()
		InvitePopGui.Enabled = false
		invitedFriend(currentFriendUserId)
		if currentFriendUserId then
			table.insert(invitedFriends, currentFriendUserId)
		end
	end)
end

local function iterPageItems(pages)
	return coroutine.wrap(function()
		local pagenum = 1
		while true do
			for _, item in ipairs(pages:GetCurrentPage()) do
				coroutine.yield(item, pagenum)
			end
			if pages.IsFinished then
				break
			end
			pages:AdvanceToNextPageAsync()
			pagenum = pagenum + 1
		end
	end)
end

local function showInviteGui()
	InvitePopGui.Frame.AvatarImage.Image = ""
	InvitePopGui.Frame.NameLabel.Text = ""

	local Success, result = pcall(function()
		return SocialService:CanSendGameInviteAsync(localPlayer)
	end)
	if not result then warn("No result found!") return end

	local friends = {}
	-- local friendPages = Players:GetFriendsAsync(localPlayer.UserId)
	-- local onlineFriends = Players:GetFriendsOnline()
	local getOnlineFriendsSuccess, onlineFriends = pcall(localPlayer.GetFriendsOnline, localPlayer, 10)
	if not getOnlineFriendsSuccess then warn("No online friends found!") return end
	
	-- for item, _pageNo in iterPageItems(onlineFriends) do
	for _, item in pairs(onlineFriends) do
        if not item.IsOnline then  continue end						-- friend is offline
		if table.find(invitedFriends, item.VisitorId) then continue end	-- friend is already invited
		if Players:GetPlayerByUserId(item.VisitorId) then continue end		-- friend is already in the game
		-- if Knit.GetController("FightController"):IsFighting() then continue end	--  in fight

		table.insert(friends, item)
	end

	-- warn(friends)

	if #friends == 0 then return end
	local item = friends[math.random(1, #friends)]
	
	InvitePopGui.Frame.AvatarImage.Image = PlayerThumbnailUtil.GetHeadshot(item.VisitorId, 60)
	InvitePopGui.Frame.NameLabel.Text = item.DisplayName .. "is online!"
	InvitePopGui.Enabled = true
	task.delay(AUTO_CLOSE_TIME, function()
		InvitePopGui.Enabled = false
	end)

	currentFriendUserId = item.VisitorId
end

function InviteGuiController:KnitInit()
	initGui()
end

function InviteGuiController:KnitStart()

	local inviteTimer = Timer.new(INVITE_COOLDOWN)
	-- local inviteTimer = Timer.new(10)
	inviteTimer.Tick:Connect(function()
		if InvitePopGui.Enabled then return end
		showInviteGui()
	end)
	inviteTimer:Start()
end

return InviteGuiController

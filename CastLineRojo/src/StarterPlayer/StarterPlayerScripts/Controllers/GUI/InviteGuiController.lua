local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SocialService = game:GetService("SocialService")

local Knit = require(ReplicatedStorage.Packages.Knit)
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
	InvitePopGui.Frame.NameLabel.Text = ""
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

local function showInviteGui()
	local canInviteSuccess, canInvite = pcall(SocialService.CanSendGameInviteAsync, SocialService, localPlayer)
	if not canInviteSuccess then
		warn("InviteGuiController: Could not check invite availability", canInvite)
		return
	end
	if not canInvite then return end

	local getOnlineFriendsSuccess, onlineFriends = pcall(localPlayer.GetFriendsOnlineAsync, localPlayer, 10)
	if not getOnlineFriendsSuccess then
		warn("InviteGuiController: Could not get online friends", onlineFriends)
		return
	end

	local friends = {}
	for _, friend in ipairs(onlineFriends) do
		if not friend.IsOnline then continue end
		if table.find(invitedFriends, friend.VisitorId) then continue end
		if Players:GetPlayerByUserId(friend.VisitorId) then continue end
		table.insert(friends, friend)
	end

	if #friends == 0 then return end
	local friend = friends[math.random(1, #friends)]
	local name = friend.DisplayName
	if not name or name == "" then
		name = friend.UserName
	end

	InvitePopGui.Frame.AvatarImage.Image = PlayerThumbnailUtil.GetHeadshot(friend.VisitorId, 60)
	currentFriendUserId = friend.VisitorId
	InvitePopGui.Frame.NameLabel.Text = if name and name ~= "" then name .. " is online!" else "friend is online"
	InvitePopGui.Enabled = true
	task.delay(AUTO_CLOSE_TIME, function()
		InvitePopGui.Enabled = false
	end)
end

function InviteGuiController:KnitInit()
	initGui()
end

function InviteGuiController:KnitStart()
	local inviteTimer = Timer.new(INVITE_COOLDOWN)
	inviteTimer.Tick:Connect(function()
		if InvitePopGui.Enabled then return end
		showInviteGui()
	end)
	inviteTimer:Start()
end

return InviteGuiController

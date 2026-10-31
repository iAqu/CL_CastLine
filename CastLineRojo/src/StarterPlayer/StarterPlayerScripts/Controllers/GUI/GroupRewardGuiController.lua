local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SocialService = game:GetService("SocialService")
local GroupService = game:GetService("GroupService")
local StarterPlayer = game:GetService("StarterPlayer")

local AreasWorkspace = require(ReplicatedStorage.Modules.AreasWorkspace)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local Knit = require(ReplicatedStorage.Packages.Knit)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local groupRewardGui = playerGui:WaitForChild("GroupRewardGui")
local frame = groupRewardGui:WaitForChild("Frame")
local rewardFrame = frame:WaitForChild("RewardFrame")
local closeButton = frame:WaitForChild("CloseButton")
local claimButton = rewardFrame:WaitForChild("ClaimButton")
local claimedButton = rewardFrame:WaitForChild("ClaimedButton")
local inviteButton = rewardFrame:WaitForChild("InviteButton")
local joinButton = rewardFrame:WaitForChild("JoinButton")

local GROUP_CHEST_PROMPT_NAME = "GroupChestPrompt"
local HIGHLIGHT_NAME = "GroupChestPromptHighlight"
local registeredPrompts: { [ProximityPrompt]: Model } = {}
local activeHighlights: { [ProximityPrompt]: Highlight } = {}

local GroupRewardGuiController = Knit.CreateController {
    Name = "GroupRewardGuiController",
}

local function clearHighlight(prompt: ProximityPrompt)
    local highlight = activeHighlights[prompt]
    if highlight then
        activeHighlights[prompt] = nil
        highlight:Destroy()
    end
end

local function applyHighlight(prompt: ProximityPrompt)
    if activeHighlights[prompt] then
        return
    end

    local chest = registeredPrompts[prompt]
    if not chest or not chest.Parent then
        return
    end

    local highlightTarget = chest:FindFirstChild("Chest")
    if not highlightTarget then
        warn("GroupRewardGuiController: GroupChest is missing Chest highlight target")
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = HIGHLIGHT_NAME
    highlight.Adornee = highlightTarget
    highlight.FillColor = Color3.fromRGB(255, 218, 75)
    highlight.FillTransparency = 0.65
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    highlight.Parent = chest
    activeHighlights[prompt] = highlight
end

local function updateClaimButton()
    local playerData = PlayerDataController:GetData()
    local claimed = playerData and playerData.GroupChestIsClaimed == true
    claimButton.Visible = not claimed
    claimedButton.Visible = claimed
end

local function openGroupRewardGui()
    updateClaimButton()
    GuiAnimation.OpenGui(groupRewardGui)
end

local function configurePrompt(chest: Model)
    local primaryPart = chest.PrimaryPart
    if not primaryPart then
        warn("GroupRewardGuiController: GroupChest has no PrimaryPart")
        return
    end

    local prompt = primaryPart:FindFirstChild(GROUP_CHEST_PROMPT_NAME)
    if not prompt or not prompt:IsA("ProximityPrompt") then
        prompt = Instance.new("ProximityPrompt")
        prompt.Name = GROUP_CHEST_PROMPT_NAME
        prompt.Parent = primaryPart
        prompt.Triggered:Connect(function(player)
            if player == localPlayer then
                openGroupRewardGui()
            end
        end)
    end

    prompt.ActionText = "Open"
    prompt.ObjectText = "Group Chest"
    prompt.MaxActivationDistance = 12
    prompt.HoldDuration = 0
    prompt.RequiresLineOfSight = false
    prompt.KeyboardKeyCode = Enum.KeyCode.E
    prompt.Style = Enum.ProximityPromptStyle.Default
    registeredPrompts[prompt] = chest
end

local function registerGroupChests()
    for prompt in registeredPrompts do
        clearHighlight(prompt)
    end
    table.clear(registeredPrompts)

    AreasWorkspace.forEachAreaContext(function(areaRoot)
        local items = areaRoot:FindFirstChild("Items")
        if not items then
            return
        end

        for _, item in items:GetChildren() do
            if item.Name == "GroupChest" and item:IsA("Model") then
                configurePrompt(item)
            end
        end
    end)
end

local function inviteFriends()
    local options = Instance.new("ExperienceInviteOptions")
    options.PromptMessage = "Invite all your friends to get rewards! 🎁"

    local ok, canInvite = pcall(function()
        return SocialService:CanSendGameInviteAsync(localPlayer)
    end)
    if ok and canInvite then
        SocialService:PromptGameInvite(localPlayer, options)
    else
        NotificationClient.RedNotify("Unable to send game invites right now.")
    end
end

local function joinGroup()
    local ok, membershipStatus = pcall(function()
        return GroupService:PromptJoinAsync(game.CreatorId)
    end)
    if not ok then
        warn("GroupRewardGuiController: group join prompt failed", membershipStatus)
        NotificationClient.RedNotify("Could not open the group join prompt.")
        return
    end

    if membershipStatus == Enum.GroupMembershipStatus.Joined
        or membershipStatus == Enum.GroupMembershipStatus.JoinRequestPending
        or membershipStatus == Enum.GroupMembershipStatus.AlreadyMember then
        Knit.GetService("ChestService"):MarkGroupJoined():andThen(function(marked)
            if marked then
                NotificationClient.GreenNotify("Group joined! You can claim your reward now.")
            else
                NotificationClient.WhiteNotify("Group membership is still updating. Please try Claim in a moment.")
            end
        end)
    else
        NotificationClient.RedNotify("You must join the group before claiming.")
    end
end

function GroupRewardGuiController:KnitInit()
    Knit.GetController("AreaController").LoadedNewWorldClientEvent:Connect(registerGroupChests)

    ProximityPromptService.PromptShown:Connect(function(prompt)
        if registeredPrompts[prompt] then
            applyHighlight(prompt)
        end
    end)
    ProximityPromptService.PromptHidden:Connect(clearHighlight)

    closeButton.Activated:Connect(function()
        GuiAnimation.CloseGui(groupRewardGui)
    end)
    claimButton.Activated:Connect(function()
        Knit.GetService("ChestService"):ClaimGroupChest():andThen(function(result)
            if result.isSuccess then
                NotificationClient.GreenNotify(result.resultText)
                updateClaimButton()
            else
                NotificationClient.RedNotify(result.resultText)
            end
        end)
    end)
    inviteButton.Activated:Connect(inviteFriends)
    joinButton.Activated:Connect(joinGroup)
end

function GroupRewardGuiController:KnitStart()
    GuiAnimation.Setup(groupRewardGui)
    ButtonAnimation.SetUp(closeButton)
    ButtonAnimation.SetUp(claimButton)
    ButtonAnimation.SetUp(inviteButton)
    ButtonAnimation.SetUp(joinButton)
    groupRewardGui.Enabled = false
    updateClaimButton()
    registerGroupChests()
end

return GroupRewardGuiController

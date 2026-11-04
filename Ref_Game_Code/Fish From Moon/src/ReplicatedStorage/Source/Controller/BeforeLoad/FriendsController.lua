local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SocialService = game:GetService("SocialService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local Knit = require(ReplicatedStorage.Packages.Knit)
local FriendsHelper = require(ReplicatedStorage.Config.FriendsHelper)
local NumberFormat = require(ReplicatedStorage.Source.Utils.NumberFormat)
local FrameTrigger=require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)

local FriendsService

---GUI
local MainHud=player.PlayerGui:WaitForChild("MainUi",5).MainHud

local friendMenu=player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.Invite
local friendFrame=friendMenu.Menu.Container.ScrollingFrame.Frame
local friendFolder=friendMenu.Menu.Container.ScrollingFrame.Frame.Folder.Frame

local BtnOpen=MainHud.Right.daily.Invite
local BtnClose=friendMenu.Menu.Exit.TextButton

local FriendsController = Knit.CreateController { Name = "FriendsController" }

local function canSendGameInvite(targetPlayer)
	local res, canSend = pcall(function()
		return SocialService:CanSendGameInviteAsync(targetPlayer)
	end)
	return res and canSend
end

local function openGameInvitePrompt(targetPlayer)
	local canInvite = canSendGameInvite(targetPlayer)
	if canInvite then
		local res = pcall(function()
			local inviteOptions = Instance.new("ExperienceInviteOptions")
			inviteOptions.PromptMessage = "Get Roll Speed if your friend joins!"
			SocialService:PromptGameInvite(targetPlayer,inviteOptions)
		end)
		return res
	end
	return false
end

-----打开界面
function FriendsController:OpenMenu()
	-----清除之前的
	for k,v in pairs(friendFrame:GetChildren()) do
		if v:IsA("Frame") and v.Name~="Top" then
			v:Destroy()
		end
	end
	FriendsService:GetFriendsData():andThen(function(friendsData)
		
		local num=#(friendsData.friendList)
		friendFrame.Top.Down.TextLabel.Text="Currently Invited: "..num
		
		-----初始化
		local friendList=FriendsHelper.GetFriends()
		
		for k,v in pairs(friendList) do
			local inviteClone=friendFolder.Invite:Clone()
			inviteClone.Up.TextLabel.Text="Invite ".. k .." friend"
			inviteClone.Up.Count.Text=num.."/"..k
			inviteClone.LayoutOrder=k

			inviteClone.Down.Left.Icon1.ImageLabel.Image=FriendsHelper.GetFriendsImg(k,1)
			inviteClone.Down.Left.Icon1.TextLabel.Text=NumberFormat.AbbreviateNumber(FriendsHelper.GetFriendsTxt(k,1),2)
			inviteClone.Down.Left.Icon2.ImageLabel.Image=FriendsHelper.GetFriendsImg(k,2)
			inviteClone.Down.Left.Icon2.TextLabel.Text=FriendsHelper.GetFriendsTxt(k,2)
			inviteClone.Down.Left.Icon3.ImageLabel.Image=FriendsHelper.GetFriendsImg(k,3)
			inviteClone.Down.Left.Icon3.TextLabel.Text=FriendsHelper.GetFriendsTxt(k,3)
			
			inviteClone.Parent=friendFrame
			
			inviteClone.Down.Button.Invite.MouseButton1Click:Connect(function()
				openGameInvitePrompt(player)
			end)
			local cd=false
			inviteClone.Down.Button.Claim.MouseButton1Click:Connect(function()
				if not cd then
					cd = true
					FriendsService:GetRewards(k)
					task.wait(1)
					cd = false
				end
			end)
			
			if num>=k then
				inviteClone.Down.Button.Claim.Visible=true
				inviteClone.Down.Button.Invite.Visible=false
				inviteClone.Down.Button.IsClaimed.Visible=false
			end
			if table.find(friendsData.getRewardList,k) then
				inviteClone.Down.Button.Claim.Visible=false
				inviteClone.Down.Button.Invite.Visible=false
				inviteClone.Down.Button.IsClaimed.Visible=true
			end
		end

		local FriendBuff = 0

		local num=#(friendsData.friendList)
		if num>10 then
			FriendBuff = 0.5
		else
			FriendBuff += (0.05 * num)
		end
		
		friendMenu.Menu.Container.Boosts.Text="Current Boosts: +"..tostring(math.floor(FriendBuff*100)).."%"
	end)
end

--改变页面FriendBonus的值
local function changeFriendBonus()

	FriendsService:GetFriendsData():andThen(function(friendsData)

		local FriendBuff = 0

		local FriendBuff = 0

		local num=#(friendsData.friendList)
		if num>10 then
			FriendBuff = 0.5
		else
			FriendBuff += (0.05 * num)
		end

		local txtFriendsBuff=player.PlayerGui:WaitForChild("MainUi",5).MainHud.Boobm.BoostMenu.FriendBoost.boost

		txtFriendsBuff.Text="+"..tostring(math.floor(FriendBuff*100)).."%"
	end)
end

function FriendsController:KnitInit()
	FriendsService = Knit.GetService("FriendsService")
end

function FriendsController:KnitStart()
	
	BtnOpen.MouseButton1Click:Connect(function()
		local frameName="Invite"
		FrameTrigger.OpenFram(frameName)
		self.OpenMenu()
	end)
	BtnClose.MouseButton1Click:Connect(function()
		local frameName="Invite"
		FrameTrigger.CloseFram(frameName)
		
	end)
	friendFrame.Top.Down.TextButton.MouseButton1Click:Connect(function()
		openGameInvitePrompt(player)
	end)
	
	--好友加成
	FriendsService.ChangeFriendBonus:Connect(changeFriendBonus)
	FriendsService.ChangeMenuData:Connect(self.OpenMenu)
end

return FriendsController

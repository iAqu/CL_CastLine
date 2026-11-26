local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local function signal()
	local event = {}
	function event:Connect(callback)
		self.Fire = callback
		return { Disconnect = function() self.Fire = nil end }
	end
	return event
end

local popup = {
	Name = "InvitePopGui",
	Enabled = true,
	Parent = true,
	GetPropertyChangedSignal = signal,
	Frame = {
		NameLabel = { Text = "NameName is online!" },
		AvatarImage = { Image = "" },
		InviteButton = { Activated = signal() },
		CloseButton = { Activated = signal() },
	},
}
local home = { Name = "HomeGui", Enabled = true, Parent = true, GetPropertyChangedSignal = signal }
local playerGui = { WaitForChild = function() return popup end }
local friends, queryFails, invitedId = {}, false, nil
local function getOnlineFriends()
	assert(not queryFails, "friend lookup failed")
	return friends
end
local player = { WaitForChild = function() return playerGui end, GetFriendsOnline = getOnlineFriends, GetFriendsOnlineAsync = getOnlineFriends }
local tick = signal()
local services = {
	Players = { LocalPlayer = player, GetPlayerByUserId = function(_, id) return id == 99 and player or nil end },
	SocialService = {
		CanSendGameInviteAsync = function() return true end,
		PromptGameInvite = function(_, recipient, options)
			assert(recipient == player)
			invitedId = options.InviteUser
		end,
	},
	StarterPlayer = { StarterPlayerScripts = { Controllers = {} } },
	ReplicatedStorage = {
		Packages = {
			Knit = { CreateController = function(controller) return controller end },
			Timer = { new = function() return { Tick = tick, Start = function() end } end },
		},
		Modules = { PlayerThumbnailUtil = { GetHeadshot = function(id) return "avatar:" .. id end } },
	},
}
local inviteSource = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/InviteGuiController.lua")
local controller = assert(load(inviteSource, "InviteGuiController", "t", setmetatable({
	game = { GetService = function(_, name) return services[name] end },
	require = function(value) return value end,
	Instance = { new = function() return {} end },
	task = { delay = function() end },
	warn = function() end,
}, { __index = getfenv() })))()

local loadingSource = read("src/ReplicatedFirst/LoadingScreen.client.lua")
local first = assert(loadingSource:find("local function hideGui(", 1, true))
local last = assert(loadingSource:find("local function hideSceneGui(", first, true))
local loadingGuiLifecycle = "local hiddenGuis, guiConnections = {}, {}\n"
	.. loadingSource:sub(first, last - 1)
	.. "return hideGui, restoreOtherGuis"
local hideGui, restoreOtherGuis = assert(load(loadingGuiLifecycle, "Loading GUI lifecycle", "t", getfenv()))()
hideGui(popup)
hideGui(home)
controller:KnitInit()
controller:KnitStart()
restoreOtherGuis()

assert(home.Enabled, "Loading must restore the home UI")
assert(not popup.Enabled, "Loading must leave the invite popup hidden")
assert(popup.Frame.NameLabel.Text == "", "Initialization must clear the invite template name")

local function checkInvite(friend, expectedText)
	friends = { friend }
	tick.Fire()
	assert(popup.Enabled, "An eligible friend must show the popup")
	assert(popup.Frame.NameLabel.Text == expectedText, "Unexpected invite text: " .. popup.Frame.NameLabel.Text)
	assert(popup.Frame.AvatarImage.Image == "avatar:" .. friend.VisitorId, "The avatar must belong to the selected friend")
	popup.Frame.InviteButton.Activated.Fire()
	assert(invitedId == friend.VisitorId, "The invite must target the displayed friend")
	assert(not popup.Enabled, "Inviting must close the popup")
end

checkInvite({ VisitorId = 41, IsOnline = true, DisplayName = "Ocean Friend", UserName = "OceanFriend41" }, "Ocean Friend is online!")
checkInvite({ VisitorId = 42, IsOnline = true, DisplayName = "", UserName = "OceanFriend42" }, "OceanFriend42 is online!")
checkInvite({ VisitorId = 43, IsOnline = true, UserName = "" }, "friend is online")

friends = {
	{ VisitorId = 41, IsOnline = true, UserName = "OceanFriend41" },
	{ VisitorId = 99, IsOnline = true, DisplayName = "In server" },
	{ VisitorId = 44, IsOnline = false, DisplayName = "Offline" },
}
tick.Fire()
assert(not popup.Enabled, "The popup must stay hidden when every friend is excluded")
queryFails = true
tick.Fire()
assert(not popup.Enabled, "The popup must stay hidden when friend lookup fails")

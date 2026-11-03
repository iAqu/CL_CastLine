-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:20
-- Luau version 6, Types version 3
-- Time taken: 0.001712 seconds

local Players = game:GetService("Players")
local module = require(script.Parent:WaitForChild("ChatConstants"))
local tbl_upvr = {
	WindowDraggable = false;
	WindowResizable = false;
	ShowChannelsBar = false;
	GamepadNavigationEnabled = false;
	AllowMeCommand = false;
	ShowUserOwnFilteredMessage = true;
	ChatOnWithTopBarOff = false;
	ScreenGuiDisplayOrder = 6;
	ShowFriendJoinNotification = true;
	BubbleChatEnabled = Players.BubbleChat;
	ClassicChatEnabled = Players.ClassicChat;
	ChatWindowTextSize = 18;
	ChatChannelsTabTextSize = 18;
	ChatBarTextSize = 18;
	ChatWindowTextSizePhone = 14;
	ChatChannelsTabTextSizePhone = 18;
	ChatBarTextSizePhone = 14;
	DefaultFont = Enum.Font.SourceSansBold;
	ChatBarFont = Enum.Font.SourceSansBold;
	BackGroundColor = Color3.new(0, 0, 0);
	DefaultMessageColor = Color3.new(1, 1, 1);
	DefaultNameColor = Color3.new(1, 1, 1);
	ChatBarBackGroundColor = Color3.new(0, 0, 0);
	ChatBarBoxColor = Color3.new(1, 1, 1);
	ChatBarTextColor = Color3.new(0, 0, 0);
	ChannelsTabUnselectedColor = Color3.new(0, 0, 0);
	ChannelsTabSelectedColor = Color3.new(0.11764705882352941, 0.11764705882352941, 0.11764705882352941);
	DefaultChannelNameColor = Color3.fromRGB(35, 76, 142);
	WhisperChannelNameColor = Color3.fromRGB(102, 14, 102);
	ErrorMessageTextColor = Color3.fromRGB(245, 50, 50);
	MinimumWindowSize = UDim2.new(0.3, 0, 0.25, 0);
	MaximumWindowSize = UDim2.new(1, 0, 1, 0);
	DefaultWindowPosition = UDim2.new(0, 0, 0, 0);
	DefaultWindowSizePhone = UDim2.new(0.5, 0, 0.5, 24);
	DefaultWindowSizeTablet = UDim2.new(0.4, 0, 0.3, 24);
	DefaultWindowSizeDesktop = UDim2.new(0.3, 0, 0.25, 24);
	ChatWindowBackgroundFadeOutTime = 3.5;
	ChatWindowTextFadeOutTime = 30;
	ChatDefaultFadeDuration = 0.8;
	ChatShouldFadeInFromNewInformation = false;
	ChatAnimationFPS = 20;
	GeneralChannelName = "All";
	EchoMessagesInGeneralChannel = true;
	ChannelsBarFullTabSize = 4;
	MaxChannelNameLength = 12;
	MaxChannelNameCheckLength = 50;
	RightClickToLeaveChannelEnabled = false;
	MessageHistoryLengthPerChannel = 50;
	ShowJoinAndLeaveHelpText = false;
	MaximumMessageLength = 200;
	DisallowedWhiteSpace = {'\n', '\r', '\t', '\v', '\f'};
	ClickOnPlayerNameToWhisper = true;
	ClickOnChannelNameToSetMainChannel = true;
	BubbleChatMessageTypes = {module.MessageTypeDefault, module.MessageTypeWhisper};
	WhisperCommandAutoCompletePlayerNames = true;
	PlayerDisplayNamesEnabled = true;
	WhisperByDisplayName = true;
}
local BindableEvent_upvr = Instance.new("BindableEvent")
local setmetatable_result1 = setmetatable({}, {
	__index = function(arg1, arg2) -- Line 107, Named "__index"
		--[[ Upvalues[1]:
			[1]: tbl_upvr (readonly)
		]]
		return tbl_upvr[arg2]
	end;
	__newindex = function(arg1, arg2, arg3) -- Line 110, Named "__newindex"
		--[[ Upvalues[2]:
			[1]: tbl_upvr (readonly)
			[2]: BindableEvent_upvr (readonly)
		]]
		tbl_upvr[arg2] = arg3
		BindableEvent_upvr:Fire(arg2, arg3)
	end;
})
rawset(setmetatable_result1, "SettingsChanged", BindableEvent_upvr.Event)
return setmetatable_result1
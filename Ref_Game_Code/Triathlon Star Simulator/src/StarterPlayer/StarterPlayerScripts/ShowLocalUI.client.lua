-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:32
-- Luau version 6, Types version 3
-- Time taken: 0.001675 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer_upvr = game.Players.LocalPlayer
local HideScreenGuiModule_upvr = require(ReplicatedStorage.Tool.HideScreenGuiModule)
LocalPlayer_upvr:WaitForChild("PlayerGui", math.huge):WaitForChild("ScreenGui", math.huge)
local Folder_upvr = Instance.new("Folder", LocalPlayer_upvr)
Folder_upvr.Name = "ShieldFolder"
local module_upvr = require(ReplicatedStorage:WaitForChild("Tool"):WaitForChild("UIanima"))
local function showUI_upvr(arg1, arg2, arg3, arg4) -- Line 20, Named "showUI"
	--[[ Upvalues[4]:
		[1]: Folder_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
		[3]: module_upvr (readonly)
		[4]: HideScreenGuiModule_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [2] 2. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [2] 2. Error Block 2 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [3] 3. Error Block 3 start (CF ANALYSIS FAILED)
	local guildID = arg2.guildID
	-- KONSTANTERROR: [3] 3. Error Block 3 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [8] 6. Error Block 4 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [8] 6. Error Block 4 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [9] 7. Error Block 5 start (CF ANALYSIS FAILED)
	local SOME_2 = Folder_upvr:FindFirstChild(guildID)
	-- KONSTANTERROR: [9] 7. Error Block 5 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [15] 12. Error Block 6 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [15] 12. Error Block 6 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [19] 14. Error Block 7 start (CF ANALYSIS FAILED)
	do
		return
	end
	-- KONSTANTERROR: [19] 14. Error Block 7 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [20] 15. Error Block 8 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [20] 15. Error Block 8 end (CF ANALYSIS FAILED)
end
ReplicatedStorage.LocalMsg.refreshLocalUI.Event:Connect(function(arg1, arg2, arg3) -- Line 82
	--[[ Upvalues[2]:
		[1]: LocalPlayer_upvr (readonly)
		[2]: showUI_upvr (readonly)
	]]
	if not LocalPlayer_upvr:WaitForChild("PlayerGui"):WaitForChild("ScreenGui"):FindFirstChild(arg1) then
		warn("没有这个弹窗"..arg1)
	else
		showUI_upvr(arg1, arg2, arg3)
	end
end)
ReplicatedStorage.LocalMsg.showLocalUI.Event:Connect(function(arg1, arg2, arg3, arg4) -- Line 92
	--[[ Upvalues[2]:
		[1]: LocalPlayer_upvr (readonly)
		[2]: showUI_upvr (readonly)
	]]
	local SOME = LocalPlayer_upvr:WaitForChild("PlayerGui"):WaitForChild("ScreenGui"):FindFirstChild(arg1)
	if not SOME then
		warn("没有这个弹窗"..arg1)
	else
		if arg3 == nil then
			showUI_upvr(arg1, arg2, not SOME.Visible)
			return
		end
		showUI_upvr(arg1, arg2, arg3, arg4)
	end
end)
ReplicatedStorage.ServerMsg.showLocalUI.OnClientEvent:Connect(function(arg1, arg2, arg3, arg4) -- Line 106
	--[[ Upvalues[1]:
		[1]: showUI_upvr (readonly)
	]]
	showUI_upvr(arg1, arg2, arg3, arg4)
end)
ReplicatedStorage.LocalMsg.fadeUI.Event:Connect(function(arg1) -- Line 111
	--[[ Upvalues[2]:
		[1]: LocalPlayer_upvr (readonly)
		[2]: HideScreenGuiModule_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local _, _, _ = pairs(LocalPlayer_upvr:WaitForChild("PlayerGui"):WaitForChild("ScreenGui"):GetChildren())
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [16] 13. Error Block 2 start (CF ANALYSIS FAILED)
	local _, pairs_result2, _ = pairs(arg1)
	-- KONSTANTERROR: [16] 13. Error Block 2 end (CF ANALYSIS FAILED)
end)
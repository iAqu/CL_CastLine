-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TextChatService = game:GetService("TextChatService")
game:GetService("StarterGui")
local Window = require(script.Parent.CmdrInterface.Window)
local function ChatMakeSystemMessage(p1, p2) --[[ ChatMakeSystemMessage | Line: 6 | Upvalues: TextChatService (copy) ]]
	local RBXGeneral = TextChatService:FindFirstChild("RBXGeneral", true)
	if not RBXGeneral then
		return
	end
	RBXGeneral:DisplaySystemMessage(string.format("<font color=\'rgb(%d,%d,%d)\'>%s</font>", p2.R * 255, p2.G * 255, p2.B * 255, p1))
end
return function(p1) --[[ Line: 18 | Upvalues: TextChatService (copy), Window (copy) ]]
	p1:HandleEvent("Message", function(p1) --[[ Line: 19 | Upvalues: TextChatService (ref) ]]
		local v1 = ("[Announcement] %s"):format(p1)
		local v2 = Color3.fromRGB(249, 217, 56)
		local RBXGeneral = TextChatService:FindFirstChild("RBXGeneral", true)
		if not RBXGeneral then
			return
		end
		RBXGeneral:DisplaySystemMessage(string.format("<font color=\'rgb(%d,%d,%d)\'>%s</font>", v2.R * 255, v2.G * 255, v2.B * 255, v1))
	end)
	p1:HandleEvent("AddLine", function(...) --[[ Line: 23 | Upvalues: Window (ref) ]]
		Window:AddLine(...)
	end)
end
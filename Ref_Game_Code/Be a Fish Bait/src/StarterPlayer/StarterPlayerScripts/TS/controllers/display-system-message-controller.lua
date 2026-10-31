-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local TextChatService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TextChatService
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events

local function capitalizeRarity(p1) -- line: 7
    return string.upper((string.sub(p1, 1, 1))) .. string.sub(p1, 2)
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 13
        return "SystemMessageController"
    end
})

self.__index = self

function self.new(...) -- line: 18
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(_) -- line: 22
end

function self.onStart(_) -- line: 24
    -- upvalues: TextChatService (copy), events (copy)
    local ChannelTabsConfiguration = TextChatService:WaitForChild("ChatWindowConfiguration"):FindFirstChild("ChannelTabsConfiguration")

    if ChannelTabsConfiguration ~= nil then
        ChannelTabsConfiguration.Enabled = true
    end

    events.displaySystemMessage:connect(function(p4) -- line: 30
        -- upvalues: TextChatService (copy)
        TextChatService:WaitForChild("TextChannels"):WaitForChild("Server Message"):DisplaySystemMessage(p4)
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/display-system-message-controller@SystemMessageController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    SystemMessageController = self
}

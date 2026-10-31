-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, TextChatService = services.Players, services.TextChatService
local selectPlayerChatTags = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "chat-tags.selectors").selectPlayerChatTags
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 12
        return "ChatTagsController"
    end
})

self.__index = self

function self.new(...) -- line: 17
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 21
    p1._reflexController = p2
end

function self.onStart(p3) -- line: 24
    -- upvalues: Players (copy), TextChatService (copy), selectPlayerChatTags (copy)
    local v3 = p3._reflexController:getClientProducer()

    TextChatService.OnIncomingMessage = function(p4) -- line: 26
        -- upvalues: v3 (copy), Players (copy), selectPlayerChatTags (copy)
        local TextSource = p4.TextSource

        if TextSource ~= nil then
            TextSource = TextSource.UserId
        end

        if TextSource == nil then
            return nil
        end

        local PlayerByUserId = Players:GetPlayerByUserId(TextSource)

        if not PlayerByUserId then
            return nil
        end

        local v5 = selectPlayerChatTags((tostring(TextSource)))(v3:getState())

        if not v5 or #v5.tags == 0 then
            return nil
        end

        local TextChatMessageProperties = Instance.new("TextChatMessageProperties")
        local tags = v5.tags

        table.sort(tags, function(p5, p6) -- line: 46
            return p5.order < p6.order
        end)

        local v6 = table.create(#tags)

        local function v7(p7) -- line: 51
            return p7.richText
        end

        for v8, v9 in tags do
            local _ = v8 - 1

            v6[v8] = v9.richText
        end

        TextChatMessageProperties.PrefixText = table.concat(v6, " ") .. (" %*:"):format(PlayerByUserId.DisplayName)

        return TextChatMessageProperties
    end
end

Reflect.defineMetadata(self, "identifier", "client/controllers/chat-tags-controller@ChatTagsController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    ChatTagsController = self
}

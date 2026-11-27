-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local t1 = {}

t1.__index = t1
t1.ATTRIBUTE = "OwnsVIP"
t1.TAG = "<font color=\"#FFD23C\"><b>[VIP]</b></font> "

function t1.new() -- line: 9
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self.Tagged = 0

    return self
end

function t1:IsVip(p2) -- line: 15
    -- upvalues: Players (copy)
    local PlayerByUserId = Players:GetPlayerByUserId(p2)

    return PlayerByUserId ~= nil and PlayerByUserId:GetAttribute(self.ATTRIBUTE) == true
end

function t1:Decorate(p4) -- line: 20
    local TextSource = p4.TextSource

    if TextSource and self:IsVip(TextSource.UserId) then
        local TextChatMessageProperties = Instance.new("TextChatMessageProperties")

        TextChatMessageProperties.PrefixText = self.TAG .. (p4.PrefixText or "")
        self.Tagged += 1

        return TextChatMessageProperties
    end

    return nil
end

function t1:Start() -- line: 31
    -- upvalues: TextChatService (copy)
    TextChatService.OnIncomingMessage = function(p6) -- line: 32
        -- upvalues: self (copy)
        local Decorate = self.Decorate
        local ok, result = pcall(Decorate, self, p6)

        return if ok then result else nil
    end
end

t1.Shared = t1.new()

return t1

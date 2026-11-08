-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local t1 = {}
local TextChannel = Instance.new("TextChannel")

TextChannel.Name = "GameSystem"
TextChannel.Parent = TextChatService

local function markup(p1) -- line: 22
    local Color = p1.Color

    if Color == nil then
        return p1.Text
    end

    return (("<font color=\"#%*\">%*</font>"):format(Color:ToHex(), p1.Text))
end

local function metadata(p2) -- line: 32
    -- upvalues: HttpService (copy)
    local Rarity = p2.Rarity

    if Rarity == nil then
        return ""
    end

    return HttpService:JSONEncode({
        rarity = Rarity
    })
end

local function accept(p3) -- line: 41
    local Color, Rarity, t2, v1

    if typeof(p3) == "table" then
        if typeof(p3.Text) == "string" then
            Color = p3.Color
            Rarity = p3.Rarity
            t2 = {
                Text = p3.Text
            }

            if typeof(Color) ~= "Color3" then
                Color = nil
            end

            v1 = false
        else
            v1 = true
        end
    else
        v1 = true
    end

    if v1 then
        return nil
    end

    t2.Color = Color

    if typeof(Rarity) ~= "string" then
        Rarity = nil
    end

    t2.Rarity = Rarity

    return t2
end

function t1.Post(p4) -- line: 54
    -- upvalues: TextChannel (copy), metadata (copy)
    local Color = p4.Color

    TextChannel:DisplaySystemMessage(if Color == nil then p4.Text else ("<font color=\"#%*\">%*</font>"):format(Color:ToHex(), p4.Text), metadata(p4))
end

Remotes.ChatFeed.Post.OnClientEvent:Connect(function(p5) -- line: 58
    -- upvalues: t1 (copy), accept (copy)
    local v3 = accept(p5)

    if v3 ~= nil then
        t1.Post(v3)
    end
end)

return table.freeze(t1)

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local Rarity = require(ReplicatedStorage.Data.Rarity)
local Staff = require(ReplicatedStorage.Shared.Modules.Staff)
local FFC700 = Color3.fromHex("FFC700")
local v1 = Color3.new(1, 1, 1)
local t1 = {
    Divine = true,
    Eternal = true,
    Secret = true
}
local t2 = {}

local function tinted(p1, p2) -- line: 27
    return (("<font color=\"#%*\">%*</font>"):format(p2:ToHex(), p1))
end

local function freshProperties() -- line: 31
    -- upvalues: TextChatService (copy)
    return TextChatService.ChatWindowConfiguration:DeriveNewMessageProperties()
end

local function badgesFor(p3) -- line: 36
    -- upvalues: Players (copy), Staff (copy), FFC700 (copy)
    local t3 = {}
    local v2 = if p3 == nil then nil else Players:GetPlayerByUserId(p3.UserId)

    if v2 ~= nil then
        local CreatorDisguiseUserId = v2:GetAttribute("CreatorDisguiseUserId")
        local v3 = Staff.ChatTag(if typeof(CreatorDisguiseUserId) == "number" then CreatorDisguiseUserId else v2.UserId)

        if v3 ~= nil then
            table.insert(t3, v3)
        end

        if CreatorDisguiseUserId == nil and v2:GetAttribute("MonetizationVipProductOwned") == true then
            table.insert(t3, (("<font color=\"#%*\">[VIP-OG]</font>"):format((FFC700:ToHex()))))
        end
    end

    return t3
end

local function speakerName(p4) -- line: 55
    -- upvalues: Players (copy)
    local TextSource = p4.TextSource
    local v5 = if TextSource == nil then nil else Players:GetPlayerByUserId(TextSource.UserId)
    local CreatorDisguiseName = if v5 == nil then nil else v5:GetAttribute("CreatorDisguiseName")

    if v5 == nil or typeof(CreatorDisguiseName) ~= "string" then
        return nil
    end

    local v6 = string.gsub(v5.DisplayName, "%p", "%%%0")
    local v7 = string.gsub(CreatorDisguiseName, "%%", "%%%%")

    return (string.gsub(p4.PrefixText, v6, v7, 1))
end

local function rarityIn(p5) -- line: 68
    -- upvalues: HttpService (copy)
    if p5 == "" then
        return nil
    end

    local JSONDecode = HttpService.JSONDecode
    local ok, result = pcall(JSONDecode, HttpService, p5)

    return if ok and typeof(result) == "table" then result.rarity else nil
end

local function shineFor(p6) -- line: 76
    -- upvalues: HttpService (copy), Rarity (copy), t1 (copy)
    local rarity

    if p6 ~= "" then
        local JSONDecode = HttpService.JSONDecode
        local ok, result = pcall(JSONDecode, HttpService, p6)

        if ok and typeof(result) == "table" then
            rarity = result.rarity
        end
    end

    local v8 = if rarity == nil or not t1[rarity] then nil else Rarity.Rarities[rarity]

    return if v8 ~= nil then v8.RarityGradient else nil
end

function TextChatService.OnIncomingMessage(p7) -- line: 82
    -- upvalues: HttpService (copy), TextChatService (copy), Rarity (copy), v1 (copy), t1 (copy), badgesFor (copy), speakerName (copy)
    local v9 = badgesFor(p7.TextSource)
    local Metadata = p7.Metadata
    local rarity

    if Metadata ~= "" then
        local JSONDecode = HttpService.JSONDecode
        local ok, result = pcall(JSONDecode, HttpService, Metadata)

        if ok and typeof(result) == "table" then
            rarity = result.rarity
        end
    end

    local v10 = if rarity == nil or not t1[rarity] then nil else Rarity.Rarities[rarity]
    local RarityGradient = if v10 == nil then nil else v10.RarityGradient

    if RarityGradient == nil then
        local v11 = speakerName(p7)

        if #v9 == 0 and v11 == nil then
            return nil
        end

        local v12 = TextChatService.ChatWindowConfiguration:DeriveNewMessageProperties()

        if #v9 > 0 then
            v12.PrefixText = ("%* %*"):format(table.concat(v9, " "), v11 or p7.PrefixText)
        else
            v12.PrefixText = v11 or p7.PrefixText
        end

        return v12
    end

    local v13 = string.gsub(p7.Text, "!", "")

    if #v9 > 0 then
        v13 = ("%* %*"):format(table.concat(v9, " "), v13)
    end

    local v14 = TextChatService.ChatWindowConfiguration:DeriveNewMessageProperties()

    v14.TextColor3 = v1

    local v15 = TextChatService.ChatWindowConfiguration:DeriveNewMessageProperties()

    v15.PrefixText = v13
    v15.PrefixTextProperties = v14
    v15.Text = "!"
    v15.TextColor3 = v1

    local clone = RarityGradient:Clone()

    clone.Parent = v14
    p7.ChatWindowMessageProperties = v15
    task.delay(10, function() -- line: 117
        -- upvalues: clone (copy)
        clone.Enabled = false
    end)

    return v15
end

return table.freeze(t2)

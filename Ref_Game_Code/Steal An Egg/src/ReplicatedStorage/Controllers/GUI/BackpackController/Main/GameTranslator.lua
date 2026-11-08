-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

game.Players.LocalPlayer.PlayerGui:WaitForChild("BackpackGui")

local v1, LocalPlayer, LocaleId, connection
local BindableEvent = Instance.new("BindableEvent")

local function handlePlayerOrLocaleChanged() -- line: 14
    -- upvalues: LocalPlayer (ref), LocaleId (ref), BindableEvent (copy)
    if not LocalPlayer or LocalPlayer.LocaleId == LocaleId then
        return
    end

    LocaleId = LocalPlayer.LocaleId
    BindableEvent:Fire(LocaleId)
end

local function reset() -- line: 21
    -- upvalues: v1 (ref), LocalPlayer (ref), connection (ref)
    v1 = nil
    LocalPlayer = nil

    if connection then
        connection:Disconnect()
        connection = nil
    end
end

local function getTranslator() -- line: 31
    -- upvalues: LocalizationService (copy), Players (copy), v1 (ref), LocalPlayer (ref), LocaleId (ref), connection (ref), BindableEvent (copy), handlePlayerOrLocaleChanged (copy)
    if not v1 then
        LocalPlayer = Players.LocalPlayer

        if LocalPlayer then
            v1 = LocalizationService:GetTranslatorForPlayer(LocalPlayer)

            if LocalPlayer and LocalPlayer.LocaleId ~= LocaleId then
                LocaleId = LocalPlayer.LocaleId
                BindableEvent:Fire(LocaleId)
            end

            connection = LocalPlayer:GetPropertyChangedSignal("LocaleId"):Connect(handlePlayerOrLocaleChanged)
        end
    end

    return v1
end

local t1 = {}

local function unregisterGui(p1) -- line: 47
    -- upvalues: t1 (copy)
    t1[p1].connection:Disconnect()
    t1[p1] = nil
end

local function makeAncestryChangedHandler(p2, p3) -- line: 52
    -- upvalues: t1 (copy)
    return function(_, _) -- line: 53
        -- upvalues: p2 (copy), p3 (copy), t1 (copy)
        local v2 = game:IsAncestorOf(p2)
        local hasBeenAdded

        if v2 then
            p3.hasBeenAdded = true
        else
            hasBeenAdded = p3.hasBeenAdded
        end

        if (v2 or hasBeenAdded) and not v2 then
            t1[p2].connection:Disconnect()
            t1[p2] = nil
        end
    end
end

local function updateRegistryInfo(p6, p7, p8) -- line: 64
    p6.context = p7
    p6.text = p8
end

local function makeRegistryInfo(p9, p10, p11) -- line: 69
    -- upvalues: t1 (copy)
    local t2 = {
        hasBeenAdded = game:IsAncestorOf(p9)
    }

    t2.context = p10
    t2.text = p11
    t2.connection = p9.AncestryChanged:Connect(function(_, _) -- line: 53
        -- upvalues: p9 (copy), t2 (copy), t1 (copy)
        local v3 = game:IsAncestorOf(p9)
        local hasBeenAdded

        if v3 then
            t2.hasBeenAdded = true
        else
            hasBeenAdded = t2.hasBeenAdded
        end

        if (v3 or hasBeenAdded) and not v3 then
            t1[p9].connection:Disconnect()
            t1[p9] = nil
        end
    end)

    return t2
end

local function registerGui(p14, p15, p16) -- line: 76
    -- upvalues: t1 (copy), makeRegistryInfo (copy)
    if t1[p14] ~= nil then
        local v4 = t1[p14]

        v4.context = p15
        v4.text = p16
    else
        t1[p14] = makeRegistryInfo(p14, p15, p16)
    end
end

local t3 = {
    LocaleChanged = BindableEvent.Event,
    TranslateGameText = function(_, _, p19) -- TranslateGameText | line: 102
        return p19
    end
}

local function retranslateAll() -- line: 115
    -- upvalues: t1 (copy), t3 (copy)
    for v5, v6 in pairs(t1) do
        v5.Text = t3:TranslateGameText(v6.context, v6.text)
    end
end

function t3.TranslateAndRegister(_, _, _, p23) -- line: 125
    return p23
end

return t3

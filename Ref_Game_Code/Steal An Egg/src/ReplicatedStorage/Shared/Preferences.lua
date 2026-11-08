-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local t1 = {
    {
        Section = "Audio",
        Items = {
            {
                Key = "Music",
                Default = true,
                Title = "Music",
                Summary = "Play background music."
            },
            {
                Key = "SFX",
                Default = true,
                Title = "Sound Effects",
                Summary = "Play sound effects."
            }
        }
    },
    {
        Section = "Gameplay",
        Items = {
            {
                Key = "HideOtherPets",
                Default = false,
                Title = "Hide Other Pets",
                Summary = "Hide the pets of other players."
            },
            {
                Key = "HideSelfPets",
                Default = false,
                Title = "Hide Your Pets",
                Summary = "Hide your own pets on your plot."
            },
            {
                Key = "DisableVideos",
                Default = false,
                Title = "Disable Videos",
                Summary = "Turn off the treadmill video."
            },
            {
                Key = "AFK",
                Default = false,
                Title = "AFK Mode",
                Summary = "Stay in the lobby and skip Murder Mystery rounds."
            }
        }
    },
    {
        Section = "Interface",
        Items = {
            {
                Key = "VirtualCursor",
                Default = false,
                Title = "Menu Navigation",
                Summary = "Use a cursor instead of button navigation in menus."
            },
            {
                Key = "CreatorPanel",
                Default = true,
                Title = "Creator Panel",
                Summary = "Open the creator panel with F3. Shown to accounts with creator access."
            }
        }
    },
    {
        Section = "Internal",
        Items = {
            {
                Key = "SeenNavigationHint",
                Default = false,
                Title = "Navigation Hint Seen"
            }
        }
    }
}
local t2 = {
    Catalogue = t1
}
local t3 = {}
local t4 = {}
local t5 = {}

for _, v1 in t1 do
    for _, v2 in v1.Items do
        t3[v2.Key] = v2
        t4[v2.Key] = v2.Default
        t5[v2.Key] = {}
        table.freeze(v2)
    end

    table.freeze(v1.Items)
    table.freeze(v1)
end

table.freeze(t1)

local function itemFor(p1) -- line: 96
    -- upvalues: t3 (copy)
    local v3 = t3[p1]

    if v3 == nil then
        error(("\"%*\" is not a preference"):format((tostring(p1))), 3)
    end

    return v3
end

local function asFlag(p2, p3) -- line: 106
    if typeof(p3) == "boolean" then
        return p3
    end

    return p2.Default
end

local function notify(p4) -- line: 110
    -- upvalues: t4 (copy), t5 (copy)
    local v4 = t4[p4]

    for _, v5 in table.clone(t5[p4]) do
        v5.Notify(v4)
    end
end

local function put(p5, p6) -- line: 119
    -- upvalues: t3 (copy), t4 (copy)
    local v6 = t3[p5]
    local v7 = if typeof(p6) == "boolean" then p6 else v6.Default

    if t4[p5] == v7 then
        return false
    end

    t4[p5] = v7

    return true
end

local function absorb(p7) -- line: 129
    -- upvalues: t3 (copy), t4 (copy), t5 (copy)
    local v8 = if typeof(p7) == "table" then p7 else {}
    local t6 = {}

    for v9 in t3 do
        local v10 = v8[v9]
        local v11 = t3[v9]

        if typeof(v10) ~= "boolean" then
            v10 = v11.Default
        end

        if t4[v9] ~= v10 then
            t4[v9] = v10
            table.insert(t6, v9)
        end
    end

    for _, v12 in t6 do
        local v13 = t4[v12]

        for _, v14 in table.clone(t5[v12]) do
            v14.Notify(v13)
        end
    end
end

function t2.IsOn(p8) -- line: 142
    -- upvalues: t3 (copy), t4 (copy)
    if t3[p8] == nil then
        error(("\"%*\" is not a preference"):format((tostring(p8))), 3)
    end

    return t4[p8]
end

function t2.Set(p9, p10) -- line: 149
    -- upvalues: Remotes (copy), t3 (copy), t4 (copy), t5 (copy), absorb (copy)
    if t3[p9] == nil then
        error(("\"%*\" is not a preference"):format((tostring(p9))), 3)
    end

    if typeof(p10) ~= "boolean" then
        error(("preference values are booleans, got %*"):format((typeof(p10))), 2)
    end

    local function v15() -- line: 155
        -- upvalues: p9 (copy), p10 (copy), Remotes (copy)
        return Remotes.Preferences.AskWrite:InvokeServer(p9, p10)
    end

    local v16, v17, v18 = pcall(v15)

    if v16 then
        if v17 ~= true then
            return false
        end

        if typeof(v18) == "table" then
            absorb(v18)
        else
            local v19 = t3[p9]
            local v20 = if typeof(p10) == "boolean" then p10 else v19.Default

            if t4[p9] ~= v20 then
                t4[p9] = v20

                local v21 = t4[p9]

                for _, v22 in table.clone(t5[p9]) do
                    v22.Notify(v21)
                end
            end
        end

        return true
    end

    warn((("preference write for %* raised: %*"):format(p9, (tostring(v17)))))

    return false
end

function t2.Toggle(p11) -- line: 174
    -- upvalues: t2 (copy)
    return t2.Set(p11, not t2.IsOn(p11))
end

function t2.Observe(p12, p13) -- line: 180
    -- upvalues: t3 (copy), t4 (copy), t5 (copy)
    if t3[p12] == nil then
        error(("\"%*\" is not a preference"):format((tostring(p12))), 3)
    end

    local v23 = t5[p12]
    local t7 = {
        Notify = p13
    }

    table.insert(v23, t7)
    p13(t4[p12])

    return function() -- line: 186
        -- upvalues: v23 (copy), t7 (copy)
        local v24 = table.find(v23, t7)

        if v24 ~= nil then
            table.remove(v23, v24)
        end
    end
end

Remotes.Preferences.PreferenceShifted.OnClientEvent:Connect(function(p14, p15) -- line: 196
    -- upvalues: t3 (copy), t4 (copy), t5 (copy)
    local v25, v26

    if typeof(p14) ~= "string" or t3[p14] == nil then
        v26 = true
    else
        local v27 = t3[p14]

        v25 = if typeof(p15) == "boolean" then p15 else v27.Default
        v26 = false
    end

    if v26 or t4[p14] == v25 then
        return
    end

    t4[p14] = v25

    local v28 = t4[p14]

    for _, v29 in table.clone(t5[p14]) do
        v29.Notify(v28)
    end
end)
Save.Watch("Settings"):Connect(absorb)
task.spawn(function() -- line: 204
    -- upvalues: Save (copy), absorb (copy)
    local v30 = Save.Await()

    if v30 ~= nil then
        absorb(v30.Settings)
    end
end)

return table.freeze(t2)

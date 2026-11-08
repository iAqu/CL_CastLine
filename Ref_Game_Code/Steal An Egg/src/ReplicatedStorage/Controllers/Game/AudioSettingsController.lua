-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Preferences = require(ReplicatedStorage.Shared.Preferences)
local Signal = require(ReplicatedStorage.Packages.Signal)
local t1 = {
    Music = { "Music" },
    SFX = { "Gameplay", "GameplayReverb" }
}
local t2 = {
    Music = 1,
    SFX = 1
}
local t3 = {}
local t4 = {
    Changed = Signal.new()
}

function t4.Get(p1) -- line: 36
    -- upvalues: t2 (copy)
    return t2[p1]
end

function t4.Set(p2, p3) -- line: 40
    -- upvalues: t2 (copy), t4 (copy)
    assert(t2[p2] ~= nil, (("no volume category called %*"):format(p2)))

    local v3 = math.clamp(p3, 0, 1)

    if t2[p2] ~= v3 then
        t2[p2] = v3
        t4.Changed:Fire(p2, v3)
    end
end

function t4.Start() -- line: 50
    -- upvalues: SoundService (copy), Preferences (copy), t1 (copy), t3 (copy), t4 (copy)
    local function gainFor(p4) -- line: 52
        -- upvalues: Preferences (copy), t4 (copy)
        if Preferences.IsOn(p4) then
            return (t4.Get(p4))
        end

        return 0
    end

    local function apply(p5) -- line: 56
        -- upvalues: Preferences (copy), t4 (copy)
        local Setting = p5.Setting
        local v4 = if Preferences.IsOn(Setting) then t4.Get(Setting) else 0

        for v5, v6 in p5.Groups do
            v6.Volume = p5.Authored[v5] * v4
        end
    end

    local function onTouched(p6) -- line: 63
        -- upvalues: Preferences (copy), t3 (copy), t4 (copy)
        local v7 = t3[p6]

        if v7 == nil then
            return
        end

        local Setting = v7.Setting
        local v8 = if Preferences.IsOn(Setting) then t4.Get(Setting) else 0

        for v9, v10 in v7.Groups do
            v10.Volume = v7.Authored[v9] * v8
        end
    end

    for v11, v12 in t1 do
        local t5 = {}
        local t6 = {}

        for _, v13 in v12 do
            local v14 = SoundService:WaitForChild(v13)

            table.insert(t5, v14)
            table.insert(t6, v14.Volume)
        end

        t3[v11] = {
            Setting = v11,
            Groups = t5,
            Authored = t6
        }
    end

    t4.Changed:Connect(onTouched)

    for _, v15 in t3 do
        Preferences.Observe(v15.Setting, function() -- line: 87
            -- upvalues: v15 (copy), Preferences (copy), t4 (copy)
            local Setting = v15.Setting
            local v16 = if Preferences.IsOn(Setting) then t4.Get(Setting) else 0

            for v17, v18 in v15.Groups do
                v18.Volume = v15.Authored[v17] * v16
            end
        end)
    end
end

return table.freeze(t4)

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local SoundService = game:GetService("SoundService")
local t1 = {
    AdComplete = {
        id = "rbxassetid://15675043410",
        volume = 0.4
    },
    Click = {
        id = "rbxassetid://15675059323",
        volume = 0.2
    },
    Enter = {
        id = "rbxassetid://96158989044754",
        volume = 0.2
    }
}
local t2 = {}

local function getSound(p1) -- line: 11
    -- upvalues: SoundService (copy), t1 (copy), t2 (copy)
    local v1 = t2[p1]

    if v1 then
        return v1
    end

    local v2 = t1[p1]
    local Sound = Instance.new("Sound")

    Sound.Name = p1
    Sound.SoundId = v2.id
    Sound.Volume = v2.volume
    Sound.Parent = SoundService

    if p1 == "Enter" then
        local PitchShiftSoundEffect = Instance.new("PitchShiftSoundEffect")

        PitchShiftSoundEffect.Octave = 0.4
        PitchShiftSoundEffect.Parent = Sound
    end

    t2[p1] = Sound

    return Sound
end

return {
    playAdCompleteSound = function() -- playAdCompleteSound | line: 32
        -- upvalues: SoundService (copy), t1 (copy), t2 (copy)
        local AdComplete = t2.AdComplete

        if not AdComplete then
            local AdComplete2 = t1.AdComplete

            AdComplete = Instance.new("Sound")
            AdComplete.Name = "AdComplete"
            AdComplete.SoundId = AdComplete2.id
            AdComplete.Volume = AdComplete2.volume
            AdComplete.Parent = SoundService
            t2.AdComplete = AdComplete
        end

        AdComplete:Play()
    end,
    playClickSound = function() -- playClickSound | line: 35
        -- upvalues: SoundService (copy), t1 (copy), t2 (copy)
        local Click = t2.Click

        if not Click then
            local Click2 = t1.Click

            Click = Instance.new("Sound")
            Click.Name = "Click"
            Click.SoundId = Click2.id
            Click.Volume = Click2.volume
            Click.Parent = SoundService
            t2.Click = Click
        end

        Click:Play()
    end,
    playEnterSound = function() -- playEnterSound | line: 38
        -- upvalues: SoundService (copy), t1 (copy), t2 (copy)
        local Enter = t2.Enter

        if not Enter then
            local Enter2 = t1.Enter

            Enter = Instance.new("Sound")
            Enter.Name = "Enter"
            Enter.SoundId = Enter2.id
            Enter.Volume = Enter2.volume
            Enter.Parent = SoundService

            local PitchShiftSoundEffect = Instance.new("PitchShiftSoundEffect")

            PitchShiftSoundEffect.Octave = 0.4
            PitchShiftSoundEffect.Parent = Enter
            t2.Enter = Enter
        end

        Enter:Play()
    end
}

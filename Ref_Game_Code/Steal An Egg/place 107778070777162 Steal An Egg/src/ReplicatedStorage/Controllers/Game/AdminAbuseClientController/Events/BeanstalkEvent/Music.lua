-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local MusicDirector = require(ReplicatedStorage.Client.MusicDirector)
local Preferences = require(ReplicatedStorage.Shared.Preferences)

require(ReplicatedStorage.Packages.Trove)

local Music = ReplicatedStorage.Assets.Sounds.BeanstalkEvent.Music
local v1 = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local t1 = {}
local t2 = {}
local t3 = {}
local v2, v3
local v4 = true

local function fade(p1, p2) -- line: 38
    -- upvalues: TweenService (copy), v1 (copy), t3 (copy)
    local v5 = t3[p1]

    if v5 then
        v5:Cancel()
    end

    if p2 > 0 and not p1.IsPlaying then
        p1.TimePosition = 0
        p1:Play()
    end

    local tween = TweenService:Create(p1, v1, {
        Volume = p2
    })

    t3[p1] = tween
    tween.Completed:Once(function(p3) -- line: 49
        -- upvalues: p1 (copy), p2 (copy), tween (copy), t3 (copy)
        if t3[p1] == tween then
            t3[p1] = nil
        end

        if p3 == Enum.PlaybackState.Completed and p2 <= 0 then
            p1:Stop()
        end
    end)
    tween:Play()
end

local function apply() -- line: 60
    -- upvalues: t1 (copy), t2 (copy), v2 (ref), v3 (ref), v4 (ref), fade (copy)
    local v6 = if v4 then v2 else nil

    if v6 == v3 or v6 ~= nil and t1[v6] == nil then
        return
    end

    local v7 = v3

    v3 = v6

    if v7 ~= nil then
        fade(t1[v7], 0)
    end

    if v6 ~= nil then
        fade(t1[v6], t2[v6])
    end
end

return {
    Start = function(p4) -- Start | line: 80
        -- upvalues: Debris (copy), SoundService (copy), TweenService (copy), MusicDirector (copy), Preferences (copy), Music (copy), v1 (copy), t1 (copy), t2 (copy), t3 (copy), v2 (ref), v3 (ref), v4 (ref), fade (copy)
        for _, child in Music:GetChildren() do
            assert(child:IsA("Sound"), (("%* must be a Sound"):format((child:GetFullName()))))

            local clone = child:Clone()

            t2[clone.Name] = clone.Volume
            clone.Volume = 0
            clone.Parent = SoundService
            t1[clone.Name] = clone
        end

        MusicDirector.SetEventMusic(true)
        p4:Add(Preferences.Observe("Music", function(p5) -- line: 91
            -- upvalues: t1 (copy), t2 (copy), v2 (ref), v3 (ref), v4 (ref), fade (copy)
            v4 = p5 ~= false

            local v9 = if v4 then v2 else nil

            if v9 == v3 or v9 ~= nil and t1[v9] == nil then
                return
            end

            local v10 = v3

            v3 = v9

            if v10 ~= nil then
                fade(t1[v10], 0)
            end

            if v9 ~= nil then
                fade(t1[v9], t2[v9])
            end
        end))
        p4:Add(function() -- line: 95
            -- upvalues: Debris (copy), TweenService (copy), MusicDirector (copy), v1 (copy), t1 (copy), t2 (copy), t3 (copy), v2 (ref), v3 (ref)
            MusicDirector.SetEventMusic(false)

            for _, v11 in t1 do
                local v12 = t3[v11]

                if v12 then
                    v12:Cancel()
                end

                TweenService:Create(v11, v1, {
                    Volume = 0
                }):Play()
                Debris:AddItem(v11, v1.Time)
            end

            table.clear(t1)
            table.clear(t2)
            table.clear(t3)
            v2 = nil
            v3 = nil
        end)
    end,
    Play = function(p6) -- Play | line: 113
        -- upvalues: MusicDirector (copy), Music (copy), t1 (copy), t2 (copy), v2 (ref), v3 (ref), v4 (ref), fade (copy)
        assert(Music:FindFirstChild(p6) ~= nil, (("No Beanstalk music track named %*"):format(p6)))
        MusicDirector.SetEventMusic(true)
        v2 = p6

        local v15 = if v4 then v2 else nil

        if v15 == v3 or v15 ~= nil and t1[v15] == nil then
            return
        end

        local v16 = v3

        v3 = v15

        if v16 ~= nil then
            fade(t1[v16], 0)
        end

        if v15 ~= nil then
            fade(t1[v15], t2[v15])
        end
    end,
    Release = function() -- Release | line: 121
        -- upvalues: MusicDirector (copy), t1 (copy), t2 (copy), v2 (ref), v3 (ref), v4 (ref), fade (copy)
        v2 = nil

        local v17 = if v4 then v2 else nil

        if v17 ~= v3 and (v17 == nil or t1[v17] ~= nil) then
            local v18 = v3

            v3 = v17

            if v18 ~= nil then
                fade(t1[v18], 0)
            end

            if v17 ~= nil then
                fade(t1[v17], t2[v17])
            end
        end

        MusicDirector.SetEventMusic(false)
    end
}

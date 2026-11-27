-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")
local t1 = {
    137052434290156, 73705869162277, 1844398912, 1844398749
}
local LocalPlayer = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")

local function setting() -- line: 71
    -- upvalues: LocalPlayer (copy)
    local SetMusic = LocalPlayer:GetAttribute("SetMusic")

    if type(SetMusic) ~= "number" or not SetMusic then
        SetMusic = 0.5
    end

    return SetMusic
end

local function duck() -- line: 76
    -- upvalues: LocalPlayer (copy)
    local MusicDuck = LocalPlayer:GetAttribute("MusicDuck")

    return type(MusicDuck) == "number" and math.clamp(MusicDuck, 0, 1) or 1
end

local function trackOn() -- line: 80
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("MusicTrack") ~= nil
end

local function weatherOn() -- line: 83
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("MusicWeather") ~= nil
end

local function target() -- line: 86
    -- upvalues: LocalPlayer (copy)
    if LocalPlayer:GetAttribute("MusicTrack") ~= nil or LocalPlayer:GetAttribute("MusicWeather") ~= nil then
        return 0
    end

    local SetMusic = LocalPlayer:GetAttribute("SetMusic")
    local v1 = 0.5 * (type(SetMusic) == "number" and SetMusic or 0.5)
    local MusicDuck = LocalPlayer:GetAttribute("MusicDuck")

    return v1 * (type(MusicDuck) == "number" and math.clamp(MusicDuck, 0, 1) or 1)
end

local function weatherTarget() -- line: 91
    -- upvalues: LocalPlayer (copy)
    local v2 = false
    local v3 = false
    local v4 = false
    local v5 = false

    if LocalPlayer:GetAttribute("MusicWeather") ~= nil then
        v2 = true
    end

    if v2 then
        if LocalPlayer:GetAttribute("MusicTrack") ~= nil then
            v3 = true
        else
            v4 = true
        end
    end

    v2 = false

    local v6

    if v3 then
        v6 = true
        v2 = true
    end

    v3 = false

    if v4 then
        v6 = false
        v2 = true
    end

    v4 = false

    if v2 then
        if v6 then
            v5 = false
        else
            v4 = true
        end
    end

    v2 = false

    local v7, SetMusic

    if v4 then
        v7 = (LocalPlayer:GetAttribute("MusicWeatherVolume") or 0.25) * 2
        SetMusic = LocalPlayer:GetAttribute("SetMusic")

        if type(SetMusic) == "number" then
            v2 = true
        else
            v3 = true
        end
    end

    v4 = false

    local v8

    if v2 then
        if SetMusic then
            v8 = SetMusic
            v4 = true
        else
            v3 = true
        end
    end

    v2 = false

    if v3 then
        v8 = 0.5
        v4 = true
    end

    v3 = false

    local v9, MusicDuck

    if v4 then
        v9 = v7 * v8
        MusicDuck = LocalPlayer:GetAttribute("MusicDuck")

        if type(MusicDuck) == "number" then
            v3 = true
        else
            v2 = true
        end
    end

    v4 = false

    local v10

    if v3 then
        local v11 = math.clamp(MusicDuck, 0, 1)

        if v11 then
            v10 = v11
            v4 = true
        else
            v2 = true
        end
    end

    if v2 then
        v10 = 1
        v4 = true
    end

    local v12

    if v4 then
        local v13 = v9 * v10

        if v13 then
            v12 = v13
            v5 = true
        else
            v5 = false
        end
    end

    if not v5 then
        v12 = 0
    end

    return v12
end

local function trackTarget() -- line: 94
    -- upvalues: LocalPlayer (copy)
    local v14, v15

    if LocalPlayer:GetAttribute("MusicTrack") ~= nil then
        local v16 = (LocalPlayer:GetAttribute("MusicTrackVolume") or 0.25) * 2
        local SetMusic = LocalPlayer:GetAttribute("SetMusic")
        local v17 = v16 * (type(SetMusic) == "number" and SetMusic or 0.5)
        local MusicDuck = LocalPlayer:GetAttribute("MusicDuck")
        local v18 = v17 * (type(MusicDuck) == "number" and math.clamp(MusicDuck, 0, 1) or 1)

        if v18 then
            v14 = v18
            v15 = true
        else
            v15 = false
        end
    else
        v15 = false
    end

    if not v15 then
        v14 = 0
    end

    return v14
end

local Sound = Instance.new("Sound")

Sound.Name = "Music"
Sound:SetAttribute("Music", true)
Sound.Volume = 0
Sound.Looped = false
Sound.SoundId = "rbxassetid://" .. t1[1]
Sound.Parent = SoundService

local Sound2 = Instance.new("Sound")

Sound2.Name = "MusicTrack"
Sound2:SetAttribute("Music", true)
Sound2.Volume = 0
Sound2.Looped = true
Sound2.Parent = SoundService

local Sound3 = Instance.new("Sound")

Sound3.Name = "MusicWeather"
Sound3:SetAttribute("Music", true)
Sound3.Volume = 0
Sound3.Looped = true
Sound3.Parent = SoundService

local function ease(p1) -- line: 123
    -- upvalues: LocalPlayer (copy), TweenService (copy), Sound (copy), Sound2 (copy), Sound3 (copy)
    local t2 = {}

    if LocalPlayer:GetAttribute("MusicTrack") == nil and LocalPlayer:GetAttribute("MusicWeather") == nil then
        local SetMusic = LocalPlayer:GetAttribute("SetMusic")

        if type(SetMusic) ~= "number" or not SetMusic then
            SetMusic = 0.5
        end

        local v19 = 0.5 * SetMusic
        local MusicDuck = LocalPlayer:GetAttribute("MusicDuck")

        t2.Volume = v19 * (type(MusicDuck) == "number" and math.clamp(MusicDuck, 0, 1) or 1)
    else
        t2.Volume = 0
    end

    TweenService:Create(Sound, p1, t2):Play()

    local v20 = false
    local v21 = false
    local v22 = false
    local v23 = false

    if LocalPlayer:GetAttribute("MusicWeather") ~= nil then
        v20 = true
    end

    if v20 then
        if LocalPlayer:GetAttribute("MusicTrack") ~= nil then
            v21 = true
        else
            v22 = true
        end
    end

    v20 = false

    local v24

    if v21 then
        v24 = true
        v20 = true
    end

    v21 = false

    if v22 then
        v24 = false
        v20 = true
    end

    v22 = false

    if v20 then
        if v24 then
            v23 = false
        else
            v22 = true
        end
    end

    v20 = false

    local v25, SetMusic

    if v22 then
        v25 = (LocalPlayer:GetAttribute("MusicWeatherVolume") or 0.25) * 2
        SetMusic = LocalPlayer:GetAttribute("SetMusic")

        if type(SetMusic) == "number" then
            v20 = true
        else
            v21 = true
        end
    end

    v22 = false

    local v26

    if v20 then
        if SetMusic then
            v26 = SetMusic
            v22 = true
        else
            v21 = true
        end
    end

    v20 = false

    if v21 then
        v26 = 0.5
        v22 = true
    end

    v21 = false

    local v27, MusicDuck

    if v22 then
        v27 = v25 * v26
        MusicDuck = LocalPlayer:GetAttribute("MusicDuck")

        if type(MusicDuck) == "number" then
            v21 = true
        else
            v20 = true
        end
    end

    v22 = false

    local v28

    if v21 then
        local v29 = math.clamp(MusicDuck, 0, 1)

        if v29 then
            v28 = v29
            v22 = true
        else
            v20 = true
        end
    end

    if v20 then
        v28 = 1
        v22 = true
    end

    local v30

    if v22 then
        local v31 = v27 * v28

        if v31 then
            v30 = v31
            v23 = true
        else
            v23 = false
        end
    end

    if not v23 then
        v30 = 0
    end

    TweenService:Create(Sound3, p1, {
        Volume = v30
    }):Play()

    local v32, v33

    if LocalPlayer:GetAttribute("MusicTrack") ~= nil then
        local v34 = (LocalPlayer:GetAttribute("MusicTrackVolume") or 0.25) * 2
        local SetMusic = LocalPlayer:GetAttribute("SetMusic")
        local v35 = v34 * (type(SetMusic) == "number" and SetMusic or 0.5)
        local MusicDuck = LocalPlayer:GetAttribute("MusicDuck")
        local v36 = v35 * (type(MusicDuck) == "number" and math.clamp(MusicDuck, 0, 1) or 1)

        if v36 then
            v32 = v36
            v33 = true
        else
            v33 = false
        end
    else
        v33 = false
    end

    if not v33 then
        v32 = 0
    end

    return TweenService:Create(Sound2, p1, {
        Volume = v32
    })
end

local v37 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

LocalPlayer:GetAttributeChangedSignal("SetMusic"):Connect(function() -- line: 130
    -- upvalues: ease (copy), v37 (copy)
    ease(v37):Play()
end)
LocalPlayer:GetAttributeChangedSignal("MusicDuck"):Connect(function() -- line: 133
    -- upvalues: LocalPlayer (copy), ease (copy)
    local v38 = LocalPlayer:GetAttribute("MusicDuck") ~= nil

    ease(TweenInfo.new(v38 and 0.6 or 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)):Play()
end)
LocalPlayer:GetAttributeChangedSignal("MusicTrack"):Connect(function() -- line: 137
    -- upvalues: LocalPlayer (copy), TweenService (copy), Sound2 (copy), ease (copy)
    local MusicTrack = LocalPlayer:GetAttribute("MusicTrack")
    local v40

    if MusicTrack then
        local v41 = "rbxassetid://" .. tostring(MusicTrack)

        if Sound2.SoundId == v41 then
            if not Sound2.IsPlaying then
                Sound2.TimePosition = LocalPlayer:GetAttribute("MusicTrackAt") or 0
            end
        else
            local v42 = LocalPlayer:GetAttribute("MusicTrackAt") or 0

            local function load() -- line: 143
                -- upvalues: v41 (copy), v42 (copy), LocalPlayer (copy), Sound2 (copy)
                Sound2.SoundId = v41
                Sound2.Looped = LocalPlayer:GetAttribute("MusicTrackOnce") ~= true
                Sound2.TimePosition = v42

                if not Sound2.IsLoaded then
                    Sound2.Loaded:Once(function() -- line: 149
                        -- upvalues: v41 (copy), v42 (copy), Sound2 (copy)
                        if Sound2.SoundId == v41 then
                            Sound2.TimePosition = v42
                        end
                    end)
                end
            end

            if Sound2.IsPlaying and Sound2.Volume > 0.01 then
                local tween = TweenService:Create(Sound2, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                    Volume = 0
                })

                tween.Completed:Once(function(p2) -- line: 154
                    -- upvalues: MusicTrack (copy), v41 (copy), v42 (copy), LocalPlayer (copy), Sound2 (copy), ease (copy)
                    if p2 ~= Enum.PlaybackState.Completed or LocalPlayer:GetAttribute("MusicTrack") ~= MusicTrack then
                        return
                    end

                    Sound2.SoundId = v41
                    Sound2.Looped = LocalPlayer:GetAttribute("MusicTrackOnce") ~= true
                    Sound2.TimePosition = v42

                    if not Sound2.IsLoaded then
                        Sound2.Loaded:Once(function() -- line: 149
                            -- upvalues: v41 (copy), v42 (copy), Sound2 (copy)
                            if Sound2.SoundId == v41 then
                                Sound2.TimePosition = v42
                            end
                        end)
                    end

                    Sound2:Play()
                    ease(TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)):Play()
                end)
                tween:Play()

                return
            end

            Sound2.SoundId = v41
            Sound2.Looped = LocalPlayer:GetAttribute("MusicTrackOnce") ~= true
            Sound2.TimePosition = v42

            if not Sound2.IsLoaded then
                Sound2.Loaded:Once(function() -- line: 149
                    -- upvalues: v41 (copy), v42 (copy), Sound2 (copy)
                    if Sound2.SoundId == v41 then
                        Sound2.TimePosition = v42
                    end
                end)
            end
        end

        if not Sound2.IsPlaying then
            Sound2:Play()
        end

        v40 = LocalPlayer:GetAttribute("MusicTrackCut") == true
    else
        v40 = MusicTrack
    end

    local new, v44, v45, v46

    if v40 then
        local v47 = TweenInfo.new(0)

        if v47 then
            v45 = v47
            v46 = true
        else
            new = TweenInfo.new
            v44 = if MusicTrack then 0.8 else 2
            v46 = false
        end
    else
        new = TweenInfo.new
        v44 = if MusicTrack then 0.8 else 2
        v46 = false
    end

    if not v46 then
        v45 = new(v44, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    end

    local v48 = ease(v45)

    v48:Play()

    if not MusicTrack then
        v48.Completed:Connect(function(p3) -- line: 176
            -- upvalues: LocalPlayer (copy), Sound2 (copy)
            if p3 == Enum.PlaybackState.Completed and LocalPlayer:GetAttribute("MusicTrack") == nil then
                Sound2:Stop()
            end
        end)
    end
end)

local function weatherAt(p4) -- line: 186
    -- upvalues: LocalPlayer (copy)
    local MusicWeatherSince = LocalPlayer:GetAttribute("MusicWeatherSince")

    if type(MusicWeatherSince) ~= "number" then
        return p4
    end

    return (math.max(0, workspace:GetServerTimeNow() - MusicWeatherSince))
end

local function playWeather(p5, p6) -- line: 191
    -- upvalues: LocalPlayer (copy), Sound3 (copy)
    local v50 = "rbxassetid://" .. tostring(p5)

    if Sound3.SoundId ~= v50 then
        Sound3.SoundId = v50
    end

    local MusicWeatherSince = LocalPlayer:GetAttribute("MusicWeatherSince")

    Sound3.TimePosition = if type(MusicWeatherSince) == "number" then math.max(0, workspace:GetServerTimeNow() - MusicWeatherSince) else p6

    if not Sound3.IsLoaded then
        Sound3.Loaded:Once(function() -- line: 196
            -- upvalues: p6 (copy), v50 (copy), LocalPlayer (copy), Sound3 (copy)
            if Sound3.SoundId ~= v50 then
                return
            end

            local v53 = p6
            local MusicWeatherSince = LocalPlayer:GetAttribute("MusicWeatherSince")

            Sound3.TimePosition = if type(MusicWeatherSince) == "number" then math.max(0, workspace:GetServerTimeNow() - MusicWeatherSince) else v53
        end)
    end

    Sound3:Play()
end

local v55

Sound3.Ended:Connect(function() -- line: 202
    -- upvalues: LocalPlayer (copy), playWeather (copy), v55 (ref)
    local v56 = v55

    if v56 and LocalPlayer:GetAttribute("MusicWeather") == v56.first then
        v56.k = (v56.k + 1) % (#v56.list + 1)

        if v56.k == 0 then
            playWeather(v56.first, v56.at)
        else
            playWeather(v56.list[v56.k], 0)
        end
    end
end)

local n1 = 0

local function onWeather() -- line: 210
    -- upvalues: ContentProvider (copy), LocalPlayer (copy), TweenService (copy), Sound (copy), Sound3 (copy), playWeather (copy), v55 (ref), n1 (ref)
    local MusicWeather = LocalPlayer:GetAttribute("MusicWeather")

    n1 += 1

    local v57 = n1
    local MusicWeatherFade = LocalPlayer:GetAttribute("MusicWeatherFade")
    local MusicWeatherFade2 = if type(MusicWeatherFade) == "number" and MusicWeatherFade > 0 and MusicWeatherFade then MusicWeatherFade else nil

    if MusicWeather and MusicWeatherFade2 then
        local v58 = LocalPlayer:GetAttribute("MusicWeatherAt") or 0
        local MusicWeatherDelay = LocalPlayer:GetAttribute("MusicWeatherDelay")
        local v59 = type(MusicWeatherDelay) == "number" and math.max(0, MusicWeatherDelay) or 0

        v55 = nil
        Sound3.Looped = LocalPlayer:GetAttribute("MusicWeatherOnce") ~= true
        Sound3:Stop()
        Sound3.Volume = 0

        local v60 = TweenInfo.new(MusicWeatherFade2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local t5 = {}

        if LocalPlayer:GetAttribute("MusicTrack") == nil and LocalPlayer:GetAttribute("MusicWeather") == nil then
            local SetMusic = LocalPlayer:GetAttribute("SetMusic")

            if type(SetMusic) ~= "number" or not SetMusic then
                SetMusic = 0.5
            end

            local v61 = 0.5 * SetMusic
            local MusicDuck = LocalPlayer:GetAttribute("MusicDuck")

            t5.Volume = v61 * (type(MusicDuck) == "number" and math.clamp(MusicDuck, 0, 1) or 1)
        else
            t5.Volume = 0
        end

        TweenService:Create(Sound, v60, t5):Play()
        task.delay(v59, function() -- line: 227
            -- upvalues: MusicWeather (copy), v57 (copy), v58 (copy), v59 (copy), v60 (copy), LocalPlayer (copy), TweenService (copy), Sound3 (copy), playWeather (copy), n1 (ref)
            if v57 ~= n1 then
                return
            end

            playWeather(MusicWeather, v58)

            local v62 = v59 > 0 and TweenInfo.new(1) or v60
            local v63 = false
            local v64 = false
            local v65 = false
            local v66 = false

            if LocalPlayer:GetAttribute("MusicWeather") ~= nil then
                v63 = true
            end

            if v63 then
                if LocalPlayer:GetAttribute("MusicTrack") ~= nil then
                    v64 = true
                else
                    v65 = true
                end
            end

            v63 = false

            local v67

            if v64 then
                v67 = true
                v63 = true
            end

            v64 = false

            if v65 then
                v67 = false
                v63 = true
            end

            v65 = false

            if v63 then
                if v67 then
                    v66 = false
                else
                    v65 = true
                end
            end

            v63 = false

            local v68, SetMusic

            if v65 then
                v68 = (LocalPlayer:GetAttribute("MusicWeatherVolume") or 0.25) * 2
                SetMusic = LocalPlayer:GetAttribute("SetMusic")

                if type(SetMusic) == "number" then
                    v63 = true
                else
                    v64 = true
                end
            end

            v65 = false

            local v69

            if v63 then
                if SetMusic then
                    v69 = SetMusic
                    v65 = true
                else
                    v64 = true
                end
            end

            v63 = false

            if v64 then
                v69 = 0.5
                v65 = true
            end

            v64 = false

            local v70, MusicDuck

            if v65 then
                v70 = v68 * v69
                MusicDuck = LocalPlayer:GetAttribute("MusicDuck")

                if type(MusicDuck) == "number" then
                    v64 = true
                else
                    v63 = true
                end
            end

            v65 = false

            local v71

            if v64 then
                local v72 = math.clamp(MusicDuck, 0, 1)

                if v72 then
                    v71 = v72
                    v65 = true
                else
                    v63 = true
                end
            end

            if v63 then
                v71 = 1
                v65 = true
            end

            local v73

            if v65 then
                local v74 = v70 * v71

                if v74 then
                    v73 = v74
                    v66 = true
                else
                    v66 = false
                end
            end

            if not v66 then
                v73 = 0
            end

            TweenService:Create(Sound3, v62, {
                Volume = v73
            }):Play()
        end)
    else
        local v75, TweenService2, Sound2, t7, v76, v77

        if MusicWeather then
            v77 = true
        elseif MusicWeatherFade2 then
            v55 = nil
            v75 = TweenInfo.new(MusicWeatherFade2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            TweenService2 = TweenService
            Sound2 = Sound
            t7 = {}
            v76 = LocalPlayer:GetAttribute("MusicTrack") ~= nil
            v77 = false
        else
            v77 = true
        end

        if not v77 then
            if not v76 and LocalPlayer:GetAttribute("MusicWeather") == nil then
                local SetMusic = LocalPlayer:GetAttribute("SetMusic")

                if type(SetMusic) ~= "number" or not SetMusic then
                    SetMusic = 0.5
                end

                local v78 = 0.5 * SetMusic
                local MusicDuck = LocalPlayer:GetAttribute("MusicDuck")

                t7.Volume = v78 * (type(MusicDuck) == "number" and math.clamp(MusicDuck, 0, 1) or 1)
            else
                t7.Volume = 0
            end

            TweenService2:Create(Sound2, v75, t7):Play()

            local tween = TweenService:Create(Sound3, v75, {
                Volume = 0
            })

            tween.Completed:Once(function(p7) -- line: 239
                -- upvalues: v57 (copy), Sound3 (copy), n1 (ref)
                if p7 == Enum.PlaybackState.Completed and v57 == n1 then
                    Sound3:Stop()
                end
            end)
            tween:Play()
        else
            if MusicWeather then
                local v79 = LocalPlayer:GetAttribute("MusicWeatherAt") or 0
                local t8 = {}
                local v80 = LocalPlayer:GetAttribute("MusicWeatherNext") or ""

                for match in tostring(v80):gmatch("%d+") do
                    t8[#t8 + 1] = tonumber(match)
                end

                v55 = #t8 > 0 and {
                    k = 0,
                    first = MusicWeather,
                    at = v79,
                    list = t8
                } or nil
                Sound3.Looped = v55 == nil
                playWeather(MusicWeather, v79)

                if v55 then
                    task.spawn(function() -- line: 255
                        -- upvalues: t8 (copy), ContentProvider (copy)
                        local t9 = {}

                        for _, v81 in ipairs(t8) do
                            local Sound = Instance.new("Sound")

                            Sound.SoundId = "rbxassetid://" .. v81
                            t9[#t9 + 1] = Sound
                        end

                        local function v82() -- line: 262
                            -- upvalues: t9 (copy), ContentProvider (copy)
                            ContentProvider:PreloadAsync(t9)
                        end

                        pcall(v82)

                        for _, v83 in ipairs(t9) do
                            v83:Destroy()
                        end
                    end)
                end
            else
                v55 = nil
                Sound3:Stop()
            end

            local v84 = TweenInfo.new(0)
            local t10 = {}

            if LocalPlayer:GetAttribute("MusicTrack") == nil and LocalPlayer:GetAttribute("MusicWeather") == nil then
                local SetMusic = LocalPlayer:GetAttribute("SetMusic")

                if type(SetMusic) ~= "number" or not SetMusic then
                    SetMusic = 0.5
                end

                local v85 = 0.5 * SetMusic
                local MusicDuck = LocalPlayer:GetAttribute("MusicDuck")

                t10.Volume = v85 * (type(MusicDuck) == "number" and math.clamp(MusicDuck, 0, 1) or 1)
            else
                t10.Volume = 0
            end

            TweenService:Create(Sound, v84, t10):Play()

            local v86 = false
            local v87 = false
            local v88 = false
            local v89 = false

            if LocalPlayer:GetAttribute("MusicWeather") ~= nil then
                v86 = true
            end

            if v86 then
                if LocalPlayer:GetAttribute("MusicTrack") ~= nil then
                    v87 = true
                else
                    v88 = true
                end
            end

            v86 = false

            local v90

            if v87 then
                v90 = true
                v86 = true
            end

            v87 = false

            if v88 then
                v90 = false
                v86 = true
            end

            v88 = false

            if v86 then
                if v90 then
                    v89 = false
                else
                    v88 = true
                end
            end

            v86 = false

            local v91, SetMusic

            if v88 then
                v91 = (LocalPlayer:GetAttribute("MusicWeatherVolume") or 0.25) * 2
                SetMusic = LocalPlayer:GetAttribute("SetMusic")

                if type(SetMusic) == "number" then
                    v86 = true
                else
                    v87 = true
                end
            end

            v88 = false

            local v92

            if v86 then
                if SetMusic then
                    v92 = SetMusic
                    v88 = true
                else
                    v87 = true
                end
            end

            v86 = false

            if v87 then
                v92 = 0.5
                v88 = true
            end

            v87 = false

            local v93, MusicDuck

            if v88 then
                v93 = v91 * v92
                MusicDuck = LocalPlayer:GetAttribute("MusicDuck")

                if type(MusicDuck) == "number" then
                    v87 = true
                else
                    v86 = true
                end
            end

            v88 = false

            local v94

            if v87 then
                local v95 = math.clamp(MusicDuck, 0, 1)

                if v95 then
                    v94 = v95
                    v88 = true
                else
                    v86 = true
                end
            end

            if v86 then
                v94 = 1
                v88 = true
            end

            local v96

            if v88 then
                local v97 = v93 * v94

                if v97 then
                    v96 = v97
                    v89 = true
                else
                    v89 = false
                end
            end

            if not v89 then
                v96 = 0
            end

            TweenService:Create(Sound3, v84, {
                Volume = v96
            }):Play()
        end
    end
end

LocalPlayer:GetAttributeChangedSignal("MusicWeather"):Connect(onWeather)

if LocalPlayer:GetAttribute("MusicWeather") ~= nil then
    onWeather()
end

local n2 = 1
local playNext

function playNext() -- line: 291
    -- upvalues: t1 (copy), Sound (copy), n2 (ref), playNext (ref)
    n2 = n2 % #t1 + 1
    Sound.SoundId = "rbxassetid://" .. t1[n2]
    Sound.TimePosition = 0
    Sound:Play()

    local v99 = n2

    task.delay(15, function() -- line: 287
        -- upvalues: v99 (copy), Sound (copy), n2 (ref), playNext (ref)
        if n2 == v99 and not Sound.IsLoaded then
            playNext()
        end
    end)
end

Sound.Ended:Connect(playNext)
task.spawn(function() -- line: 300
    -- upvalues: ContentProvider (copy), t1 (copy)
    local t12 = {}

    for _, v100 in ipairs(t1) do
        local Sound = Instance.new("Sound")

        Sound.SoundId = "rbxassetid://" .. v100
        table.insert(t12, Sound)
    end

    local function v101() -- line: 307
        -- upvalues: t12 (copy), ContentProvider (copy)
        ContentProvider:PreloadAsync(t12)
    end

    pcall(v101)

    for _, v102 in ipairs(t12) do
        v102:Destroy()
    end
end)

local elapsed = os.clock()

while not Sound.IsLoaded and os.clock() - elapsed < 10 do
    task.wait(0.05)
end

Sound.Volume = 0
Sound.TimePosition = 0
Sound:Play()

local v103 = n2

task.delay(15, function() -- line: 287
    -- upvalues: Sound (copy), n2 (ref), playNext (ref), v103 (copy)
    if n2 == v103 and not Sound.IsLoaded then
        playNext()
    end
end)

local v104 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t13 = {}

if LocalPlayer:GetAttribute("MusicTrack") == nil and LocalPlayer:GetAttribute("MusicWeather") == nil then
    local SetMusic = LocalPlayer:GetAttribute("SetMusic")

    if type(SetMusic) ~= "number" or not SetMusic then
        SetMusic = 0.5
    end

    local v105 = 0.5 * SetMusic
    local MusicDuck = LocalPlayer:GetAttribute("MusicDuck")

    t13.Volume = v105 * (type(MusicDuck) == "number" and math.clamp(MusicDuck, 0, 1) or 1)
else
    t13.Volume = 0
end

TweenService:Create(Sound, v104, t13):Play()

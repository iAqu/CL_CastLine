-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Sounds = require(ReplicatedStorage:WaitForChild("Shared").Data.Sounds)
local UIKit = require(script.Parent.UIKit)
local DataClient = require(script.Parent.DataClient)
local HUD = require(script.Parent.HUD)
local t1 = {
    Counts = {}
}
local LocalPlayer = Players.LocalPlayer
local v1 = Random.new()
local SoundGroup, SoundGroup2, SoundGroup3
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local t6 = {
    Hover = 0.06,
    Coin = 0.5,
    MeterTick = 0.08,
    LuckTick = 0.05,
    Reel = 0.1,
    Zap = 0.09,
    OmenHit = 0.3
}

local function make(p1, p2, p3) -- line: 29
    -- upvalues: SoundGroup (ref), SoundGroup2 (ref), SoundGroup3 (ref)
    local Sound = Instance.new("Sound")

    Sound.Name = p1
    Sound.SoundId = "rbxassetid://" .. p2.id
    Sound.Volume = p2.volume or 0.5
    Sound.PlaybackSpeed = p2.pitch or 1
    Sound.Looped = p2.loop == true

    if p2.group == "music" then
        Sound.SoundGroup = SoundGroup2
    elseif p2.group == "ambience" then
        Sound.SoundGroup = SoundGroup3
    else
        Sound.SoundGroup = SoundGroup
    end

    Sound.Parent = p3

    return Sound
end

local n1 = 0

function t1.Play(p4, p5) -- line: 43
    -- upvalues: TweenService (copy), Sounds (copy), t1 (copy), v1 (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), n1 (ref)
    local v2 = Sounds.List[p4]

    if not v2 then
        return
    end

    local elapsed = os.clock()
    local v3 = t6[p4]

    if v3 and t5[p4] and elapsed - t5[p4] < v3 then
        return
    end

    t5[p4] = elapsed
    t1.Counts[p4] = (t1.Counts[p4] or 0) + 1

    if v2.loop or v2.held then
        local v4 = t4[p4]

        if v4 then
            if p5 then
                v4.PlaybackSpeed = p5
            end

            if t2[p4] then
                t2[p4]:Cancel()
                t2[p4] = nil
            end

            if v2.held then
                v4.Volume = v2.volume or 0.5
                v4.TimePosition = 0
                v4:Play()
            elseif v4.IsPlaying then
                TweenService:Create(v4, TweenInfo.new(0.6), {
                    Volume = v2.volume or 0.5
                }):Play()
            else
                v4.Volume = v2.volume or 0.5
                v4:Play()
            end
        end
    else
        local v5 = t3[p4]
        local v6 = v5[1]

        for _, v7 in ipairs(v5) do
            if not v7.IsPlaying then
                v6 = v7
                break
            end
        end

        local v8 = p5 or v2.pitch or 1

        if p4 == "Riser" then
            n1 = 0
        elseif p4 == "LetterPop" then
            n1 += 1
            v8 = math.min(n1, 14) * 0.07 + 0.8
        end

        if v2.vary then
            v8 *= 1 + v1:NextNumber(-v2.vary, v2.vary)
        end

        v6.PlaybackSpeed = v8
        v6.TimePosition = 0
        v6:Play()
    end
end

function t1.Stop(p6, p7) -- line: 104
    -- upvalues: TweenService (copy), t2 (copy), t4 (copy)
    local v10 = t4[p6]

    if v10 and v10.IsPlaying then
        local tween = TweenService:Create(v10, TweenInfo.new(p7 or 0.4), {
            Volume = 0
        })

        t2[p6] = tween
        tween:Play()
        tween.Completed:Once(function(p8) -- line: 110
            -- upvalues: p6 (copy), v10 (copy), tween (copy), t2 (copy)
            if t2[p6] == tween then
                t2[p6] = nil
            end

            if p8 == Enum.PlaybackState.Completed and v10.Volume <= 0.001 then
                v10:Stop()
            end
        end)
    end
end

function t1.PlayEndingIn(p9, p10, p11) -- line: 124
    -- upvalues: Sounds (copy), t1 (copy), t2 (copy), t4 (copy)
    local v11 = Sounds.List[p9]
    local v12 = t4[p9]

    if not (v11 and v12) then
        return
    end

    t1.Counts[p9] = (t1.Counts[p9] or 0) + 1

    if t2[p9] then
        t2[p9]:Cancel()
        t2[p9] = nil
    end

    p11 = p11 or v11.pitch or 1
    v12.PlaybackSpeed = p11
    v12.Volume = v11.volume or 0.5

    if v12.TimeLength > 0 then
        v12.TimePosition = math.max(0, v12.TimeLength - p10 * p11)
    else
        v12.TimePosition = 0
    end

    v12:Play()
end

function t1.Bend(p12, p13, p14) -- line: 143
    -- upvalues: Sounds (copy), t2 (copy), t4 (copy)
    local v15 = Sounds.List[p12]
    local v16 = t4[p12]

    if v15 and v16 and not t2[p12] then
        if p13 then
            v16.PlaybackSpeed = p13
        end

        if p14 then
            v16.Volume = (v15.volume or 0.5) * math.clamp(p14, 0, 1.5)
        end
    end
end

function t1.IsPlaying(p15) -- line: 157
    -- upvalues: t2 (copy), t4 (copy)
    local v17 = t4[p15]

    return v17 ~= nil and v17.IsPlaying and t2[p15] == nil
end

function t1.LoadReport() -- line: 163
    -- upvalues: Sounds (copy), t3 (copy), t4 (copy)
    local t7 = {}
    local n2 = 0

    for v18 in pairs(Sounds.List) do
        local v19 = t4[v18]

        v19 = v19 or t3[v18] and t3[v18][1]

        if v19 and v19.IsLoaded and v19.TimeLength > 0 then
            n2 += 1
        else
            table.insert(t7, v18)
        end
    end

    table.sort(t7)

    return n2 .. " loaded; not loaded: " .. (if #t7 > 0 then table.concat(t7, ", ") else "none")
end

local function level(p16) -- line: 178
    if type(p16) == "number" then
        return (math.clamp(p16, 0, 1))
    end

    return 1
end

local function applySettings() -- line: 181
    -- upvalues: DataClient (copy), SoundGroup (ref), SoundGroup2 (ref), SoundGroup3 (ref)
    local v20 = DataClient.Get("Settings") or {}
    local SoundGroup4 = SoundGroup2

    if v20.Music == false then
        SoundGroup4.Volume = 0
    else
        local MusicVolume = v20.MusicVolume

        if type(MusicVolume) == "number" then
            SoundGroup4.Volume = math.clamp(MusicVolume, 0, 1)
        else
            SoundGroup4.Volume = 1
        end
    end

    local SoundGroup5 = SoundGroup

    if v20.Sfx == false then
        SoundGroup5.Volume = 0
    else
        local SfxVolume = v20.SfxVolume

        if type(SfxVolume) == "number" then
            SoundGroup5.Volume = math.clamp(SfxVolume, 0, 1)
        else
            SoundGroup5.Volume = 1
        end
    end

    local SoundGroup6 = SoundGroup3
    local AmbienceVolume = v20.AmbienceVolume

    if type(AmbienceVolume) == "number" then
        SoundGroup6.Volume = math.clamp(AmbienceVolume, 0, 1)
    else
        SoundGroup6.Volume = 1
    end
end

function t1.SetVolume(p17, p18) -- line: 189
    -- upvalues: SoundGroup (ref), SoundGroup2 (ref), SoundGroup3 (ref)
    local SoundGroup4 = if p17 == "MusicVolume" then SoundGroup2
        elseif p17 == "SfxVolume" then SoundGroup
        elseif p17 == "AmbienceVolume" then SoundGroup3
        else nil

    if SoundGroup4 then
        SoundGroup4.Volume = math.clamp(p18, 0, 1)
    end
end

function t1.Init() -- line: 196
    -- upvalues: RunService (copy), SoundService (copy), ContentProvider (copy), Sounds (copy), UIKit (copy), DataClient (copy), HUD (copy), t1 (copy), LocalPlayer (copy), SoundGroup (ref), SoundGroup2 (ref), SoundGroup3 (ref), t3 (copy), t4 (copy), make (copy), applySettings (copy)
    SoundGroup = Instance.new("SoundGroup")
    SoundGroup.Name = "Sfx"
    SoundGroup.Parent = SoundService
    SoundGroup2 = Instance.new("SoundGroup")
    SoundGroup2.Name = "Music"
    SoundGroup2.Parent = SoundService
    SoundGroup3 = Instance.new("SoundGroup")
    SoundGroup3.Name = "Ambience"
    SoundGroup3.Parent = SoundService

    local Folder = Instance.new("Folder")

    Folder.Name = "GameSounds"
    Folder.Parent = SoundService

    local t8 = {}

    for v21, v22 in pairs(Sounds.List) do
        if v22.loop or v22.held then
            t4[v21] = make(v21, v22, Folder)
            table.insert(t8, t4[v21])
        else
            t3[v21] = {}
            t3[v21][1] = make(v21, v22, Folder)
            t3[v21][2] = make(v21, v22, Folder)
            t3[v21][3] = make(v21, v22, Folder)
            table.insert(t8, t3[v21][1])
        end
    end

    task.spawn(function() -- line: 223
        -- upvalues: t8 (copy), ContentProvider (copy)
        local function v25() -- line: 224
            -- upvalues: t8 (copy), ContentProvider (copy)
            ContentProvider:PreloadAsync(t8)
        end

        pcall(v25)
    end)
    UIKit.SoundHandler = t1.Play
    UIKit.SoundStopHandler = t1.Stop
    DataClient.Observe("Settings", applySettings)
    t4.Music:Play()
    t4.Waves.Volume = 0
    t4.Waves:Play()

    local v26

    DataClient.Observe("Cash", function(p19) -- line: 240
        -- upvalues: v26 (ref), LocalPlayer (copy)
        local v27 = v26

        v26 = p19

        if v27 and not (p19 <= v27) and not ((LocalPlayer:GetAttribute("IncomePerSecond") or 0) <= 0) then
            local Character = LocalPlayer.Character

            if Character then
                Character:FindFirstChild("HumanoidRootPart")
            end

            LocalPlayer:GetAttribute("PlotId")
        end
    end)

    local v28 = false

    RunService.Heartbeat:Connect(function(p20) -- line: 258
        -- upvalues: v28 (ref), Sounds (copy), UIKit (copy), HUD (copy), t1 (copy), LocalPlayer (copy), t4 (copy)
        local v29 = HUD.GetMode() == "cutscene"
        local v30 = t4.PovStart.IsPlaying and t4.PovStart.Volume > 0.01

        if v28 and not v29 then
            t1.Stop("PovStart", 0.5)
        end

        v28 = v29

        local v31, v32

        if workspace:GetAttribute("CosmicOn") == true and workspace:GetAttribute("CosmicAct") ~= "cosmic" then
            v32 = 0
            v31 = 1.6
        else
            v32 = Sounds.List.Music.volume * (if v30 then 0.25 elseif v29 then 0.55 else 1) * (if os.clock() < (UIKit.DuckUntil or 0) then 0.3 else 1)
            v31 = if t4.Music.Volume < v32 * 0.9 then 0.6 else 4
        end

        local Music = t4.Music

        Music.Volume = Music.Volume + (v32 - t4.Music.Volume) * math.min(1, p20 * v31)

        local Character = LocalPlayer.Character
        local n3 = 0

        if Character and Character:FindFirstChild("HumanoidRootPart") then
            if v30 then
            else
                local Z = workspace.CurrentCamera.CFrame.Position.Z

                n3 = Sounds.List.Waves.volume * math.clamp(1 - (Z - 12) / 55, 0, 1)
            end
        end

        local Waves = t4.Waves

        Waves.Volume = Waves.Volume + (n3 - t4.Waves.Volume) * math.min(1, p20 * 3)
    end)
end

return t1

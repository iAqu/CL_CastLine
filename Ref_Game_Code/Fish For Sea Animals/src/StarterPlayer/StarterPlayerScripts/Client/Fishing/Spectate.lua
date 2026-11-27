-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local Animals = require(ReplicatedStorage.Shared.Animals)
local AnimalModel = require(ReplicatedStorage.Shared.AnimalModel)
local Format = require(ReplicatedStorage.Shared.Format)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Poses = require(script.Parent.Parent.Character.Poses)
local CastFlight = require(script.Parent.CastFlight)
local Effects = require(script.Parent.Effects)
local RarityText = require(script.Parent.Parent.UI.RarityText)
local Settings = require(script.Parent.Parent.UI.Settings)
local t1 = {}
local v1 = Color3.new(1, 1, 1)
local CastPace = Config.CastPace
local v2 = 4.4 * CastPace
local v3 = 0.9 * CastPace
local v4 = 0.6 * CastPace
local v5 = Random.new()

local function oddsText(p1) -- line: 43
    -- upvalues: Format (copy)
    return "1 in " .. (if p1 < 1000 then tostring((math.floor(p1))) else Format.short(p1))
end

local function label(p2, p3, p4, p5, p6) -- line: 47
    -- upvalues: Config (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.fromScale(0, p5)
    TextLabel.Size = UDim2.fromScale(1, p6)
    TextLabel.FontFace = Config.Font
    TextLabel.TextScaled = true
    TextLabel.Text = p3
    TextLabel.TextColor3 = p4

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 3
    UIStroke.Color = Color3.fromRGB(20, 20, 30)
    UIStroke.Parent = TextLabel
    TextLabel.Parent = p2

    return TextLabel
end

local function tag(p7, p8, p9, p10, p11, p12) -- line: 65
    -- upvalues: Format (copy), UIUtil (copy), RarityText (copy), v1 (copy), label (copy)
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Size = UDim2.fromOffset(320, 130)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, p7.Size.Y / 2 + 3, 0)
    BillboardGui.LightInfluence = 0
    BillboardGui.MaxDistance = 700
    BillboardGui.Adornee = p7
    label(BillboardGui, ("%* caught"):format(p8.DisplayName), v1, 0, 0.2)
    RarityText.apply(label(BillboardGui, string.upper(p9.Rarity), p10.Color, 0.2, 0.28), p10)
    label(BillboardGui, p12, v1, 0.48, 0.3)
    label(BillboardGui, "1 in " .. (if p11 < 1000 then tostring((math.floor(p11))) else Format.short(p11)), p10.Color:Lerp(v1, 0.4), 0.78, 0.22)
    BillboardGui.Parent = p7

    for _, child in BillboardGui:GetChildren() do
        UIUtil.pop(child, 0.2)
    end
end

local function announce(p13, p14, p15, p16, p17) -- line: 82
    -- upvalues: Animals (copy), Format (copy), UIUtil (copy)
    if not (p15.Index >= math.max(5, (Animals.TopRarity[p14.Biome] or 1) - 1) or p16 >= 10000) then
        return
    end

    UIUtil.toast(("🌟 %* caught a %* %*! (%*)"):format(p13.DisplayName, string.upper(p14.Rarity), p17, "1 in " .. (if p16 < 1000 then tostring((math.floor(p16))) else Format.short(p16))), "purchase")
    UIUtil.sound("GoodCast", 0.5)
end

local function breach(p18, p19, p20, p21, p22, p23, p24, p25, p26) -- line: 92
    -- upvalues: RunService (copy), Config (copy), Animals (copy), AnimalModel (copy), Effects (copy), Settings (copy), v1 (copy), CastPace (copy), v5 (copy), tag (copy)
    local v15 = Animals.displaySize({
        Id = p19.Id,
        Weight = p24,
        Size = p26
    })
    local v17 = p21 + Vector3.new(0, 3 + v15 * 0.55, 0)
    local v18 = AnimalModel.clone(p19.Id, v15, p25)

    if not v18 then
        return
    end

    local Folder = Instance.new("Folder")

    Folder.Name = "SpectateCatch"
    Folder.Parent = workspace
    v18.Parent = Folder

    local v19 = AnimalModel.rig(v18)
    local v20 = AnimalModel.body(v18)
    local PointLight = Instance.new("PointLight")

    PointLight.Color = p20.Color:Lerp(v1, 0.5)
    PointLight.Range = v15 * 2.5
    PointLight.Brightness = 1.2
    PointLight.Parent = v20
    Effects.breach(p21, p22, math.min(v15, 24) / 12 + 0.9)
    Effects.splash(p21, p22, 1.2)

    local CFramePosition = workspace.CurrentCamera.CFrame.Position
    local v21 = if p20.Index >= 4 then Effects.rays(v17, CFramePosition, v15, p20, Folder) else nil

    if v20 then
        tag(v20, p18, p19, p20, p23, Animals.displayName({
            Id = p19.Id,
            Mutation = p25,
            Size = p26
        }))
    end

    local v22 = Effects.part({
        Size = Vector3.new(1, 1, 1),
        Transparency = 1,
        Position = p21,
        Parent = Folder
    })
    local Sound = Instance.new("Sound")

    Sound.SoundId = Config.Sounds.Reveal
    Sound.Volume = 0.8
    Sound.RollOffMaxDistance = 400
    Sound.SoundGroup = Settings.group("Sfx")
    Sound.Parent = v22
    Sound:Play()

    local v23 = v5:NextNumber(0, 6.283185307179586)
    local elapsed = os.clock()
    local connection

    connection = RunService.Heartbeat:Connect(function() -- line: 130
        -- upvalues: p21 (copy), p22 (copy), v15 (copy), v17 (copy), Folder (copy), v19 (copy), v23 (copy), elapsed (copy), connection (ref), v21 (copy), AnimalModel (copy), Effects (copy), CastPace (copy)
        local v24 = (os.clock() - elapsed) / CastPace
        local v25, v26

        if v24 > 5.1 then
            v26 = true
        elseif Folder.Parent then
            if v24 < 1 then
                local v27 = 1 - (1 - v24) ^ 3
                local v28 = p21.Y - v15 * 0.9 + (v17.Y - p21.Y + v15 * 0.9) * v27

                v25 = CFrame.new(v17.X, v28, v17.Z) * CFrame.Angles(0, v23 + (1 - v27) * 3.141592653589793 * 2, 0) * CFrame.Angles(-1.3089969389957472 * (1 - v27) ^ 1.5, 0, 0)
            elseif v24 < 4.5 then
                local v29 = v24 - 1

                v25 = CFrame.new(v17 + Vector3.new(0, math.sin(v29 * 2) * 0.35, 0)) * CFrame.Angles(0, v23 + v29 * 0.6, 0)
            else
                local v32 = (v24 - 4.5) / 0.6

                v25 = CFrame.new(v17 - Vector3.new(0, (v17.Y - p21.Y + v15) * v32 * v32, 0)) * CFrame.Angles(0, v23 + (v24 - 1) * 0.6, 0) * CFrame.Angles(1.2217304763960306 * v32, 0, 0)

                if v32 > 0.6 and not Folder:GetAttribute("Splashed") then
                    Folder:SetAttribute("Splashed", true)
                    Effects.splash(p21, p22, 0.9)
                end
            end

            v26 = false
        else
            v26 = true
        end

        if not v26 then
            AnimalModel.pose(v19, v25, v24, v24 < 1.4 and 1 or 0.5)

            if v21 then
                v21(v24)
            end
        else
            connection:Disconnect()
            Folder:Destroy()
        end
    end)
end

local function play(p27, p28) -- line: 161
    -- upvalues: Debris (copy), Players (copy), RunService (copy), Config (copy), Animals (copy), UIUtil (copy), Poses (copy), CastFlight (copy), Effects (copy), v1 (copy), CastPace (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), label (copy), announce (copy), breach (copy)
    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p27)
    local v34 = type(p28) == "table" and Animals.get(p28.Id)

    if PlayerFromCharacter and v34 and type(p28.Distance) == "number" and type(p28.LandX) == "number" and not (Players.LocalPlayer:GetAttribute("InWorld2Trip") or PlayerFromCharacter:GetAttribute("InWorld2Trip")) then
        local v35 = Config.RarityByName[v34.Rarity]
        local v36 = tonumber(p28.Odds) or Animals.odds(v34.Id)
        local Mutation2 = if type(p28.Mutation) == "string" then p28.Mutation else nil
        local Size2 = if type(p28.Size) ~= "string" or not Config.SizeByName[p28.Size] then nil else p28.Size
        local v37 = Animals.displayName({
            Id = v34.Id,
            Mutation = Mutation2,
            Size = Size2
        })
        local v38, v39 = CastFlight.landing(p28.Distance, p28.LandX)
        local v40 = if v39 then v39.Color else Color3.fromRGB(80, 170, 230)
        local v41 = CastFlight.flightTime(p28.Distance)
        local v42 = Poses.RELEASE + v41 + 0.2 * CastPace + v2 + v3 + v4
        local elapsed = os.clock()

        local function fishing() -- line: 181
            -- upvalues: p27 (copy)
            return p27.Parent ~= nil and p27:GetAttribute("Fishing") == true
        end

        local function waitUntil(p29) -- line: 184
            -- upvalues: elapsed (copy)
            task.wait((math.max(0, p29 - (os.clock() - elapsed))))
        end

        local function outcome() -- line: 188
            -- upvalues: p27 (copy)
            local v44 = os.clock() + 25
            local CastResult

            while true do
                if p27.Parent == nil or p27:GetAttribute("Fishing") ~= true or not (os.clock() < v44) then
                    return nil
                end

                CastResult = p27:GetAttribute("CastResult")

                if CastResult then
                    break
                end

                task.wait(0.1)
            end

            return CastResult
        end

        local HumanoidRootPart = p27:FindFirstChild("HumanoidRootPart")
        local CFramePosition = workspace.CurrentCamera.CFrame.Position

        if not HumanoidRootPart or (HumanoidRootPart.Position - CFramePosition).Magnitude > 700 then
            task.wait((math.max(0, v42 - (os.clock() - elapsed))))

            if outcome() == "Won" then
                task.wait(1.8)
                announce(PlayerFromCharacter, v34, v35, v36, v37)
            end
        else
            local RELEASE = Poses.RELEASE

            task.wait((math.max(0, RELEASE - (os.clock() - elapsed))))

            local RodModel = p27:FindFirstChild("RodModel")
            local v45 = RodModel and RodModel:FindFirstChild("RodTip", true)

            if v45 and p27.Parent ~= nil and p27:GetAttribute("Fishing") == true then
                local v48, v49, v50, v51 = CastFlight.makeBobber()

                v48.Name = "SpectateBobber"

                local v52 = CastFlight.attachLine(v45, v48.Line)
                local WorldPosition = v45.WorldPosition
                local v53 = CastFlight.arcHeight(p28.Distance)

                local function cleanup() -- line: 224
                    -- upvalues: v48 (copy)
                    v48:Destroy()
                end

                local elapsed2 = os.clock()

                while p27.Parent ~= nil and p27:GetAttribute("Fishing") == true do
                    local v55 = math.min((os.clock() - elapsed2) / v41, 1)

                    CastFlight.moveBobber(v48, v49, CastFlight.flightPoint(WorldPosition, v38, v53, v55))

                    if v55 >= 1 then
                        break
                    end

                    RunService.Heartbeat:Wait()
                end

                if p27.Parent ~= nil and p27:GetAttribute("Fishing") == true then
                    v50.Enabled = false
                    v51:Destroy()
                    Effects.splash(v38, v40, 1.2)

                    local elapsed2 = os.clock()
                    local v56 = false

                    while p27.Parent ~= nil and p27:GetAttribute("Fishing") == true and os.clock() - elapsed < v42 do
                        local v57 = os.clock() - elapsed2
                        local n1 = 0

                        for _, v58 in {
                                v2 * 0.72,
                                v2 * 0.86
                            } do
                            n1 += math.max(0, 1 - math.abs(v57 - v58) / (0.12 * CastPace)) * 0.45
                        end

                        if v2 < v57 and not v56 then
                            v56 = true
                            Effects.exclaim(v48)
                        end

                        local v61 = if v2 < v57 then math.min((v57 - v2) / v3, 1) * 0.8 else 0

                        CastFlight.moveBobber(v48, v49, v38 + Vector3.new(0, math.sin(v57 / CastPace * 5) * 0.12 - n1 - v61, 0))
                        RunService.Heartbeat:Wait()
                    end

                    if p27.Parent ~= nil and p27:GetAttribute("Fishing") == true then
                        Poses.playOn(p27, "Reel", 25)

                        local v65

                        task.spawn(function() -- line: 272
                            -- upvalues: outcome (copy), v65 (ref)
                            v65 = outcome() or "Gone"
                        end)

                        local elapsed = os.clock()
                        local n2 = -1

                        while true do
                            local v66

                            if p27.Parent == nil or p27:GetAttribute("Fishing") ~= true or v65 then
                                break
                            else
                                v66 = (os.clock() - elapsed) / CastPace

                                local v74 = Vector3.new(math.sin(v66 * 23) * 0.6, math.sin(v66 * 17) * 0.3 + -0.5, math.cos(v66 * 19) * 0.6)

                                CastFlight.moveBobber(v48, v49, v38 + v74)

                                if v66 - n2 > 0.4 then
                                    Effects.splash(v38, v40, 0.6)
                                else
                                    v66 = n2
                                end
                            end

                            n2 = v66
                            RunService.Heartbeat:Wait()
                        end

                        if v65 == "Won" then
                            v52:Destroy()
                            v48:Destroy()

                            local v75 = Effects.part({
                                Name = "SpectateGlow",
                                Size = Vector3.new(1, 1, 1),
                                Transparency = 1,
                                Position = v38 - Vector3.new(0, 3, 0),
                                Parent = workspace
                            })
                            local PointLight = Instance.new("PointLight")

                            PointLight.Color = v35.Color
                            PointLight.Range = 14
                            PointLight.Brightness = 0
                            PointLight.Parent = v75
                            UIUtil.tween(PointLight, 1.8, {
                                Brightness = 3
                            })
                            Debris:AddItem(v75, 2)

                            local elapsed = os.clock()

                            while os.clock() - elapsed < 1.8 do
                                Effects.ripple(v38 + Vector3.new(v5:NextNumber(-1, 1), 0, v5:NextNumber(-1, 1)), 4 + v35.Index, v40:Lerp(v1, 0.7))
                                task.wait(0.5)
                            end

                            announce(PlayerFromCharacter, v34, v35, v36, v37)
                            breach(PlayerFromCharacter, v34, v35, v38, v40, v36, tonumber(p28.Weight), Mutation2, Size2)
                        else
                            v52:Destroy()

                            if v65 == "Lost" then
                                Effects.splash(v38, v40, 1)
                                CastFlight.moveBobber(v48, v49, v38)

                                local BillboardGui = Instance.new("BillboardGui")

                                BillboardGui.Size = UDim2.fromOffset(240, 50)
                                BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
                                BillboardGui.LightInfluence = 0
                                BillboardGui.MaxDistance = 700
                                BillboardGui.Adornee = v48
                                label(BillboardGui, "GOT AWAY!", Color3.fromRGB(255, 90, 90), 0, 1)
                                BillboardGui.Parent = v48
                                UIUtil.pop(BillboardGui:FindFirstChildOfClass("TextLabel"), 0.2)
                                task.wait(1.6)
                            end

                            v48:Destroy()
                        end
                    else
                        v48:Destroy()
                    end
                else
                    v48:Destroy()
                end
            end
        end
    end
end

function t1.init() -- line: 329
    -- upvalues: Remotes (copy), play (copy)
    Remotes.CastShow.OnClientEvent:Connect(function(p30, p31) -- line: 330
        -- upvalues: play (copy)
        if typeof(p30) == "Instance" and p30:IsA("Model") then
            task.spawn(play, p30, p31)
        end
    end)
end

return t1

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

game:GetService("Workspace")

local function toMMSS(p1) -- line: 8
    return string.format("%02i:%02i", p1 / 60 % 60, p1 % 60)
end

local function ParsePath(p2) -- line: 10
    -- upvalues: Lighting (copy), Players (copy)
    local v1 = p2:split(".")
    local _workspace

    for v2, v3 in v1 do
        if v2 == #v1 then
            return _workspace, v3
        end

        _workspace = if _workspace then _workspace[v3]
            elseif v3 == "game" then game
            elseif v3 == "workspace" or v3 == "Workspace" then workspace
            elseif v3 == "Terrain" then workspace.Terrain
            elseif v3 == "Lighting" then Lighting
            elseif v3 == "Player" or v3 == "player" then Players.LocalPlayer
            elseif v3 == "PlayerGui" then Players.LocalPlayer.PlayerGui
            else _workspace[v3]
    end

    error((("[%*] Invalid Path"):format(script.Name)))
end

local function SetProperty(p3, p4) -- line: 39
    -- upvalues: ParsePath (copy)
    return function() -- line: 40
        -- upvalues: p3 (copy), p4 (ref), ParsePath (copy)
        local v4, v5 = ParsePath(p3)

        if v5 == "CFrame" and v4:GetAttribute("OffsetCFrame") then
            local v6 = p4

            p4 = v6 * v4:GetAttribute("OffsetCFrame")
        end

        if not v4:IsA("Model") or v5 ~= "CFrame" then
            v4[v5] = p4
        else
            v4:PivotTo(p4)
        end
    end
end

local function TweenProperty(p5, p6, p7) -- line: 55
    -- upvalues: TweenService (copy), ParsePath (copy)
    return function() -- line: 56
        -- upvalues: p5 (copy), p6 (copy), p7 (ref), TweenService (copy), ParsePath (copy)
        local v8, v9 = ParsePath(p5)

        if v9 == "CFrame" and v8:GetAttribute("OffsetCFrame") then
            local v10 = p7

            p7 = v10 * v8:GetAttribute("OffsetCFrame")
        end

        if v9 ~= "CFrame" or not v8:IsA("Model") then
            TweenService:Create(v8, p6, {
                [v9] = p7
            }):Play()
        else
            local CFrameValue = Instance.new("CFrameValue")

            CFrameValue.Value = v8:GetPivot()
            TweenService:Create(CFrameValue, p6, {
                Value = p7
            }):Play()
            CFrameValue.Changed:Connect(function() -- line: 67
                -- upvalues: v8 (copy), CFrameValue (copy)
                v8:PivotTo(CFrameValue.Value)
            end)
        end
    end
end

local function LoadAnimationIntoRig(p8, p9) -- line: 75
    local AnimationController = p8:FindFirstChild("AnimationController")
    local Humanoid = p8:FindFirstChild("Humanoid")
    local v11, v12

    if AnimationController then
        local Animator = AnimationController:FindFirstChild("Animator")

        if Animator then
            v11 = Animator
            v12 = true
        elseif Humanoid then
            local Animator = Humanoid:FindFirstChild("Animator")

            if Animator then
                v11 = Animator
                v12 = true
            else
                v12 = false
            end
        else
            v12 = false
        end
    elseif Humanoid then
        local Animator = Humanoid:FindFirstChild("Animator")

        if Animator then
            v11 = Animator
            v12 = true
        else
            v12 = false
        end
    else
        v12 = false
    end

    if not v12 then
        v11 = AnimationController or Humanoid
    end

    if not v11 then
        error((("No usable animation controller or humanoid exists for %*"):format(p8)))
    end

    local Animation = Instance.new("Animation")

    Animation.AnimationId = p9

    return v11:LoadAnimation(Animation)
end

local function SetVisibility(p10, p11) -- line: 94
    for _, descendant in p10:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant:GetAttribute("OriginalTransparency") == nil then
                descendant:SetAttribute("OriginalTransparency", descendant.Transparency)
            end

            descendant.Transparency = p11 and descendant:GetAttribute("OriginalTransparency") or 1
        end
    end
end

return {
    GetHelperFunctions = function(p12) -- GetHelperFunctions | line: 108
        -- upvalues: RunService (copy), SoundService (copy), TweenService (copy), toMMSS (copy), ParsePath (copy), SetProperty (copy), TweenProperty (copy), LoadAnimationIntoRig (copy), SetVisibility (copy)
        local function CreateAndPlaySound(p13, p14, p15) -- line: 109
            -- upvalues: p12 (copy)
            p14 = p14 or workspace:FindFirstChild("Terrain")

            local Sound = Instance.new("Sound")

            Sound.SoundId = p13
            Sound.Parent = p14
            Sound.Volume = p15 or 0.5
            Sound.RollOffMaxDistance = 9999
            Sound.RollOffMinDistance = 0
            Sound.RollOffMode = Enum.RollOffMode.Linear
            task.delay(0.1, function() -- line: 119
                -- upvalues: Sound (copy)
                Sound:Play()
            end)
            p12:Add(Sound)

            return Sound
        end

        local function PlaySequenceAsync(p16, p17, p18) -- line: 126
            -- upvalues: p12 (copy), RunService (copy)
            if p16 then
                p16:Play()
            end

            local t2 = {}
            local n1 = 0
            local connection = RunService.Heartbeat:Connect(function(p19) -- line: 137
                -- upvalues: p17 (copy), t2 (copy), n1 (ref)
                n1 += p19

                for i = 0, 9 do
                    local v15 = math.floor(n1 * 60 - i)

                    if p17[v15] and not t2[v15] then
                        t2[v15] = true

                        for _, v16 in p17[v15] do
                            task.spawn(v16)
                        end
                    end
                end
            end)

            p12:Add(connection)
            task.wait(p18)
            connection:Disconnect()
        end

        local function TweenMuteBackgroundMusic() -- line: 158
            -- upvalues: p12 (copy), SoundService (copy), TweenService (copy)
            TweenService:Create(SoundService.Music.BackgroundMusic, TweenInfo.new(1), {
                Volume = 0
            }):Play()
            p12:Add(function() -- line: 162
                -- upvalues: SoundService (copy), TweenService (copy)
                TweenService:Create(SoundService.Music.BackgroundMusic, TweenInfo.new(1), {
                    Volume = 1
                }):Play()
            end)
        end

        return {
            toMMSS = toMMSS,
            ParsePath = ParsePath,
            SetProperty = SetProperty,
            TweenProperty = TweenProperty,
            LoadAnimationIntoRig = LoadAnimationIntoRig,
            CreateAndPlaySound = CreateAndPlaySound,
            PlaySequenceAsync = PlaySequenceAsync,
            SetVisibility = SetVisibility,
            TweenMuteBackgroundMusic = TweenMuteBackgroundMusic
        }
    end
}

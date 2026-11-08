-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AdService = game:GetService("AdService")
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local PolicyService = game:GetService("PolicyService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local FullscreenPresentation = require(ReplicatedStorage.Client.FullscreenPresentation)
local GameFlags = require(ReplicatedStorage.Shared.Flags.GameFlags)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local t2 = {}
local t3 = {}
local t4 = {}

local function hideIneligible(p1) -- line: 19
    -- upvalues: t3 (copy)
    if not t3[p1] then
        t3[p1] = p1.Destroying:Once(function() -- line: 21
            -- upvalues: p1 (copy), t3 (copy)
            t3[p1] = nil
        end)
    end

    p1.Parent = nil
end

local function dispose(p2) -- line: 28
    -- upvalues: t1 (copy), t2 (copy)
    if t2[p2] then
        t2[p2]:Disconnect()
        t2[p2] = nil
    end

    local v1 = t1[p2]

    if not v1 then
        return
    end

    t1[p2] = nil

    for _, v2 in v1.connections do
        v2:Disconnect()
    end

    if v1.session then
        v1.session.Close()
    end

    for _, v3 in v1.tweens do
        v3:Cancel()
        v3:Destroy()
    end

    if v1.disclaimer then
        v1.disclaimer:Destroy()
    end

    if v1.video and v1.video.Parent then
        v1.video:Pause()
    end
end

local function bind(p3) -- line: 56
    -- upvalues: AdService (copy), LocalizationService (copy), PolicyService (copy), RunService (copy), TweenService (copy), Workspace (copy), FullscreenPresentation (copy), GameFlags (copy), LocalPlayer (copy), t1 (copy), t2 (copy), t3 (copy), dispose (copy)
    local Display, AdGUI

    if p3.Name ~= "ForbiddenIsland" or not p3:IsA("Model") or t1[p3] then
        return
    else
        Display = p3:FindFirstChild("Display")
        AdGUI = Display and Display:FindFirstChild("AdGUI")
    end

    local VideoFrame = AdGUI and AdGUI:FindFirstChild("VideoFrame")
    local ClickDetector = Display and Display:FindFirstChild("ClickDetector")
    local WatchingGUI = p3:FindFirstChild("WatchingGUI")
    local DisclaimerGUI = p3:FindFirstChild("DisclaimerGUI")
    local v5

    if DisclaimerGUI then
        v5 = DisclaimerGUI:FindFirstChild("AdDisclosure")
        DisclaimerGUI.Enabled = false
    else
        v5 = DisclaimerGUI
    end

    local HintGUI = p3:FindFirstChild("HintGUI")
    local HintHighlight = p3:FindFirstChild("HintHighlight")
    local HintIcon = HintGUI and HintGUI:FindFirstChild("HintIcon")
    local UIScale = HintIcon and HintIcon:FindFirstChildOfClass("UIScale")
    local WatchStarted = p3:FindFirstChild("WatchStarted")
    local WatchEnded = p3:FindFirstChild("WatchEnded")
    local WatchLooped = p3:FindFirstChild("WatchLooped")
    local Watched = p3:FindFirstChild("Watched")

    if not (Display and AdGUI and VideoFrame and ClickDetector and WatchingGUI and DisclaimerGUI and v5 and HintGUI and HintHighlight and UIScale and WatchStarted and WatchEnded and WatchLooped and Watched) then
        return
    end

    local t5 = {
        connections = {},
        tweens = {},
        video = VideoFrame
    }

    t1[p3] = t5

    if t2[p3] then
        t2[p3]:Disconnect()
        t2[p3] = nil
    end

    AdGUI.Enabled = false
    HintGUI.Enabled = false
    HintHighlight.Enabled = false
    VideoFrame:Pause()

    local function current() -- line: 111
        -- upvalues: p3 (copy), t5 (copy), Workspace (copy), t1 (copy)
        if t1[p3] == t5 then
            return (p3:IsDescendantOf(Workspace))
        end

        return false
    end

    task.spawn(function() -- line: 115
        -- upvalues: p3 (copy), Display (ref), AdGUI (ref), WatchingGUI (copy), DisclaimerGUI (copy), HintGUI (copy), HintHighlight (copy), WatchStarted (copy), WatchEnded (copy), WatchLooped (copy), Watched (copy), t5 (copy), VideoFrame (copy), ClickDetector (copy), UIScale (copy), AdService (copy), LocalizationService (copy), PolicyService (copy), RunService (copy), TweenService (copy), Workspace (copy), FullscreenPresentation (copy), GameFlags (copy), LocalPlayer (copy), t1 (copy), t3 (copy), dispose (copy)
        local GetCountryRegionForPlayerAsync = LocalizationService.GetCountryRegionForPlayerAsync
        local ok, result = pcall(GetCountryRegionForPlayerAsync, LocalizationService, LocalPlayer)

        if t1[p3] == t5 and p3:IsDescendantOf(Workspace) then
            local v7 = tostring(p3:GetAttribute("RegionCodes") or ""):split()
            local v8 = table.find(v7, result) ~= nil

            if p3:GetAttribute("RegionFilterType") ~= "Whitelist" then
                v8 = not v8
            end

            if ok and v8 then
                local GetPolicyInfoForPlayerAsync = PolicyService.GetPolicyInfoForPlayerAsync
                local ok, result = pcall(GetPolicyInfoForPlayerAsync, PolicyService, LocalPlayer)

                if t1[p3] == t5 and p3:IsDescendantOf(Workspace) then
                    if ok and result and result.AreAdsAllowed then
                        local CampaignID = p3:GetAttribute("CampaignID")
                        local ok, result

                        if CampaignID and CampaignID ~= "" then
                            local GetCampaignEligibilityAsync = AdService.GetCampaignEligibilityAsync

                            ok, result = pcall(GetCampaignEligibilityAsync, AdService, CampaignID)

                            if t1[p3] ~= t5 or not p3:IsDescendantOf(Workspace) then
                                return
                            end

                            if not (ok and result and result.IsEligible) then
                                if not t3[p3] then
                                    t3[p3] = p3.Destroying:Once(function() -- line: 21
                                        -- upvalues: p3 (copy), t3 (copy)
                                        t3[p3] = nil
                                    end)
                                end

                                p3.Parent = nil

                                return
                            end
                        end

                        local v11 = tostring(p3:GetAttribute("PlacementID") or "")

                        if v11 ~= "" then
                            local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

                            if t1[p3] ~= t5 or not p3:IsDescendantOf(Workspace) then
                                return
                            end

                            local clone = DisclaimerGUI:Clone()

                            t5.disclaimer = clone
                            clone.ResetOnSpawn = false
                            clone.Adornee = p3
                            clone.Parent = PlayerGui

                            local RegisterDisclosureButton = AdService.RegisterDisclosureButton
                            local AdDisclosure = clone.AdDisclosure
                            local ok, result = pcall(RegisterDisclosureButton, AdService, AdDisclosure, v11)

                            if t1[p3] ~= t5 or not p3:IsDescendantOf(Workspace) then
                                return
                            end

                            if not ok then
                                warn("ForbiddenIsland disclosure registration failed", result)

                                if not t3[p3] then
                                    t3[p3] = p3.Destroying:Once(function() -- line: 21
                                        -- upvalues: p3 (copy), t3 (copy)
                                        t3[p3] = nil
                                    end)
                                end

                                p3.Parent = nil

                                return
                            end

                            clone.Enabled = GameFlags.ForbiddenIslandEnabled:Get()
                        end

                        VideoFrame.Video = "rbxassetid://" .. tostring(p3:GetAttribute("VideoID"))

                        local v12 = false

                        local function updateHints() -- line: 178
                            -- upvalues: v12 (ref), HintGUI (copy), HintHighlight (copy), t5 (copy), GameFlags (copy)
                            local v13 = v12 and not t5.session and GameFlags.ForbiddenIslandEnabled:Get()

                            HintGUI.Enabled = v13
                            HintHighlight.Enabled = v13
                        end

                        local function finishWatch() -- line: 184
                            -- upvalues: v12 (ref), p3 (copy), HintGUI (copy), HintHighlight (copy), WatchEnded (copy), t5 (copy), Workspace (copy), GameFlags (copy), t1 (copy)
                            if t5.session then
                                t5.session = nil

                                if t5.loopConnection then
                                    t5.loopConnection:Disconnect()
                                    t5.loopConnection = nil
                                end

                                if t1[p3] ~= t5 or not p3:IsDescendantOf(Workspace) or not WatchEnded:IsDescendantOf(Workspace) then
                                    return
                                end

                                WatchEnded:FireServer()

                                local v14 = v12 and not t5.session and GameFlags.ForbiddenIslandEnabled:Get()

                                HintGUI.Enabled = v14
                                HintHighlight.Enabled = v14
                            end
                        end

                        table.insert(t5.connections, ClickDetector.MouseClick:Connect(function(p4) -- line: 201
                            -- upvalues: v12 (ref), finishWatch (copy), p3 (copy), Display (ref), AdGUI (ref), WatchingGUI (copy), HintGUI (copy), HintHighlight (copy), WatchStarted (copy), WatchEnded (copy), WatchLooped (copy), Watched (copy), t5 (copy), VideoFrame (copy), Workspace (copy), FullscreenPresentation (copy), GameFlags (copy), LocalPlayer (copy), t1 (copy)
                            if p4 ~= LocalPlayer then
                                return
                            end

                            if t1[p3] == t5 and p3:IsDescendantOf(Workspace) and v12 and AdGUI.Enabled and not t5.session and GameFlags.ForbiddenIslandEnabled:Get() then
                                local v16 = FullscreenPresentation.Open(p3, Display, WatchingGUI)

                                if v16 then
                                    t5.session = v16
                                    v16.Closed:Once(finishWatch)

                                    local v17 = v12 and not t5.session and GameFlags.ForbiddenIslandEnabled:Get()

                                    HintGUI.Enabled = v17
                                    HintHighlight.Enabled = v17
                                    WatchStarted:FireServer()
                                    t5.loopConnection = VideoFrame.DidLoop:Connect(function() -- line: 220
                                        -- upvalues: p3 (copy), WatchStarted (copy), WatchEnded (copy), WatchLooped (copy), Watched (copy), t5 (copy), Workspace (copy), t1 (copy)
                                        if t1[p3] ~= t5 or not p3:IsDescendantOf(Workspace) or not t5.session or t5.session.IsClosed() then
                                            return
                                        end

                                        WatchEnded:FireServer()
                                        WatchStarted:FireServer()
                                        WatchLooped:FireServer()
                                        Watched:Fire()
                                    end)
                                end
                            end
                        end))
                        table.insert(t5.connections, AdGUI:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 234
                            -- upvalues: AdGUI (ref), t5 (copy)
                            if not AdGUI.Enabled and t5.session then
                                t5.session.Close()
                            end
                        end))

                        local n1 = 0

                        table.insert(t5.connections, RunService.Heartbeat:Connect(function(p5) -- line: 244
                            -- upvalues: v12 (ref), n1 (ref), p3 (copy), AdGUI (ref), HintGUI (copy), HintHighlight (copy), t5 (copy), VideoFrame (copy), UIScale (copy), TweenService (copy), Workspace (copy), GameFlags (copy), LocalPlayer (copy), t1 (copy), dispose (copy)
                            n1 += p5

                            if not (n1 < 0.1) then
                                n1 = 0

                                if t1[p3] == t5 and p3:IsDescendantOf(Workspace) then
                                    local Character = LocalPlayer.Character
                                    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                                    local v20 = Humanoid ~= nil and Humanoid.Health > 0 and (Character:GetPivot().Position - p3:GetPivot().Position).Magnitude <= 48 and GameFlags.ForbiddenIslandEnabled:Get()

                                    if v20 ~= v12 then
                                        v12 = v20
                                        AdGUI.Enabled = v12

                                        if not v12 and t5.session then
                                            t5.session.Close()
                                        end

                                        local v21 = v12 and not t5.session and GameFlags.ForbiddenIslandEnabled:Get()

                                        HintGUI.Enabled = v21
                                        HintHighlight.Enabled = v21

                                        if v12 then
                                            VideoFrame:Play()
                                        else
                                            VideoFrame:Pause()
                                        end

                                        for _, v22 in t5.tweens do
                                            v22:Cancel()
                                            v22:Destroy()
                                        end

                                        table.clear(t5.tweens)

                                        local v23 = if v12 then TweenInfo.new(0.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, -1, true) else TweenInfo.new(0.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)

                                        table.insert(t5.tweens, TweenService:Create(HintHighlight, v23, {
                                            OutlineTransparency = v12 and 0 or 1
                                        }))
                                        table.insert(t5.tweens, TweenService:Create(UIScale, v23, {
                                            Scale = v12 and 0.75 or 1
                                        }))

                                        for _, v24 in t5.tweens do
                                            v24:Play()
                                        end
                                    end
                                else
                                    dispose(p3)
                                end
                            end
                        end))
                    else
                        if not t3[p3] then
                            t3[p3] = p3.Destroying:Once(function() -- line: 21
                                -- upvalues: p3 (copy), t3 (copy)
                                t3[p3] = nil
                            end)
                        end

                        p3.Parent = nil
                    end
                end
            else
                if not t3[p3] then
                    t3[p3] = p3.Destroying:Once(function() -- line: 21
                        -- upvalues: p3 (copy), t3 (copy)
                        t3[p3] = nil
                    end)
                end

                p3.Parent = nil
            end
        end
    end)
end

local function observe(p6) -- line: 302
    -- upvalues: t1 (copy), t2 (copy), t3 (copy), bind (copy)
    if p6.Name ~= "ForbiddenIsland" or not p6:IsA("Model") then
        return
    end

    if t3[p6] then
        t3[p6]:Disconnect()
        t3[p6] = nil
    end

    if not t1[p6] and not t2[p6] then
        t2[p6] = p6.DescendantAdded:Connect(function() -- line: 311
            -- upvalues: p6 (copy), bind (copy)
            bind(p6)
        end)
    end

    bind(p6)
end

Workspace.ChildAdded:Connect(observe)
Workspace.ChildRemoved:Connect(dispose)
GameFlags.ForbiddenIslandEnabled.Changed:Connect(function(p7) -- line: 320
    -- upvalues: t1 (copy)
    for _, v25 in t1 do
        if v25.disclaimer then
            v25.disclaimer.Enabled = p7
        end
    end

    if not p7 then
        for _, v26 in t1 do
            if v26.session then
                v26.session.Close()
            end
        end
    end
end)

for _, child in Workspace:GetChildren() do
    observe(child)
end

return table.freeze(t4)

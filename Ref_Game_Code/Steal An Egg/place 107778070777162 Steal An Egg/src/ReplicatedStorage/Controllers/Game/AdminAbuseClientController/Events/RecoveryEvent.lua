-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")

game:GetService("ReplicatedStorage")

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local clone
local t1 = {}
local connection

local function fadeSecondsFor(p1) -- line: 33
    local v1 = p1[1]

    return v1 ~= nil and tonumber(v1:GetAttribute("FadeSeconds")) or 1.2
end

local function show() -- line: 41
    -- upvalues: RunService (copy), TweenService (copy), Workspace (copy), PlayerGui (copy), clone (ref), t1 (ref), connection (ref)
    if clone ~= nil then
        return
    end

    local v2 = PlayerGui:WaitForChild("RecoveryVignette", 10)

    if v2 == nil or not v2:IsA("ScreenGui") then
        warn("[RecoveryEvent] Missing StarterGui.RecoveryVignette; the vignette is skipped")
    elseif clone == nil and Workspace:GetAttribute("Event_RecoveryEvent") then
        local clone2 = v2:Clone()

        clone2.Name = "RecoveryVignetteActive"
        clone2.Enabled = true

        local t2 = {}
        local t3 = {}

        for _, child in clone2:GetChildren() do
            if child:IsA("ImageLabel") then
                table.insert(t2, child)

                local UIGradient = child:FindFirstChildOfClass("UIGradient")

                if UIGradient ~= nil then
                    table.insert(t3, UIGradient)
                end
            end
        end

        if #t2 == 0 then
            warn("[RecoveryEvent] RecoveryVignette needs at least one ImageLabel; the vignette is skipped")
            clone2:Destroy()
        else
            local v3 = t2[1]
            local v4 = v3 ~= nil and tonumber(v3:GetAttribute("FadeSeconds")) or 1.2
            local v6 = tonumber(t2[1]:GetAttribute("SpinDegreesPerSecond")) or 45

            for _, v7 in t2 do
                v7.ImageTransparency = 1
            end

            clone = clone2
            t1 = t2
            clone2.Parent = PlayerGui

            for _, v8 in t2 do
                local v9 = tonumber(v8:GetAttribute("RestTransparency")) or 0.25

                TweenService:Create(v8, TweenInfo.new(v4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    ImageTransparency = v9
                }):Play()
            end

            if #t3 > 0 then
                local v10 = t3[1].Rotation

                connection = RunService.Heartbeat:Connect(function(p2) -- line: 103
                    -- upvalues: t3 (copy), v6 (copy), v10 (ref)
                    v10 = (v10 + v6 * p2) % 360

                    for _, v12 in t3 do
                        v12.Rotation = v10
                    end
                end)
            end
        end
    end
end

local function hide() -- line: 112
    -- upvalues: TweenService (copy), clone (ref), t1 (ref), connection (ref)
    local clone2 = clone
    local t4 = t1

    clone = nil
    t1 = {}

    if clone2 == nil then
        return
    end

    local v13 = t4[1]
    local v14 = v13 ~= nil and tonumber(v13:GetAttribute("FadeSeconds")) or 1.2

    if #t4 > 0 then
        for _, v15 in t4 do
            TweenService:Create(v15, TweenInfo.new(v14, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                ImageTransparency = 1
            }):Play()
        end
    end

    local connection2 = connection

    connection = nil
    task.delay(v14, function() -- line: 131
        -- upvalues: clone2 (copy), connection2 (copy)
        if connection2 ~= nil then
            connection2:Disconnect()
        end

        clone2:Destroy()
    end)
end

local function onEventAttributeChanged() -- line: 139
    -- upvalues: Workspace (copy), show (copy), hide (copy)
    if Workspace:GetAttribute("Event_RecoveryEvent") then
        show()
    else
        hide()
    end
end

local t5 = {
    StartEvent = function(_, _, _) -- StartEvent | line: 151
        -- upvalues: show (copy)
        show()
    end,
    StopEvent = function(_) -- StopEvent | line: 155
        -- upvalues: hide (copy)
        hide()
    end
}

Workspace:GetAttributeChangedSignal("Event_RecoveryEvent"):Connect(onEventAttributeChanged)

if Workspace:GetAttribute("Event_RecoveryEvent") then
    show()
else
    hide()
end

return t5

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

require(ReplicatedStorage.Shared.Eggs.Types)

local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Color3.fromRGB(166, 255, 111)
local v2 = TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local t1 = {}

local function stopPulse(p1) -- line: 29
    local PulseTween = p1.PulseTween

    p1.PulseTween = nil

    if PulseTween ~= nil then
        PulseTween:Cancel()
        PulseTween:Destroy()
    end

    p1.HatchButton.BackgroundColor3 = p1.OriginalHatchColor
end

local function startPulse(p2) -- line: 40
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy)
    if p2.PulseTween ~= nil then
        return
    end

    local tween = TweenService:Create(p2.HatchButton, v2, {
        BackgroundColor3 = v1
    })

    p2.PulseTween = tween
    tween:Play()
end

local function updateButtonState(p3, p4, p5) -- line: 52
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy)
    if p3.HatchButton == p3.GrowButton then
        local GrowButton = p3.GrowButton

        GrowButton.Visible = p4 or p5
        GrowButton.Active = p4 or p5
    else
        p3.GrowButton.Visible = not p4 and p5
        p3.GrowButton.Active = not p4 and p5
        p3.HatchButton.Visible = p4
        p3.HatchButton.Active = p4
    end

    p3.Ready = p4

    if p4 then
        if p3.PulseTween == nil then
            local tween = TweenService:Create(p3.HatchButton, v2, {
                BackgroundColor3 = v1
            })

            p3.PulseTween = tween
            tween:Play()
        end
    else
        local PulseTween = p3.PulseTween

        p3.PulseTween = nil

        if PulseTween ~= nil then
            PulseTween:Cancel()
            PulseTween:Destroy()
        end

        p3.HatchButton.BackgroundColor3 = p3.OriginalHatchColor
    end
end

function t1.Mount(p6, p7, p8, p9, p10) -- line: 76
    -- upvalues: Trove (copy)
    local clone = p6:Clone()

    clone.Name = p8
    clone.Visible = true
    clone.Parent = p7

    local Skip = clone.Spacer.Skip
    local v3 = clone.Spacer:FindFirstChild("Open") or Skip

    Skip.Selectable = true
    v3.Selectable = true

    if v3 ~= Skip then
        v3.Visible = false
    end

    local v4 = Trove.new()
    local t2 = {
        PulseTween = nil,
        Ready = false,
        Uid = p8,
        Root = clone,
        GrowButton = Skip,
        HatchButton = v3,
        OriginalHatchColor = v3.BackgroundColor3,
        Trove = v4
    }

    v4:Add(clone)
    v4:Add(function() -- line: 110
        -- upvalues: t2 (copy)
        local PulseTween = t2.PulseTween

        t2.PulseTween = nil

        if PulseTween ~= nil then
            PulseTween:Cancel()
            PulseTween:Destroy()
        end

        t2.HatchButton.BackgroundColor3 = t2.OriginalHatchColor
    end)

    if v3 == Skip then
        v4:Connect(Skip.Activated, function() -- line: 112
            -- upvalues: p8 (copy), p9 (copy), p10 (copy), t2 (copy)
            if t2.Ready then
                p10(p8)
            else
                p9(p8)
            end
        end)
    else
        v4:Connect(Skip.Activated, function() -- line: 120
            -- upvalues: p8 (copy), p9 (copy)
            p9(p8)
        end)
        v4:Connect(v3.Activated, function() -- line: 121
            -- upvalues: p8 (copy), p10 (copy)
            p10(p8)
        end)
    end

    return t2
end

function t1.Update(p11, p12, p13, p14, p15, p16) -- line: 127
    -- upvalues: updateButtonState (copy)
    local Spacer = p11.Root.Spacer

    Spacer.Icon.Image = p12
    Spacer.Progress.Fill.Size = UDim2.fromScale(p13, 1)
    Spacer.Progress.TextLabel.Text = p14
    Spacer.Progress.Visible = not p15
    updateButtonState(p11, p15, p16)
end

function t1.Destroy(p17) -- line: 144
    p17.Trove:Destroy()
end

return t1

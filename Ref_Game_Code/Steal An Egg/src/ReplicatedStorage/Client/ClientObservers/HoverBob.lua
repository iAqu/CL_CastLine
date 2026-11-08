-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local ObserveUITag = require(ReplicatedStorage.Client.ObserveUITag)

require(ReplicatedStorage.Packages.Trove)

local Sine = Enum.EasingStyle.Sine

local function GetBasePosition(p1) -- line: 21
    local HoverBobBasePosition = p1:GetAttribute("HoverBobBasePosition")

    if typeof(HoverBobBasePosition) == "UDim2" then
        return HoverBobBasePosition
    end

    p1:SetAttribute("HoverBobBasePosition", p1.Position)

    return p1.Position
end

local function StartHover(p2, p3) -- line: 30
    -- upvalues: TweenService (copy), Sine (copy)
    local HoverBobBasePosition = p2:GetAttribute("HoverBobBasePosition")

    if typeof(HoverBobBasePosition) ~= "UDim2" then
        p2:SetAttribute("HoverBobBasePosition", p2.Position)
        HoverBobBasePosition = p2.Position
    end

    local t1 = {}
    local v1 = true

    p3:Add(function() -- line: 35
        -- upvalues: p2 (copy), HoverBobBasePosition (ref), t1 (copy), v1 (ref)
        v1 = false

        for _, v2 in t1 do
            v2:Cancel()
            v2:Destroy()
        end

        p2.Position = HoverBobBasePosition
    end)

    local tween = TweenService:Create(p2, TweenInfo.new(0.7, Sine, Enum.EasingDirection.Out), {
        Position = HoverBobBasePosition - UDim2.fromOffset(0, 6)
    })

    table.insert(t1, tween)
    p3:Connect(tween.Completed, function(p4) -- line: 51
        -- upvalues: p2 (copy), HoverBobBasePosition (ref), t1 (copy), v1 (ref), TweenService (copy), Sine (copy)
        if v1 and p4 == Enum.PlaybackState.Completed then
            local tween = TweenService:Create(p2, TweenInfo.new(1.4, Sine, Enum.EasingDirection.InOut, -1, true), {
                Position = HoverBobBasePosition + UDim2.fromOffset(0, 6)
            })

            table.insert(t1, tween)
            tween:Play()
        end
    end)
    tween:Play()
end

ObserveUITag("HoverBob", function(p5, p6) -- PlayHover | line: 66
    -- upvalues: StartHover (copy)
    if p5:IsA("GuiObject") then
        StartHover(p5, p6)
    else
        warn((("HoverBob tag on %* needs a GuiObject"):format((p5:GetFullName()))))
    end
end)

return nil

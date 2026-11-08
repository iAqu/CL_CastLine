-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local Parent = script.Parent
local PendingPurchase = Parent:WaitForChild("PendingPurchase")
local Gift = PendingPurchase:WaitForChild("Gift")
local Spinner = PendingPurchase:WaitForChild("Spinner")
local UIScale = Gift:WaitForChild("UIScale")
local cleanup
local t1 = {}

Parent.Enabled = false

function t1.observePendingPurchase() -- line: 12
    -- upvalues: TweenService (copy), Parent (copy), PendingPurchase (copy), Gift (copy), Spinner (copy), UIScale (copy), cleanup (ref)
    if cleanup then
        cleanup()
    end

    Parent.Enabled = true
    PendingPurchase.Visible = true
    PendingPurchase.BackgroundTransparency = 1
    Gift.Size = UDim2.fromScale(0.2, 0.2)
    Spinner.Size = UDim2.fromScale(0.5, 0.5)
    UIScale.Scale = 1
    Spinner.Rotation = 0

    local t2 = {
        TweenService:Create(PendingPurchase, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.4
        }),
        TweenService:Create(UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            Scale = 1.3
        }),
        TweenService:Create(Spinner, TweenInfo.new(1.25, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
            Rotation = 360
        })
    }
    local v2 = false

    local function cleanup2() -- line: 52
        -- upvalues: t2 (copy), v2 (ref), Parent (copy), PendingPurchase (copy), Gift (copy), Spinner (copy), UIScale (copy), cleanup (ref)
        if v2 then
            return
        end

        v2 = true

        for _, v3 in t2 do
            v3:Cancel()
            v3:Destroy()
        end

        Parent.Enabled = false
        PendingPurchase.BackgroundTransparency = 1
        Gift.Size = UDim2.fromScale(0, 0)
        Spinner.Size = UDim2.fromScale(0, 0)
        UIScale.Scale = 1
        Spinner.Rotation = 0
        cleanup = nil
    end

    cleanup = cleanup2

    for _, v4 in t2 do
        v4:Play()
    end

    return cleanup2
end

return t1

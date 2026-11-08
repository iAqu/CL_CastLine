-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ButtonFX = require(script.Parent.ButtonFX)
local _ = {
    peakScale = 1.045,
    pressedScale = 0.965,
    cueGain = 1.75,
    hitAreaName = "PressSurface",
    hitAreaLift = 64
}

local function hitAreaOf(p1) -- line: 15
    if p1:IsA("GuiButton") then
        return p1, false
    end

    local PressSurface = p1:FindFirstChild("PressSurface")

    if PressSurface and PressSurface:IsA("GuiButton") then
        return PressSurface, false
    end

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "PressSurface"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundTransparency = 1
    TextButton.ZIndex = p1.ZIndex + 64
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.Parent = p1

    return TextButton, true
end

return function(p2, p3, p4) -- line: 36
    -- upvalues: ButtonFX (copy), hitAreaOf (copy)
    p2.Active = true

    local v1, v2 = hitAreaOf(p2)

    return ButtonFX({
        pressedScale = 0.965,
        cueGain = 1.75,
        host = p2,
        input = v1,
        ownsInput = v2,
        peakScale = p3 or 1.045,
        onActivate = p4
    })
end

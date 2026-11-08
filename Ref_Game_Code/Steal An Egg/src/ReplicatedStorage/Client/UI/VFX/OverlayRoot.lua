-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local t1 = {
    displayOrder = 1200,
    marker = "OverlayRootFallback"
}
local LocalPlayer = Players.LocalPlayer
local v1

local function playerGui() -- line: 17
    -- upvalues: LocalPlayer (copy), v1 (ref)
    local v2 = v1

    if v2 and v2.Parent then
        return v2
    end

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    v1 = PlayerGui

    return PlayerGui
end

local function authoredDisplayOrder() -- line: 27
    -- upvalues: StarterGui (copy)
    local OverlayUI = StarterGui:FindFirstChild("OverlayUI")

    if not (OverlayUI and OverlayUI:IsA("ScreenGui")) then
        return 1200
    end

    return OverlayUI.DisplayOrder
end

local function buildFallback(p1) -- line: 32
    -- upvalues: StarterGui (copy), t1 (copy)
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "OverlayUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local OverlayUI = StarterGui:FindFirstChild("OverlayUI")

    if not (OverlayUI and OverlayUI:IsA("ScreenGui")) then
        ScreenGui.DisplayOrder = t1.displayOrder
    else
        ScreenGui.DisplayOrder = OverlayUI.DisplayOrder
    end

    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui:SetAttribute("OverlayRootFallback", true)
    ScreenGui.Parent = p1

    return ScreenGui
end

return function() -- line: 44
    -- upvalues: StarterGui (copy), t1 (copy), LocalPlayer (copy), v1 (ref)
    local v3 = v1

    if not (v3 and v3.Parent) then
        v3 = LocalPlayer:WaitForChild("PlayerGui")
        v1 = v3
    end

    local v4 = v3:FindFirstChild("OverlayUI") or v3:WaitForChild("OverlayUI", 8)

    if v4 and v4:IsA("ScreenGui") then
        return v4
    end

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "OverlayUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local OverlayUI = StarterGui:FindFirstChild("OverlayUI")

    if not (OverlayUI and OverlayUI:IsA("ScreenGui")) then
        ScreenGui.DisplayOrder = t1.displayOrder
    else
        ScreenGui.DisplayOrder = OverlayUI.DisplayOrder
    end

    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui:SetAttribute(t1.marker, true)
    ScreenGui.Parent = v3

    return ScreenGui
end

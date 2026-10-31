-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local ClientState = require(script.Parent.ClientState)
local t2 = {
    "ShopOpen",
    "SellOpen",
    "IndexOpen",
    "ExclusiveShopOpen",
    "OfflineOpen"
}
local BlurEffect, ColorCorrectionEffect
local t3 = {}
local n1 = 0
local t1 = {}

function t1.Push(p1) -- line: 31
    -- upvalues: t3 (copy)
    t3[p1] = true
end

function t1.Pop(p2) -- line: 35
    -- upvalues: t3 (copy)
    t3[p2] = nil
end

local function wanted() -- line: 39
    -- upvalues: ClientState (copy), t2 (copy), t3 (copy)
    if next(t3) then
        return true
    end

    for _, v1 in ipairs(t2) do
        if ClientState[v1] then
            return true
        end
    end

    return false
end

local function ensureEffects() -- line: 47
    -- upvalues: Lighting (copy), BlurEffect (ref), ColorCorrectionEffect (ref)
    if not BlurEffect or BlurEffect.Parent ~= Lighting then
        BlurEffect = Instance.new("BlurEffect")
        BlurEffect.Name = "UIBackdropBlur"
        BlurEffect.Size = 0
        BlurEffect.Enabled = false
        BlurEffect.Parent = Lighting
    end

    if ColorCorrectionEffect and ColorCorrectionEffect.Parent == Lighting then
        return
    end

    ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
    ColorCorrectionEffect.Name = "UIBackdropTint"
    ColorCorrectionEffect.Enabled = false
    ColorCorrectionEffect.Parent = Lighting
end

local function step(p3) -- line: 63
    -- upvalues: ClientState (copy), t2 (copy), BlurEffect (ref), ColorCorrectionEffect (ref), t3 (copy), n1 (ref), ensureEffects (copy)
    local v2

    if next(t3) then
        v2 = true
    else
        local v3 = false

        for _, v4 in ipairs(t2) do
            if ClientState[v4] then
                v2 = true
                v3 = true
                break
            end
        end

        if not v3 then
            v2 = false
        end
    end

    local v5 = if v2 then 1 else 0

    if n1 == v5 and v5 == 0 == not (BlurEffect and BlurEffect.Enabled) then
        return
    end

    n1 += (v5 - n1) * math.min(1, p3 * 8)

    if math.abs(v5 - n1) < 0.01 then
        n1 = v5
    end

    ensureEffects()

    local v10 = n1 > 0

    BlurEffect.Enabled = v10
    ColorCorrectionEffect.Enabled = v10
    BlurEffect.Size = n1 * 10
    ColorCorrectionEffect.Brightness = n1 * -0.12
    ColorCorrectionEffect.Saturation = n1 * -0.15
end

function t1.Init() -- line: 77
    -- upvalues: RunService (copy), ensureEffects (copy), step (copy)
    ensureEffects()
    RunService.RenderStepped:Connect(step)
end

return t1

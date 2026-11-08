-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

require(ReplicatedStorage.Shared.Types.AssetItem)

local ItemDisplay = require(ReplicatedStorage.Shared.Modules.ItemDisplay)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {}

t1.__index = t1

local function isHiddenByDefault(p1, p2) -- line: 49
    while true do
        if p1 == nil or p1 == p2 then
            return false
        end

        if not p1:IsA("GuiObject") or p1.Visible then
            p1 = p1.Parent
            continue
        end

        break
    end

    return true
end

local function addChannel(p3, p4, p5) -- line: 61
    if not (p4 >= 1) then
        table.insert(p3, {
            Original = p4,
            Apply = p5
        })
    end
end

local function addTextLabelChannels(p6, p7) -- line: 71
    local TextTransparency = p7.TextTransparency

    local function v2(p8) -- line: 75
        -- upvalues: p7 (copy)
        p7.TextTransparency = p8
    end

    if not (TextTransparency >= 1) then
        table.insert(p6, {
            Original = TextTransparency,
            Apply = v2
        })
    end

    local TextStrokeTransparency = p7.TextStrokeTransparency

    local function v3(p9) -- line: 80
        -- upvalues: p7 (copy)
        p7.TextStrokeTransparency = p9
    end

    if not (TextStrokeTransparency >= 1) then
        table.insert(p6, {
            Original = TextStrokeTransparency,
            Apply = v3
        })
    end
end

local function addTextButtonChannels(p10, p11) -- line: 84
    local TextTransparency = p11.TextTransparency

    local function v4(p12) -- line: 88
        -- upvalues: p11 (copy)
        p11.TextTransparency = p12
    end

    if not (TextTransparency >= 1) then
        table.insert(p10, {
            Original = TextTransparency,
            Apply = v4
        })
    end

    local TextStrokeTransparency = p11.TextStrokeTransparency

    local function v5(p13) -- line: 93
        -- upvalues: p11 (copy)
        p11.TextStrokeTransparency = p13
    end

    if not (TextStrokeTransparency >= 1) then
        table.insert(p10, {
            Original = TextStrokeTransparency,
            Apply = v5
        })
    end
end

local function addTextBoxChannels(p14, p15) -- line: 97
    local TextTransparency = p15.TextTransparency

    local function v6(p16) -- line: 101
        -- upvalues: p15 (copy)
        p15.TextTransparency = p16
    end

    if not (TextTransparency >= 1) then
        table.insert(p14, {
            Original = TextTransparency,
            Apply = v6
        })
    end

    local TextStrokeTransparency = p15.TextStrokeTransparency

    local function v7(p17) -- line: 106
        -- upvalues: p15 (copy)
        p15.TextStrokeTransparency = p17
    end

    if not (TextStrokeTransparency >= 1) then
        table.insert(p14, {
            Original = TextStrokeTransparency,
            Apply = v7
        })
    end
end

local function addImageLabelChannel(p18, p19) -- line: 110
    local ImageTransparency = p19.ImageTransparency

    local function v8(p20) -- line: 114
        -- upvalues: p19 (copy)
        p19.ImageTransparency = p20
    end

    if not (ImageTransparency >= 1) then
        table.insert(p18, {
            Original = ImageTransparency,
            Apply = v8
        })
    end
end

local function addImageButtonChannel(p21, p22) -- line: 118
    local ImageTransparency = p22.ImageTransparency

    local function v9(p23) -- line: 122
        -- upvalues: p22 (copy)
        p22.ImageTransparency = p23
    end

    if not (ImageTransparency >= 1) then
        table.insert(p21, {
            Original = ImageTransparency,
            Apply = v9
        })
    end
end

local function captureFadeChannels(p24) -- line: 126
    -- upvalues: isHiddenByDefault (copy), addTextLabelChannels (copy), addTextButtonChannels (copy), addTextBoxChannels (copy)
    local t11 = {}

    for _, descendant in ipairs(p24:GetDescendants()) do
        if not isHiddenByDefault(descendant, p24) then
            if descendant:IsA("GuiObject") then
                local BackgroundTransparency = descendant.BackgroundTransparency

                local function v10(p25) -- line: 137
                    -- upvalues: descendant (copy)
                    descendant.BackgroundTransparency = p25
                end

                if not (BackgroundTransparency >= 1) then
                    table.insert(t11, {
                        Original = BackgroundTransparency,
                        Apply = v10
                    })
                end

                if descendant:IsA("TextLabel") then
                    addTextLabelChannels(t11, descendant)
                elseif descendant:IsA("TextButton") then
                    addTextButtonChannels(t11, descendant)
                elseif descendant:IsA("TextBox") then
                    addTextBoxChannels(t11, descendant)
                elseif descendant:IsA("ImageLabel") then
                    local ImageTransparency = descendant.ImageTransparency

                    local function v11(p26) -- line: 114
                        -- upvalues: descendant (copy)
                        descendant.ImageTransparency = p26
                    end

                    if not (ImageTransparency >= 1) then
                        table.insert(t11, {
                            Original = ImageTransparency,
                            Apply = v11
                        })
                    end
                elseif descendant:IsA("ImageButton") then
                    local ImageTransparency = descendant.ImageTransparency

                    local function v12(p27) -- line: 122
                        -- upvalues: descendant (copy)
                        descendant.ImageTransparency = p27
                    end

                    if not (ImageTransparency >= 1) then
                        table.insert(t11, {
                            Original = ImageTransparency,
                            Apply = v12
                        })
                    end
                end

                if descendant:IsA("CanvasGroup") then
                    local GroupTransparency = descendant.GroupTransparency

                    local function v13(p28) -- line: 157
                        -- upvalues: descendant (copy)
                        descendant.GroupTransparency = p28
                    end

                    if not (GroupTransparency >= 1) then
                        table.insert(t11, {
                            Original = GroupTransparency,
                            Apply = v13
                        })
                    end
                end
            elseif descendant:IsA("UIStroke") then
                local Transparency = descendant.Transparency

                local function v14(p29) -- line: 165
                    -- upvalues: descendant (copy)
                    descendant.Transparency = p29
                end

                if not (Transparency >= 1) then
                    table.insert(t11, {
                        Original = Transparency,
                        Apply = v14
                    })
                end
            end
        end
    end

    return t11
end

local function resolveTransparency(p30, p31) -- line: 173
    return 1 - p31 * (1 - p30)
end

local function applyFadeAlpha(p32) -- line: 177
    for _, v15 in ipairs(p32.Channels) do
        local Original = v15.Original
        local v16 = 1 - p32.Alpha * (1 - Original)

        v15.Apply(v16)
    end
end

local function applyEntryTargetVisible(p33) -- line: 184
    local v17 = p33.RangeVisible and p33.SuppressCount <= 0

    p33.TargetVisible = v17

    if v17 then
        p33.Billboard.Enabled = true
    end
end

local function setEntryRangeVisible(p34, p35) -- line: 192
    p34.RangeVisible = p35

    local v18 = p34.RangeVisible and p34.SuppressCount <= 0

    p34.TargetVisible = v18

    if v18 then
        p34.Billboard.Enabled = true
    end
end

local function stepEntryFade(p36, p37) -- line: 197
    -- upvalues: applyFadeAlpha (copy)
    local v19 = if p36.TargetVisible then 1 else 0

    if p36.Alpha ~= v19 then
        local v20 = p37 / 0.2

        if p36.Alpha < v19 then
            p36.Alpha = math.min(p36.Alpha + v20, v19)
        else
            p36.Alpha = math.max(p36.Alpha - v20, v19)
        end

        applyFadeAlpha(p36)
    end

    if p36.TargetVisible then
        p36.Billboard.Enabled = true
    elseif p36.Alpha <= 0 then
        p36.Billboard.Enabled = false
    end
end

function t1.new() -- line: 220
    -- upvalues: Players (copy), RunService (copy), ItemDisplay (copy), Trove (copy), t1 (copy), stepEntryFade (copy)
    local self = setmetatable({}, t1)

    self._trove = Trove.new()
    self._entries = {}
    self._elapsed = 0
    self._trove:Add(RunService.Heartbeat:Connect(function(p38) -- line: 225
        -- upvalues: self (copy), Players (copy), ItemDisplay (copy), stepEntryFade (copy)
        self._elapsed += p38

        local v24 = self._elapsed >= 0.15

        if v24 then
            self._elapsed = 0
        end

        local Character = Players.LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
            HumanoidRootPart = nil
        end

        for v25, v26 in pairs(self._entries) do
            if v24 then
                local PrimaryPart = v25.PrimaryPart

                if PrimaryPart == nil or v25.Parent == nil or HumanoidRootPart == nil then
                    v26.RangeVisible = false

                    local RangeVisible = v26.RangeVisible and v26.SuppressCount <= 0

                    v26.TargetVisible = RangeVisible

                    if RangeVisible then
                        v26.Billboard.Enabled = true
                    end
                else
                    local v27 = PrimaryPart.Position - HumanoidRootPart.Position

                    v26.RangeVisible = Vector2.new(v27.X, v27.Z).Magnitude <= ItemDisplay.GetDataBillboardMaxDistance()

                    local v28 = v26.RangeVisible and v26.SuppressCount <= 0

                    v26.TargetVisible = v28

                    if v28 then
                        v26.Billboard.Enabled = true
                    end
                end
            end

            stepEntryFade(v26, p38)
        end
    end))

    return self
end

function t1:Add(p40, p41, p42) -- line: 259
    -- upvalues: ItemDisplay (copy), captureFadeChannels (copy), applyFadeAlpha (copy)
    local v29 = ItemDisplay.CreateDataBillboard(p40, p41.Category, p41, p42)

    assert(v29 ~= nil, (("Asset model %* must expose CENTER for its data billboard"):format(p40.Name)))
    v29.MaxDistance = 1E+05

    local t18 = {
        Alpha = 0,
        RangeVisible = false,
        SuppressCount = 0,
        TargetVisible = false,
        Model = p40,
        Billboard = v29,
        Channels = captureFadeChannels(v29)
    }

    applyFadeAlpha(t18)
    v29.Enabled = false
    self._entries[p40] = t18
end

function t1:UpdateMoneyPerSecond(p44, p45) -- line: 283
    -- upvalues: ItemDisplay (copy)
    local v32 = self._entries[p44]

    assert(v32 ~= nil, (("Asset model %* must have a data billboard before its MPS can update"):format(p44.Name)))
    ItemDisplay.SetDataBillboardMoneyPerSecond(v32.Billboard, p45)
end

function t1:SetSuppressed(p47, p48) -- line: 296
    local v35 = self._entries[p47]

    if v35 == nil then
        return
    end

    if p48 then
        v35.SuppressCount += 1
    elseif v35.SuppressCount > 0 then
        v35.SuppressCount -= 1
    end

    local v36 = v35.RangeVisible and v35.SuppressCount <= 0

    v35.TargetVisible = v36

    if v36 then
        v35.Billboard.Enabled = true
    end
end

function t1:Remove(p50) -- line: 314
    local v37 = self._entries[p50]

    if v37 ~= nil then
        v37.Billboard:Destroy()
        self._entries[p50] = nil
    end
end

function t1:Destroy() -- line: 322
    for v38 in pairs(self._entries) do
        self:Remove(v38)
    end

    self._trove:Destroy()
end

return t1

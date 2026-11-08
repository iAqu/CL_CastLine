-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)

require(ReplicatedStorage.Shared.FusionShrines)

local Billboards = ReplicatedStorage.Assets.Billboards
local t1 = {}

local function child(p1, p2) -- line: 13
    local v1 = p1:FindFirstChild(p2)

    assert(v1, p1:GetFullName() .. "." .. p2 .. " is missing")

    return v1
end

local function contentOf(p3) -- line: 19
    local Card = p3:FindFirstChild("Card")

    assert(Card, p3:GetFullName() .. "." .. "Card" .. " is missing")

    local Inner = Card:FindFirstChild("Inner")

    assert(Inner, Card:GetFullName() .. "." .. "Inner" .. " is missing")

    local Content = Inner:FindFirstChild("Content")

    assert(Content, Inner:GetFullName() .. "." .. "Content" .. " is missing")

    return Content
end

local function statusOf(p4, p5) -- line: 23
    local v6 = p4:FindFirstChild(p5)

    assert(v6, p4:GetFullName() .. "." .. p5 .. " is missing")

    local Status = v6:FindFirstChild("Status")

    assert(Status, v6:GetFullName() .. "." .. "Status" .. " is missing")
    assert(Status:IsA("TextLabel"), Status:GetFullName() .. " must be a TextLabel")

    return Status
end

local function styleOf(p6) -- line: 29
    local UIGradient = p6:FindFirstChildOfClass("UIGradient")

    return {
        Text = p6.Text,
        Color = if UIGradient then UIGradient.Color else nil
    }
end

local function templateOf(p7) -- line: 34
    -- upvalues: Billboards (copy)
    local v10 = Billboards:WaitForChild(p7.Billboard.Template)

    assert(v10:IsA("BillboardGui"), v10:GetFullName() .. " must be a BillboardGui")

    return v10
end

local function stylesOf(p8) -- line: 40
    -- upvalues: Billboards (copy), t1 (copy)
    local v12 = t1[p8.Id]

    if v12 then
        return v12
    end

    local v13 = Billboards:WaitForChild(p8.Billboard.Template)

    assert(v13:IsA("BillboardGui"), v13:GetFullName() .. " must be a BillboardGui")

    local Card = v13:FindFirstChild("Card")

    assert(Card, v13:GetFullName() .. "." .. "Card" .. " is missing")

    local Inner = Card:FindFirstChild("Inner")

    assert(Inner, Card:GetFullName() .. "." .. "Inner" .. " is missing")

    local Content = Inner:FindFirstChild("Content")

    assert(Content, Inner:GetFullName() .. "." .. "Content" .. " is missing")

    local t3 = {}

    for v18, v19 in p8.Billboard.Styles do
        local v20 = Content:FindFirstChild(v19)

        assert(v20, Content:GetFullName() .. "." .. v19 .. " is missing")

        local Status = v20:FindFirstChild("Status")

        assert(Status, v20:GetFullName() .. "." .. "Status" .. " is missing")
        assert(Status:IsA("TextLabel"), Status:GetFullName() .. " must be a TextLabel")

        local UIGradient = Status:FindFirstChildOfClass("UIGradient")

        t3[v18] = {
            Text = Status.Text,
            Color = if UIGradient then UIGradient.Color else nil
        }
    end

    t1[p8.Id] = t3

    return t3
end

local function apply(p9, p10, p11) -- line: 54
    if p11 then
        p9.Text = p11
    elseif p10 then
        p9.Text = p10.Text
    else
        p9.Text = "LOADING"
    end

    local UIGradient = p9:FindFirstChildOfClass("UIGradient")

    if UIGradient and p10 and p10.Color then
        UIGradient.Color = p10.Color
    end
end

local function displayName(p12) -- line: 62
    -- upvalues: Assets (copy)
    local v24 = if type(p12) == "string" then Assets.Directory[p12] else nil
    local v25 = if v24 then type(v24.DisplayName) == "string" else nil

    return if v24 and v25 then string.upper(v24.DisplayName) else nil
end

local t5 = {
    Tiers = function(p13, p14) -- Tiers | line: 70
        for v26, v27 in p13.Columns do
            local v28 = if p14.Ready and p14.Status then p14.Status[v26] else nil
            local Status = v27.Status
            local v29 = p13.Styles[v28]

            if v29 then
                Status.Text = v29.Text
            else
                Status.Text = "LOADING"
            end

            local UIGradient = Status:FindFirstChildOfClass("UIGradient")

            if UIGradient and v29 and v29.Color then
                UIGradient.Color = v29.Color
            end
        end
    end,
    Sides = function(p15, p16) -- Sides | line: 76
        -- upvalues: Assets (copy)
        local v30 = p15.Kind.Tiers[1]
        local v31 = if not (p16.Ready and p16.Recipes) then nil else p16.Recipes[v30]
        local Ready = p16.Ready and p16.Status and p16.Status[v30] == "COMPLETED"
        local READY = p15.Styles.READY

        for _, v32 in p15.Columns do
            local v33 = v31 and v31[v32.Side]
            local v34 = if type(v33) == "string" then Assets.Directory[v33] else nil
            local v35 = if v34 and type(v34.DisplayName) == "string" then string.upper(v34.DisplayName) else nil

            if v35 and v32.Label then
                v32.Label.Text = v35
            end

            if p16.Ready then
                if Ready then
                    local Status = v32.Status
                    local COMPLETED = string.gsub(READY.Text, "READY", "COMPLETED")

                    if not COMPLETED then
                        COMPLETED = if READY then READY.Text else "LOADING"
                    end

                    Status.Text = COMPLETED

                    local UIGradient = Status:FindFirstChildOfClass("UIGradient")

                    if UIGradient and READY and READY.Color then
                        UIGradient.Color = READY.Color
                    end
                else
                    local v36 = v32.Pad ~= nil and v32.Pad:GetAttribute("FusionActive") == true
                    local Status = v32.Status
                    local v37 = if v36 then READY else p15.Styles.MISSING

                    if v37 then
                        Status.Text = v37.Text
                    else
                        Status.Text = "LOADING"
                    end

                    local UIGradient = Status:FindFirstChildOfClass("UIGradient")

                    if UIGradient and v37 and v37.Color then
                        UIGradient.Color = v37.Color
                    end
                end
            else
                local Status = v32.Status

                Status.Text = "LOADING"

                if Status:FindFirstChildOfClass("UIGradient") then
                end
            end
        end
    end
}
local t6 = {}

t6.__index = t6

function t6.Update(p17, p18) -- line: 101
    -- upvalues: t5 (copy)
    t5[p17.Kind.Billboard.Mode](p17, p18)
end

function t6.Destroy(p19) -- line: 105
    for _, v38 in p19.Guis do
        v38:Destroy()
    end

    for _, v39 in p19.Anchors do
        v39:Destroy()
    end
end

local t7 = {}

local function place(p20, p21, p22, p23) -- line: 116
    p20.Name = "PersonalFusionStatus"
    p20.Adornee = p21
    p20.ResetOnSpawn = false
    p20.Enabled = true

    if p22 then
        p20.StudsOffsetWorldSpace = Vector3.new(0, p22, 0)
    end

    p20.Parent = p23
end

local function isolate(p24, p25, p26) -- line: 127
    local Card = p24:FindFirstChild("Card")

    assert(Card, p24:GetFullName() .. "." .. "Card" .. " is missing")

    local Inner = Card:FindFirstChild("Inner")

    assert(Inner, Card:GetFullName() .. "." .. "Inner" .. " is missing")

    local Content = Inner:FindFirstChild("Content")

    assert(Content, Inner:GetFullName() .. "." .. "Content" .. " is missing")

    local v43 = p25.Billboard.Columns[p26]
    local v44 = Content:FindFirstChild(v43)

    assert(v44, Content:GetFullName() .. "." .. v43 .. " is missing")

    for v46, v47 in p25.Billboard.Columns do
        if v46 ~= p26 then
            local v48 = Content:FindFirstChild(v47)

            assert(v48, Content:GetFullName() .. "." .. v47 .. " is missing")
            v48.Visible = false
        end
    end

    local Scale = v44.Size.X.Scale

    v44.Size = UDim2.new(1, 0, v44.Size.Y.Scale, v44.Size.Y.Offset)

    local UIListLayout = Content:FindFirstChildOfClass("UIListLayout")

    if UIListLayout then
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    end

    local v51 = math.clamp(Scale * 1.15, 0.2, 1)

    p24.Size = UDim2.new(p24.Size.X.Scale * v51, 0, p24.Size.Y.Scale, 0)

    local Card2 = p24:FindFirstChild("Card")

    assert(Card2, p24:GetFullName() .. "." .. "Card" .. " is missing")

    local UIAspectRatioConstraint = Card2:FindFirstChildOfClass("UIAspectRatioConstraint")

    if UIAspectRatioConstraint then
        UIAspectRatioConstraint.AspectRatio *= v51
    end
end

local function sideAnchor(p27) -- line: 150
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "FusionSideStatusAnchor"
    Attachment.Position = Vector3.new(0, p27.Size.Y / 2, 0)
    Attachment.Parent = p27

    return Attachment
end

function t7.new(p28, p29, p30, p31, p32) -- line: 158
    -- upvalues: Billboards (copy), stylesOf (copy), t6 (copy), isolate (copy)
    local v54 = Billboards:WaitForChild(p28.Billboard.Template)

    assert(v54:IsA("BillboardGui"), v54:GetFullName() .. " must be a BillboardGui")

    local StatusHeight = p28.PadVfx.StatusHeight
    local t8 = {}
    local t9 = {}
    local t10 = {}

    local function bind(p33, p34, p35) -- line: 170
        -- upvalues: p28 (copy), p29 (copy), t10 (copy)
        local Card = p33:FindFirstChild("Card")

        assert(Card, p33:GetFullName() .. "." .. "Card" .. " is missing")

        local Inner = Card:FindFirstChild("Inner")

        assert(Inner, Card:GetFullName() .. "." .. "Inner" .. " is missing")

        local Content = Inner:FindFirstChild("Content")

        assert(Content, Inner:GetFullName() .. "." .. "Content" .. " is missing")

        for _, v59 in p34 do
            local v60 = p28.Billboard.Columns[v59]
            local v61 = Content:FindFirstChild(v60)

            assert(v61, Content:GetFullName() .. "." .. v60 .. " is missing")

            local Label = v61:FindFirstChild("Label")
            local v63 = if p35 then p35.Name else v59
            local t11 = {}
            local v64 = Content:FindFirstChild(v60)

            assert(v64, Content:GetFullName() .. "." .. v60 .. " is missing")

            local Status = v64:FindFirstChild("Status")

            assert(Status, v64:GetFullName() .. "." .. "Status" .. " is missing")
            assert(Status:IsA("TextLabel"), Status:GetFullName() .. " must be a TextLabel")
            t11.Status = Status
            t11.Label = if not (Label and Label:IsA("TextLabel")) then nil else Label
            t11.Side = v59
            t11.Pad = if p35 then p35.Pad else p29[v59]
            t10[v63] = t11
        end
    end

    if not p28.Billboard.PerSide or not p32 then
        if p28.Billboard.PerSide then
            for v68 in p28.Billboard.Columns do
                local clone = v54:Clone()

                isolate(clone, p28, v68)

                local v69 = p29[v68]
                local Attachment = Instance.new("Attachment")

                Attachment.Name = "FusionSideStatusAnchor"
                Attachment.Position = Vector3.new(0, v69.Size.Y / 2, 0)
                Attachment.Parent = v69
                table.insert(t9, Attachment)
                clone.Name = "PersonalFusionStatus"
                clone.Adornee = Attachment
                clone.ResetOnSpawn = false
                clone.Enabled = true

                if StatusHeight then
                    clone.StudsOffsetWorldSpace = Vector3.new(0, StatusHeight, 0)
                end

                clone.Parent = p31
                bind(clone, { v68 })
                table.insert(t8, clone)
            end
        else
            local clone = v54:Clone()

            clone.Name = "PersonalFusionStatus"
            clone.Adornee = p30
            clone.ResetOnSpawn = false
            clone.Enabled = true

            if StatusHeight then
                clone.StudsOffsetWorldSpace = Vector3.new(0, StatusHeight, 0)
            end

            clone.Parent = p31

            local t12 = {}

            for v71 in p28.Billboard.Columns do
                table.insert(t12, v71)
            end

            bind(clone, t12)
            table.insert(t8, clone)
        end
    else
        local Placement = p28.Placement

        for _, v72 in p32 do
            local clone = v54:Clone()

            isolate(clone, p28, v72.Side)

            local Pad = v72.Pad
            local Attachment = Instance.new("Attachment")

            Attachment.Name = "FusionSideStatusAnchor"
            Attachment.Position = Vector3.new(0, Pad.Size.Y / 2, 0)
            Attachment.Parent = Pad
            table.insert(t9, Attachment)

            local v74 = (if Placement then Placement.StatusHeights[v72.Side] else nil) or StatusHeight

            clone.Name = "PersonalFusionStatus"
            clone.Adornee = Attachment
            clone.ResetOnSpawn = false
            clone.Enabled = true

            if v74 then
                clone.StudsOffsetWorldSpace = Vector3.new(0, v74, 0)
            end

            clone.Parent = p31
            bind(clone, { v72.Side }, v72)
            table.insert(t8, clone)
        end
    end

    local v75 = setmetatable({
        Guis = t8,
        Anchors = t9,
        Kind = p28,
        Pads = p29,
        Columns = t10,
        Styles = stylesOf(p28)
    }, t6)

    v75:Update({
        Ready = false
    })

    return v75
end

return table.freeze(t7)

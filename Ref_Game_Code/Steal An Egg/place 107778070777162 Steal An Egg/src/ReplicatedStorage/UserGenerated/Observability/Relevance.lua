-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Styles = require(ReplicatedStorage.UserGenerated.Observability.Styles)

local function v1() -- line: 27
    return workspace[nil]
end

local function v2() -- line: 29
    return debug.info(2, "f")
end

local _, v3 = xpcall(v1, v2)
local v4 = v3

if type(v3) ~= "function" then
    v4 = function(p1, p2) -- line: 33
        return p1[p2]
    end
end

local Get = Styles.Get
local t1 = {
    ShownBy = table.freeze({
        Visible = true,
        Enabled = true,
        Adornee = true
    })
}
local v5 = table.freeze({
    Position = true,
    AnchorPoint = true
})
local v6 = table.freeze({
    Position = true,
    AnchorPoint = true,
    Size = true
})
local v7 = table.freeze({
    LayoutOrder = true
})
local v8 = table.freeze({
    BackgroundColor3 = true,
    BorderColor3 = true,
    BorderMode = true,
    BorderSizePixel = true
})
local v9 = table.freeze({
    BorderColor3 = true,
    BorderMode = true
})
local v10 = table.freeze({
    TextSize = true
})
local v11 = table.freeze({
    TextColor3 = true,
    TextStrokeColor3 = true,
    TextStrokeTransparency = true
})
local v12 = table.freeze({
    IsLoaded = true,
    ImageColor3 = true,
    ImageRectOffset = true,
    ImageRectSize = true,
    ScaleType = true,
    SliceCenter = true,
    SliceScale = true,
    TileSize = true,
    ResampleMode = true
})
local v13 = table.freeze({
    Color = true,
    Offset = true,
    Rotation = true,
    Transparency = true
})
local v14 = table.freeze({
    ApplyStrokeMode = true,
    BorderOffset = true,
    BorderStrokePosition = true,
    Color = true,
    LineJoinMode = true,
    StrokeSizingMode = true,
    Transparency = true,
    ZIndex = true
})
local t2 = {}

local function kindOf(p3) -- line: 103
    -- upvalues: v4 (ref), v5 (copy), v6 (copy), t2 (copy)
    local ClassName = v4(p3, "ClassName")
    local v15 = t2[ClassName]

    if v15 then
        return v15
    end

    local v16 = if p3:IsA("ScreenGui") then 1
        elseif p3:IsA("BillboardGui") or p3:IsA("SurfaceGui") then 2
        elseif p3:IsA("LayerCollector") then 3
        else 0
    local v17 = if p3:IsA("UIGridLayout") or p3:IsA("UITableLayout") then v6 elseif p3:IsA("UIListLayout") then v5 else false
    local v18 = table.freeze({
        Collector = v16,
        Gui = p3:IsA("GuiObject"),
        Text = if p3:IsA("TextBox") then 2 elseif p3:IsA("TextLabel") or p3:IsA("TextButton") then 1 else 0,
        Image = p3:IsA("ImageLabel") or p3:IsA("ImageButton"),
        Gradient = p3:IsA("UIGradient"),
        Stroke = p3:IsA("UIStroke"),
        Layout = v17,
        IsLayout = p3:IsA("UIGridStyleLayout")
    })

    t2[ClassName] = v18

    return v18
end

local function collectorHides(p4, p5) -- line: 139
    -- upvalues: v4 (ref), Get (copy)
    if p5 == 1 then
        return not Get(p4, "Enabled")
    end

    if p5 ~= 2 or not Get(p4, "Enabled") then
        return true
    end

    if v4(p4, "Adornee") ~= nil then
        return false
    end

    local Parent = v4(p4, "Parent")

    return not (Parent and (Parent:IsA("BasePart") or Parent:IsA("Attachment") or Parent:IsA("Model")))
end

function t1.HidesSubtree(p6) -- line: 157
    -- upvalues: Get (copy), kindOf (copy), collectorHides (copy)
    local v19 = kindOf(p6)

    if v19.Collector ~= 0 then
        return (collectorHides(p6, v19.Collector))
    end

    return v19.Gui and not Get(p6, "Visible")
end

function t1.NewMemo() -- line: 173
    return {
        Hidden = {},
        Layout = {}
    }
end

local t4 = {}

function t1.IsHidden(p7, p8, p9) -- line: 182
    -- upvalues: v4 (ref), Get (copy), kindOf (copy), collectorHides (copy), t4 (copy)
    local v20 = p9 and p9.Hidden
    local v21 = p7
    local n1 = 0
    local v22

    while true do
        if not v21 or v21 == p8 then
            v22 = true
        else
            local v23

            if v20 then
                v22 = v20[v21]
                v23 = v22 == nil
            end

            if not v20 or v23 then
                local v24 = kindOf(v21)

                if v24.Collector == 0 then
                    if not v24.Gui or Get(v21, "Visible") then
                        if v20 then
                            n1 += 1
                            t4[n1] = v21
                        end

                        v21 = v4(v21, "Parent")
                        continue
                    end

                    n1 += 1
                    v22 = true
                else
                    v22 = collectorHides(v21, v24.Collector)
                    n1 += 1
                end

                t4[n1] = v21
            end
        end

        break
    end

    if v20 then
        for i = 1, n1 do
            v20[t4[i]] = v22
        end
    end

    table.clear(t4)

    return v22
end

function t1.SubtreeHidden(p10, p11) -- line: 226
    -- upvalues: v4 (ref), Get (copy), kindOf (copy), collectorHides (copy)
    local v26

    while true do
        if not p10 or p10 == p11 then
            return false
        end

        v26 = kindOf(p10)

        if v26.Collector == 0 then
            if v26.Gui and not Get(p10, "Visible") then
                return true
            end

            p10 = v4(p10, "Parent")
            continue
        end

        break
    end

    return (collectorHides(p10, v26.Collector))
end

local v27 = table.freeze({ "Visible" })
local v28 = table.freeze({ "Enabled" })
local v29 = table.freeze({ "Enabled", "Adornee", "Parent" })
local v30 = table.freeze({})

function t1.ShownByOf(p12) -- line: 247
    -- upvalues: kindOf (copy), v27 (copy), v28 (copy), v29 (copy), v30 (copy)
    local v31 = kindOf(p12)

    if v31.Collector == 2 then
        return v29
    end

    if v31.Collector ~= 0 then
        return v28
    end

    if v31.Gui then
        return v27
    end

    return v30
end

local function noImage(p13) -- line: 260
    -- upvalues: Get (copy)
    if Get(p13, "Image") == "" then
        return true
    end

    return Get(p13, "ImageTransparency") >= 1
end

function t1.PolledUnseen(p14, p15, p16) -- line: 266
    -- upvalues: Get (copy), t1 (copy), kindOf (copy)
    if t1.IsHidden(p14, p15, p16) then
        return true
    end

    return kindOf(p14).Image and (Get(p14, "Image") == "" or Get(p14, "ImageTransparency") >= 1)
end

local t5 = {}

local function union(p17, p18) -- line: 276
    -- upvalues: t5 (copy)
    if not p17 then
        return p18
    end

    local v32 = t5[p17]

    if not v32 then
        v32 = {}
        t5[p17] = v32
    end

    local v33 = v32[p18]

    if not v33 then
        local v34 = table.clone(p17)

        for v35 in p18 do
            v34[v35] = true
        end

        v33 = table.freeze(v34)
        v32[p18] = v33
    end

    return v33
end

local function layoutSet(p19) -- line: 298
    -- upvalues: Get (copy), v7 (copy), kindOf (copy), union (copy)
    local UIGridStyleLayout = p19:FindFirstChildWhichIsA("UIGridStyleLayout")

    if not UIGridStyleLayout then
        return v7
    end

    local v36 = kindOf(UIGridStyleLayout).Layout or nil

    if Get(UIGridStyleLayout, "SortOrder") ~= Enum.SortOrder.LayoutOrder then
        v36 = union(v36, v7)
    end

    return v36 or false
end

function t1.Suppressed(p20, p21) -- line: 313
    -- upvalues: v4 (ref), Get (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), v13 (copy), v14 (copy), kindOf (copy), union (copy), layoutSet (copy)
    local v37 = kindOf(p20)
    local v38

    if v37.Gui then
        local Parent = v4(p20, "Parent")
        local v39

        if Parent then
            local v40

            if p21 then
                local Layout = p21.Layout

                if Layout then
                    v40 = Layout[Parent]

                    if v40 == nil then
                        v40 = layoutSet(Parent)
                        Layout[Parent] = v40
                    end
                else
                    v40 = Layout

                    if Layout == nil then
                        v40 = layoutSet(Parent)
                    end
                end
            else
                v40 = p21

                if p21 == nil then
                    v40 = layoutSet(Parent)
                end
            end

            v39 = v40 or nil
        end

        if Get(p20, "BackgroundTransparency") >= 1 then
            v39 = union(v39, v8)
        elseif Get(p20, "BorderSizePixel") == 0 then
            v39 = union(v39, v9)
        end

        local Text = v37.Text

        if Text == 0 then
            if v37.Image and (Get(p20, "Image") == "" or Get(p20, "ImageTransparency") >= 1) then
                return (union(v39, v12))
            end

            v38 = v39
        else
            local v41 = if Get(p20, "TextScaled") then union(v39, v10) else v39

            if Get(p20, "TextTransparency") >= 1 or Text == 1 and Get(p20, "Text") == "" then
                return (union(v41, v11))
            end

            v38 = v41
        end
    elseif v37.Gradient then
        if not Get(p20, "Enabled") then
            return v13
        end

        v38 = nil
    elseif v37.Stroke and (not Get(p20, "Enabled") or Get(p20, "Thickness") <= 0) then
        v38 = v14
    end

    return v38
end

function t1.IsLayout(p22) -- line: 363
    -- upvalues: kindOf (copy)
    return kindOf(p22).IsLayout
end

return table.freeze(t1)

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local GameConfig = require(Shared.GameConfig)
local Fish = require(Shared.Data.Fish)
local Zones = require(Shared.Data.Zones)
local Variants = require(Shared.Data.Variants)
local Sizes = require(Shared.Data.Sizes)
local Roll = require(Shared.Roll)
local FishModels = require(Shared.FishModels)
local HUD = require(script.Parent.HUD)
local ScreenFx = require(script.Parent.ScreenFx)
local RevealCutscene = require(script.Parent.RevealCutscene)
local CutsceneFx = require(script.Parent.CutsceneFx)
local t1 = {
    Playing = false,
    Index = 0,
    Stop = false,
    TapAfter = 3.5,
    List = {
        { "mecha_shark", 1, 1, "SUPER-RARE: heartbeat, drum roll, riser, the drop", "pov" },
        { "megalodon", 1, 1, "RAREST IN ZONE: the held breath, then the braam", "hunt", false },
        { "the_sleepless", 1, 1, "RAREST IN ZONE: the fake-out (reverse swell into the crack)", "eyes", true },
        { "glacier_mammoth", 1, 7, "TITANIC GIANT: rising out of the sea", "whirl", false },
        { "null_entity", 1, 1, "RAREST IN ZONE: NULL", "drag", false },
        { "tidefather", 1, 1, "LEGEND I" },
        { "seraphion", 1, 1, "LEGEND II" },
        { "charybdis", 1, 1, "LEGEND III" },
        { "kronos", 1, 1, "LEGEND IV" },
        { "khaos", 1, 1, "LEGEND V" }
    }
}

local function zoneIndexOf(p1) -- line: 44
    -- upvalues: Zones (copy)
    for v1, v2 in ipairs(Zones.List) do
        if v2.id == p1 then
            return v1
        end
    end

    return 1
end

function t1.Result(p2, p3, p4) -- line: 54
    -- upvalues: Fish (copy), Zones (copy), Variants (copy), Sizes (copy), Roll (copy)
    local v3 = Fish.ById[p2]
    local v4 = Variants.List[p3] or Variants.List[1]
    local v5 = Sizes.List[p4] or Sizes.List[Sizes.NORMAL_INDEX]
    local t2 = {
        ok = true,
        isNew = false,
        fishId = p2,
        name = v3.name,
        variant = v4.index or p3,
        size = v5.index or p4,
        zoneId = v3.zone
    }
    local zone = v3.zone
    local v6 = false
    local v7

    for v8, v9 in ipairs(Zones.List) do
        if v9.id == zone then
            v7 = v8
            v6 = true
            break
        end
    end

    t2.zoneIndex = if not v6 then 1 else v7
    t2.odds = math.floor((v3.odds or 1) * (v4.odds or 1) * (v5.odds or 1))
    t2.income = Roll.income(p2, p3, p4)
    t2.kg = (v3.kg and v3.kg[2] or 1) * (v5.scale or 1)
    t2.thrill = Roll.thrill(p2, p3, p4)

    return t2
end

function t1.LandFor(p5) -- line: 75
    -- upvalues: GameConfig (copy)
    local v11 = (p5 - 0.35) * GameConfig.ZONE_LENGTH

    return (Vector3.new(0, GameConfig.WATER_Y, GameConfig.DOCK_Z - math.min(v11, GameConfig.MAX_DISTANCE - 40)))
end

local TextLabel

local function caption(p6) -- line: 81
    -- upvalues: Players (copy), TextLabel (ref)
    if p6 then
        if not TextLabel then
            local ScreenGui = Instance.new("ScreenGui")

            ScreenGui.Name = "ShowcaseCaption"
            ScreenGui.DisplayOrder = 200
            ScreenGui.IgnoreGuiInset = true
            ScreenGui.ResetOnSpawn = false
            TextLabel = Instance.new("TextLabel")

            local TextLabel2 = TextLabel

            TextLabel2.BackgroundColor3 = Color3.new(0, 0, 0)
            TextLabel.BackgroundTransparency = 0.45

            local TextLabel3 = TextLabel

            TextLabel3.TextColor3 = Color3.new(1, 1, 1)

            local TextLabel4 = TextLabel

            TextLabel4.Font = Enum.Font.FredokaOne
            TextLabel.TextSize = 18

            local TextLabel5 = TextLabel

            TextLabel5.AutomaticSize = Enum.AutomaticSize.X

            local TextLabel6 = TextLabel

            TextLabel6.Size = UDim2.fromOffset(0, 30)

            local TextLabel7 = TextLabel

            TextLabel7.Position = UDim2.new(0, 12, 1, -12)

            local TextLabel8 = TextLabel

            TextLabel8.AnchorPoint = Vector2.new(0, 1)

            local UIPadding = Instance.new("UIPadding")

            UIPadding.PaddingLeft = UDim.new(0, 10)
            UIPadding.PaddingRight = UDim.new(0, 10)
            UIPadding.Parent = TextLabel

            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0, 8)
            UICorner.Parent = TextLabel
            TextLabel.Parent = ScreenGui
            ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        end

        TextLabel.Text = p6
    elseif TextLabel then
        TextLabel.Parent:Destroy()
        TextLabel = nil
    end
end

function t1.PlayOne(p7, p8, p9, p10, p11) -- line: 119
    -- upvalues: Players (copy), RunService (copy), FishModels (copy), HUD (copy), ScreenFx (copy), RevealCutscene (copy), CutsceneFx (copy), t1 (copy)
    local v14 = t1.Result(p7, p8 or 1, p9 or 1)
    local v15 = t1.LandFor(v14.zoneIndex)
    local LocalPlayer = Players.LocalPlayer

    local function v16() -- line: 123
        -- upvalues: v15 (copy), LocalPlayer (copy)
        LocalPlayer:RequestStreamAroundAsync(v15, 6)
    end

    pcall(v16)

    local CurrentCamera = workspace.CurrentCamera

    if v14.variant ~= 1 or v14.size ~= 1 then
        FishModels.Warm(p7, 1, 1, 1)
        FishModels.Warm(p7, v14.variant, v14.size, 1)
    else
        FishModels.Warm(p7, 1, 1, 2)
    end

    HUD.SetMode("cutscene")
    ScreenFx.Fade(1, 0.3, Color3.new(0, 0, 0))
    task.wait(1.6)
    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    RevealCutscene.ForceIntro = p10
    RevealCutscene.ForceFull = true
    CutsceneFx.ForceFakeOut = p11
    RunService:BindToRenderStep("ShowcaseCamera", Enum.RenderPriority.First.Value, function() -- line: 143
        -- upvalues: CurrentCamera (copy)
        if CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
        end
    end)

    local v17 = task.spawn(function() -- line: 148
        -- upvalues: RevealCutscene (copy), t1 (copy)
        while true do
            task.wait(0.25)

            if RevealCutscene.Waiting then
                task.wait(t1.TapAfter)
                RevealCutscene.Tap()
            end
        end
    end)
    local Play = RevealCutscene.Play
    local ok, result = pcall(Play, v14, v15)

    task.cancel(v17)
    RunService:UnbindFromRenderStep("ShowcaseCamera")
    RevealCutscene.ForceFull = nil
    RevealCutscene.ForceIntro = nil
    CutsceneFx.ForceFakeOut = nil

    if not ok then
        warn("[Showcase] " .. p7 .. ": " .. tostring(result))
        RevealCutscene.Cleanup()
    end

    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.FieldOfView = 70
    ScreenFx.Fade(0, 0.45)
    HUD.SetMode("normal")

    return ok, result
end

function t1.Play(p12, p13) -- line: 174
    -- upvalues: RunService (copy), Fish (copy), t1 (copy), TextLabel (ref), caption (copy)
    local t3, v18, v19

    if not RunService:IsStudio() or t1.Playing then
        return
    else
        t1.Playing = true
        t1.Stop = false
        t3 = {}
        v18 = math.clamp(p12 or 1, 1, #t1.List)
        v19 = p13 or #t1.List
    end

    for i = v18, math.clamp(v19, 1, #t1.List) do
        if t1.Stop then
            break
        end

        local v24 = t1.List[i]

        t1.Index = i

        local v25 = Fish.ById[v24[1]]

        caption(("SHOWCASE %d/%d   %s   (%s)"):format(i, #t1.List, if v25 then v25.name else v24[1], v24[4] or ""))

        local v28, v29 = t1.PlayOne(v24[1], v24[2], v24[3], v24[5], v24[6])

        if not v28 then
            table.insert(t3, v24[1] .. ": " .. tostring(v29))
        end

        task.wait(1.2)
    end

    if TextLabel then
        TextLabel.Parent:Destroy()
        TextLabel = nil
    end

    t1.Index = 0
    t1.Playing = false
    t1.Fails = t3

    return t3
end

return t1

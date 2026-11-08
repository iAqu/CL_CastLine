-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)
local Player = require(ReplicatedStorage.Shared.Player)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local t1 = {
    "Assets",
    "UI",
    "HalloweenDimension",
    "HalloweenTransition"
}
local v1 = Color3.fromRGB(96, 34, 146)
local v2 = Color3.fromRGB(16, 5, 28)
local v3 = Color3.fromRGB(176, 110, 232)
local t2 = {
    0.8, 1.6
}
local t3 = {
    Color3.fromRGB(255, 150, 48),
    Color3.fromRGB(255, 196, 90),
    Color3.fromRGB(190, 110, 255)
}
local t4 = {
    ["in"] = {
        Id = "rbxassetid://140305170110264",
        Volume = 0.5
    },
    out = {
        Id = "rbxassetid://89104702130285",
        Volume = 0.35
    }
}
local Transition = HalloweenDimension.PlayerAttributes.Transition
local t5 = {
    Core = v1,
    Edge = v2,
    Shade = v3,
    Embers = t3
}
local v4 = Random.new()
local v5 = Trove.new()
local clone, Veil, Puffs, Puff, Embers, Ember
local t6 = {}
local t7 = {}
local v6 = Vector2.zero
local v7 = "clear"
local n1 = 0
local n2 = 0
local v8 = false
local v9 = false
local connection
local n3 = 0
local Position
local v10 = ""
local v11 = t5
local v12 = Color3.new()
local Color, Color2, v13
local t8 = {}

local function findTemplate() -- line: 131
    -- upvalues: ReplicatedStorage (copy), t1 (copy)
    local v14 = ReplicatedStorage

    for _, v15 in t1 do
        v14 = if v14 then v14:FindFirstChild(v15) else nil
    end

    return if v14 and v14:IsA("ScreenGui") then v14 else nil
end

local function gradientOf(p1) -- line: 139
    return if p1 then p1:FindFirstChildOfClass("UIGradient") else nil
end

local function ensureGui() -- line: 143
    -- upvalues: LocalPlayer (copy), t5 (copy), v5 (copy), clone (ref), Veil (ref), Puffs (ref), Puff (ref), Embers (ref), Ember (ref), t6 (ref), t7 (ref), v6 (ref), v7 (ref), v11 (ref), v12 (ref), Color (ref), Color2 (ref), findTemplate (copy)
    if clone and clone.Parent then
        return true
    end

    local v16 = findTemplate()

    if v16 == nil then
        return false
    end

    v5:Clean()
    t6 = {}
    t7 = {}
    v6 = Vector2.zero
    v7 = "clear"

    local clone2 = v5:Clone(v16)

    clone2.Enabled = false
    Veil = clone2:WaitForChild("Veil")
    Puffs = clone2:WaitForChild("Puffs")
    Puff = Puffs:WaitForChild("Puff")
    Embers = clone2:WaitForChild("Embers")
    Ember = Embers:WaitForChild("Ember")
    Puff.Visible = false
    Ember.Visible = false
    v11 = t5
    v12 = Veil.BackgroundColor3

    local Veil2 = Veil
    local UIGradient = if Veil2 then Veil2:FindFirstChildOfClass("UIGradient") else nil
    local Puff2 = Puff
    local UIGradient2 = if Puff2 then Puff2:FindFirstChildOfClass("UIGradient") else nil

    Color = if UIGradient then UIGradient.Color else nil
    Color2 = if UIGradient2 then UIGradient2.Color else nil
    clone2.Parent = LocalPlayer:WaitForChild("PlayerGui")
    clone = clone2

    return true
end

local function tint(p2, p3) -- line: 177
    local UIGradient = if p2 then p2:FindFirstChildOfClass("UIGradient") else nil

    if UIGradient ~= nil and p3 ~= nil then
        UIGradient.Color = p3
    end
end

local function applyPalette(p4) -- line: 184
    -- upvalues: Veil (ref), Puff (ref), v6 (ref), v11 (ref), v12 (ref), Color (ref), Color2 (ref)
    if p4 == v11 then
        return
    end

    v11 = p4
    v6 = Vector2.zero

    local Veil2 = Veil

    Veil2.BackgroundColor3 = p4.Veil or v12

    local v17 = p4.VeilTint or Color
    local UIGradient = if Veil2 then Veil2:FindFirstChildOfClass("UIGradient") else nil

    if UIGradient ~= nil and v17 ~= nil then
        UIGradient.Color = v17
    end

    local Puff2 = Puff
    local v18 = p4.PuffTint or Color2
    local UIGradient2 = if Puff2 then Puff2:FindFirstChildOfClass("UIGradient") else nil

    if UIGradient2 ~= nil and v18 ~= nil then
        UIGradient2.Color = v18
    end
end

local function portalHitbox(p5) -- line: 196
    -- upvalues: Workspace (copy), HalloweenDimension (copy)
    local v19

    if p5 == "in" then
        local World = Workspace:FindFirstChild("World")

        if World then
            v19 = World:FindFirstChild(HalloweenDimension.PortalName)
        end
    else
        local v20 = Workspace:FindFirstChild(HalloweenDimension.MapName)

        if v20 then
            v19 = v20:FindFirstChild("ExitPortal", true)
        end
    end

    local v21 = if v19 then v19:FindFirstChild("Hitbox", true) else nil

    return if v21 ~= nil and v21:IsA("BasePart") then v21 else nil
end

local function portalSound(p6) -- line: 209
    -- upvalues: Player (copy), LocalPlayer (copy), t4 (copy), portalHitbox (copy)
    local v22 = t4[p6]
    local v23 = portalHitbox(p6)
    local v24 = Player.FindRootPart(LocalPlayer)

    if v22 == nil or v23 == nil or v24 == nil then
        return nil
    end

    local v25 = v23.CFrame:PointToObjectSpace(v24.Position)
    local v26 = v23.Size / 2 + Vector3.new(8, 8, 8)

    return if math.abs(v25.X) <= v26.X and math.abs(v25.Y) <= v26.Y and math.abs(v25.Z) <= v26.Z then v22 else nil
end

local function viewport() -- line: 224
    -- upvalues: Workspace (copy), clone (ref)
    local v27 = if clone then clone.AbsoluteSize else Vector2.zero

    if v27.X >= 1 and v27.Y >= 1 then
        return v27
    end

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera then
        return CurrentCamera.ViewportSize
    end

    return (Vector2.new(1280, 720))
end

local function rebuild() -- line: 233
    -- upvalues: Workspace (copy), v4 (copy), clone (ref), Puffs (ref), Puff (ref), t6 (ref), v6 (ref), v7 (ref), v11 (ref)
    local v28 = if clone then clone.AbsoluteSize else Vector2.zero

    if not (v28.X >= 1 and v28.Y >= 1) then
        local CurrentCamera = Workspace.CurrentCamera

        v28 = if CurrentCamera then CurrentCamera.ViewportSize else Vector2.new(1280, 720)
    end

    if v28 == v6 and #t6 > 0 then
        return
    end

    v6 = v28

    for _, v29 in t6 do
        v29.Frame:Destroy()
    end

    table.clear(t6)

    local v30 = math.max(v28.X, v28.Y) / 11
    local v32 = math.ceil(v28.X / v30) + 1
    local v34 = math.ceil(v28.Y / v30) + 1
    local v35 = v28 / 2
    local Magnitude = v35.Magnitude
    local v36 = if v7 == "covered" then 1 else 0

    for i = 0, v32 - 1 do
        for j = 0, v34 - 1 do
            local v37 = Vector2.new((i + j % 2 * 0.5 + v4:NextNumber(-0.28, 0.28)) * v30, (j + v4:NextNumber(-0.28, 0.28)) * v30)
            local v39 = math.clamp((v37 - v35).Magnitude / Magnitude, 0, 1)
            local clone = Puff:Clone()

            clone.Name = ("%*_%*"):format(i, j)
            clone.Position = UDim2.fromScale(v37.X / v28.X, v37.Y / v28.Y)

            local v40 = v30 * 1.75 * v4:NextNumber(0.85, 1.3)

            clone.Size = UDim2.fromScale(v40 / v28.X, v40 / v28.Y)
            clone.Visible = true

            local v42 = v11.Core:Lerp(v11.Edge, (math.clamp(v39 + v4:NextNumber(-0.1, 0.1), 0, 1)))

            clone.BackgroundColor3 = v42

            local Shade = clone:FindFirstChild("Shade")

            if Shade ~= nil and Shade:IsA("GuiObject") then
                Shade.BackgroundColor3 = v42:Lerp(v11.Shade, 0.14)
                Shade.Position = UDim2.fromScale(v4:NextNumber(0.36, 0.48), v4:NextNumber(0.32, 0.44))
            end

            local v43 = clone:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")

            v43.Scale = v36
            v43.Parent = clone
            clone.Parent = Puffs

            local t9 = t6

            table.insert(t9, {
                Frame = clone,
                Scale = v43,
                Reach = v39,
                Jitter = v4:NextNumber(0, 0.05),
                Spin = v4:NextNumber(-55, 55)
            })
        end
    end
end

local function spawnEmber(p7) -- line: 291
    -- upvalues: Workspace (copy), t2 (copy), v4 (copy), clone (ref), Embers (ref), Ember (ref), t7 (ref), v11 (ref)
    local v44 = if clone then clone.AbsoluteSize else Vector2.zero

    if not (v44.X >= 1 and v44.Y >= 1) then
        local CurrentCamera = Workspace.CurrentCamera

        v44 = if CurrentCamera then CurrentCamera.ViewportSize else Vector2.new(1280, 720)
    end

    local clone2 = Ember:Clone()
    local Embers2 = v11.Embers

    clone2.ImageColor3 = Embers2[v4:NextInteger(1, #Embers2)]
    clone2.Visible = true
    clone2.Parent = Embers

    local t11 = t7

    table.insert(t11, {
        Frame = clone2,
        Born = p7,
        Life = v4:NextNumber(t2[1], t2[2]),
        From = Vector2.new(v4:NextNumber(0.06, 0.94), v4:NextNumber(0.55, 1.05)),
        Drift = Vector2.new(v4:NextNumber(-0.06, 0.06), -v4:NextNumber(0.18, 0.4)),
        Size = v4:NextNumber(0.018, 0.04) * math.min(v44.X, v44.Y)
    })
end

local function stepEmbers(p8) -- line: 308
    -- upvalues: Workspace (copy), clone (ref), t7 (ref), v7 (ref), spawnEmber (copy)
    local v46 = if clone then clone.AbsoluteSize else Vector2.zero

    if not (v46.X >= 1 and v46.Y >= 1) then
        local CurrentCamera = Workspace.CurrentCamera

        v46 = if CurrentCamera then CurrentCamera.ViewportSize else Vector2.new(1280, 720)
    end

    for i = #t7, 1, -1 do
        local v47 = t7[i]
        local v48 = (p8 - v47.Born) / v47.Life

        if v48 >= 1 then
            v47.Frame:Destroy()
            table.remove(t7, i)
        else
            local v50 = math.sin(v48 * 3.141592653589793 * 3 + v47.Life * 7) * 0.012
            local v51 = v47.From + v47.Drift * v48 + Vector2.new(v50, 0)
            local v53 = math.sin(v48 * 3.141592653589793)
            local v54 = v47.Size * (v53 * 0.5 + 0.5)

            v47.Frame.Position = UDim2.fromScale(v51.X, v51.Y)
            v47.Frame.Size = UDim2.fromScale(v54 / v46.X, v54 / v46.Y)
            v47.Frame.Rotation = v48 * 240
            v47.Frame.ImageTransparency = 1 - v53
        end
    end

    if v7 ~= "clear" and v7 ~= "revealing" and #t7 < 24 then
        spawnEmber(p8)
    end
end

local function clearEmbers() -- line: 332
    -- upvalues: t7 (ref)
    for _, v55 in t7 do
        v55.Frame:Destroy()
    end

    table.clear(t7)
end

local function setVeil(p9) -- line: 339
    -- upvalues: Veil (ref)
    local Veil2 = Veil

    Veil2.BackgroundTransparency = 1 - p9
    Veil2.Visible = p9 > 0
end

local v56, v57

local function finish() -- line: 348
    -- upvalues: clone (ref), Veil (ref), t6 (ref), t7 (ref), v7 (ref), n1 (ref), v9 (ref), connection (ref), v13 (ref), v56 (ref)
    if n1 == 1 then
        v7 = "covered"

        local Veil2 = Veil

        Veil2.BackgroundTransparency = 0
        Veil2.Visible = true

        if v9 then
            v9 = false
            v56(0)
        end
    else
        v7 = "clear"
        v13 = nil

        if connection then
            connection:Disconnect()
            connection = nil
        end

        for _, v58 in t7 do
            v58.Frame:Destroy()
        end

        table.clear(t7)

        for _, v59 in t6 do
            v59.Scale.Scale = 0
        end

        local Veil2 = Veil

        Veil2.BackgroundTransparency = 1
        Veil2.Visible = false

        if clone then
            clone.Enabled = false
        end
    end
end

local function step() -- line: 374
    -- upvalues: TweenService (copy), Veil (ref), t6 (ref), v7 (ref), n1 (ref), n2 (ref), v8 (ref), stepEmbers (copy), finish (copy)
    local elapsed = os.clock()

    stepEmbers(elapsed)

    if v7 == "covered" and not v8 then
        for _, v60 in t6 do
            v60.Scale.Scale = math.sin(elapsed * 2.2 + v60.Spin) * 0.05 + 1
        end
    end

    if v7 == "covering" or v7 == "revealing" then
        local v62 = elapsed - n2

        if v8 then
            local v64 = math.clamp(v62 / 0.2, 0, 1)
            local v65 = if n1 == 1 then v64 else 1 - v64
            local Veil2 = Veil

            Veil2.BackgroundTransparency = 1 - v65
            Veil2.Visible = v65 > 0

            if v64 >= 1 then
                finish()
            end
        else
            local v66 = true

            for _, v67 in t6 do
                local v69 = math.clamp((v62 - (if n1 == 1 then (1 - v67.Reach) * 0.34 + v67.Jitter else v67.Reach * 0.3 + v67.Jitter)) / 0.3, 0, 1)

                if v69 < 1 then
                    v66 = false
                end

                local v70 = if n1 == 1 then TweenService:GetValue(v69, Enum.EasingStyle.Back, Enum.EasingDirection.Out) else 1 - TweenService:GetValue(v69, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

                v67.Scale.Scale = math.max(v70, 0)
                v67.Frame.Rotation = v67.Spin * (1 - v70)
            end

            if v66 then
                finish()
            end
        end
    end
end

v56 = function(p10) -- line: 414
    -- upvalues: GuiService (copy), RunService (copy), Audio (copy), clone (ref), Veil (ref), v7 (ref), n1 (ref), n2 (ref), v8 (ref), connection (ref), v13 (ref), rebuild (copy), step (copy)
    local clone2 = clone

    v8 = GuiService.ReducedMotionEnabled
    n1 = p10
    n2 = os.clock()
    v7 = p10 == 1 and "covering" or "revealing"

    if not v8 then
        rebuild()

        if p10 == 0 then
            local Veil2 = Veil

            Veil2.BackgroundTransparency = 1
            Veil2.Visible = false
        end
    end

    clone2.Enabled = true

    if v13 ~= nil then
        if p10 == 1 then
            Audio.Play(v13.Id, script, {
                Volume = v13.Volume
            })
        end
    elseif p10 == 1 then
        Audio.Play("rbxassetid://138533090376585", script, {
            Volume = 0.35,
            PlaybackSpeed = 0.7
        })
    else
        Audio.Play("rbxassetid://71759553024274", script, {
            Volume = 0.3,
            PlaybackSpeed = 0.85
        })
    end

    if connection == nil then
        connection = RunService.RenderStepped:Connect(step)
    end
end

local function rootPosition() -- line: 443
    -- upvalues: Player (copy), LocalPlayer (copy)
    local v71 = Player.FindRootPart(LocalPlayer)

    return if v71 then v71.Position else nil
end

local function cameraModule() -- line: 448
    -- upvalues: LocalPlayer (copy)
    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
    local PlayerModule = if PlayerScripts then PlayerScripts:FindFirstChild("PlayerModule") else nil

    if PlayerModule == nil or not PlayerModule:IsA("ModuleScript") then
        return nil
    end

    return require(PlayerModule):GetCameras()
end

local function faceForward() -- line: 457
    -- upvalues: Workspace (copy), Player (copy), LocalPlayer (copy), cameraModule (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local v72 = Player.FindRootPart(LocalPlayer)

    if CurrentCamera == nil or v72 == nil or CurrentCamera.CameraType ~= Enum.CameraType.Custom then
        return
    end

    local LookVector = v72.CFrame.LookVector
    local v73 = Vector3.new(LookVector.X, 0, LookVector.Z)

    if v73.Magnitude < 0.01 then
        return
    end

    local v74 = cameraModule()
    local v75 = (if v74 then v74:GetCameraSubjectPosition() else nil) or v72.Position + Vector3.new(0, 1.5, 0)
    local v77 = math.max((if v74 then v74:GetCameraToSubjectDistance() else nil) or (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude, 0.5)
    local v78 = v73.Unit * 0.9781476007338057 + Vector3.new(-0, -0.20791169, -0, -0)
    local v79 = CFrame.lookAt(v75 - v78 * v77, v75)

    CurrentCamera.CFrame = v79

    if v74 then
        v74:CommitCameraCFrame(v79, Enum.CameraType.Custom)
    end
end

local function onSignal() -- line: 484
    -- upvalues: LocalPlayer (copy), Transition (copy), v10 (ref), t8 (copy), portalSound (copy), v57 (ref)
    local Attribute = LocalPlayer:GetAttribute(Transition)

    if type(Attribute) ~= "string" or Attribute == v10 then
        return
    end

    v10 = Attribute

    local _, v80, v81 = string.match(Attribute, "^(%d+):(%a+):(%a+)$")

    if v80 == "cover" then
        v57(nil, nil, if v81 then portalSound(v81) else nil)
    elseif v80 == "reveal" then
        t8.RevealAfterMove()
    end
end

v57 = function(p11, p12, p13) -- line: 502
    -- upvalues: Player (copy), LocalPlayer (copy), t5 (copy), Veil (ref), Puff (ref), v6 (ref), v7 (ref), v9 (ref), n3 (ref), Position (ref), v11 (ref), v12 (ref), Color (ref), Color2 (ref), v13 (ref), t8 (copy), ensureGui (copy), v56 (ref)
    if not ensureGui() then
        return
    end

    n3 += 1

    local v83 = n3
    local v84 = Player.FindRootPart(LocalPlayer)

    Position = if v84 then v84.Position else nil
    v9 = false

    local v86 = math.clamp(p12 or 6, 6, 30)

    task.delay(v86, function() -- line: 511
        -- upvalues: v83 (copy), v7 (ref), n3 (ref), t8 (copy)
        if n3 == v83 and v7 ~= "clear" and v7 ~= "revealing" then
            t8.Reveal()
        end
    end)

    if v7 == "covered" or v7 == "covering" then
        return
    end

    p11 = p11 or t5

    if p11 ~= v11 then
        v11 = p11
        v6 = Vector2.zero

        local Veil2 = Veil

        Veil2.BackgroundColor3 = p11.Veil or v12

        local v88 = p11.VeilTint or Color
        local UIGradient = if Veil2 then Veil2:FindFirstChildOfClass("UIGradient") else nil

        if UIGradient ~= nil and v88 ~= nil then
            UIGradient.Color = v88
        end

        local Puff2 = Puff
        local v89 = p11.PuffTint or Color2
        local UIGradient2 = if Puff2 then Puff2:FindFirstChildOfClass("UIGradient") else nil

        if UIGradient2 ~= nil and v89 ~= nil then
            UIGradient2.Color = v89
        end
    end

    v13 = p13
    v56(1)
end

function t8.Cover(p14, p15) -- line: 524
    -- upvalues: v57 (ref)
    v57(p14, p15, nil)
end

function t8.IsCovering() -- line: 528
    -- upvalues: v7 (ref)
    if v7 == "covering" then
        return true
    end

    return v7 == "covered"
end

function t8.Reveal() -- line: 532
    -- upvalues: clone (ref), v7 (ref), v9 (ref), v56 (ref)
    if clone ~= nil and v7 ~= "clear" and v7 ~= "revealing" then
        if v7 == "covering" then
            v9 = true
        else
            v56(0)
        end
    end
end

function t8.RevealAfterMove() -- line: 543
    -- upvalues: Player (copy), LocalPlayer (copy), n3 (ref), Position (ref), t8 (copy), faceForward (copy)
    local v90 = n3
    local Position2 = Position
    local elapsed = os.clock()

    task.spawn(function() -- line: 547
        -- upvalues: v90 (copy), Position2 (copy), elapsed (copy), Player (copy), LocalPlayer (copy), n3 (ref), t8 (copy), faceForward (copy)
        while true do
            if os.clock() - elapsed < 1.2 then
                if n3 == v90 then
                    local v91 = Player.FindRootPart(LocalPlayer)
                    local Position = if v91 then v91.Position else nil

                    if Position2 == nil or Position and (Position - Position2).Magnitude > 12 then
                        break
                    end

                    task.wait()
                    continue
                end

                return
            end

            break
        end

        task.wait(0.15)

        if n3 == v90 then
            faceForward()
            t8.Reveal()
        end
    end)
end

function t8.Start(p16) -- line: 566
    -- upvalues: LocalPlayer (copy), Transition (copy), v5 (copy), clone (ref), v7 (ref), connection (ref), v10 (ref), onSignal (copy)
    v10 = ""

    local Attribute = LocalPlayer:GetAttribute(Transition)

    if type(Attribute) == "string" then
        v10 = Attribute
    end

    p16:Connect(LocalPlayer:GetAttributeChangedSignal(Transition), onSignal)
    p16:Add(function() -- line: 573
        -- upvalues: v5 (copy), clone (ref), v7 (ref), connection (ref)
        if connection then
            connection:Disconnect()
            connection = nil
        end

        v5:Clean()
        clone = nil
        v7 = "clear"
    end)
end

return t8

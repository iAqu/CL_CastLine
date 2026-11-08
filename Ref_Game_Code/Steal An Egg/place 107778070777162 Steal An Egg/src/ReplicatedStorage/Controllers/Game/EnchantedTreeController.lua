-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local ButterflyCatalog = require(ReplicatedStorage.Shared.Modules.ButterflyCatalog)
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {
    "Assets",
    "UI",
    "EnchantedTree",
    "EnchantedTransition"
}
local v1 = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local t2 = {
    0.9, 1.6
}
local v3 = Color3.fromRGB(150, 255, 214)
local v4 = Color3.fromRGB(122, 64, 214)
local LocalPlayer = Players.LocalPlayer
local v5 = Random.new()
local v6 = Trove.new()
local clone, Veil, Petals, Petal, Emblem, UIScale, Motes, Mote
local t3 = {}
local t4 = {}
local v7 = Vector2.zero
local v8 = "clear"
local n1 = 0
local n2 = 0
local v9 = false
local v10 = false
local n3 = 0
local Position, connection
local t5 = {}

local function findTemplate() -- line: 95
    -- upvalues: ReplicatedStorage (copy), t1 (copy)
    local v11 = ReplicatedStorage

    for _, v12 in t1 do
        v11 = if v11 then v11:FindFirstChild(v12) else nil
    end

    return if v11 and v11:IsA("ScreenGui") then v11 else nil
end

local function ensureGui() -- line: 103
    -- upvalues: LocalPlayer (copy), v6 (copy), clone (ref), Veil (ref), Petals (ref), Petal (ref), Emblem (ref), UIScale (ref), Motes (ref), Mote (ref), t3 (ref), t4 (ref), v7 (ref), v8 (ref), findTemplate (copy)
    if clone and clone.Parent then
        return true
    end

    local v13 = findTemplate()

    if v13 == nil then
        return false
    end

    v6:Clean()
    t3 = {}
    t4 = {}
    v7 = Vector2.zero
    v8 = "clear"

    local clone2 = v6:Clone(v13)

    clone2.Enabled = false
    Veil = clone2:WaitForChild("Veil")
    Petals = clone2:WaitForChild("Petals")

    local Petal2 = Petals:WaitForChild("Petal")

    Motes = clone2:WaitForChild("Motes")

    local Mote2 = Motes:WaitForChild("Mote")

    Emblem = clone2:WaitForChild("Emblem")
    UIScale = Emblem:WaitForChild("UIScale")
    Petal2.Visible = false
    Mote2.Visible = false
    Petal = Petal2
    Mote = Mote2
    clone2.Parent = LocalPlayer:WaitForChild("PlayerGui")
    clone = clone2

    return true
end

local function viewport() -- line: 135
    -- upvalues: Workspace (copy), clone (ref)
    local v14 = if clone then clone.AbsoluteSize else Vector2.zero

    if v14.X >= 1 and v14.Y >= 1 then
        return v14
    end

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera then
        return CurrentCamera.ViewportSize
    end

    return (Vector2.new(1280, 720))
end

local function rebuild() -- line: 144
    -- upvalues: Workspace (copy), v3 (copy), v4 (copy), v5 (copy), clone (ref), Petals (ref), Petal (ref), t3 (ref), v7 (ref), v8 (ref)
    local v15 = if clone then clone.AbsoluteSize else Vector2.zero

    if not (v15.X >= 1 and v15.Y >= 1) then
        local CurrentCamera = Workspace.CurrentCamera

        v15 = if CurrentCamera then CurrentCamera.ViewportSize else Vector2.new(1280, 720)
    end

    if v15 == v7 and #t3 > 0 then
        return
    end

    v7 = v15

    for _, v16 in t3 do
        v16.Frame:Destroy()
    end

    table.clear(t3)

    local v17 = math.max(v15.X, v15.Y) / 14
    local v19 = math.ceil(v15.X / v17) + 1
    local v21 = math.ceil(v15.Y / v17) + 1
    local v22 = v15 / 2
    local Magnitude = v22.Magnitude
    local v23 = if v8 == "covered" then 1 else 0

    for i = 0, v19 - 1 do
        for j = 0, v21 - 1 do
            local v24 = Vector2.new((i + j % 2 * 0.5) * v17, j * v17)
            local v25 = (v24 - v22).Magnitude / Magnitude
            local clone = Petal:Clone()

            clone.Name = ("%*_%*"):format(i, j)
            clone.Position = UDim2.fromScale(v24.X / v15.X, v24.Y / v15.Y)
            clone.Size = UDim2.fromScale(v17 * 1.5 / v15.X, v17 * 1.5 / v15.Y)
            clone.Visible = true

            local v27 = v3:Lerp(v4, (math.clamp(v25 + v5:NextNumber(-0.08, 0.08), 0, 1)))

            if clone:IsA("ImageLabel") then
                clone.ImageColor3 = v27
            else
                clone.BackgroundColor3 = v27
            end

            local v28 = clone:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")

            v28.Scale = v23
            v28.Parent = clone
            clone.Parent = Petals

            local t6 = t3

            table.insert(t6, {
                Frame = clone,
                Scale = v28,
                Delay = v25 * 0.38 + v5:NextNumber(0, 0.05),
                Spin = v5:NextNumber(-70, 70),
                Value = v23
            })
        end
    end
end

local function spawnMote(p1) -- line: 194
    -- upvalues: Workspace (copy), t2 (copy), v5 (copy), clone (ref), Motes (ref), Mote (ref), t4 (ref)
    local v29 = if clone then clone.AbsoluteSize else Vector2.zero

    if not (v29.X >= 1 and v29.Y >= 1) then
        local CurrentCamera = Workspace.CurrentCamera

        v29 = if CurrentCamera then CurrentCamera.ViewportSize else Vector2.new(1280, 720)
    end

    local clone2 = Mote:Clone()
    local v30 = Vector2.new(v5:NextNumber(0.08, 0.92), v5:NextNumber(0.2, 1))
    local v32 = v5:NextNumber(0.018, 0.04) * math.min(v29.X, v29.Y)

    clone2.Visible = true
    clone2.Parent = Motes

    local t8 = t4

    table.insert(t8, {
        Image = clone2,
        Born = p1,
        Life = v5:NextNumber(t2[1], t2[2]),
        From = v30,
        Drift = Vector2.new(v5:NextNumber(-0.05, 0.05), -v5:NextNumber(0.12, 0.28)),
        Size = v32
    })
end

local function stepMotes(p2) -- line: 211
    -- upvalues: Workspace (copy), clone (ref), t4 (ref), v8 (ref), spawnMote (copy)
    local v33 = if clone then clone.AbsoluteSize else Vector2.zero

    if not (v33.X >= 1 and v33.Y >= 1) then
        local CurrentCamera = Workspace.CurrentCamera

        v33 = if CurrentCamera then CurrentCamera.ViewportSize else Vector2.new(1280, 720)
    end

    for i = #t4, 1, -1 do
        local v34 = t4[i]
        local v35 = (p2 - v34.Born) / v34.Life

        if v35 >= 1 then
            v34.Image:Destroy()
            table.remove(t4, i)
        else
            local v36 = v34.From + v34.Drift * v35
            local v38 = math.sin(v35 * 3.141592653589793)
            local v39 = v34.Size * (v38 * 0.6 + 0.4)

            v34.Image.Position = UDim2.fromScale(v36.X, v36.Y)
            v34.Image.Size = UDim2.fromScale(v39 / v33.X, v39 / v33.Y)
            v34.Image.Rotation = v35 * 180

            if v34.Image:IsA("ImageLabel") then
                v34.Image.ImageTransparency = 1 - v38
            end
        end
    end

    if v8 ~= "clear" and v8 ~= "revealing" and #t4 < 26 then
        spawnMote(p2)
    end
end

local function clearMotes() -- line: 236
    -- upvalues: t4 (ref)
    for _, v40 in t4 do
        v40.Image:Destroy()
    end

    table.clear(t4)
end

local function setVeil(p3) -- line: 243
    -- upvalues: Veil (ref)
    local Veil2 = Veil

    Veil2.BackgroundTransparency = 1 - p3
    Veil2.Visible = p3 > 0
end

local v41

local function finish() -- line: 251
    -- upvalues: clone (ref), Veil (ref), t3 (ref), t4 (ref), v8 (ref), n1 (ref), v10 (ref), connection (ref), v41 (ref)
    if n1 == 1 then
        v8 = "covered"

        if v10 then
            v10 = false
            v41(0)
        end
    else
        v8 = "clear"

        if connection then
            connection:Disconnect()
            connection = nil
        end

        for _, v42 in t4 do
            v42.Image:Destroy()
        end

        table.clear(t4)

        for _, v43 in t3 do
            v43.Value = 0
            v43.Scale.Scale = 0
        end

        local Veil2 = Veil

        Veil2.BackgroundTransparency = 1
        Veil2.Visible = false

        if clone then
            clone.Enabled = false
        end
    end
end

local function step() -- line: 276
    -- upvalues: TweenService (copy), Veil (ref), t3 (ref), v8 (ref), n1 (ref), n2 (ref), v9 (ref), stepMotes (copy), finish (copy)
    local elapsed = os.clock()

    stepMotes(elapsed)

    if v8 == "covering" or v8 == "revealing" then
        local v44 = elapsed - n2

        if v9 then
            local v46 = math.clamp(v44 / 0.2, 0, 1)
            local v47 = if n1 == 1 then v46 else 1 - v46
            local Veil2 = Veil

            Veil2.BackgroundTransparency = 1 - v47
            Veil2.Visible = v47 > 0

            if v46 >= 1 then
                finish()
            end
        else
            local v48 = true

            for _, v49 in t3 do
                local v51 = math.clamp((v44 - (if n1 == 1 then v49.Delay else v49.Delay * 0.8)) / 0.26, 0, 1)

                if v51 < 1 then
                    v48 = false
                end

                local v52 = if n1 == 1 then TweenService:GetValue(v51, Enum.EasingStyle.Back, Enum.EasingDirection.Out) else 1 - TweenService:GetValue(v51, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

                v49.Value = v52
                v49.Scale.Scale = math.max(v52, 0)
                v49.Frame.Rotation = 45 + v49.Spin * (1 - v52)
            end

            if v48 then
                finish()
            end
        end
    end
end

v41 = function(p4) -- line: 310
    -- upvalues: GuiService (copy), RunService (copy), TweenService (copy), Audio (copy), ButterflyCatalog (copy), v1 (copy), v2 (copy), clone (ref), Emblem (ref), UIScale (ref), v8 (ref), n1 (ref), n2 (ref), v9 (ref), connection (ref), rebuild (copy), step (copy)
    local clone2 = clone

    v9 = GuiService.ReducedMotionEnabled
    n1 = p4
    n2 = os.clock()
    v8 = p4 == 1 and "covering" or "revealing"

    if not v9 then
        rebuild()
    end

    clone2.Enabled = true

    local Emblem2 = Emblem
    local UIScale2 = UIScale

    if p4 == 1 then
        Emblem2.Visible = true
        UIScale2.Scale = 0.4
        TweenService:Create(UIScale2, v1, {
            Scale = 1
        }):Play()
        Audio.Play(ButterflyCatalog.Sounds.BloomStart, script, {
            Volume = 0.55,
            PlaybackSpeed = 1.15
        })
    else
        TweenService:Create(UIScale2, v2, {
            Scale = 0
        }):Play()
        Audio.Play(ButterflyCatalog.Sounds.Craft, script, {
            Volume = 0.5,
            PlaybackSpeed = 1.2
        })
    end

    if connection == nil then
        connection = RunService.RenderStepped:Connect(step)
    end
end

local function rootPosition() -- line: 342
    -- upvalues: Player (copy), LocalPlayer (copy)
    local v53 = Player.FindRootPart(LocalPlayer)

    return if v53 then v53.Position else nil
end

local function cameraModule() -- line: 347
    -- upvalues: LocalPlayer (copy)
    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
    local PlayerModule = if PlayerScripts then PlayerScripts:FindFirstChild("PlayerModule") else nil

    if PlayerModule == nil or not PlayerModule:IsA("ModuleScript") then
        return nil
    end

    return require(PlayerModule):GetCameras()
end

local function faceForward() -- line: 356
    -- upvalues: Workspace (copy), Player (copy), LocalPlayer (copy), cameraModule (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local v54 = Player.FindRootPart(LocalPlayer)

    if CurrentCamera == nil or v54 == nil or CurrentCamera.CameraType ~= Enum.CameraType.Custom then
        return
    end

    local LookVector = v54.CFrame.LookVector
    local v55 = Vector3.new(LookVector.X, 0, LookVector.Z)

    if v55.Magnitude < 0.01 then
        return
    end

    local v56 = cameraModule()
    local v57 = (if v56 then v56:GetCameraSubjectPosition() else nil) or v54.Position + Vector3.new(0, 1.5, 0)
    local v59 = math.max((if v56 then v56:GetCameraToSubjectDistance() else nil) or (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude, 0.5)
    local v60 = v55.Unit * 0.9781476007338057 + Vector3.new(-0, -0.20791169, -0, -0)
    local v61 = CFrame.lookAt(v57 - v60 * v59, v57)

    CurrentCamera.CFrame = v61

    if v56 then
        v56:CommitCameraCFrame(v61, Enum.CameraType.Custom)
    end
end

local function syncLighting() -- line: 383
    -- upvalues: LightingController (copy), LocalPlayer (copy)
    local v62 = LocalPlayer:GetAttribute("InEnchantedTree") == true
    local EnchantedTree

    if v62 then
        EnchantedTree = LightingController.Presets.EnchantedTree
    else
        LightingController.ClearLayer("EnchantedTree", 0)
    end

    if (not v62 or EnchantedTree) and v62 then
        LightingController.SetLayer("EnchantedTree", "EnchantedTree", 150, 0)
    end
end

function t5.Cover(p5) -- line: 397
    -- upvalues: Player (copy), LocalPlayer (copy), v8 (ref), v10 (ref), n3 (ref), Position (ref), t5 (copy), ensureGui (copy), v41 (ref)
    if not ensureGui() then
        return
    end

    n3 += 1

    local v63 = n3
    local v64 = Player.FindRootPart(LocalPlayer)

    Position = if v64 then v64.Position else nil
    v10 = false
    task.delay(math.clamp(p5 or 6, 6, 30), function() -- line: 405
        -- upvalues: v63 (copy), v8 (ref), n3 (ref), t5 (copy)
        if n3 == v63 and v8 ~= "clear" and v8 ~= "revealing" then
            t5.Reveal()
        end
    end)

    if v8 ~= "covered" and v8 ~= "covering" then
        v41(1)
    end
end

function t5.Reveal() -- line: 416
    -- upvalues: clone (ref), v8 (ref), v10 (ref), v41 (ref)
    if clone ~= nil and v8 ~= "clear" and v8 ~= "revealing" then
        if v8 == "covering" then
            v10 = true
        else
            v41(0)
        end
    end
end

function t5.RevealAfterMove(p6, p7, p8) -- line: 427
    -- upvalues: LightingController (copy), Player (copy), LocalPlayer (copy), v8 (ref), n3 (ref), Position (ref), t5 (copy), faceForward (copy)
    local v66 = n3
    local Position2 = Position
    local elapsed = os.clock()

    task.spawn(function() -- line: 431
        -- upvalues: p6 (copy), p7 (copy), p8 (copy), v66 (copy), Position2 (copy), elapsed (copy), LightingController (copy), Player (copy), LocalPlayer (copy), v8 (ref), n3 (ref), t5 (copy), faceForward (copy)
        if p6 then
            local v67

            while true do
                if os.clock() - elapsed < 20 then
                    if n3 == v66 and v8 ~= "clear" and v8 ~= "revealing" then
                        local v68 = Player.FindRootPart(LocalPlayer)
                        local Position = if v68 then v68.Position else nil
                        local Character = LocalPlayer.Character
                        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                        local v69

                        if Character == p7 and Humanoid ~= nil and Humanoid.Health > 0 and Position ~= nil and (Position - p6).Magnitude <= 24 then
                            local v70 = v67 or os.clock()

                            if os.clock() - v70 >= (p8 or 0.12) then
                                if LocalPlayer:GetAttribute("InEnchantedTree") == true then
                                    if LightingController.Presets.EnchantedTree then
                                        LightingController.SetLayer("EnchantedTree", "EnchantedTree", 150, 0)
                                    end
                                else
                                    LightingController.ClearLayer("EnchantedTree", 0)
                                end

                                faceForward()
                                t5.Reveal()

                                return
                            end

                            v69 = v70
                        end

                        task.wait()
                        v67 = v69
                        continue
                    end

                    return
                end

                break
            end
        else
            while true do
                if os.clock() - elapsed < 1 then
                    if n3 == v66 then
                        local v71 = Player.FindRootPart(LocalPlayer)
                        local Position = if v71 then v71.Position else nil

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

            if LocalPlayer:GetAttribute("InEnchantedTree") == true then
                if LightingController.Presets.EnchantedTree then
                    LightingController.SetLayer("EnchantedTree", "EnchantedTree", 150, 0)
                end
            else
                LightingController.ClearLayer("EnchantedTree", 0)
            end

            task.wait(0.12)

            if n3 == v66 then
                faceForward()
                t5.Reveal()
            end
        end
    end)
end

function t5.Start() -- line: 479
    -- upvalues: LightingController (copy), Remotes (copy), LocalPlayer (copy), v8 (ref), t5 (copy)
    Remotes.EnchantedTree.Transition.OnClientEvent:Connect(function(p9, _, p11, p12) -- line: 481
        -- upvalues: t5 (copy)
        if p11 == nil then
            local v72 = if typeof(p12) == "table" then p12 else nil

            if p9 == "Cover" then
                t5.Cover(v72 and v72.TimeoutSeconds)
            elseif p9 == "Reveal" then
                t5.RevealAfterMove(v72 and v72.Destination, v72 and v72.Character, v72 and v72.HoldSeconds)
            end
        end
    end)
    LocalPlayer:GetAttributeChangedSignal("InEnchantedTree"):Connect(function() -- line: 498
        -- upvalues: LightingController (copy), LocalPlayer (copy), v8 (ref)
        if v8 == "clear" then
            if LocalPlayer:GetAttribute("InEnchantedTree") == true then
                if LightingController.Presets.EnchantedTree then
                    LightingController.SetLayer("EnchantedTree", "EnchantedTree", 150, 0)
                end
            else
                LightingController.ClearLayer("EnchantedTree", 0)
            end
        end
    end)

    local v73 = LocalPlayer:GetAttribute("InEnchantedTree") == true
    local EnchantedTree

    if v73 then
        EnchantedTree = LightingController.Presets.EnchantedTree
    else
        LightingController.ClearLayer("EnchantedTree", 0)
    end

    if (not v73 or EnchantedTree) and v73 then
        LightingController.SetLayer("EnchantedTree", "EnchantedTree", 150, 0)
    end
end

return t5

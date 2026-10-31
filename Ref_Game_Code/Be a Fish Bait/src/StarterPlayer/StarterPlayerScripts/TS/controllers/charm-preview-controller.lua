-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, StarterGui, Workspace = services.Players, services.StarterGui, services.Workspace
local charmPreviewCharmIdAtom = RuntimeLib.import(script, script.Parent.Parent, "charm-preview-atom").charmPreviewCharmIdAtom
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local v1 = RuntimeLib.import(script, script.Parent.Parent, "transitions", "screen-transition")
local ScreenTransition, screenTransitionGuiName = v1.ScreenTransition, v1.screenTransitionGuiName

local function getAnchorCFrame(p1) -- line: 19
    return p1.CFrame
end

local function findCharacterAnimation(p2, p3) -- line: 22
    local Animate = p2:FindFirstChild("Animate")

    if Animate ~= nil then
        Animate = Animate:FindFirstChild(p3)
    end

    if Animate ~= nil then
        Animate = Animate:FindFirstChildWhichIsA("Animation", true)
    end

    return Animate
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 38
        return "CharmPreviewController"
    end
})

self.__index = self

function self.new(...) -- line: 43
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p4, p5, p6) -- line: 47
    p4._characterController = p5
    p4._charmController = p6
    p4._coreGuiSnapshots = {}
    p4._screenGuiSnapshots = {}
end

function self.onStart(p7) -- line: 53
    -- upvalues: Players (copy)
    Players.LocalPlayer.CharacterAdded:Connect(function() -- line: 54
        -- upvalues: p7 (copy)
        return p7:stopPreview()
    end)
end

function self.onRender(p8) -- line: 58
    local _session = p8._session

    if _session == nil then
        return nil
    end

    if _session.rig.Parent == nil or _session.charmModel.Parent == nil then
        p8:stopPreview()

        return nil
    end

    _session.rig:PivotTo(_session.rigCFrame)

    if not _session.cameraActive then
        return nil
    end

    p8:_applyPreviewCamera(_session)
end

function self.startPreview(p9, p10) -- line: 73
    -- upvalues: Players (copy), Workspace (copy)
    p9:stopPreview()

    local CharmPreviewArea = Workspace:FindFirstChild("CharmPreviewArea")
    local v4 = if CharmPreviewArea == nil then CharmPreviewArea else CharmPreviewArea:FindFirstChild("Camera")
    local v5 = if CharmPreviewArea == nil then CharmPreviewArea else CharmPreviewArea:FindFirstChild("PreviewOrigin")
    local CurrentCamera = Workspace.CurrentCamera
    local Character = Players.LocalPlayer.Character
    local v6 = CharmPreviewArea == nil
    local v7

    if v6 then
        v7 = v6
    else
        local v8 = (if v4 == nil then v4 else v4:IsA("BasePart")) ~= true

        v8 = v8 and (if v4 == nil then v4 else v4:IsA("Camera")) ~= true

        if v8 then
            v7 = v8
        else
            local v9 = (if v5 == nil then v5 else v5:IsA("BasePart")) ~= true

            v7 = v9 or CurrentCamera == nil or Character == nil
        end
    end

    if v7 then
        warn("[src/client/controllers/charm-preview-controller.ts:95]", "Charm preview requires Workspace.CharmPreviewArea.Camera and Workspace.CharmPreviewArea.PreviewOrigin.")

        return false
    end

    local v10 = p9:_cloneCharacter(Character)

    if v10 == nil then
        warn("[src/client/controllers/charm-preview-controller.ts:103]", "Charm preview could not clone the local character.")

        return false
    end

    local v11 = p9:_getFacingCameraCFrame(v5, v4)

    v10:PivotTo(v11)
    v10.Parent = CharmPreviewArea

    local v12 = p9._charmController:attachCharmToCharacter(v10, p10, CharmPreviewArea, (("Preview_%*"):format(p10)))

    if v12 == nil then
        v10:Destroy()
        warn("[src/client/controllers/charm-preview-controller.ts:119]", "Charm preview could not attach the selected charm to its rig.")

        return false
    end

    local v13 = p9:_playIdleAnimation(Character, v10)
    local v14 = p9._characterController:acquireMovementLock()
    local t4 = {
        cameraSubject = CurrentCamera.CameraSubject,
        cameraType = CurrentCamera.CameraType,
        cframe = CurrentCamera.CFrame,
        fieldOfView = CurrentCamera.FieldOfView
    }
    local v15 = p9:_showTransition()
    local t5 = {
        cameraActive = false,
        camera = CurrentCamera,
        cameraAnchor = v4,
        cameraSnapshot = t4,
        charmModel = v12.model,
        idleTrack = v13,
        previewOrigin = v5,
        releaseCharmVisual = v12.destroy,
        releaseMovementLock = v14,
        rig = v10,
        rigCFrame = v11
    }

    p9._session = t5
    p9:_revealPreviewAfterTransition(t5, p10, v15)

    return true
end

function self.closePreview(p11) -- line: 158
    -- upvalues: clientProducer (copy)
    local v16 = p11._session ~= nil

    p11:stopPreview()

    if v16 then
        clientProducer.windowOpened({
            currentWindow = "celebrationEventShop"
        })
    end
end

function self.stopPreview(p12) -- line: 167
    -- upvalues: charmPreviewCharmIdAtom (copy)
    local _screenTransition = p12._screenTransition

    if _screenTransition ~= nil then
        _screenTransition:hideInstant()
    end

    local _session = p12._session

    p12._session = nil
    charmPreviewCharmIdAtom(nil)

    if _session ~= nil then
        local idleTrack = _session.idleTrack

        if idleTrack ~= nil then
            idleTrack:Stop(0)
        end

        local idleTrack2 = _session.idleTrack

        if idleTrack2 ~= nil then
            idleTrack2:Destroy()
        end

        _session.releaseCharmVisual()
        _session.rig:Destroy()
        _session.releaseMovementLock()
        _session.camera.CameraType = _session.cameraSnapshot.cameraType
        _session.camera.CameraSubject = _session.cameraSnapshot.cameraSubject
        _session.camera.CFrame = _session.cameraSnapshot.cframe
        _session.camera.FieldOfView = _session.cameraSnapshot.fieldOfView
    end

    p12:_restoreUi()
end

function self._cloneCharacter(_, p14) -- line: 194
    local Archivable = p14.Archivable

    p14.Archivable = true

    local clone = p14:Clone()

    p14.Archivable = Archivable

    if clone == nil then
        return nil
    end

    clone.Name = "CharmPreviewRig"

    for _, child in clone:GetChildren() do
        if child:HasTag("ToolbarSelectedItem") then
            child:Destroy()
        end
    end

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BaseScript") or descendant:IsA("Tool") or descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") or descendant:IsA("Beam") then
            descendant:Destroy()
        elseif descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.Massless = true
        end
    end

    local HumanoidRootPart = clone:FindFirstChild("HumanoidRootPart")

    if if HumanoidRootPart == nil then HumanoidRootPart else HumanoidRootPart:IsA("BasePart") then
        HumanoidRootPart.Anchored = true
        clone.PrimaryPart = HumanoidRootPart
    end

    local Humanoid = clone:FindFirstChildOfClass("Humanoid")

    if Humanoid ~= nil then
        Humanoid.AutoRotate = false
        Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end

    return clone
end

function self._playIdleAnimation(_, p16, p17) -- line: 237
    local Animate = p16:FindFirstChild("Animate")

    if Animate ~= nil then
        Animate = Animate:FindFirstChild("idle")
    end

    if Animate ~= nil then
        Animate = Animate:FindFirstChildWhichIsA("Animation", true)
    end

    local Humanoid = p17:FindFirstChildOfClass("Humanoid")

    if Animate == nil or Humanoid == nil then
        return nil
    end

    local Animator = Humanoid:FindFirstChildOfClass("Animator")

    if Animator == nil then
        Animator = Instance.new("Animator")
        Animator.Parent = Humanoid
    end

    local clone = Animate:Clone()
    local track = Animator:LoadAnimation(clone)

    clone:Destroy()
    track.Looped = true
    track.Priority = Enum.AnimationPriority.Idle
    track:Play(0.15, 1, 1)

    return track
end

function self._getFacingCameraCFrame(_, p19, p20) -- line: 256
    local Position = p19.Position
    local CFramePosition = p20.CFrame.Position
    local v19 = Vector3.new(CFramePosition.X - Position.X, 0, CFramePosition.Z - Position.Z)
    local v20 = p19.CFrame.LookVector * -1

    if v19.Magnitude > 0.01 then
        v20 = v19.Unit
    end

    return CFrame.lookAt(Position, Position + v20, p19.CFrame.UpVector)
end

function self._showTransition(p21) -- line: 264
    -- upvalues: RuntimeLib (copy), Players (copy), ScreenTransition (copy)
    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PlayerGui == nil then
        return RuntimeLib.Promise.resolve()
    end

    if p21._screenTransition == nil then
        p21._screenTransition = ScreenTransition.new(PlayerGui)
    end

    return p21._screenTransition:show()
end

function self._revealPreviewAfterTransition(p22, p23, p24, p25) -- line: 274
    -- upvalues: charmPreviewCharmIdAtom (copy)
    p25:andThen(function() -- line: 275
        -- upvalues: p22 (copy), p23 (copy), p24 (copy), charmPreviewCharmIdAtom (copy)
        if p22._session ~= p23 then
            return nil
        end

        p22:_hideUi()
        p23.cameraActive = true
        charmPreviewCharmIdAtom(p24)
        p22:_applyPreviewCamera(p23)
        task.spawn(function() -- line: 283
            -- upvalues: p22 (copy), p23 (copy)
            task.wait()

            if p22._session ~= p23 then
                return nil
            end

            local _screenTransition = p22._screenTransition

            if _screenTransition ~= nil then
                _screenTransition:hide()
            end
        end)
    end)
end

function self._applyPreviewCamera(_, p27) -- line: 295
    p27.camera.CameraType = Enum.CameraType.Scriptable
    p27.camera.CameraSubject = nil
    p27.camera.CFrame = p27.cameraAnchor.CFrame
    p27.camera.FieldOfView = 50
end

function self._hideUi(p28) -- line: 301
    -- upvalues: Players (copy), StarterGui (copy), screenTransitionGuiName (copy)
    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PlayerGui ~= nil then
        local t6 = {
            PlayerGui
        }
        local v21 = #t6
        local Descendants = PlayerGui:GetDescendants()

        table.move(Descendants, 1, #Descendants, v21 + 1, t6)

        for _, v22 in t6 do
            if v22:IsA("ScreenGui") and v22.Name ~= "CharmPreviewOverlay" and v22.Name ~= screenTransitionGuiName then
                p28._screenGuiSnapshots[v22] = v22.Enabled
                v22.Enabled = false
            end
        end
    end

    for _, v23 in Enum.CoreGuiType:GetEnumItems() do
        if v23 ~= Enum.CoreGuiType.All then
            local function v24() -- line: 322
                -- upvalues: v23 (copy), StarterGui (copy)
                return StarterGui:GetCoreGuiEnabled(v23)
            end

            local ok, result = pcall(v24)

            if ok and type(result) == "boolean" then
                p28._coreGuiSnapshots[v23] = result

                local function v25() -- line: 329
                    -- upvalues: v23 (copy), StarterGui (copy)
                    return StarterGui:SetCoreGuiEnabled(v23, false)
                end

                pcall(v25)
            end
        end
    end
end

function self._restoreUi(p29) -- line: 334
    -- upvalues: StarterGui (copy)
    for v26, v27 in p29._screenGuiSnapshots do
        if v26.Parent ~= nil then
            v26.Enabled = v27
        end
    end

    table.clear(p29._screenGuiSnapshots)

    for v28, v29 in p29._coreGuiSnapshots do
        local function v30() -- line: 342
            -- upvalues: v28 (copy), v29 (copy), StarterGui (copy)
            return StarterGui:SetCoreGuiEnabled(v28, v29)
        end

        pcall(v30)
    end

    table.clear(p29._coreGuiSnapshots)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/charm-preview-controller@CharmPreviewController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/character-controller@CharacterController", "client/controllers/charm-controller@CharmController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    CharmPreviewController = self
}

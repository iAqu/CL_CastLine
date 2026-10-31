-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, Players, StarterGui, Workspace = services.CollectionService, services.Players, services.StarterGui, services.Workspace
local aquariumSkinPreviewNameAtom = RuntimeLib.import(script, script.Parent.Parent, "aquarium-skin-preview-atom").aquariumSkinPreviewNameAtom
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local v1 = RuntimeLib.import(script, script.Parent.Parent, "transitions", "screen-transition")
local ScreenTransition, screenTransitionGuiName = v1.ScreenTransition, v1.screenTransitionGuiName
local getAquariumSkinModel = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquariums").getAquariumSkinModel
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "aquarium-placement-utils")
local computeAquariumCenteredPivotCFrame, prepareAquariumPrefabInstance = v2.computeAquariumCenteredPivotCFrame, v2.prepareAquariumPrefabInstance

local function getAnchorCFrame(p1) -- line: 24
    return p1.CFrame
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 30
        return "AquariumSkinPreviewController"
    end
})

self.__index = self

function self.new(...) -- line: 35
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p2) -- line: 39
    p2._coreGuiSnapshots = {}
    p2._screenGuiSnapshots = {}
end

function self.onStart(p3) -- line: 43
    -- upvalues: Players (copy), events (copy)
    Players.LocalPlayer.CharacterAdded:Connect(function() -- line: 44
        -- upvalues: p3 (copy)
        return p3:stopPreview()
    end)
    events.previewAquariumSkin:connect(function(p4, p5) -- line: 47
        -- upvalues: p3 (copy)
        return p3:startPreview(p4, p5)
    end)
end

function self.onRender(p6) -- line: 51
    local _session = p6._session

    if _session == nil then
        return nil
    end

    if _session.aquariumModel.Parent == nil then
        p6:stopPreview()

        return nil
    end

    if not _session.cameraActive then
        return nil
    end

    p6:_applyPreviewCamera(_session)
end

function self.startPreview(p7, p8, p9) -- line: 65
    -- upvalues: CollectionService (copy), Workspace (copy), getAquariumSkinModel (copy), computeAquariumCenteredPivotCFrame (copy), prepareAquariumPrefabInstance (copy)
    p7:stopPreview()

    local v5 = CollectionService:GetTagged("AquariumPreviewArea")[1]
    local v6 = if v5 == nil then v5 else v5:FindFirstChild("Camera")
    local v7 = if v5 == nil then v5 else v5:FindFirstChild("PreviewOrigin")
    local CurrentCamera = Workspace.CurrentCamera
    local v8 = v5 == nil
    local v9

    if v8 then
        v9 = v8
    else
        local v10 = (if v6 == nil then v6 else v6:IsA("BasePart")) ~= true

        v10 = v10 and (if v6 == nil then v6 else v6:IsA("Camera")) ~= true
        v9 = v10 or (if v7 == nil then v7 else v7:IsA("BasePart")) ~= true or CurrentCamera == nil
    end

    if v9 then
        warn("[src/client/controllers/aquarium-skin-preview-controller.ts:78]", "Aquarium skin preview requires an instance tagged \"AquariumPreviewArea\" with children Camera and PreviewOrigin.")

        return false
    end

    local v11 = getAquariumSkinModel(p9, p8)
    local Archivable = v11.Archivable

    v11.Archivable = true

    local clone = v11:Clone()

    v11.Archivable = Archivable

    if clone == nil then
        warn("[src/client/controllers/aquarium-skin-preview-controller.ts:90]", "Aquarium skin preview could not clone the skin model.")

        return false
    end

    clone.Name = "AquariumSkinPreviewModel"
    prepareAquariumPrefabInstance(clone)
    clone.Parent = Workspace
    clone:PivotTo(computeAquariumCenteredPivotCFrame(clone, v7.CFrame))
    clone.Parent = v5

    local t4 = {
        cameraSubject = CurrentCamera.CameraSubject,
        cameraType = CurrentCamera.CameraType,
        cframe = CurrentCamera.CFrame,
        fieldOfView = CurrentCamera.FieldOfView
    }
    local v12 = p7:_showTransition()
    local t5 = {
        cameraActive = false,
        aquariumModel = clone,
        camera = CurrentCamera,
        cameraAnchor = v6,
        cameraSnapshot = t4
    }

    p7._session = t5
    p7:_revealPreviewAfterTransition(t5, p8, v12)

    return true
end

function self.closePreview(p10) -- line: 144
    -- upvalues: clientProducer (copy)
    local v13 = p10._session ~= nil

    p10:stopPreview()

    if v13 then
        clientProducer.windowOpened({
            currentWindow = "aquariumShop",
            aquariumShopSection = "skins"
        })
    end
end

function self.stopPreview(p11) -- line: 154
    -- upvalues: aquariumSkinPreviewNameAtom (copy)
    local _screenTransition = p11._screenTransition

    if _screenTransition ~= nil then
        _screenTransition:hideInstant()
    end

    local _session = p11._session

    p11._session = nil
    aquariumSkinPreviewNameAtom(nil)

    if _session ~= nil then
        _session.aquariumModel:Destroy()
        _session.camera.CameraType = _session.cameraSnapshot.cameraType
        _session.camera.CameraSubject = _session.cameraSnapshot.cameraSubject
        _session.camera.CFrame = _session.cameraSnapshot.cframe
        _session.camera.FieldOfView = _session.cameraSnapshot.fieldOfView
    end

    p11:_restoreUi()
end

function self._showTransition(p12) -- line: 171
    -- upvalues: RuntimeLib (copy), Players (copy), ScreenTransition (copy)
    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PlayerGui == nil then
        return RuntimeLib.Promise.resolve()
    end

    if p12._screenTransition == nil then
        p12._screenTransition = ScreenTransition.new(PlayerGui)
    end

    return p12._screenTransition:show()
end

function self._revealPreviewAfterTransition(p13, p14, p15, p16) -- line: 181
    -- upvalues: aquariumSkinPreviewNameAtom (copy)
    p16:andThen(function() -- line: 182
        -- upvalues: p13 (copy), p14 (copy), p15 (copy), aquariumSkinPreviewNameAtom (copy)
        if p13._session ~= p14 then
            return nil
        end

        p13:_hideUi()
        p14.cameraActive = true
        aquariumSkinPreviewNameAtom(p15)
        p13:_applyPreviewCamera(p14)
        task.spawn(function() -- line: 190
            -- upvalues: p13 (copy), p14 (copy)
            task.wait()

            if p13._session ~= p14 then
                return nil
            end

            local _screenTransition = p13._screenTransition

            if _screenTransition ~= nil then
                _screenTransition:hide()
            end
        end)
    end)
end

function self._applyPreviewCamera(_, p18) -- line: 202
    p18.camera.CameraType = Enum.CameraType.Scriptable
    p18.camera.CameraSubject = nil
    p18.camera.CFrame = p18.cameraAnchor.CFrame
    p18.camera.FieldOfView = 70
end

function self._hideUi(p19) -- line: 208
    -- upvalues: Players (copy), StarterGui (copy), screenTransitionGuiName (copy)
    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PlayerGui ~= nil then
        local t6 = {
            PlayerGui
        }
        local v14 = #t6
        local Descendants = PlayerGui:GetDescendants()

        table.move(Descendants, 1, #Descendants, v14 + 1, t6)

        for _, v15 in t6 do
            if v15:IsA("ScreenGui") and v15.Name ~= "AquariumSkinPreviewOverlay" and v15.Name ~= screenTransitionGuiName then
                p19._screenGuiSnapshots[v15] = v15.Enabled
                v15.Enabled = false
            end
        end
    end

    for _, v16 in Enum.CoreGuiType:GetEnumItems() do
        if v16 ~= Enum.CoreGuiType.All then
            local function v17() -- line: 229
                -- upvalues: v16 (copy), StarterGui (copy)
                return StarterGui:GetCoreGuiEnabled(v16)
            end

            local ok, result = pcall(v17)

            if ok and type(result) == "boolean" then
                p19._coreGuiSnapshots[v16] = result

                local function v18() -- line: 236
                    -- upvalues: v16 (copy), StarterGui (copy)
                    return StarterGui:SetCoreGuiEnabled(v16, false)
                end

                pcall(v18)
            end
        end
    end
end

function self._restoreUi(p20) -- line: 241
    -- upvalues: StarterGui (copy)
    for v19, v20 in p20._screenGuiSnapshots do
        if v19.Parent ~= nil then
            v19.Enabled = v20
        end
    end

    table.clear(p20._screenGuiSnapshots)

    for v21, v22 in p20._coreGuiSnapshots do
        local function v23() -- line: 249
            -- upvalues: v21 (copy), v22 (copy), StarterGui (copy)
            return StarterGui:SetCoreGuiEnabled(v21, v22)
        end

        pcall(v23)
    end

    table.clear(p20._coreGuiSnapshots)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/aquarium-skin-preview-controller@AquariumSkinPreviewController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    AquariumSkinPreviewController = self
}

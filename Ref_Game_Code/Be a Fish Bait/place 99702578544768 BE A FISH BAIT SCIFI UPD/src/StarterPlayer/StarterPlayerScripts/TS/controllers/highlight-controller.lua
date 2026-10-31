-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, Players, UserInputService, Workspace = services.CollectionService, services.Players, services.UserInputService, services.Workspace
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 15
        return "HighlightController"
    end
})

self.__index = self

function self.new(...) -- line: 20
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(_) -- line: 24
end

function self._isAlreadyBeingHighlighted(_, p3) -- line: 26
    return p3:GetAttribute("IsBeingHighlightedAlready") == true
end

function self._trySetAdornee(p4, p5) -- line: 29
    -- upvalues: self (copy)
    if self:_isAlreadyBeingHighlighted(p5) or not p4._highlight then
        return false
    end

    p4._highlight.Adornee = p5

    return true
end

function self._updateDebugRayVisual(p6, p7, p8) -- line: 39
    -- upvalues: Workspace (copy)
    if not p6._debugRayPart then
        p6._debugRayPart = Instance.new("Part")
        p6._debugRayPart.Name = "HighlightRayDebug"
        p6._debugRayPart.Anchored = true
        p6._debugRayPart.CanCollide = false
        p6._debugRayPart.CanQuery = false
        p6._debugRayPart.CanTouch = false
        p6._debugRayPart.Material = Enum.Material.Neon
        p6._debugRayPart.Color = Color3.fromRGB(255, 255, 0)
        p6._debugRayPart.Transparency = 0.35
        p6._debugRayPart.Parent = Workspace
    end

    local v3 = p8 * 100
    local v4 = p7 + v3

    p6._debugRayPart.Size = Vector3.new(0.12, 0.12, v3.Magnitude)
    p6._debugRayPart.CFrame = CFrame.lookAt(p7:Lerp(v4, 0.5), v4)
end

function self._isUsingGamepad(_) -- line: 57
    -- upvalues: UserInputService (copy)
    local LastInputType = UserInputService:GetLastInputType()

    if LastInputType == Enum.UserInputType.Gamepad1
        or LastInputType == Enum.UserInputType.Gamepad2
        or LastInputType == Enum.UserInputType.Gamepad3
        or LastInputType == Enum.UserInputType.Gamepad4
        or LastInputType == Enum.UserInputType.Gamepad5
        or LastInputType == Enum.UserInputType.Gamepad6
        or LastInputType == Enum.UserInputType.Gamepad7 then
        return true
    end

    return LastInputType == Enum.UserInputType.Gamepad8
end

function self._resolveHighlightableTarget(p10, p11) -- line: 61
    -- upvalues: CollectionService (copy)
    if not p10._highlight or not p10._character then
        return false
    end

    local HumanoidRootPart = p10._character:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart and not ((p11.Position - HumanoidRootPart.Position).Magnitude > 50) then
        if CollectionService:HasTag(p11, "Highlightable") and p10:_trySetAdornee(p11) then
            return true
        end

        local Parent = p11.Parent

        if Parent and CollectionService:HasTag(Parent, "Highlightable") and p10:_trySetAdornee(Parent) then
            return true
        end

        if Parent ~= nil then
            Parent = Parent.Parent
        end

        if Parent and CollectionService:HasTag(Parent, "Highlightable") and p10:_trySetAdornee(Parent) then
            return true
        end
    end

    p10._highlight.Adornee = nil

    return false
end

function self.pcAndMobileDetection(p12) -- line: 98
    if not (p12._mouse and p12._highlight and p12._character) then
        return nil
    end

    local Target = p12._mouse.Target

    if not Target then
        p12._highlight.Adornee = nil

        return nil
    end

    p12:_resolveHighlightableTarget(Target)
end

function self._gamepadDetection(p13) -- line: 109
    -- upvalues: Workspace (copy)
    if not p13._highlight or not p13._character then
        return nil
    end

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera then
        local v5 = CurrentCamera.ViewportSize / 2
        local v6 = CurrentCamera:ViewportPointToRay(v5.X, v5.Y)
        local v7 = RaycastParams.new()

        v7.FilterType = Enum.RaycastFilterType.Exclude

        if p13._character then
            v7:AddToFilter({
                p13._character
            })
        end

        local v8 = Workspace:Raycast(v6.Origin, v6.Direction * 100, v7)

        if v8 ~= nil then
            v8 = v8.Instance
        end

        if not (v8 and v8:IsA("BasePart")) then
            p13._highlight.Adornee = nil

            return nil
        end

        p13:_resolveHighlightableTarget(v8)

        return
    end

    p13._highlight.Adornee = nil

    return nil
end

function self.onStart(p14) -- line: 138
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer

    p14._mouse = LocalPlayer:GetMouse()
    p14._highlight = Instance.new("Highlight")
    p14._highlight.FillColor = Color3.new(1, 1, 1)
    p14._highlight.FillTransparency = 0.9
    p14._highlight.OutlineColor = Color3.new(1, 1, 1)
    p14._highlight.OutlineTransparency = 0
    p14._highlight.Parent = LocalPlayer
    p14._character = LocalPlayer.Character
    LocalPlayer.CharacterAdded:Connect(function(p15) -- line: 150
        -- upvalues: p14 (copy)
        p14._character = p15
    end)
end

function self.onTick(p16) -- line: 154
    if p16:_isUsingGamepad() then
        p16:_gamepadDetection()

        return nil
    end

    p16:pcAndMobileDetection()
end

Reflect.defineMetadata(self, "identifier", "client/controllers/highlight-controller@HighlightController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, { {} })

return {
    HighlightController = self
}

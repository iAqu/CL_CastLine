-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, Workspace = services.Players, services.Workspace
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local functions = RuntimeLib.import(script, script.Parent.Parent, "network").functions
local animations = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "animation-utils").animations
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "slap-weapon-utils")
local computeSlapCFrame, slapHitCooldown, slapToolName = v1.computeSlapCFrame, v1.slapHitCooldown, v1.slapToolName
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 24
        return "SlapWeaponController"
    end
})

self.__index = self

function self.new(...) -- line: 29
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 33
    -- upvalues: Maid (copy)
    p1._characterController = p2
    p1._characterMaid = Maid.new()
end

function self.onStart(p3) -- line: 37
    -- upvalues: Players (copy)
    Players.LocalPlayer.CharacterAdded:Connect(function(p4) -- line: 38
        -- upvalues: p3 (copy)
        return p3:_onCharacterAdded(p4)
    end)

    if Players.LocalPlayer.Character then
        p3:_onCharacterAdded(Players.LocalPlayer.Character)
    end
end

function self._onCharacterAdded(p5, p6) -- line: 45
    -- upvalues: Maid (copy)
    p5._characterMaid:Destroy()
    p5._characterMaid = Maid.new()

    for _, child in p6:GetChildren() do
        p5:_tryConnectSlapTool(child)
    end

    p5._characterMaid:GiveTask(p6.ChildAdded:Connect(function(p7) -- line: 51
        -- upvalues: p5 (copy)
        return p5:_tryConnectSlapTool(p7)
    end))
end

function self._tryConnectSlapTool(p8, p9) -- line: 55
    -- upvalues: slapToolName (copy)
    if p9.Name ~= slapToolName or not p9:IsA("Tool") then
        return nil
    end

    p8._characterMaid:GiveTask(p9.Activated:Connect(function() -- line: 59
        -- upvalues: p8 (copy)
        return p8:activateSlap()
    end))
end

function self._canSlap(p10) -- line: 63
    -- upvalues: Workspace (copy), slapHitCooldown (copy)
    if p10._lastSwingTimestamp == nil then
        return true
    end

    return Workspace:GetServerTimeNow() - p10._lastSwingTimestamp >= slapHitCooldown
end

function self.activateSlap(p11) -- line: 69
    -- upvalues: Players (copy), Workspace (copy), functions (copy), animations (copy), computeSlapCFrame (copy)
    if not p11:_canSlap() then
        return nil
    end

    local Character = Players.LocalPlayer.Character

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart")
    end

    if not Character then
        return nil
    end

    p11._lastSwingTimestamp = Workspace:GetServerTimeNow()
    p11._characterController:playAnimation(animations.slap, Enum.AnimationPriority.Action)

    local v4 = computeSlapCFrame(Character)

    functions.slapUsed(v4):catch(function() -- line: 88
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/slap-weapon-controller@SlapWeaponController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/character-controller@CharacterController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    SlapWeaponController = self
}

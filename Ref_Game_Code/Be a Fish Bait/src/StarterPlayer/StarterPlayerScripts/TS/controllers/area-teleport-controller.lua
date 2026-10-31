-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local _ = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, Workspace = services.Players, services.Workspace
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent, "utils").localPlayerUserId
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 13
        return "AreaTeleportController"
    end
})

self.__index = self

function self.new(...) -- line: 18
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 22
    p1._components = p2
end

function self.onStart(_) -- line: 25
end

self.teleportToHome = RuntimeLib.async(function(p4) -- line: 27
    -- upvalues: Players (copy), Workspace (copy), localPlayerUserId (copy)
    local v4 = p4._components:getAllComponents("client/components/plot-component@PlotComponent")
    local t4 = {}

    local function v5(p5) -- line: 38
        -- upvalues: localPlayerUserId (copy)
        return p5.attributes.ownerUserId == localPlayerUserId
    end

    local n1 = 0

    for v6, v7 in v4 do
        local _ = v6 - 1

        if v7.attributes.ownerUserId == localPlayerUserId == true then
            n1 += 1
            t4[n1] = v7
        end
    end

    local instance = t4[1].instance
    local Character = Players.LocalPlayer.Character
    local v8 = instance.OwnerDetails.WorldPosition + Vector3.new(0, -11, 0)
    local Position = instance:GetPivot().Position

    if Character then
        Character:PivotTo(CFrame.lookAt(v8, Position))
    end

    local CurrentCamera = Workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    CurrentCamera.CameraType = Enum.CameraType.Scriptable

    local Unit = (Position - v8).Unit
    local v9 = v8 - Unit * 16 + Vector3.new(0, 6, 0)

    CurrentCamera.CFrame = CFrame.lookAt(v9, v8 + Unit)
    task.wait(0.1)
    CurrentCamera.CameraType = Enum.CameraType.Custom
end)
Reflect.defineMetadata(self, "identifier", "client/controllers/area-teleport-controller@AreaTeleportController")
Reflect.defineMetadata(self, "flamework:parameters", { "$c:components@Components" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    AreaTeleportController = self
}

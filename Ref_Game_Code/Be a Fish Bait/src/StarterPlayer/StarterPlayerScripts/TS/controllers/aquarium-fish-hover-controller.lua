-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, Players, UserInputService, Workspace = services.CollectionService, services.Players, services.UserInputService, services.Workspace
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local screenPointToRay = RuntimeLib.import(script, script.Parent.Parent, "utils").screenPointToRay

local function findAquariumFishModelFromPart(p1) -- line: 13
    -- upvalues: CollectionService (copy)
    if CollectionService:HasTag(p1, "AquariumFishPart") or CollectionService:HasTag(p1, "ShowcaseFishPart") then
        local Parent = p1.Parent

        while true do
            if Parent == nil then
                return nil
            end

            if Parent:IsA("Model") and (CollectionService:HasTag(Parent, "AquariumFish") or CollectionService:HasTag(Parent, "ShowcaseFish")) then
                break
            end

            Parent = Parent.Parent
        end

        return Parent
    end

    return nil
end

local function raycastForAquariumFish(p2, p3) -- line: 27
    -- upvalues: CollectionService (copy), Workspace (copy), screenPointToRay (copy), findAquariumFishModelFromPart (copy)
    local v1 = screenPointToRay(p2, p3)
    local v2 = RaycastParams.new()

    v2.FilterType = Enum.RaycastFilterType.Include

    local t1 = {}
    local v3 = #t1
    local AquariumFishPart = CollectionService:GetTagged("AquariumFishPart")
    local v4 = #AquariumFishPart

    table.move(AquariumFishPart, 1, v4, v3 + 1, t1)

    local v5 = v3 + v4
    local ShowcaseFishPart = CollectionService:GetTagged("ShowcaseFishPart")

    table.move(ShowcaseFishPart, 1, #ShowcaseFishPart, v5 + 1, t1)
    v2.FilterDescendantsInstances = t1

    local v6 = Workspace:Raycast(v1.Origin, v1.Direction * 200, v2)

    if v6 ~= nil then
        v6 = v6.Instance
    end

    return if if v6 == nil then v6 else v6:IsA("BasePart") then findAquariumFishModelFromPart(v6) else nil
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 58
        return "AquariumFishHoverController"
    end
})

self.__index = self

function self.new(...) -- line: 63
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(_) -- line: 67
end

function self.onStart(p5) -- line: 69
    -- upvalues: Players (copy)
    p5._mouse = Players.LocalPlayer:GetMouse()
    p5:_setupTouchListeners()
end

function self.onTick(p6) -- line: 73
    -- upvalues: UserInputService (copy), clientProducer (copy), raycastForAquariumFish (copy)
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        return nil
    end

    local _mouse = p6._mouse

    if not _mouse then
        return nil
    end

    local v9 = raycastForAquariumFish(_mouse.X, _mouse.Y)

    if v9 ~= nil then
        v9 = v9.Name
    end

    if v9 ~= clientProducer:getState().aquariumFishHover.hoveredFishId then
        clientProducer.aquariumFishHovered({
            fishId = v9
        })
    end
end

function self._setupTouchListeners(p7) -- line: 93
    -- upvalues: UserInputService (copy), clientProducer (copy), raycastForAquariumFish (copy)
    UserInputService.TouchStarted:Connect(function(p8) -- line: 94
        -- upvalues: p7 (copy), clientProducer (copy), raycastForAquariumFish (copy)
        local v10 = raycastForAquariumFish(p8.Position.X, p8.Position.Y)

        if not v10 then
            return nil
        end

        p7._touchFishId = v10.Name
        clientProducer.aquariumFishHovered({
            fishId = v10.Name
        })
    end)
    UserInputService.TouchEnded:Connect(function() -- line: 104
        -- upvalues: p7 (copy), clientProducer (copy)
        if p7._touchFishId ~= nil then
            p7._touchFishId = nil
            clientProducer.aquariumFishHovered({
                fishId = nil
            })
        end
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/aquarium-fish-hover-controller@AquariumFishHoverController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, { {} })

return {
    AquariumFishHoverController = self
}

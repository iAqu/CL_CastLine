-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, Players, UserInputService, Workspace = services.CollectionService, services.Players, services.UserInputService, services.Workspace
local screenPointToRay = RuntimeLib.import(script, script.Parent.Parent, "utils").screenPointToRay

local function findBillboardFromHit(p1) -- line: 12
    local Parent = p1.Parent

    while Parent ~= nil do
        if Parent:IsA("Model") and Parent.Name == "BestFishDisplay" then
            local v1 = Parent.PrimaryPart or Parent:FindFirstChildWhichIsA("BasePart", true)

            if v1 ~= nil then
                v1 = v1:FindFirstChild("BestFishBillboard")
            end

            return v1
        end

        Parent = Parent.Parent
    end

    return nil
end

local function raycastForBestFish(p2, p3) -- line: 27
    -- upvalues: CollectionService (copy), Workspace (copy), screenPointToRay (copy), findBillboardFromHit (copy)
    local v2 = screenPointToRay(p2, p3)
    local v3 = RaycastParams.new()

    v3.FilterType = Enum.RaycastFilterType.Include
    v3.FilterDescendantsInstances = CollectionService:GetTagged("BestFishPart")

    local v4 = Workspace:Raycast(v2.Origin, v2.Direction * 200, v3)

    if v4 ~= nil then
        v4 = v4.Instance
    end

    return if if v4 == nil then v4 else v4:IsA("BasePart") then findBillboardFromHit(v4) else nil
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 50
        return "BestFishHoverController"
    end
})

self.__index = self

function self.new(...) -- line: 55
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(_) -- line: 59
end

function self.onStart(p5) -- line: 61
    -- upvalues: Players (copy)
    p5._mouse = Players.LocalPlayer:GetMouse()
end

function self.onTick(p6) -- line: 64
    -- upvalues: UserInputService (copy), raycastForBestFish (copy)
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        return nil
    end

    local _mouse = p6._mouse

    if not _mouse then
        return nil
    end

    local v7 = raycastForBestFish(_mouse.X, _mouse.Y)

    if v7 == p6._activeBillboard then
        return nil
    end

    if p6._activeBillboard then
        p6._activeBillboard.Enabled = false
    end

    if v7 then
        v7.Enabled = true
    end

    p6._activeBillboard = v7
end

Reflect.defineMetadata(self, "identifier", "client/controllers/best-fish-hover-controller@BestFishHoverController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, { {} })

return {
    BestFishHoverController = self
}

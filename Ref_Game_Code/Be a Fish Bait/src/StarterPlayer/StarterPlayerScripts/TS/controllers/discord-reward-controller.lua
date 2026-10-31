-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, Workspace = services.Players, services.Workspace
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local isPartOnAnotherPart = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "detectable-utils").isPartOnAnotherPart
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 14
        return "DiscordRewardController"
    end
})

self.__index = self

function self.new(...) -- line: 19
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1) -- line: 23
    p1._checkInterval = 0.2
    p1._timeLastChecked = 0
    p1._wasInside = false
end

function self.onStart(_) -- line: 28
    -- upvalues: clientProducer (copy), events (copy)
    events.openDiscordRewardWindow:connect(function() -- line: 29
        -- upvalues: clientProducer (copy)
        clientProducer.windowOpened({
            currentWindow = "discordReward"
        })
    end)
end

function self.onTick(p3) -- line: 35
    -- upvalues: clientProducer (copy)
    if os.clock() - p3._timeLastChecked < p3._checkInterval then
        return nil
    end

    p3._timeLastChecked = os.clock()

    local v3 = p3:_isPlayerInsideArea()

    if v3 == p3._wasInside then
        return nil
    end

    p3._wasInside = v3

    if v3 then
        clientProducer.windowOpened({
            currentWindow = "discordReward"
        })
    elseif clientProducer:getState().currentWindow.currentWindow == "discordReward" then
        clientProducer.windowClosed({})
    end
end

function self._isPlayerInsideArea(p4) -- line: 54
    -- upvalues: Players (copy), isPartOnAnotherPart (copy)
    local Character = Players.LocalPlayer.Character

    if Character then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart then
            local v4 = p4:_findDetectableArea()

            if v4 then
                return isPartOnAnotherPart(HumanoidRootPart, v4, (Vector3.new(0, 0.5, 0)))
            end
        end
    end

    return false
end

function self._findDetectableArea(_) -- line: 69
    -- upvalues: Workspace (copy)
    local Map = Workspace:FindFirstChild("Map")

    if Map ~= nil then
        Map = Map:FindFirstChild("Shops")
    end

    if Map ~= nil then
        Map = Map:FindFirstChild("DiscordReward")
    end

    if Map == nil then
        Map = Workspace:FindFirstChild("DiscordReward", true)
    end

    if Map ~= nil then
        Map = Map:FindFirstChild("DetectableArea")
    end

    return if if Map == nil then Map else Map:IsA("BasePart") then Map else nil
end

Reflect.defineMetadata(self, "identifier", "client/controllers/discord-reward-controller@DiscordRewardController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    DiscordRewardController = self
}

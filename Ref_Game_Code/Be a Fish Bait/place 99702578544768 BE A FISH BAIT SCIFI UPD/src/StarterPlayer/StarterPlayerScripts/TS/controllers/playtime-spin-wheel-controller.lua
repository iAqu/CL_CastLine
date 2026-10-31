-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, ReplicatedStorage, Workspace = services.Players, services.ReplicatedStorage, services.Workspace
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local isPartOnAnotherPart = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "detectable-utils").isPartOnAnotherPart
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 17
        return "PlaytimeSpinWheelController"
    end
})

self.__index = self

function self.new(...) -- line: 22
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1) -- line: 26
    p1._closeBindable = Instance.new("BindableEvent")
    p1._openBindable = Instance.new("BindableEvent")
    p1._checkInterval = 0.2
    p1._timeLastChecked = 0
    p1._wasInside = false
    p1._hasFiredAnalyticsOpen = false
end

function self.close(_) -- line: 34
    -- upvalues: clientProducer (copy)
    clientProducer.windowClosed({})
end

function self.open(p3) -- line: 37
    -- upvalues: clientProducer (copy), events (copy)
    clientProducer.windowOpened({
        currentWindow = "playtimeSpinWheel"
    })

    if not p3._hasFiredAnalyticsOpen then
        p3._hasFiredAnalyticsOpen = true
        events.analyticsSpinWheelUIOpened:fire()
    end
end

function self.onStart(p4) -- line: 46
    -- upvalues: ReplicatedStorage (copy)
    p4._closeBindable.Name = "ClosePlaytimeSpinWheel"
    p4._closeBindable.Parent = ReplicatedStorage
    p4._closeBindable.Event:Connect(function() -- line: 49
        -- upvalues: p4 (copy)
        return p4:close()
    end)
    p4._openBindable.Name = "OpenPlaytimeSpinWheel"
    p4._openBindable.Parent = ReplicatedStorage
    p4._openBindable.Event:Connect(function() -- line: 54
        -- upvalues: p4 (copy)
        return p4:open()
    end)
end

function self.onTick(p5) -- line: 58
    -- upvalues: clientProducer (copy)
    if os.clock() - p5._timeLastChecked < p5._checkInterval then
        return nil
    end

    p5._timeLastChecked = os.clock()

    local v3 = p5:_isPlayerInsideSpinWheelArea()

    if v3 == p5._wasInside then
        return nil
    end

    p5._wasInside = v3

    if v3 then
        p5:open()
    elseif clientProducer:getState().currentWindow.currentWindow == "playtimeSpinWheel" then
        p5:close()
    end
end

function self._isPlayerInsideSpinWheelArea(p6) -- line: 75
    -- upvalues: Players (copy), isPartOnAnotherPart (copy)
    local Character = Players.LocalPlayer.Character

    if Character then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart then
            local v4 = p6:_findSpinWheelDetectableArea()

            if v4 then
                return isPartOnAnotherPart(HumanoidRootPart, v4, (Vector3.new(0, 0.5, 0)))
            end
        end
    end

    return false
end

function self._findSpinWheelDetectableArea(_) -- line: 90
    -- upvalues: Workspace (copy)
    local Map = Workspace:FindFirstChild("Map")

    if Map ~= nil then
        Map = Map:FindFirstChild("Shops")
    end

    if Map ~= nil then
        Map = Map:FindFirstChild("SpinWheel")
    end

    if Map == nil then
        Map = Workspace:FindFirstChild("SpinWheel", true)
    end

    if Map ~= nil then
        Map = Map:FindFirstChild("DetectableArea")
    end

    return if if Map == nil then Map else Map:IsA("BasePart") then Map else nil
end

Reflect.defineMetadata(self, "identifier", "client/controllers/playtime-spin-wheel-controller@PlaytimeSpinWheelController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    openPlaytimeSpinWheelBindableName = "OpenPlaytimeSpinWheel",
    closePlaytimeSpinWheelBindableName = "ClosePlaytimeSpinWheel",
    PlaytimeSpinWheelController = self
}

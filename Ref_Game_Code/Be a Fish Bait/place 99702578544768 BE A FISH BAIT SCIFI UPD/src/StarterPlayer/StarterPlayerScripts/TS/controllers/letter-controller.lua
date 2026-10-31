-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, Workspace = services.Players, services.Workspace
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local getLetterData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "letters").getLetterData

local function findLetterInstance(p1) -- line: 17
    return if p1:IsA("BasePart") or p1:IsA("Model") then p1 else nil
end

local function findPrompt(p2) -- line: 23
    local ProximityPrompt = p2:FindFirstChildOfClass("ProximityPrompt")

    if ProximityPrompt then
        return ProximityPrompt
    end

    return p2:FindFirstChildWhichIsA("ProximityPrompt", true)
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 33
        return "LetterController"
    end
})

self.__index = self

function self.new(...) -- line: 38
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p3) -- line: 42
    -- upvalues: Maid (copy)
    p3._maid = Maid.new()
    p3._time = 0
    p3._tracked = {}
end

function self.onStart(p4) -- line: 47
    -- upvalues: Workspace (copy)
    local v3 = Workspace:WaitForChild("Community", 10)

    if v3 ~= nil then
        v3 = v3:WaitForChild("Letter", 10)
    end

    if not v3 then
        return nil
    end

    for _, child in v3:GetChildren() do
        p4:_setup(child)
    end

    p4._maid:GiveTask(v3.ChildAdded:Connect(function(p5) -- line: 60
        -- upvalues: p4 (copy)
        return p4:_setup(p5)
    end))
    p4._maid:GiveTask(v3.ChildRemoved:Connect(function(p6) -- line: 63
        -- upvalues: p4 (copy)
        return p4:_teardown(p6)
    end))
end

function self.onTick(p7, p8) -- line: 67
    p7._time += p8

    for _, v4 in p7._tracked do
        local v5 = (p7._time * 0.39269908169872414 + v4.phase) % 6.283185307179586
        local v7 = math.sin(p7._time * 1.5707963267948966 + v4.phase) * 0.5
        local v8 = v4.basePosition + Vector3.new(0, v7, 0)
        local instance = v4.instance
        local v9 = CFrame.new(v8)
        local baseRotation = v4.baseRotation
        local v10 = CFrame.Angles(0, v5, 0)

        instance:PivotTo(v9 * baseRotation * v10)
    end
end

function self._setup(p9, p10) -- line: 82
    -- upvalues: Players (copy), clientProducer (copy), getLetterData (copy)
    if not getLetterData(p10.Name) then
        return nil
    end

    local v11 = if p10:IsA("BasePart") or p10:IsA("Model") then p10 else nil

    if not v11 then
        return nil
    end

    local Pivot = v11:GetPivot()

    table.insert(p9._tracked, {
        basePosition = Pivot.Position,
        baseRotation = Pivot.Rotation,
        instance = v11,
        phase = math.random() * 2 * 3.141592653589793
    })

    local v12 = v11:FindFirstChildOfClass("ProximityPrompt") or v11:FindFirstChildWhichIsA("ProximityPrompt", true)

    if not v12 then
        return nil
    end

    p9._maid:GiveTask(v12.Triggered:Connect(function(p11) -- line: 103
        -- upvalues: p10 (copy), Players (copy), clientProducer (copy)
        if p11 ~= Players.LocalPlayer then
            return nil
        end

        clientProducer.letterSelected({
            letterId = p10.Name
        })
        clientProducer.windowOpened({
            currentWindow = "letter"
        })
    end))
end

function self._teardown(p12, p13) -- line: 115
    local _tracked = p12._tracked
    local t5 = {}
    local n1 = 0

    for v13, v14 in _tracked do
        local _ = v13 - 1

        if v14.instance ~= p13 == true then
            n1 += 1
            t5[n1] = v14
        end
    end

    p12._tracked = t5
end

Reflect.defineMetadata(self, "identifier", "client/controllers/letter-controller@LetterController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    LetterController = self
}

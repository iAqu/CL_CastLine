-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, Workspace = services.Players, services.Workspace
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 16
        return "SecretFrostwyrmController"
    end
})

self.__index = self

function self.new(...) -- line: 21
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1) -- line: 25
    p1._lookupStarted = false
    p1._hasFiredNearTablet = false
    p1._timeLastChecked = 0
end

function self.onTick(p2) -- line: 30
    -- upvalues: Players (copy), events (copy)
    if p2._hasFiredNearTablet then
        return nil
    end

    if not p2._lookupStarted then
        p2._lookupStarted = true
        task.spawn(function() -- line: 36
            -- upvalues: p2 (copy)
            return p2:_findPromptPart()
        end)
    end

    local _promptPart = p2._promptPart

    if _promptPart == nil or os.clock() - p2._timeLastChecked < 0.2 then
        return nil
    end

    p2._timeLastChecked = os.clock()

    local Character = Players.LocalPlayer.Character

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart")
    end

    if not (if Character == nil then Character else Character:IsA("BasePart")) or (Character.Position - _promptPart.Position).Magnitude > 20 then
        return nil
    end

    p2._hasFiredNearTablet = true
    events.analyticsFrostwyrmNearTablet:fire()
end

function self._findPromptPart(p3) -- line: 70
    -- upvalues: Workspace (copy)
    local v3 = Workspace:WaitForChild("FrostwyrmNPC", 10)

    if v3 == nil then
        return nil
    end

    local v4 = v3:WaitForChild("NearTabletPart", 10)

    if if v4 == nil then v4 else v4:IsA("BasePart") then
        p3._promptPart = v4
    end
end

Reflect.defineMetadata(self, "identifier", "client/controllers/secret-frostwyrm-controller@SecretFrostwyrmController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    SecretFrostwyrmController = self
}

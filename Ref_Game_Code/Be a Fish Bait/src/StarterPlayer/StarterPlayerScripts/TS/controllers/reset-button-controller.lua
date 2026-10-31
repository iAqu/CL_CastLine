-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local StarterGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").StarterGui
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 9
        return "ResetButtonController"
    end
})

self.__index = self

function self.new(...) -- line: 14
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(_) -- line: 18
end

function self.onStart(_) -- line: 20
    -- upvalues: StarterGui (copy)
    for _ = 0, 9 do
        local function v3() -- line: 23
            -- upvalues: StarterGui (copy)
            return StarterGui:SetCore("ResetButtonCallback", false)
        end

        if pcall(v3) then
            break
        end

        task.wait(1)
    end
end

Reflect.defineMetadata(self, "identifier", "client/controllers/reset-button-controller@ResetButtonController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    ResetButtonController = self
}

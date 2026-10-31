-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local Centurion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "centurion", "out").Centurion
local CenturionUI = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "centurion-ui", "out").CenturionUI
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, StarterGui, TextChatService = services.Players, services.StarterGui, services.TextChatService
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 14
        return "CenturionController"
    end
})

self.__index = self

function self.new(...) -- line: 19
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(_) -- line: 23
end

function self.onInit(_) -- line: 25
    -- upvalues: Centurion (copy), CenturionUI (copy)
    Centurion.client():start():andThen(function() -- line: 26
        -- upvalues: Centurion (copy), CenturionUI (copy)
        return CenturionUI.start(Centurion.client({}), {})
    end):catch(function(p3) -- line: 28
        return warn("Failed to start Centurion:", p3)
    end)
end

function self.onStart(_) -- line: 32
    -- upvalues: CenturionUI (copy), Players (copy), StarterGui (copy), TextChatService (copy)
    TextChatService.SendingMessage:Connect(function(p5) -- line: 33
        -- upvalues: CenturionUI (copy), Players (copy), StarterGui (copy)
        local TextSource = p5.TextSource

        if TextSource ~= nil then
            TextSource = TextSource.UserId
        end

        if TextSource == Players.LocalPlayer.UserId and p5.Text == "/cmd" then
            CenturionUI.setVisible(not CenturionUI.isVisible())
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
        end
    end)
end

function self.onTick(_) -- line: 47
    -- upvalues: CenturionUI (copy), StarterGui (copy)
    local v3 = not CenturionUI.isVisible()

    if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat) ~= v3 then
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, v3)
    end
end

Reflect.defineMetadata(self, "identifier", "client/controllers/centurion-controller@CenturionController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    CenturionController = self
}

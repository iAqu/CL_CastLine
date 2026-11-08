-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Shared = script:WaitForChild("Shared")
local Util = require(Shared:WaitForChild("Util"))

if RunService:IsClient() == false then
    error("Server scripts cannot require the client library. Please require the server library to use Cmdr in your own code.")
end

local v2 = setmetatable({
    Enabled = true,
    MashToEnable = false,
    ActivationUnlocksMouse = false,
    HideOnLostFocus = true,
    PlaceName = "Cmdr",
    ReplicatedRoot = script,
    RemoteFunction = script:WaitForChild("CmdrFunction"),
    RemoteEvent = script:WaitForChild("CmdrEvent"),
    ActivationKeys = {},
    Util = Util,
    Events = {}
}, {
    __index = function(p1, p2) -- __index | line: 28
        local v1 = p1.Dispatcher[p2]

        if v1 and type(v1) == "function" then
            return function(_, ...) -- line: 31
                -- upvalues: p1 (copy), v1 (copy)
                return v1(p1.Dispatcher, ...)
            end
        end
    end
})

v2.Registry = require(Shared.Registry)(v2)
v2.Dispatcher = require(Shared.Dispatcher)(v2)

if StarterGui:WaitForChild("Cmdr") and wait() and LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Cmdr") == nil then
    StarterGui.Cmdr:Clone().Parent = LocalPlayer.PlayerGui
end

local v3 = require(script.CmdrInterface)(v2)

function v2.SetActivationKeys(p4, p5) -- line: 49
    -- upvalues: Util (copy)
    p4.ActivationKeys = Util.MakeDictionary(p5)
end

function v2.SetPlaceName(p6, p7) -- line: 54
    -- upvalues: v3 (copy)
    p6.PlaceName = p7
    v3.Window:UpdateLabel()
end

function v2.SetEnabled(p8, p9) -- line: 60
    p8.Enabled = p9
end

function v2.SetActivationUnlocksMouse(p10, p11) -- line: 65
    p10.ActivationUnlocksMouse = p11
end

function v2.Show(p12) -- line: 70
    -- upvalues: v3 (copy)
    if p12.Enabled then
        v3.Window:Show()
    end
end

function v2.Hide(_) -- line: 79
    -- upvalues: v3 (copy)
    v3.Window:Hide()
end

function v2.Toggle(p14) -- line: 84
    -- upvalues: v3 (copy)
    if not p14.Enabled then
        return p14:Hide()
    end

    v3.Window:SetVisible(not v3.Window:IsVisible())
end

function v2.SetMashToEnable(p15, p16) -- line: 93
    p15.MashToEnable = p16

    if p16 then
        p15:SetEnabled(false)
    end
end

function v2.SetHideOnLostFocus(p17, p18) -- line: 102
    p17.HideOnLostFocus = p18
end

function v2.HandleEvent(p19, p20, p21) -- line: 107
    p19.Events[p20] = p21
end

if RunService:IsServer() == false then
    v2.Registry:RegisterTypesIn(script:WaitForChild("Types"))
    v2.Registry:RegisterCommandsIn(script:WaitForChild("Commands"))
end

v2.RemoteEvent.OnClientEvent:Connect(function(p22, ...) -- line: 118
    -- upvalues: v2 (copy)
    if v2.Events[p22] then
        v2.Events[p22](...)
    end
end)
require(script.DefaultEventHandlers)(v2)

return v2

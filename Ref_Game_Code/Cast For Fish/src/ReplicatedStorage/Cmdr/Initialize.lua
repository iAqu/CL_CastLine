-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local CreateGui = require(script.Parent.CreateGui)

return function(p1) -- line: 6
    -- upvalues: ReplicatedStorage (copy), StarterGui (copy), CreateGui (copy)
    local CmdrClient

    local function Create(p2, p3, p4) -- line: 9
        -- upvalues: CmdrClient (ref)
        local v1 = Instance.new(p2)

        v1.Name = p3
        v1.Parent = p4 or CmdrClient

        return v1
    end

    CmdrClient = script.Parent.CmdrClient
    CmdrClient.Parent = ReplicatedStorage

    local RemoteFunction = Instance.new("RemoteFunction")

    RemoteFunction.Name = "CmdrFunction"
    RemoteFunction.Parent = CmdrClient

    local RemoteEvent = Instance.new("RemoteEvent")

    RemoteEvent.Name = "CmdrEvent"
    RemoteEvent.Parent = CmdrClient

    local Folder = Instance.new("Folder")

    Folder.Name = "Commands"
    Folder.Parent = CmdrClient

    local Folder2 = Instance.new("Folder")

    Folder2.Name = "Types"
    Folder2.Parent = CmdrClient
    script.Parent.Shared.Parent = CmdrClient
    p1.ReplicatedRoot = CmdrClient
    p1.RemoteFunction = RemoteFunction
    p1.RemoteEvent = RemoteEvent
    p1:RegisterTypesIn(script.Parent.BuiltInTypes)
    script.Parent.BuiltInTypes:Destroy()
    script.Parent.BuiltInCommands.Name = "Server commands"

    if StarterGui:FindFirstChild("Cmdr") == nil then
        CreateGui()
    end
end

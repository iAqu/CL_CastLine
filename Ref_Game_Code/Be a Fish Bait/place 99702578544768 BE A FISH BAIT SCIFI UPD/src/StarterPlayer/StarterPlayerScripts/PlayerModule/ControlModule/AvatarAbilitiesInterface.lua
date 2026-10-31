-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")

if not require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag("UserAllowAbilityControls") then
    return
end

local Players = game:GetService("Players")
local t1 = {}
local AbilityManagerActor, Humanoid
local BindableEvent = Instance.new("BindableEvent")
local connection
local v1 = false

local function characterAdded(p1) -- line: 16
    -- upvalues: AbilityManagerActor (ref), Humanoid (ref), BindableEvent (copy), connection (ref)
    AbilityManagerActor = nil
    Humanoid = nil

    if connection then
        connection:Disconnect()
        connection = nil
    end

    if not p1 then
        return
    end

    AbilityManagerActor = p1:FindFirstChild("AbilityManagerActor")
    Humanoid = p1:FindFirstChildOfClass("Humanoid")

    while not Humanoid do
        p1.ChildAdded:wait()
        Humanoid = p1:FindFirstChildOfClass("Humanoid")
    end

    BindableEvent:Fire()
    connection = Humanoid:GetPropertyChangedSignal("EvaluateStateMachine"):Connect(function() -- line: 33
        -- upvalues: BindableEvent (copy)
        BindableEvent:Fire()
    end)
end

local function lazyInit() -- line: 39
    -- upvalues: Players (copy), v1 (ref), characterAdded (copy)
    if v1 then
        return
    end

    v1 = true

    local LocalPlayer = Players.LocalPlayer

    if LocalPlayer then
        LocalPlayer.characterAdded:Connect(characterAdded)

        if LocalPlayer.Character then
            characterAdded(LocalPlayer.Character)
        end
    end
end

function t1.isEnabled() -- line: 54
    -- upvalues: Players (copy), AbilityManagerActor (ref), Humanoid (ref), v1 (ref), characterAdded (copy)
    if not v1 then
        v1 = true

        local LocalPlayer = Players.LocalPlayer

        if LocalPlayer then
            LocalPlayer.characterAdded:Connect(characterAdded)

            if LocalPlayer.Character then
                characterAdded(LocalPlayer.Character)
            end
        end
    end

    return AbilityManagerActor ~= nil and Humanoid and not Humanoid.EvaluateStateMachine
end

function t1.GetEnabledChangedSignal() -- line: 59
    -- upvalues: Players (copy), BindableEvent (copy), v1 (ref), characterAdded (copy)
    if v1 then
        return BindableEvent.Event
    end

    v1 = true

    local LocalPlayer = Players.LocalPlayer

    if LocalPlayer then
        LocalPlayer.characterAdded:Connect(characterAdded)

        if LocalPlayer.Character then
            characterAdded(LocalPlayer.Character)
        end
    end

    return BindableEvent.Event
end

return t1

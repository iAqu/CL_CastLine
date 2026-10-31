-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local t1 = {
    Functions = {
        "Throw_Start",
        "Throw_Resolve",
        "Throw_Complete",
        "Throw_Cancel",
        "Throw_UseSuper",
        "Training_Start",
        "Training_Stop",
        "Training_TapBonus",
        "Shop_Buy",
        "Shop_Equip",
        "Stand_Upgrade",
        "Plot_PlaceAnimal",
        "Plot_PickUpAnimal",
        "Plot_SellAnimal",
        "Player_SetThrowPower",
        "Plot_UpgradeFence",
        "Plot_EquipAnimal",
        "Plot_EquipBest",
        "Player_SetSetting",
        "Animations_Get",
        "Shop_Prompt",
        "Shop_ClaimFree",
        "Egg_Place",
        "Gift_Request",
        "Gift_Respond",
        "Gift_Cancel",
        "Offline_Claim",
        "Plot_SellAll",
        "Sell_Protected",
        "Dev_Action"
    },
    Events = {
        "Notify",
        "Effect",
        "Shop_Reward",
        "Shop_Announce",
        "Gift_Update",
        "Training_Bonus",
        "Throw_SuperGranted",
        "Shop_PromptClosed",
        "Shop_PackOffer",
        "Release_Seen",
        "Event_Asked"
    }
}

local function getFolder() -- line: 66
    -- upvalues: ReplicatedStorage (copy), RunService (copy)
    if not RunService:IsServer() then
        return ReplicatedStorage:WaitForChild("Remotes")
    end

    local Remotes = ReplicatedStorage:FindFirstChild("Remotes")

    if not Remotes then
        Remotes = Instance.new("Folder")
        Remotes.Name = "Remotes"
        Remotes.Parent = ReplicatedStorage
    end

    return Remotes
end

function t1.Init() -- line: 80
    -- upvalues: ReplicatedStorage (copy), RunService (copy), t1 (copy)
    local Remotes

    if RunService:IsServer() then
        Remotes = ReplicatedStorage:FindFirstChild("Remotes")

        if not Remotes then
            Remotes = Instance.new("Folder")
            Remotes.Name = "Remotes"
            Remotes.Parent = ReplicatedStorage
        end
    else
        Remotes = ReplicatedStorage:WaitForChild("Remotes")
    end

    for _, v1 in ipairs(t1.Functions) do
        if not Remotes:FindFirstChild(v1) then
            local RemoteFunction = Instance.new("RemoteFunction")

            RemoteFunction.Name = v1
            RemoteFunction.Parent = Remotes
        end
    end

    for _, v2 in ipairs(t1.Events) do
        if not Remotes:FindFirstChild(v2) then
            local RemoteEvent = Instance.new("RemoteEvent")

            RemoteEvent.Name = v2
            RemoteEvent.Parent = Remotes
        end
    end
end

function t1.Function(p1) -- line: 98
    -- upvalues: ReplicatedStorage (copy), RunService (copy)
    local Remotes

    if RunService:IsServer() then
        Remotes = ReplicatedStorage:FindFirstChild("Remotes")

        if not Remotes then
            Remotes = Instance.new("Folder")
            Remotes.Name = "Remotes"
            Remotes.Parent = ReplicatedStorage
        end
    else
        Remotes = ReplicatedStorage:WaitForChild("Remotes")
    end

    if RunService:IsServer() then
        return Remotes:FindFirstChild(p1)
    end

    return Remotes:WaitForChild(p1)
end

function t1.Event(p2) -- line: 106
    -- upvalues: t1 (copy)
    return t1.Function(p2)
end

function t1.Invoke(p3, ...) -- line: 111
    -- upvalues: t1 (copy)
    local v3 = t1.Function(p3)
    local InvokeServer = v3.InvokeServer
    local ok, result = pcall(InvokeServer, v3, ...)

    if ok then
        if type(result) == "table" then
            return result
        end

        return {
            Ok = false,
            Reason = "BadResponse"
        }
    end

    warn("[Remotes] " .. p3 .. " failed: " .. tostring(result))

    return {
        Ok = false,
        Reason = "Error"
    }
end

return t1

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local fishDataByName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish").fishDataByName
local t1 = {
    WSwordfish = {
        itemName = "WSwordfish",
        displayName = "W Swordfish",
        description = "MOUNT PERK: RIDE IN WATER!",
        hipHeight = 7,
        iconImageId = "rbxassetid://98224783354728",
        modelName = "Mount_WSwordfish",
        podiumFolderName = "Mount_WSwordFish",
        priceRobux = 899,
        previewStyle = "agile",
        productId = 3611261222,
        shopIconImageId = "rbxassetid://98224783354728",
        speedMultiplier = 1.5,
        jumpPowerMultiplier = 1,
        seatOffset = CFrame.new()
    },
    CookedWhale = {
        itemName = "CookedWhale",
        displayName = "Cooked Whale",
        description = "MOUNT PERK: RIDE IN WATER!",
        hipHeight = 7,
        iconImageId = "rbxassetid://79213338588051",
        modelName = "Mount_CookedWhale",
        podiumFolderName = "Mount_CookedWhale",
        priceRobux = 499,
        productId = 3611261288,
        previewStyle = "heavy",
        shopIconImageId = "rbxassetid://79213338588051",
        speedMultiplier = 1.3,
        jumpPowerMultiplier = 1,
        seatOffset = CFrame.new()
    }
}

return {
    mountFishReleased = true,
    getMountFishData = function(p1) -- getMountFishData | line: 40
        -- upvalues: t1 (copy)
        return t1[p1]
    end,
    getMountFishDataByPodiumFolderName = function(p2) -- getMountFishDataByPodiumFolderName | line: 44
        -- upvalues: t1 (copy)
        for _, v1 in t1 do
            if v1.podiumFolderName == p2 then
                return v1
            end
        end

        return nil
    end,
    findMountFishModel = function(p3) -- findMountFishModel | line: 52
        -- upvalues: ReplicatedStorage (copy), fishDataByName (copy), t1 (copy)
        local v2 = t1[p3]

        if v2 ~= nil then
            local MountableFish = ReplicatedStorage:FindFirstChild("MountableFish")

            if MountableFish ~= nil then
                MountableFish = MountableFish:FindFirstChild(v2.modelName)
            end

            if if MountableFish == nil then MountableFish else MountableFish:IsA("Model") then
                return MountableFish
            end

            local v3 = fishDataByName.CardboardFish or fishDataByName.cardboardFish

            if v3 ~= nil then
                v3 = v3.model
            end

            if if v3 == nil then v3 else v3:IsA("Model") then
                return v3
            end
        end

        return nil
    end,
    mountFishData = t1
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local ArrowPointer3D = require(ReplicatedStorage.Client.WorldFX.ArrowPointer3D)
local MonsterParasite = require(ReplicatedStorage.Data.MonsterParasite)
local Save = require(ReplicatedStorage.Shared.Save)
local LocalPlayer = Players.LocalPlayer
local v1, v2
local n1 = 0
local v3 = false

return {
    Start = function() -- Start | line: 25
        -- upvalues: Workspace (copy), ArrowPointer3D (copy), MonsterParasite (copy), Save (copy), LocalPlayer (copy), v1 (ref), v2 (ref), n1 (ref), v3 (ref)
        local function resolveTargetPart(p1) -- line: 26
            if p1:IsA("BasePart") then
                return p1
            end

            if not p1:IsA("Model") then
                return nil
            end

            if p1.PrimaryPart == nil then
                return p1:FindFirstChildWhichIsA("BasePart", true)
            end

            return p1.PrimaryPart
        end

        local function getCharacterRoot() -- line: 39
            -- upvalues: LocalPlayer (copy)
            local Character = LocalPlayer.Character

            if Character == nil then
                return nil
            end

            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

            return if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
        end

        local function findNearestMonsterPart(p2) -- line: 48
            -- upvalues: Workspace (copy), MonsterParasite (copy)
            local v4 = Workspace:FindFirstChild(MonsterParasite.WorldFolderName)

            if v4 == nil then
                return nil
            end

            local n2 = 1e999
            local v5

            for _, child in v4:GetChildren() do
                local v6 = if child:IsA("BasePart") then child
                    elseif not child:IsA("Model") then nil
                    elseif child.PrimaryPart ~= nil then child.PrimaryPart
                    else child:FindFirstChildWhichIsA("BasePart", true)

                if v6 ~= nil then
                    local Magnitude = (v6.Position - p2.Position).Magnitude

                    if Magnitude < n2 then
                        n2 = Magnitude
                        v5 = v6
                    end
                end
            end

            return v5
        end

        local function holdsParasiteEgg() -- line: 69
            -- upvalues: Save (copy)
            local v7 = Save.Await()
            local EggInventory = if v7 == nil then nil else v7.EggInventory

            if typeof(EggInventory) == "table" then
                for _, v8 in EggInventory do
                    if typeof(v8) == "table" and v8.HasParasite == true then
                        return true
                    end
                end
            end

            return false
        end

        local function hasNeverFed() -- line: 83
            -- upvalues: Save (copy)
            local v9 = Save.Await()
            local MonsterParasite = if v9 == nil then nil else v9.MonsterParasite

            if typeof(MonsterParasite) == "table" then
                return (MonsterParasite.TotalFeeds or 0) <= 0
            end

            return false
        end

        local function shouldGuide() -- line: 92
            -- upvalues: holdsParasiteEgg (copy), Save (copy)
            local v10 = Save.IsLoaded()

            if not v10 then
                return v10
            end

            local v11 = Save.Await()
            local MonsterParasite = if v11 == nil then nil else v11.MonsterParasite

            return typeof(MonsterParasite) == "table" and (MonsterParasite.TotalFeeds or 0) <= 0 and holdsParasiteEgg()
        end

        local function destroyArrow() -- line: 96
            -- upvalues: v1 (ref), v2 (ref)
            if v1 ~= nil then
                v1:Destroy()
                v1 = nil
            end

            v2 = nil
        end

        local function pointArrowAt(p3, p4) -- line: 104
            -- upvalues: ArrowPointer3D (copy), v1 (ref), v2 (ref)
            if v1 ~= nil and v2 == p3 then
                v1:PointFrom(p4)

                return
            end

            if v1 ~= nil then
                v1:Destroy()
                v1 = nil
            end

            v2 = nil

            local v12 = ArrowPointer3D.new(p3, p4)

            v12:Start()
            v1 = v12
            v2 = p3
        end

        local function runGuideLoop(p5) -- line: 117
            -- upvalues: findNearestMonsterPart (copy), holdsParasiteEgg (copy), ArrowPointer3D (copy), Save (copy), LocalPlayer (copy), v1 (ref), v2 (ref), n1 (ref), v3 (ref)
            while n1 == p5 do
                local v13 = Save.IsLoaded()

                if v13 then
                    local v14 = Save.Await()
                    local MonsterParasite = if v14 == nil then nil else v14.MonsterParasite

                    v13 = typeof(MonsterParasite) == "table" and (MonsterParasite.TotalFeeds or 0) <= 0 and holdsParasiteEgg()
                end

                if not v13 then
                    break
                end

                local Character = LocalPlayer.Character
                local HumanoidRootPart

                if Character ~= nil then
                    HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                    if HumanoidRootPart ~= nil and not HumanoidRootPart:IsA("BasePart") then
                        HumanoidRootPart = nil
                    end
                end

                local v15 = if HumanoidRootPart == nil then nil else findNearestMonsterPart(HumanoidRootPart)

                if HumanoidRootPart == nil or v15 == nil then
                    if v1 ~= nil then
                        v1:Destroy()
                        v1 = nil
                    end

                    v2 = nil
                else
                    local v16 = false

                    if v1 ~= nil then
                        if v2 == v15 then
                            v16 = true
                        elseif v1 ~= nil then
                            v1:Destroy()
                            v1 = nil
                        end
                    elseif v1 ~= nil then
                        v1:Destroy()
                        v1 = nil
                    end

                    if v16 then
                        v1:PointFrom(HumanoidRootPart)
                    else
                        v2 = nil

                        local v17 = ArrowPointer3D.new(v15, HumanoidRootPart)

                        v17:Start()
                        v1 = v17
                        v2 = v15
                    end
                end

                task.wait(0.25)
            end

            if n1 ~= p5 then
                return
            end

            v3 = false

            if v1 ~= nil then
                v1:Destroy()
                v1 = nil
            end

            v2 = nil
        end

        local function refresh() -- line: 135
            -- upvalues: holdsParasiteEgg (copy), runGuideLoop (copy), Save (copy), v1 (ref), v2 (ref), n1 (ref), v3 (ref)
            local v18 = Save.IsLoaded()

            if v18 then
                local v19 = Save.Await()
                local MonsterParasite = if v19 == nil then nil else v19.MonsterParasite

                v18 = typeof(MonsterParasite) == "table" and (MonsterParasite.TotalFeeds or 0) <= 0 and holdsParasiteEgg()
            end

            if v18 then
                if not v3 then
                    n1 += 1
                    v3 = true
                    task.spawn(runGuideLoop, n1)
                end
            else
                n1 += 1
                v3 = false

                if v1 ~= nil then
                    v1:Destroy()
                    v1 = nil
                end

                v2 = nil
            end
        end

        Save.WatchFields({ "EggInventory", "MonsterParasite" }, refresh)

        local v20 = Save.IsLoaded()

        if v20 then
            local v21 = Save.Await()
            local MonsterParasite = if v21 == nil then nil else v21.MonsterParasite

            v20 = typeof(MonsterParasite) == "table" and (MonsterParasite.TotalFeeds or 0) <= 0 and holdsParasiteEgg()
        end

        if v20 then
            if not v3 then
                n1 += 1
                v3 = true
                task.spawn(runGuideLoop, n1)
            end
        else
            n1 += 1
            v3 = false

            if v1 ~= nil then
                v1:Destroy()
                v1 = nil
            end

            v2 = nil
        end
    end
}

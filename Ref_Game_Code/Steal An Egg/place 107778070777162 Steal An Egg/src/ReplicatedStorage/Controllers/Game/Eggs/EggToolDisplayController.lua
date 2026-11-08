-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EggState = require(ReplicatedStorage.Client.EggState)
local EggToolDisplay = require(ReplicatedStorage.Shared.Eggs.EggToolDisplay)
local Log = require(ReplicatedStorage.Packages.Log)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Log.new()
local t1 = {}

return {
    Start = function() -- Start | line: 29
        -- upvalues: Players (copy), EggState (copy), EggToolDisplay (copy), Trove (copy), v1 (copy), t1 (copy)
        local function destroyActiveDisplay(p1) -- line: 34
            p1.ActiveDisplayVersion += 1

            if p1.ActiveDisplay ~= nil then
                p1.ActiveDisplay:Destroy()
                p1.ActiveDisplay = nil
            end

            p1.ActiveTool = nil
        end

        local function attachTool(p2, p3) -- line: 43
            -- upvalues: Players (copy), EggState (copy), EggToolDisplay (copy), v1 (copy)
            if p2.ActiveTool == p3 then
                return
            end

            p2.ActiveDisplayVersion += 1

            if p2.ActiveDisplay ~= nil then
                p2.ActiveDisplay:Destroy()
                p2.ActiveDisplay = nil
            end

            p2.ActiveTool = nil

            local v2 = EggToolDisplay.GetToolUid(p3)

            if v2 ~= nil then
                local v3 = EggState.ReadOwnedEgg(p2.Owner.UserId, v2)

                if v3 == nil and p2.Owner == Players.LocalPlayer then
                    v3 = EggState.FetchEggRecord(v2)
                end

                if v3 ~= nil then
                    p2.ActiveTool = p3
                    p2.ActiveDisplayVersion += 1

                    local ActiveDisplayVersion = p2.ActiveDisplayVersion
                    local v4 = EggToolDisplay.new(p3, {
                        OwnerUserId = p2.Owner.UserId,
                        UID = v2,
                        ModelName = ("%*_%*"):format(p2.Owner.UserId, v2),
                        Record = v3
                    })

                    if p2.ActiveTool == p3 and p2.ActiveDisplayVersion == ActiveDisplayVersion and p3.Parent ~= nil then
                        p2.ActiveDisplay = v4
                    else
                        v4:Destroy()
                    end
                else
                    v1:AtDebug():Log((("Egg tool %* has no record for owner %*"):format(p3:GetFullName(), p2.Owner.UserId)))
                end
            else
                v1:AtError():Log((("Egg tool %* is missing an egg UID"):format((p3:GetFullName()))))
            end
        end

        local function refreshActiveTool(p4) -- line: 88
            -- upvalues: attachTool (copy), EggToolDisplay (copy)
            local Character = p4.Owner.Character

            if Character ~= nil then
                for _, child in ipairs(Character:GetChildren()) do
                    if child.ClassName == "Tool" and EggToolDisplay.IsEggTool(child) then
                        attachTool(p4, child)

                        return
                    end
                end
            end
        end

        local function bindCharacter(p5, p6) -- line: 105
            -- upvalues: attachTool (copy), refreshActiveTool (copy), EggToolDisplay (copy), Trove (copy)
            if p5.CharacterTrove ~= nil then
                p5.CharacterTrove:Destroy()
            end

            p5.ActiveDisplayVersion += 1

            if p5.ActiveDisplay ~= nil then
                p5.ActiveDisplay:Destroy()
                p5.ActiveDisplay = nil
            end

            p5.ActiveTool = nil

            local v5 = Trove.new()

            p5.CharacterTrove = v5
            v5:Connect(p6.ChildAdded, function(p7) -- line: 113
                -- upvalues: p5 (copy), attachTool (copy), EggToolDisplay (copy)
                if p7.ClassName == "Tool" and EggToolDisplay.IsEggTool(p7) then
                    attachTool(p5, p7)
                end
            end)
            v5:Connect(p6.ChildRemoved, function(p8) -- line: 118
                -- upvalues: p5 (copy)
                if p8 ~= p5.ActiveTool then
                    return
                end

                p5.ActiveDisplayVersion += 1

                if p5.ActiveDisplay ~= nil then
                    p5.ActiveDisplay:Destroy()
                    p5.ActiveDisplay = nil
                end

                p5.ActiveTool = nil
            end)
            refreshActiveTool(p5)
        end

        local function syncActiveParasite(p9) -- line: 126
            -- upvalues: EggState (copy), EggToolDisplay (copy)
            local ActiveTool, ActiveDisplay = p9.ActiveTool, p9.ActiveDisplay

            if ActiveTool ~= nil and ActiveDisplay ~= nil then
                local v6 = EggToolDisplay.GetToolUid(ActiveTool)

                if v6 ~= nil then
                    local v7 = EggState.ReadOwnedEgg(p9.Owner.UserId, v6)

                    if v7 ~= nil then
                        ActiveDisplay:SyncParasite(v7.HasParasite)
                    end
                end
            end
        end

        local function destroyPlayerState(p10) -- line: 143
            -- upvalues: t1 (copy)
            local v8 = t1[p10]

            if v8 == nil then
                return
            end

            v8.ActiveDisplayVersion += 1

            if v8.ActiveDisplay ~= nil then
                v8.ActiveDisplay:Destroy()
                v8.ActiveDisplay = nil
            end

            v8.ActiveTool = nil

            if v8.CharacterTrove ~= nil then
                v8.CharacterTrove:Destroy()
            end

            v8.Trove:Destroy()
            t1[p10] = nil
        end

        local function trackPlayer(p11) -- line: 156
            -- upvalues: bindCharacter (copy), Trove (copy), t1 (copy)
            local v9 = t1[p11]

            if v9 ~= nil then
                v9.ActiveDisplayVersion += 1

                if v9.ActiveDisplay ~= nil then
                    v9.ActiveDisplay:Destroy()
                    v9.ActiveDisplay = nil
                end

                v9.ActiveTool = nil

                if v9.CharacterTrove ~= nil then
                    v9.CharacterTrove:Destroy()
                end

                v9.Trove:Destroy()
                t1[p11] = nil
            end

            local t3 = {
                CharacterTrove = nil,
                ActiveTool = nil,
                ActiveDisplay = nil,
                ActiveDisplayVersion = 0,
                Owner = p11,
                Trove = Trove.new()
            }

            t1[p11] = t3
            t3.Trove:Connect(p11.CharacterAdded, function(p12) -- line: 171
                -- upvalues: t3 (copy), bindCharacter (copy)
                bindCharacter(t3, p12)
            end)
            t3.Trove:Connect(p11.CharacterRemoving, function() -- line: 173
                -- upvalues: t3 (copy)
                t3.ActiveDisplayVersion += 1

                if t3.ActiveDisplay ~= nil then
                    t3.ActiveDisplay:Destroy()
                    t3.ActiveDisplay = nil
                end

                t3.ActiveTool = nil

                if t3.CharacterTrove ~= nil then
                    t3.CharacterTrove:Destroy()
                    t3.CharacterTrove = nil
                end
            end)

            if p11.Character ~= nil then
                bindCharacter(t3, p11.Character)
            end
        end

        Players.PlayerAdded:Connect(function(p13) -- line: 189
            -- upvalues: trackPlayer (copy)
            task.defer(trackPlayer, p13)
        end)
        Players.PlayerRemoving:Connect(destroyPlayerState)

        for _, player in ipairs(Players:GetPlayers()) do
            task.defer(trackPlayer, player)
        end

        EggState.OwnerRefreshed:Connect(function(p14) -- line: 199
            -- upvalues: syncActiveParasite (copy), Players (copy), EggState (copy), EggToolDisplay (copy), t1 (copy)
            for _, v10 in t1 do
                if v10.Owner.UserId == p14 then
                    if v10.Owner == Players.LocalPlayer then
                        task.defer(syncActiveParasite, v10)
                    else
                        local ActiveTool, ActiveDisplay = v10.ActiveTool, v10.ActiveDisplay

                        if ActiveTool ~= nil and ActiveDisplay ~= nil then
                            local v11 = EggToolDisplay.GetToolUid(ActiveTool)

                            if v11 ~= nil then
                                local v12 = EggState.ReadOwnedEgg(v10.Owner.UserId, v11)

                                if v12 ~= nil then
                                    ActiveDisplay:SyncParasite(v12.HasParasite)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
}

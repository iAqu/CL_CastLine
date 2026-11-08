-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = require(ReplicatedStorage.Shared.Player)
local TrappedBackpackLock = require(script.Parent.Parent.Parent.GUI.TrappedBackpackLock)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local v1 = Trove.new()
local v2 = false

return {
    Start = function() -- Start | line: 22
        -- upvalues: Player (copy), TrappedBackpackLock (copy), LocalPlayer (copy), v1 (copy), v2 (ref)
        local function unequipLocalTools() -- line: 27
            -- upvalues: Player (copy), LocalPlayer (copy)
            local v3 = Player.FindHumanoid(LocalPlayer)

            if v3 then
                v3:UnequipTools()
            end
        end

        local function setTrapBackpackLocked(p1) -- line: 34
            -- upvalues: Player (copy), TrappedBackpackLock (copy), LocalPlayer (copy), v2 (ref)
            if v2 == p1 then
                if p1 then
                    local v4 = Player.FindHumanoid(LocalPlayer)

                    if v4 then
                        v4:UnequipTools()
                    end
                end
            else
                v2 = p1

                if p1 then
                    TrappedBackpackLock.SetLocked(true)

                    local v5 = Player.FindHumanoid(LocalPlayer)

                    if v5 then
                        v5:UnequipTools()
                    end
                else
                    TrappedBackpackLock.SetLocked(false)
                end
            end
        end

        local function refreshCharacterTrapState(p2) -- line: 53
            -- upvalues: Player (copy), TrappedBackpackLock (copy), LocalPlayer (copy), v2 (ref)
            local v6 = p2:GetAttribute("IsTrapped") == true

            if v2 == v6 then
                if v6 then
                    local v7 = Player.FindHumanoid(LocalPlayer)

                    if v7 then
                        v7:UnequipTools()
                    end
                end
            else
                v2 = v6

                if v6 then
                    TrappedBackpackLock.SetLocked(true)

                    local v8 = Player.FindHumanoid(LocalPlayer)

                    if v8 then
                        v8:UnequipTools()
                    end
                else
                    TrappedBackpackLock.SetLocked(false)
                end
            end
        end

        local function bindCharacter(p3) -- line: 57
            -- upvalues: Player (copy), TrappedBackpackLock (copy), LocalPlayer (copy), v1 (copy), v2 (ref)
            v1:Clean()
            v1:Add(function() -- line: 60
                -- upvalues: TrappedBackpackLock (copy), v2 (ref)
                if v2 ~= false then
                    v2 = false
                    TrappedBackpackLock.SetLocked(false)
                end
            end)
            v1:Connect(p3:GetAttributeChangedSignal("IsTrapped"), function() -- line: 64
                -- upvalues: p3 (copy), Player (copy), TrappedBackpackLock (copy), LocalPlayer (copy), v2 (ref)
                local v9 = p3:GetAttribute("IsTrapped") == true

                if v2 == v9 then
                    if v9 then
                        local v10 = Player.FindHumanoid(LocalPlayer)

                        if v10 then
                            v10:UnequipTools()
                        end
                    end
                else
                    v2 = v9

                    if v9 then
                        TrappedBackpackLock.SetLocked(true)

                        local v11 = Player.FindHumanoid(LocalPlayer)

                        if v11 then
                            v11:UnequipTools()
                        end
                    else
                        TrappedBackpackLock.SetLocked(false)
                    end
                end
            end)
            v1:Connect(p3.ChildAdded, function(p4) -- line: 67
                -- upvalues: Player (copy), LocalPlayer (copy), v2 (ref)
                if v2 and p4:IsA("Tool") then
                    local v12 = Player.FindHumanoid(LocalPlayer)

                    if v12 then
                        v12:UnequipTools()
                    end
                end
            end)

            local v13 = p3:GetAttribute("IsTrapped") == true

            if v2 == v13 then
                if v13 then
                    local v14 = Player.FindHumanoid(LocalPlayer)

                    if v14 then
                        v14:UnequipTools()
                    end
                end
            else
                v2 = v13

                if v13 then
                    TrappedBackpackLock.SetLocked(true)

                    local v15 = Player.FindHumanoid(LocalPlayer)

                    if v15 then
                        v15:UnequipTools()
                    end
                else
                    TrappedBackpackLock.SetLocked(false)
                end
            end
        end

        LocalPlayer.CharacterAdded:Connect(bindCharacter)

        local v16 = Player.FindCharacter(LocalPlayer)

        if v16 then
            bindCharacter(v16)
        end
    end
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer

local function GetPlayerGui() -- line: 24
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

    while PlayerGui == nil do
        LocalPlayer.ChildAdded:Wait()
        PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    end

    return PlayerGui
end

local function IsShowing(p1, p2) -- line: 33
    while p1 ~= nil and p1 ~= p2 do
        if p1:GetAttribute("UIEffectsPaused") == true then
            return false
        end

        if p1:IsA("GuiObject") then
            if not p1.Visible then
                return false
            end
        elseif p1:IsA("LayerCollector") and not p1.Enabled then
            return false
        end

        p1 = p1.Parent
    end

    return p1 == p2
end

local function WatchAncestors(p3, p4, p5, p6) -- line: 51
    while p3 ~= nil and p3 ~= p4 do
        p5:Connect(p3:GetAttributeChangedSignal("UIEffectsPaused"), p6)

        if p3:IsA("GuiObject") then
            p5:Connect(p3:GetPropertyChangedSignal("Visible"), p6)
        elseif p3:IsA("LayerCollector") then
            p5:Connect(p3:GetPropertyChangedSignal("Enabled"), p6)
        end

        p3 = p3.Parent
    end
end

local function ObserveUITag(p7, p8) -- line: 74
    -- upvalues: Observers (copy), Trove (copy), GetPlayerGui (copy), IsShowing (copy), WatchAncestors (copy)
    local v3 = GetPlayerGui()
    local t1 = {
        v3
    }

    return Observers.observeTag(p7, function(p9) -- line: 77
        -- upvalues: p8 (copy), v3 (copy), Trove (copy), IsShowing (copy), WatchAncestors (copy)
        local v4 = Trove.new()
        local v5 = v4:Extend()
        local v6 = v4:Extend()
        local v7 = true
        local v8 = false

        local function refreshVisibility() -- line: 84
            -- upvalues: p9 (copy), v4 (copy), v6 (copy), v7 (ref), v8 (ref), p8 (copy), v3 (copy), IsShowing (copy)
            local v9 = v7 and IsShowing(p9, v3)

            if v9 ~= v8 then
                v8 = v9

                if v9 then
                    p8(p9, v6, v4)
                else
                    v6:Clean()
                end
            end
        end

        local function rewatchAncestors() -- line: 97
            -- upvalues: p9 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (ref), v8 (ref), refreshVisibility (copy), p8 (copy), v3 (copy), IsShowing (copy), WatchAncestors (copy)
            if not v7 then
                return
            end

            v5:Clean()
            WatchAncestors(p9, v3, v5, refreshVisibility)

            local v10 = v7 and IsShowing(p9, v3)

            if v10 ~= v8 then
                v8 = v10

                if v10 then
                    p8(p9, v6, v4)
                else
                    v6:Clean()
                end
            end
        end

        v4:Connect(p9.AncestryChanged, rewatchAncestors)

        if v7 then
            v5:Clean()
            WatchAncestors(p9, v3, v5, refreshVisibility)

            local v11 = v7 and IsShowing(p9, v3)

            if v11 ~= v8 then
                v8 = v11

                if v11 then
                    p8(p9, v6, v4)
                else
                    v6:Clean()
                end
            end
        end

        return function() -- line: 109
            -- upvalues: v4 (copy), v7 (ref)
            v7 = false
            v4:Destroy()
        end
    end, t1)
end

return ObserveUITag

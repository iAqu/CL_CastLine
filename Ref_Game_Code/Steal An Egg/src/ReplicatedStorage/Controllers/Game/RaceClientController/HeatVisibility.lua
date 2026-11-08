-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local MountRace = require(ReplicatedStorage.Data.MountRace)

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local t1 = {
    "BasePart",
    "Decal",
    "Texture",
    "ParticleEmitter",
    "Beam",
    "Trail",
    "Fire",
    "Smoke",
    "Sparkles"
}
local t2 = {
    "LayerCollector",
    "Highlight",
    "Light",
    "ProximityPrompt"
}
local t3 = {
    "BillboardGui",
    "SurfaceGui",
    "Highlight"
}

local function isAny(p1, p2) -- line: 50
    for _, v1 in p2 do
        if p1:IsA(v1) then
            return true
        end
    end

    return false
end

return {
    Run = function(p3, p4, p5) -- Run | line: 61
        -- upvalues: Players (copy), RunService (copy), Workspace (copy), MountRace (copy), LocalPlayer (copy), t1 (copy), t2 (copy), t3 (copy)
        local t5 = {}
        local t6 = {}
        local t7 = {}
        local t8 = {}

        local function force(p6, p7, p8) -- line: 67
            -- upvalues: t6 (copy)
            if t6[p6] ~= nil then
                if p6[p7] ~= p8 then
                    p6[p7] = p8
                end
            else
                local t9

                t9 = {
                    Property = p7,
                    Original = p6[p7],
                    Value = p8,
                    Connection = p6:GetPropertyChangedSignal(p7):Connect(function() -- line: 80
                        -- upvalues: p6 (copy), p7 (copy), p8 (copy), t9 (ref)
                        local v2 = p6[p7]

                        if v2 == p8 then
                            return
                        end

                        t9.Original = v2
                        p6[p7] = p8
                    end)
                }
                t6[p6] = t9
                p6[p7] = p8
            end
        end

        local function release(p9) -- line: 92
            -- upvalues: t5 (copy), t6 (copy)
            local v3 = t6[p9]

            if v3 ~= nil then
                t6[p9] = nil
                v3.Connection:Disconnect()

                if p9[v3.Property] == v3.Value then
                    p9[v3.Property] = v3.Original
                end
            end

            local v4 = t5[p9]

            if v4 ~= nil then
                t5[p9] = nil

                if p9.LocalTransparencyModifier == 1 then
                    p9.LocalTransparencyModifier = v4
                end
            end
        end

        local function conceal(p10) -- line: 112
            -- upvalues: t5 (copy), force (copy), t1 (copy), t2 (copy)
            local v5 = false
            local v6

            for _, v7 in t1 do
                if p10:IsA(v7) then
                    v6 = true
                    v5 = true
                    break
                end
            end

            if not v5 then
                v6 = false
            end

            if v6 then
                if t5[p10] == nil then
                    t5[p10] = p10.LocalTransparencyModifier
                end

                if p10.LocalTransparencyModifier ~= 1 then
                    p10.LocalTransparencyModifier = 1
                end
            else
                local v8 = false
                local v9

                for _, v10 in t2 do
                    if p10:IsA(v10) then
                        v9 = true
                        v8 = true
                        break
                    end
                end

                if not v8 then
                    v9 = false
                end

                if v9 then
                    force(p10, "Enabled", false)
                elseif p10:IsA("Sound") then
                    force(p10, "Volume", 0)
                else
                    if not p10:IsA("Humanoid") then
                        return false
                    end

                    force(p10, "DisplayDistanceType", Enum.HumanoidDisplayDistanceType.None)
                end
            end

            return true
        end

        local function concealInto(p11, p12) -- line: 135
            -- upvalues: conceal (copy)
            local ok, result = pcall(conceal, p12)

            if ok and result then
                p11.Items[p12] = true
            end
        end

        local function hide(p13) -- line: 142
            -- upvalues: t7 (copy), conceal (copy)
            if t7[p13] ~= nil then
                return
            end

            local t11

            t11 = {
                Items = {},
                Connection = p13.DescendantAdded:Connect(function(p14) -- line: 149
                    -- upvalues: t11 (ref), conceal (copy)
                    local t12 = t11
                    local ok, result = pcall(conceal, p14)

                    if ok and result then
                        t12.Items[p14] = true
                    end
                end)
            }
            t7[p13] = t11

            for _, descendant in p13:GetDescendants() do
                local t13 = t11
                local ok, result = pcall(conceal, descendant)

                if ok and result then
                    t13.Items[descendant] = true
                end
            end
        end

        local function show(p15) -- line: 159
            -- upvalues: t7 (copy), release (copy)
            local v11 = t7[p15]

            if v11 == nil then
                return
            end

            t7[p15] = nil
            v11.Connection:Disconnect()

            for v12 in v11.Items do
                pcall(release, v12)
            end
        end

        local function refresh(p16, p17) -- line: 171
            -- upvalues: release (copy), conceal (copy)
            for v13 in p17.Items do
                if not v13:IsDescendantOf(p16) then
                    p17.Items[v13] = nil
                    pcall(release, v13)
                end
            end

            for _, descendant in p16:GetDescendants() do
                local ok, result = pcall(conceal, descendant)

                if ok and result then
                    p17.Items[descendant] = true
                end
            end
        end

        local function wanted() -- line: 183
            -- upvalues: p4 (copy), p5 (copy), Players (copy), Workspace (copy), MountRace (copy), LocalPlayer (copy)
            local t14 = {}

            for _, player in Players:GetPlayers() do
                local Character = player.Character

                if player ~= LocalPlayer and Character ~= nil and Character.Parent ~= nil and MountRace.InOtherHeat(player, p4, p5) then
                    t14[Character] = true
                end
            end

            local RaceBots = Workspace:FindFirstChild("RaceBots")

            if RaceBots ~= nil then
                for _, child in RaceBots:GetChildren() do
                    if MountRace.InOtherHeat(child, p4, p5) then
                        t14[child] = true
                    end
                end
            end

            return t14
        end

        local function adornedRoot(p18) -- line: 207
            -- upvalues: t7 (copy)
            local Adornee = p18.Adornee

            if typeof(Adornee) == "Instance" then
                for v14 in t7 do
                    if Adornee == v14 or Adornee:IsDescendantOf(v14) then
                        return v14
                    end
                end
            end

            return nil
        end

        local function syncAdorned() -- line: 220
            -- upvalues: t6 (copy), t8 (copy), force (copy), release (copy), adornedRoot (copy)
            for v15 in t8 do
                if v15.Parent ~= nil then
                    if adornedRoot(v15) ~= nil then
                        pcall(force, v15, "Enabled", false)
                    elseif t6[v15] ~= nil then
                        pcall(release, v15)
                    end
                else
                    t8[v15] = nil
                    pcall(release, v15)
                end
            end
        end

        local function watchAdorned(p19) -- line: 233
            -- upvalues: p3 (copy), t8 (copy), t3 (copy)
            if p19 == nil then
                return
            end

            for _, descendant in p19:GetDescendants() do
                local v16 = false
                local v17

                for _, v18 in t3 do
                    if descendant:IsA(v18) then
                        v17 = true
                        v16 = true
                        break
                    end
                end

                if not v16 then
                    v17 = false
                end

                if v17 then
                    t8[descendant] = true
                end
            end

            p3:Connect(p19.DescendantAdded, function(p20) -- line: 242
                -- upvalues: t8 (copy), t3 (copy)
                local v19 = false
                local v20

                for _, v21 in t3 do
                    if p20:IsA(v21) then
                        v20 = true
                        v19 = true
                        break
                    end
                end

                if not v19 then
                    v20 = false
                end

                if v20 then
                    t8[p20] = true
                end
            end)
        end

        local function sync(p21) -- line: 249
            -- upvalues: t7 (copy), hide (copy), show (copy), refresh (copy), wanted (copy), syncAdorned (copy)
            local v22 = wanted()

            for v23 in t7 do
                if not v22[v23] then
                    show(v23)
                end
            end

            for v24 in v22 do
                local v25 = t7[v24]

                if v25 ~= nil then
                    if p21 then
                        refresh(v24, v25)
                    end
                else
                    hide(v24)
                end
            end

            syncAdorned()
        end

        p3:Add(function() -- line: 267
            -- upvalues: t5 (copy), t6 (copy), t7 (copy), t8 (copy), release (copy), show (copy)
            for v26 in t7 do
                show(v26)
            end

            for v27 in t6 do
                pcall(release, v27)
            end

            for v28 in t5 do
                pcall(release, v28)
            end

            table.clear(t8)
        end)
        watchAdorned(LocalPlayer:FindFirstChildOfClass("PlayerGui"))
        watchAdorned(Workspace.CurrentCamera)

        local n1 = 0
        local n2 = 0

        p3:Connect(RunService.Heartbeat, function(p22) -- line: 284
            -- upvalues: sync (copy), n1 (ref), n2 (ref)
            n1 += p22
            n2 += p22

            if n1 < 0.1 then
                return
            end

            n1 = 0

            local v29 = n2 >= 1

            if v29 then
                n2 = 0
            end

            local ok, result = pcall(sync, v29)

            if not ok then
                warn((("[HeatVisibility] %*"):format(result)))
            end
        end)
        pcall(sync, false)
    end
}

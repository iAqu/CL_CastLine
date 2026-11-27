-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local Format = require(ReplicatedStorage.Shared.Format)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local LocalPlayer = Players.LocalPlayer
local v1, v2
local t2 = {}
local t1 = {}

function t1.world() -- line: 26
    -- upvalues: Config (copy), LocalPlayer (copy)
    local v3 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if v3 then
        return (Config.worldAt(v3.Position))
    end

    return 1
end

function t1.firstBiome() -- line: 32
    -- upvalues: Config (copy), t1 (copy)
    return Config.Worlds[t1.world()].First
end

function t1.topBiome() -- line: 37
    -- upvalues: Config (copy), LocalPlayer (copy), t1 (copy)
    return Config.reachBiome(LocalPlayer:GetAttribute("Strength") or 0, t1.world())
end

function t1.fullThrow() -- line: 42
    -- upvalues: Config (copy), LocalPlayer (copy), t1 (copy)
    return Config.worldThrow(Config.reach(LocalPlayer:GetAttribute("Strength") or 0), t1.world())
end

function t1.current() -- line: 47
    -- upvalues: LocalPlayer (copy), t1 (copy), v2 (ref)
    local v4 = v2 or LocalPlayer:GetAttribute("ThrowCap") or 0

    if v4 > 0 and v4 < t1.topBiome() and t1.firstBiome() <= v4 then
        return v4
    end

    return 0
end

function t1.set(p1) -- line: 53
    -- upvalues: Remotes (copy), t1 (copy), v2 (ref)
    local v5 = if t1.topBiome() <= p1 then 0 else math.max(p1, 0)

    if v5 == t1.current() then
        return
    end

    v2 = v5
    Remotes.SetSetting:FireServer("ThrowCap", v5)
    t1.refresh()
end

function t1.onChanged(p2) -- line: 64
    -- upvalues: t2 (copy)
    table.insert(t2, p2)
end

function t1.refresh() -- line: 69
    -- upvalues: Config (copy), Format (copy), t1 (copy), v1 (ref), t2 (copy)
    if v1 then
        local v6 = t1.current()

        if v6 > 0 then
            v1.Text = ("🎣 Throw to <font color=\"#FFE15A\">%*</font>"):format(Config.Biomes[v6].Name) .. ("\n<font color=\"#C8D2E6\">%*m max</font>"):format((Format.short(Config.capMeters(v6))))
        else
            local v8 = t1.fullThrow()
            local v9 = Config.Worlds[t1.world()]
            local v10 = Config.nextBiome(v8)

            if v10 and v10.World ~= v9.Index then
                v10 = if v8 < v9.Start then Config.Biomes[v9.First] else nil
            end

            v1.Text = ("🎣 Throw <font color=\"#FFE15A\">%*m</font>"):format((Format.short((math.floor(v8))))) .. (if v10 then ("\n<font color=\"#C8D2E6\">%*m to %*</font>"):format(Format.short(v10.Start), v10.Name) else "")
        end
    end

    for _, v12 in t2 do
        task.spawn(v12)
    end
end

function t1.attach(p3) -- line: 93
    -- upvalues: v1 (ref)
    v1 = p3
end

function t1.init() -- line: 97
    -- upvalues: LocalPlayer (copy), t1 (copy), v2 (ref)
    LocalPlayer:GetAttributeChangedSignal("ThrowCap"):Connect(function() -- line: 98
        -- upvalues: LocalPlayer (copy), t1 (copy), v2 (ref)
        if LocalPlayer:GetAttribute("ThrowCap") == v2 then
            v2 = nil
        end

        t1.refresh()
    end)
    LocalPlayer:GetAttributeChangedSignal("Strength"):Connect(t1.refresh)
end

return t1

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Areas = require(ReplicatedStorage.Data.Areas)
local Audio = require(ReplicatedStorage.Shared.Audio)
local Lanes = require(script.Parent.Lanes)
local RiftEligibility = require(ReplicatedStorage.Shared.Util.RiftEligibility)
local Save = require(ReplicatedStorage.Shared.Save)
local t = require(ReplicatedStorage.Packages.t)
local RiftNotif = ReplicatedStorage.Assets.UI.Notifs.RiftNotif
local v1 = Color3.fromRGB(57, 255, 90)
local t1 = {
    0.95, 1.05
}
local v2 = t.interface({
    AreaId = t.optional(t.string),
    Seconds = t.optional(t.number),
    Color = t.optional(t.Color3),
    Sound = t.optional(t.union(t.string, t.number)),
    UniqueKey = t.optional(t.string),
    DelayInRound = t.optional(t.boolean)
})
local t2 = {}

local function compose(p1, p2) -- line: 46
    -- upvalues: Areas (copy), v1 (copy)
    local v3 = if p1 == nil or p1 == "" then nil else Areas.Directory[p1]

    if v3 == nil then
        return "A Rift has spawned!"
    end

    return (("A Rift has spawned in <font color=\"#%*\">%*</font>"):format((p2 or v3.Color or v1):ToHex(), v3.DisplayName))
end

local function playSprites(p3) -- line: 56
    local Main = p3:FindFirstChild("Main")

    if Main == nil then
        return
    end

    local t3 = {}

    for _, child in Main:GetChildren() do
        if child:IsA("ImageLabel") and child.Name == "Sprite" then
            table.insert(t3, child)
        end
    end

    if #t3 == 0 then
        return
    end

    local Cells = t3[1]:GetAttribute("Cells")
    local FPS = t3[1]:GetAttribute("FPS")

    if typeof(Cells) == "Vector2" and typeof(FPS) == "number" and not (FPS <= 0) then
        task.spawn(function() -- line: 78
            -- upvalues: p3 (copy), t3 (copy), Cells (copy), FPS (copy)
            local n1 = 0

            while p3.Parent ~= nil do
                local v4 = n1 % Cells.X
                local v6 = math.floor(n1 / Cells.X) % Cells.Y

                for _, v7 in t3 do
                    v7.ImageRectOffset = Vector2.new(v7.ImageRectSize.X * v4, v7.ImageRectSize.Y * v6)
                end

                n1 += 1
                task.wait(1 / FPS)
            end
        end)
    end
end

local function seesTheRift() -- line: 93
    -- upvalues: Players (copy), RiftEligibility (copy), Save (copy)
    local LocalPlayer = Players.LocalPlayer

    if LocalPlayer == nil then
        return false
    end

    local v8 = Save.Await()
    local v9 = if v8 == nil then 0 else v8.SpeedPower
    local v10 = if v8 == nil then 0 else v8.LastLogout

    return RiftEligibility.IsRevealed(LocalPlayer, v9, v10)
end

function t2.Show(p4) -- line: 105
    -- upvalues: Players (copy), Areas (copy), Audio (copy), Lanes (copy), RiftEligibility (copy), Save (copy), RiftNotif (copy), v1 (copy), t1 (copy), v2 (copy), playSprites (copy)
    local v11 = p4 or {}

    assert(v2(v11))

    local LocalPlayer = Players.LocalPlayer
    local v12 = false

    if LocalPlayer ~= nil then
        local v13 = Save.Await()
        local v14 = if v13 == nil then 0 else v13.SpeedPower
        local v15 = if v13 == nil then 0 else v13.LastLogout

        v12 = RiftEligibility.IsRevealed(LocalPlayer, v14, v15)
    end

    if not v12 then
        return
    end

    local clone = RiftNotif:Clone()
    local Content = clone:FindFirstChild("Main"):FindFirstChild("Content")
    local AreaId, Color = v11.AreaId, v11.Color
    local v16 = if AreaId == nil or AreaId == "" then nil else Areas.Directory[AreaId]

    if v16 ~= nil then
        Content.Text = ("A Rift has spawned in <font color=\"#%*\">%*</font>"):format((Color or v16.Color or v1):ToHex(), v16.DisplayName)
    else
        Content.Text = "A Rift has spawned!"
    end

    Lanes.Schedule({
        Lane = "Banner",
        Frame = clone,
        Seconds = v11.Seconds or 6,
        UniqueKey = v11.UniqueKey or "RiftSpawn",
        DelayInRound = v11.DelayInRound,
        OnShown = function(p5) -- OnShown | line: 124
            -- upvalues: v11 (copy), Audio (copy), t1 (copy), playSprites (copy)
            Audio.Play(v11.Sound or "rbxassetid://133842042346471", script, {
                Volume = 0.7,
                PlaybackSpeed = t1
            })
            playSprites(p5)
        end
    })
end

return table.freeze(t2)

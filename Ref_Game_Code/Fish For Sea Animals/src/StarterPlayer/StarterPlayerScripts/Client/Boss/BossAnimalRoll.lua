-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local Animals = require(ReplicatedStorage.Shared.Animals)
local AnimalModel = require(ReplicatedStorage.Shared.AnimalModel)
local Format = require(ReplicatedStorage.Shared.Format)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Viewport = require(script.Parent.Parent.UI.Viewport)
local RarityText = require(script.Parent.Parent.UI.RarityText)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local v1 = Color3.new(0, 0, 0)
local t1 = {}

t1.HEIGHT = 430

local function card(p1, p2, p3) -- line: 23
    -- upvalues: AnimalModel (copy), Viewport (copy), v1 (copy)
    local v2 = AnimalModel.clone(p2, 12, p3)

    if not v2 then
        return nil
    end

    local ViewportFrame = Instance.new("ViewportFrame")

    ViewportFrame.BackgroundTransparency = 1
    ViewportFrame.AnchorPoint = Vector2.new(0.5, 0)
    ViewportFrame.Position = UDim2.new(0.5, 0, 0, 40)
    ViewportFrame.Size = UDim2.fromOffset(330, 280)
    ViewportFrame.ImageColor3 = v1
    ViewportFrame.Ambient = Color3.fromRGB(200, 200, 200)
    ViewportFrame.LightColor = Color3.new(1, 1, 1)
    ViewportFrame.ZIndex = 6
    ViewportFrame.Visible = false
    ViewportFrame.Parent = p1

    for _, descendant in v2:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") or descendant:IsA("Light") or descendant:IsA("BillboardGui") then
            descendant:Destroy()
        end
    end

    Viewport.show(ViewportFrame, v2, 70, 1.05)

    return ViewportFrame
end

function t1.build(p4, p5, p6) -- line: 49
    -- upvalues: Config (copy), Animals (copy), Format (copy), UIUtil (copy), RarityText (copy), Kit (copy), t1 (copy), card (copy)
    local v3 = type(p6) == "table" and Animals.get(p6.Id)

    if v3 then
        local v4 = Kit.frame(p4, {
            Name = "AnimalRoll",
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, p5),
            Size = UDim2.fromOffset(600, t1.HEIGHT)
        })

        v4.Visible = false

        local v5 = Kit.text(v4, "🎲 BONUS ANIMAL...", {
            StrokeThickness = 3,
            ZIndex = 6,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 0),
            Size = UDim2.new(1, 0, 0, 40),
            TextColor3 = Color3.new(1, 1, 1)
        })
        local v6 = Kit.text(v4, "", {
            StrokeThickness = 4,
            ZIndex = 7,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 326),
            Size = UDim2.new(1, 0, 0, 56),
            TextColor3 = Color3.new(1, 1, 1)
        })
        local v7 = Kit.text(v4, "", {
            StrokeThickness = 3,
            ZIndex = 7,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 384),
            Size = UDim2.new(1, 0, 0, 36),
            TextColor3 = Color3.fromRGB(255, 225, 90)
        })

        v6.Visible = false
        v7.Visible = false

        local v8 = card(v4, v3.Id, p6.Mutation)

        if v8 then
            local t2 = {}

            for _, v9 in Animals.ByBiome[p6.Biome or v3.Biome] or {} do
                if v9.Id ~= v3.Id then
                    table.insert(t2, v9.Id)
                end
            end

            local t3 = {}

            while #t2 > 0 and #t3 < 9 do
                local v10 = card(v4, table.remove(t2, math.random(1, #t2)))

                if v10 then
                    table.insert(t3, v10)
                end
            end

            return function() -- line: 81
                -- upvalues: p6 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), t3 (copy), Config (copy), Animals (copy), Format (copy), UIUtil (copy), RarityText (copy), Kit (copy)
                v4.Visible = true
                UIUtil.pop(v5, 0.5)

                local v11

                local function showOnly(p7) -- line: 86
                    -- upvalues: v11 (ref)
                    if v11 then
                        v11.Visible = false
                    end

                    v11 = p7
                    p7.Visible = true
                end

                local v12 = if #t3 > 0 then 22 else 0
                local v13

                for i = 1, v12 do
                    local v14 = i / v12
                    local v15

                    repeat
                        v15 = t3[math.random(1, #t3)]
                    until v15 ~= v13 or #t3 == 1

                    v13 = v15

                    if v11 then
                        v11.Visible = false
                    end

                    v11 = v15
                    v15.Visible = true
                    UIUtil.sound("Click", 0.5, v14 * 0.6 + 0.8)
                    task.wait(v14 * v14 * 0.32 + 0.05)
                end

                if v11 then
                    v11.Visible = false
                end

                v11 = v8
                v8.Visible = true
                UIUtil.sound("LuckHeartbeat", 0.9, 1, 1.4)
                Kit.shake(v8, 8, 0.4)
                task.wait(0.7)

                local v16 = Kit.frame(v4, {
                    BackgroundTransparency = 0,
                    ZIndex = 9,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Size = UDim2.fromScale(1, 1)
                })

                UIUtil.tween(v16, 0.5, {
                    BackgroundTransparency = 1
                })
                task.delay(0.6, function() -- line: 113
                    -- upvalues: v16 (copy)
                    v16:Destroy()
                end)
                UIUtil.tween(v8, 0.35, {
                    ImageColor3 = Color3.new(1, 1, 1)
                })
                UIUtil.sound("Luck4", 1, 1)
                UIUtil.sound("BossGotAnimal", 0.9, 1.1, 10)
                Kit.burst(v4, Vector2.new(300, 180), Color3.fromRGB(255, 225, 90), 26, 300)
                v5.Text = "🎉 BONUS ANIMAL!"

                local v17 = Config.RarityByName[v3.Rarity]

                v6.Text = ("%* %*"):format(string.upper(v3.Rarity), (Animals.displayName({
                    Id = v3.Id,
                    Mutation = p6.Mutation,
                    Size = p6.Size
                })))

                if v17 then
                    RarityText.apply(v6, v17)
                end

                v7.Text = ("1 in %*"):format((Format.short(p6.Odds or Animals.odds(v3.Id))))
                v6.Visible = true
                v7.Visible = true
                UIUtil.pop(v6, 1.4)
                UIUtil.pop(v7, 1.3)
                task.wait(0.6)
            end
        end

        v4:Destroy()
    end

    return nil
end

return t1

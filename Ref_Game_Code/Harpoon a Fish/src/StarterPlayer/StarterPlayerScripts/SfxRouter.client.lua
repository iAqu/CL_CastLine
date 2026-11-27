-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local SoundGroup = Instance.new("SoundGroup")

SoundGroup.Name = "SFX"
SoundGroup.Volume = 1
SoundGroup.Parent = SoundService

local function apply() -- line: 20
    -- upvalues: LocalPlayer (copy), SoundGroup (copy)
    local SetSfx = LocalPlayer:GetAttribute("SetSfx")

    if type(SetSfx) ~= "number" or not SetSfx then
        SetSfx = 0.5
    end

    SoundGroup.Volume = 2 * SetSfx
end

local SetSfx = LocalPlayer:GetAttribute("SetSfx")

if type(SetSfx) ~= "number" or not SetSfx then
    SetSfx = 0.5
end

SoundGroup.Volume = 2 * SetSfx
LocalPlayer:GetAttributeChangedSignal("SetSfx"):Connect(apply)

local function claim(p1) -- line: 27
    -- upvalues: SoundService (copy), SoundGroup (copy)
    if p1:IsA("Sound") then
        if p1.SoundGroup == nil and not p1:GetAttribute("Music") then
            p1.SoundGroup = SoundGroup
        end
    elseif p1:IsA("SoundGroup") and p1 ~= SoundGroup and p1.Parent == SoundService then
        p1.Parent = SoundGroup
    end
end

game.DescendantAdded:Connect(claim)

for _, descendant in ipairs(game:GetDescendants()) do
    pcall(claim, descendant)
end

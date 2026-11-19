local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local Constants = require(ReplicatedStorage.Modules.Constants)

local SoundHelper = {}

local MAX_SAME_SOUND = 20

function SoundHelper.PlaySound(sound: Sound, parentPart: Instance?, delay: number?, maxSameSound: number?, randomPitch: boolean?, pitchOctave: number?)
    if not sound then warn ("Sound", sound, "was not found.") return end

    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No player data found!") return end
    if playerData.Settings[Constants.SETTINGS_ID.SOUND] == false then return end

    randomPitch = randomPitch or false

    -- parentPart = parentPart or Workspace
    if not parentPart then
        if not Workspace:FindFirstChild("TempSounds") then
            local tempSounds = Instance.new("Folder", Workspace)
            tempSounds.Name = "TempSounds"
        end
        parentPart = Workspace.TempSounds
    end

    local soundNum = 0
    for _, v in pairs(parentPart:GetChildren()) do
        if v.Name == sound.Name then
            soundNum = soundNum + 1
        end
    end

    maxSameSound = maxSameSound or MAX_SAME_SOUND
    if soundNum >= maxSameSound then
        return
    end

    local soundClone = sound:Clone()
    soundClone.Parent = parentPart

    if type(pitchOctave) == "number" then
        local pitchShiftSoundEffect = soundClone:FindFirstChild("PitchShiftSoundEffect")
        if not pitchShiftSoundEffect or not pitchShiftSoundEffect:IsA("PitchShiftSoundEffect") then
            if pitchShiftSoundEffect then
                pitchShiftSoundEffect:Destroy()
            end
            pitchShiftSoundEffect = Instance.new("PitchShiftSoundEffect")
            pitchShiftSoundEffect.Name = "PitchShiftSoundEffect"
            pitchShiftSoundEffect.Parent = soundClone
        end
        pitchShiftSoundEffect.Octave = pitchOctave
        pitchShiftSoundEffect.Enabled = true
    elseif randomPitch then
        local pitchShiftSoundEffect = soundClone:FindFirstChild("PitchShiftSoundEffect")
        if not pitchShiftSoundEffect then
            pitchShiftSoundEffect = Instance.new("PitchShiftSoundEffect", soundClone)
            pitchShiftSoundEffect.Name = "PitchShiftSoundEffect"
        end
        -- pitchShiftSoundEffect.Octave = math.random(0.95, 1.1)
        pitchShiftSoundEffect.Octave = math.random(95, 105) / 100
        pitchShiftSoundEffect.Parent = soundClone
        pitchShiftSoundEffect.Enabled = true
    end

    -- task.wait(delay or 0)
    task.delay(delay or 0, function()
        if not soundClone.Parent then return end
        soundClone.Ended:Once(function()
            soundClone:Destroy()
        end)
        soundClone:Play()
    end)
    return soundClone
end

function SoundHelper.PlayRandomSoundInFolder(folder: Folder, parentPart: Part?, delay: number?, maxSameSound: number?)
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No player data found!") return end
    if playerData.Settings[Constants.SETTINGS_ID.SOUND] == false then return end

    if not folder then warn ("Folder", folder, "was not found.") return end

    local randomSound = folder:GetChildren()[math.random(1, #folder:GetChildren())]
    if not randomSound then warn ("No random sound found in folder", folder.Name) return end

    SoundHelper.PlaySound(randomSound, parentPart, delay, maxSameSound)
end

function SoundHelper.StopSound(sound: Sound, parentPart: Part?)
    if not sound then warn ("Sound", sound, "was not found."); return end

    -- parentPart = parentPart or Workspace
    if not parentPart then
        if not Workspace:FindFirstChild("TempSounds") then return end

        parentPart = Workspace.TempSounds
    end

    if not parentPart then warn("No parentPart found!"); return end

    for _, v in pairs(parentPart:GetChildren()) do
        if v.Name == sound.Name then
            v:Stop()
            v:Destroy()
        end
    end
end
-- 
return SoundHelper

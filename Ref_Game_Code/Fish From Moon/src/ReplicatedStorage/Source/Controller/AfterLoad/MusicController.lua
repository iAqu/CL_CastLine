local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local BgmGroup = SoundService.BgmGroup
local EffectGroup = SoundService.EffectGroup

local Knit = require(ReplicatedStorage.Packages.Knit)

---GUI
local SettingMenu = player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.SettingMenu
----点On从On变Off
-----背景音乐开关
local OnBgm=SettingMenu.Menu.Container.ScrollingFrame.Bgm.On
local OffBgm=SettingMenu.Menu.Container.ScrollingFrame.Bgm.Off
-----音效开关
local OnEffect=SettingMenu.Menu.Container.ScrollingFrame.Effect.On
local OffEffect=SettingMenu.Menu.Container.ScrollingFrame.Effect.Off

local MusicController = Knit.CreateController { Name = "MusicController" }

function MusicController:OnToOffBgm()
	BgmGroup.Volume = 0

	OnBgm.Visible=false
	OffBgm.Visible = true
end
function MusicController:OffToOnBgm()
	BgmGroup.Volume = 1

	OnBgm.Visible=true
	OffBgm.Visible = false
end
function MusicController:OnToOffEff()
	EffectGroup.Volume = 0

	OnEffect.Visible = false
	OffEffect.Visible = true
end
function MusicController:OffToOnEff()
	EffectGroup.Volume = 1

	OnEffect.Visible = true
	OffEffect.Visible = false
end

function MusicController:KnitInit()
end

function MusicController:KnitStart()
end

return MusicController

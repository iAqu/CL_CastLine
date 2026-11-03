-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local WeatherService_Client = require(ReplicatedStorage.Modules.ServicesLoader.WeatherService_Client)
local MusicController = require(ReplicatedStorage.Modules.ControllerLoader.MusicController)
local GameHandler = require(ReplicatedStorage.Modules.HandlerLoader.GameHandler)
local t = {}
local t2 = {
	Disco = true,
	Stadium = true
}
function UpdateSong() --[[ UpdateSong | Line: 21 | Upvalues: MusicController (copy), GameHandler (copy), t2 (copy), SoundService (copy), WeatherService_Client (copy) ]]
	local _ = MusicController.Name
	if GameHandler.Status == "Tsunami" then
		if not t2[MusicController.Name] then
			MusicController:ChangePlaylist({ SoundService.TsunamiMusic }, "Tsunami")
		end
	else
		local v1 = nil
		for k in pairs(WeatherService_Client.Events) do
			if SoundService:FindFirstChild(k) then
				v1 = k
			else
				continue
			end
			break
		end
		if v1 then
			MusicController:ChangePlaylist(SoundService[v1]:GetChildren(), v1)
		else
			MusicController:ChangePlaylist(SoundService.MainTheme:GetChildren(), "Main")
		end
	end
end
function PlaylistChanged(p1) --[[ PlaylistChanged | Line: 49 | Upvalues: SoundService (copy) ]]
	if p1 ~= "Tsunami" then
		SoundService.Scratch.TimePosition = 0.3
		SoundService.Scratch:Resume()
	end
end
function t._init(p1) --[[ _init | Line: 60 | Upvalues: WeatherService_Client (copy), GameHandler (copy), MusicController (copy) ]]
	UpdateSong()
	WeatherService_Client.WeatherAdded:Connect(UpdateSong)
	WeatherService_Client.WeatherRemoved:Connect(UpdateSong)
	GameHandler.StatusChanged:Connect(UpdateSong)
	MusicController.Changed:Connect(PlaylistChanged)
	MusicController.CustomChanged:Connect(UpdateSong)
end
return t
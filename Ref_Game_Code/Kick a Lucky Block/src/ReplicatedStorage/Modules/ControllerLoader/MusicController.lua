-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local t = {
	Muted = false,
	Playlist = {},
	Changed = Signal.new(),
	MuteChanged = Signal.new(),
	CustomChanged = Signal.new()
}
local v1 = Trove.new()
local v2 = 0
local v3 = nil
function PlayNextSong() --[[ PlayNextSong | Line: 24 | Upvalues: v2 (ref), t (copy), v3 (ref), v1 (copy) ]]
	v2 = v2 + 1
	v2 = (v2 - 1) % #t.Playlist + 1
	local v12 = t.Playlist[v2]
	if v12 then
		v12:Play()
		v12.Volume = if t.Muted then 0 else 0.2
		v3 = v12
		v1:Add(v12.Ended:Once(PlayNextSong))
	end
end
function PlaylistChanged() --[[ PlaylistChanged | Line: 37 | Upvalues: v2 (ref), v1 (copy), v3 (ref) ]]
	v2 = 0
	v1:Clean()
	if v3 then
		v3:Stop()
		v3 = nil
	end
	PlayNextSong()
end
function t.ChangePlaylist(p1, p2, p3) --[[ ChangePlaylist | Line: 49 ]]
	if not p1.Custom and p1.Name ~= p3 then
		p1.Name = p3
		p1.Playlist = p2
		p1.Changed:Fire(p3)
	end
end
function t.StartCustom(p1) --[[ StartCustom | Line: 63 | Upvalues: v3 (ref), t (copy) ]]
	p1.Custom = true
	p1.Name = nil
	p1.Playlist = nil
	return function(p1, p2) --[[ ForceSong | Line: 69 | Upvalues: v3 (ref), t (ref) ]]
		if v3 then
			v3:Stop()
			v3 = nil
		end
		if p1 then
			v3 = p1
			p1.Volume = if t.Muted then 0 else 0.2
			if p2 then
				p1.TimePosition = p2
				p1:Resume()
			else
				p1:Play()
			end
		end
	end, function() --[[ EndCustom | Line: 90 | Upvalues: p1 (copy) ]]
		p1.Custom = false
		p1.CustomChanged:Fire()
	end
end
function t.Toggle(p1) --[[ Toggle | Line: 98 | Upvalues: v3 (ref) ]]
	p1.Muted = not p1.Muted
	p1.MuteChanged:Fire(p1.Muted)
	if v3 then
		v3.Volume = if p1.Muted then 0 else 0.2
	end
end
function t._init(p1) --[[ _init | Line: 109 ]]
	p1.Changed:Connect(PlaylistChanged)
end
return t
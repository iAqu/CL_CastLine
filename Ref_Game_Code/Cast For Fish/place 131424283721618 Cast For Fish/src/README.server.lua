--[[
		Thank you for using UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

		!! GETHIDDENPROPERTY ISSUES !!
		Your executor's gethiddenproperty couldn't read these types, so data may be missing or wrong.
		Tell your executor's developers. Affected types:
				Failed reads: ["boolean"]

		!! FILE WRITER ISSUES !!
		Your executor's file functions can't store data faithfully, so a binary save would be CORRUPT - this save used XML (.rbxlx) instead.
		Tell your executor's developers.

		You saved as XML, not Binary (rbxl). To convert: FILE -> Save to File As, name it .rbxl. This keeps the binary format and preserves properties ignored by IgnoreDefaultProperties.

		ServerStorage, ServerScriptService and Server Scripts are IMPOSSIBLE to save because of FilteringEnabled.

		Images, meshes, textures, sounds etc. failed to load or look invisible? Those assets are private. Try https://github.com/kartFr/Asset-Reuploader or similar.

		Player doesn't spawn? Move or delete the scripts in StarterPlayer, then run game:GetService("Players").CharacterAutoLoads = true
		Use "Play Here" instead of "Play" to spawn where your Camera is.

		GUI missing from StarterGui? Save again with IsolatePlayers = true, then check Players/<LocalPlayer>/PlayerGui.

		Chat broken? Delete everything in TextChatService/Chat, or run game:GetService("Chat"):ClearAllChildren() game:GetService("TextChatService"):ClearAllChildren()

		Union/MeshPart collisions broken? Run this in the Studio Command Bar:


		local C = game:GetService("CoreGui")
		local E = Enum.CollisionFidelity:GetEnumItems()
		local O = {}

		for _, v in game:GetDescendants() do
			if v:IsA("TriangleMeshPart") and not v:IsDescendantOf(C) then
				local c = v.CollisionFidelity
				O[v] = c
				v.CollisionFidelity = E[1] ~= c and E[1] or E[2]
			end
		end

		for v, c in O do
			v.CollisionFidelity = c
		end
		print("Done")

		Camera stuck? Run this in the Studio Command Bar:

		workspace.CurrentCamera.CameraType = Enum.CameraType.Fixed

		Or destroy the Camera.

		Settings:
		{"SavePlayerCharacters":false,"CompressionLevel":9,"Callback":false,"ShowStatus":true,"IgnoreDefaultPlayerScripts":false,"NilInstancesFixes":{"BaseWrap":null,"Animator":null,"Attachment":null,"PackageLink":null,"AdPortal":null},"IgnoreList":["CoreGui","CorePackages"],"__DEBUG_MODE":false,"KillAllScripts":true,"DecompileJobless":false,"Binary":false,"Decompile":true,"OptionsAliasesInverse":{"SkipScripts":"Decompile","DisableCompression":"CompressionMode","NullifyScripts":"Decompile","noscripts":"Decompile","NoDecompile":"Decompile","Overwrite":"AvoidFileOverwrite","XML":"Binary","RemovePlayers":"IsolatePlayers","RemovePlayerCharacters":"SavePlayerCharacters"},"IgnoreNotArchivable":true,"OptionsAliases":{"DecompilerTimeout":"DecompileTimeout","Path":"FilePath","SavePlayersData":"IsolatePlayers","ClassIgnoreList":"IgnoreList","Blacklist":"IgnoreList","IgnoreRobloxPlayerScripts":"IgnoreDefaultPlayerScripts","EmbedBytecode":"SaveBytecode","ScriptDecompile":"Decompile","StatusText":"ShowStatus","NoXML":"Binary","Compress":"CompressionMode","IgnoreInstances":"IgnoreList","AnonymousMode":"Anonymous","SaveStarterPlayer":"IsolateStarterPlayer","Compression":"CompressionMode","Decompiler":"Decompile","IgnoreClasses":"IgnoreList","SaveModel":"Object","DecompileScripts":"Decompile","Progress":"ShowStatus","IgnoreProperty":"IgnoreProperties","timeout":"DecompileTimeout","Verbose":"__DEBUG_MODE","IgnoreArchivable":"IgnoreNotArchivable","Status":"ShowStatus","SaveScripts":"Decompile","Clipboard":"CopyToClipboard","InstancesBlacklist":"IgnoreList","IsolatePlayerGui":"IsolateLocalPlayer","UseDecompiler":"Decompile","SavePlayers":"IsolatePlayers","SaveCharacters":"SavePlayerCharacters","IgnoreDefaultProps":"IgnoreDefaultProperties","Debug":"__DEBUG_MODE","SaveNonCreatable":"SaveNotCreatable","Root":"Object","SaveNilInstances":"NilInstances","FileName":"FilePath","Model":"Object","SaveLocalPlayer":"IsolateLocalPlayer","SavePlayerGui":"IsolateLocalPlayer","SaveAsBinary":"Binary","InstanceIgnoreList":"IgnoreList","Players":"IsolatePlayers","SaveNil":"NilInstances","LocalPlayer":"IsolateLocalPlayer","ShowProgress":"ShowStatus"},"RecoverScriptsFromAssets":true,"DecompileIgnore":["TextChatService"],"MaxDepth":1000,"BoostFPS":true,"IsModel":false,"NilInstances":false,"ShutdownWhenDone":false,"TreatUnionsAsParts":false,"RiskyServicesDisabled":{"Reflection":false,"Encoding":false,"UGC":true},"ExtraInstances":[],"IsolateStarterPlayer":false,"ReadMe":true,"NotCreatableFixes":["","AdvancedDragger","AnimationTrack","Dragger","Player","PlayerGui","PlayerMouse","PlayerScripts","ScreenshotHud","StudioData","TextChatMessage","TextSource","TouchTransmitter","Translator"],"IgnoreProperties":[],"SharedBinaryStrings":false,"IsolatePlayers":false,"DecompileTimeout":10,"IsolateLocalPlayerCharacter":false,"AlternativeWritefile":true,"mode":"optimized","SaveCacheInterval":56320,"IgnoreSpecialProperties":false,"SourceCache":false,"BytecodeTimeout":3,"FilePath":false,"CompressionMode":"zstd","Anonymous":false,"Object":false,"IgnoreDefaultProperties":true,"IgnorePropertiesOfNotScriptsOnScriptsMode":false,"AvoidFileOverwrite":true,"SaveNotCreatable":false,"IsolateLocalPlayer":false,"SafeMode":true,"AntiIdle":true,"CopyToClipboard":false,"SaveBytecode":false,"scriptcache":true}

		Elapsed time: 187.836104 seconds                         
		Date (UTC): 26 November 2026 06:19:58 PlaceId: 131424283721618 PlaceVersion: 63 Client Version: 0.748.0.7481526 Platform: Windows Executor: WRD v2.0.0
]]
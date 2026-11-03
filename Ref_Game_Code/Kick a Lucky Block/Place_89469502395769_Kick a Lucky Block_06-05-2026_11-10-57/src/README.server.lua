--[[
		Thank you for using UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw.

		If you didn't save in Binary (rbxl) - it's recommended to save the game right away to take advantage of the binary format & to preserve values of certain properties if you used IgnoreDefaultProperties setting (as they might change in the future).
		You can do that by going to FILE -> Save to File As -> Make sure File Name ends with .rbxl -> Save

		ServerStorage, ServerScriptService and Server Scripts are IMPOSSIBLE to save because of FilteringEnabled.

		If your player cannot spawn into the game, please move the scripts in StarterPlayer somewhere else or delete them. Then run `game:GetService("Players").CharacterAutoLoads = true`.
		And use "Play Here" to start game instead of "Play" to spawn your Character where your Camera currently is.

		If the chat system does not work, please use the explorer and delete everything inside the TextChatService/Chat service(s). 
		Or run `game:GetService("Chat"):ClearAllChildren() game:GetService("TextChatService"):ClearAllChildren()`
				
		If Union and MeshPart collisions don't work, run the script below in the Studio Command Bar:
				
				
		local C = game:GetService("CoreGui")
		local D = Enum.CollisionFidelity.Default
				
		for _, v in game:GetDescendants() do
			if v:IsA("TriangleMeshPart") and not v:IsDescendantOf(C) then
				v.CollisionFidelity = D
			end
		end
		print("Done")
				
		If you can't move the Camera, run this script in the Studio Command Bar:
			
		workspace.CurrentCamera.CameraType = Enum.CameraType.Fixed
		
		Or Destroy the Camera.

		This file was generated with the following settings:
		{"SavePlayerCharacters":false,"SaveBytecode":false,"Callback":false,"ShowStatus":true,"IgnoreDefaultPlayerScripts":true,"NilInstancesFixes":{"BaseWrap":null,"Animator":null,"Attachment":null,"PackageLink":null,"AdPortal":null},"IgnoreList":["CoreGui","CorePackages"],"__DEBUG_MODE":false,"KillAllScripts":true,"DecompileJobless":false,"Decompile":true,"IgnoreNotArchivable":true,"Object":null,"DecompileIgnore":["Chat","CoreGui","CorePackages",null,null,null,null,null,null],"IgnoreSpecialProperties":false,"BoostFPS":true,"IsModel":false,"NilInstances":true,"ExtraInstances":[],"ReadMe":true,"OptionsAliasesInverse":{"noscripts":"Decompile","RemovePlayers":"IsolatePlayers","RemovePlayerCharacters":"SavePlayerCharacters"},"OptionsAliases":{"IgnoreDefaultProps":"IgnoreDefaultProperties","timeout":"DecompileTimeout","FileName":"FilePath","SaveCharacters":"SavePlayerCharacters","IgnoreArchivable":"IgnoreNotArchivable","SavePlayers":"IsolatePlayers","SaveLocalPlayer":"IsolateLocalPlayer","InstancesBlacklist":"IgnoreList","IsolatePlayerGui":"IsolateLocalPlayer","SaveNonCreatable":"SaveNotCreatable","SavePlayerGui":"IsolateLocalPlayer"},"SharedStringOverwrite":false,"scriptcache":true,"TreatUnionsAsParts":false,"AlternativeWritefile":false,"mode":"full","SaveCacheInterval":56320,"IgnoreSharedStrings":true,"IsolatePlayers":true,"NotCreatableFixes":["","AdvancedDragger","AnimationTrack","Dragger","Player","PlayerGui","PlayerMouse","PlayerMouse","PlayerScripts","ScreenshotHud","StudioData","TextChatMessage","TextSource","TouchTransmitter","Translator"],"FilePath":"Place_89469502395769_Kick a Lucky Block_06-05-2026_11-10-57","IgnoreDefaultProperties":true,"Anonymous":false,"IsolateStarterPlayer":true,"IsolateLocalPlayerCharacter":false,"IgnorePropertiesOfNotScriptsOnScriptsMode":false,"AvoidFileOverwrite":true,"SaveNotCreatable":false,"IsolateLocalPlayer":false,"ShutdownWhenDone":false,"AntiIdle":true,"SafeMode":true,"IgnoreProperties":[],"DecompileTimeout":10}

		Elapsed time: 482.9520193999633 Date (UTC): 6 May 2026 03:19:02 PlaceId: 89469502395769 PlaceVersion: 463 Client Version: 0.719.0.7191339 Platform: Windows Executor: Xeno v1.3.35
]]
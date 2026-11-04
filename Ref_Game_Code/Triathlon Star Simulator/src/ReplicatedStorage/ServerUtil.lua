-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:11
-- Luau version 6, Types version 3
-- Time taken: 0.001077 seconds

return {
	ReplicatedStorage = game:GetService("ReplicatedStorage");
	ServerStorage = game:GetService("ServerStorage");
	Debris = game:GetService("Debris");
	Players = game:GetService("Players");
	RunService = game:GetService("RunService");
	TeleportService = game:GetService("TeleportService");
	UserInputService = game:GetService("UserInputService");
	SoundService = game:GetService("SoundService");
	GamepadService = game:GetService("GamepadService");
	TextChatService = game:GetService("TextChatService");
	TweenService = game:GetService("TweenService");
	CollectionService = game:GetService("CollectionService");
	ScriptContext = game:GetService("ScriptContext");
	HttpService = game:GetService("HttpService");
	ContentProvider = game:GetService("ContentProvider");
	Tool = game.ReplicatedStorage.Tool;
	InsMgr = require(game.ReplicatedStorage.Tool.InsMgr);
	Copy = require(game.ReplicatedStorage.Tool.Copy);
	EnumMgr = require(game.ReplicatedStorage.Tool.EnumMgr);
	AnimationModule = require(game.ReplicatedStorage.Tool.AnimationModule);
	AddListen = require(game.ReplicatedStorage.Tool.AddListen);
	VisibleMgr = require(game.ReplicatedStorage.Tool.VisibleMgr);
	PhsicUtil = require(game.ReplicatedStorage["特效表现工具"].BeatBackEffect);
	ChangeEnvironment = require(game.ReplicatedStorage["特效表现工具"]["环境变化"]);
	CfgFind = require(game.ReplicatedStorage.Tool.CfgFind);
	Log = require(game.ReplicatedStorage.Tool.Log);
	EffectUtil = require(game.ReplicatedStorage.Tool.EffectUtil);
	GetData = require(game.ReplicatedStorage.Tool.GetData);
	MathMgr = require(game.ReplicatedStorage.Tool.MathMgr);
	TipsModule = require(game.ReplicatedStorage.Tool.TipsModule);
	TranslationHelper = require(game.ReplicatedStorage.Tool.TranslationHelper);
	SoundModule = require(game.ReplicatedStorage.Tool.SoundModule);
	CheckGamePass = require(game.ReplicatedStorage.Tool.CheckGamePass);
	UpdateUI = require(game.ReplicatedStorage.Tool["服务器刷新UI"]);
}
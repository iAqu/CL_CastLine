local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local TweenService = game:GetService('TweenService')
local StarterGui = game:GetService("StarterGui")
local CollectionService = game:GetService("CollectionService")
local Debris = game:GetService("Debris")

local localAttachTemplates = {}

local Knit = require(ReplicatedStorage.Packages.Knit)

local localPlayer = Players.LocalPlayer

local templateRegistry = {}     -- {templateName: LocalScript}

local LocalScriptAttachController = Knit.CreateController {
    Name = "LocalScriptAttachController",
}


local function registerTemplate()

    for _, template in pairs(ReplicatedStorage.LocalAttachTemplate:GetChildren()) do
        if template:IsA("LocalScript") and not localAttachTemplates[template.Name] then
            localAttachTemplates[template.Name] = template
        end
    end
end

local function applyAttachScript(taggedInstance)
    -- 只处理 workspace 或 Players 下的实例
	if not (workspace:IsAncestorOf(taggedInstance) or game.Players:IsAncestorOf(taggedInstance)) then
		return
	end
	
	local templateName = taggedInstance.Name
	
    local templateScript = localAttachTemplates[templateName]
    if not templateScript then
        warn("Template not found: "..templateName)
        return
    end

	local playerScriptsFolder = localPlayer:WaitForChild("PlayerScripts")
	local RuntimeLocalScriptsFolder = nil
	if playerScriptsFolder:FindFirstChild("RuntimeLocalScripts") then
		RuntimeLocalScriptsFolder = playerScriptsFolder:FindFirstChild("RuntimeLocalScripts")
	else
		RuntimeLocalScriptsFolder = Instance.new("Folder")
		RuntimeLocalScriptsFolder.Name = "RuntimeLocalScripts"
		RuntimeLocalScriptsFolder.Parent = playerScriptsFolder
	end

	-- local RuntimeLocalScriptsFolder = localPlayer:WaitForChild("PlayerScripts"):FindFirstChild("RuntimeLocalScripts")

	-- if not RuntimeLocalScriptsFolder then
	-- 	-- warn("RuntimeLocalScriptsFolder not found!")
	-- 	return
	-- end

	-- 从注册表中获取模板并克隆
	local clonedScript = templateScript:Clone()
	clonedScript.Name = templateName
	-- clonedScript.Disabled = true
	-- clonedScript.Enabled = false
    -- clonedScript.Parent = taggedInstance.Parent
	-- clonedScript.Parent = RuntimeLocalSriptsFolder

	-- 创建目标引用
	local targetObject = Instance.new("ObjectValue")
	targetObject.Name = "Target"
	targetObject.Value = taggedInstance.Parent
	targetObject.Parent = clonedScript

	-- clonedScript.Enabled = true
	
	clonedScript.Parent = RuntimeLocalScriptsFolder
	-- clonedScript.Disabled = false

	-- 创建链接引用
	local linkObject = Instance.new("ObjectValue")
	linkObject.Name = "LS_LINK"
	linkObject.Value = clonedScript
	linkObject.Parent = taggedInstance
	
	-- 监听实例的祖先变化
	local ancestryConnection
	ancestryConnection = taggedInstance.AncestryChanged:Connect(function()
		if game:IsAncestorOf(taggedInstance) then
			-- 仍在游戏树中，继续
		else
			-- 已从游戏树中移除，清理
			linkObject:Destroy()
			local debrisTime = clonedScript:GetAttribute("Debris")
			if debrisTime then
				clonedScript:SetAttribute("InDebris", true)
				Debris:AddItem(clonedScript, debrisTime)
			else
				clonedScript:Destroy()
			end
			ancestryConnection:Disconnect()
			ancestryConnection = nil
		end
	end)
end

local function removeAttachScript(taggedInstance)
	local linkObject = taggedInstance:FindFirstChild("LS_LINK")
	if not linkObject then return end

	local clonedScript = linkObject.Value
	if clonedScript and clonedScript.Parent then
		local debrisTime = clonedScript:GetAttribute("Debris")
		if debrisTime then
			clonedScript:SetAttribute("InDebris", true)
			Debris:AddItem(clonedScript, debrisTime)
			return
		end
		clonedScript:Destroy()
	end
end

function LocalScriptAttachController:Init()

    
end

function LocalScriptAttachController:KnitStart()
    registerTemplate()

    -- 处理已存在的标记实例
    for _, taggedInstance in pairs(CollectionService:GetTagged("LocalScriptAttach")) do
        task.spawn(applyAttachScript, taggedInstance)
    end

    -- 监听新添加的标记实例
    CollectionService:GetInstanceAddedSignal("LocalScriptAttach"):Connect(applyAttachScript)
	CollectionService:GetInstanceRemovedSignal("LocalScriptAttach"):Connect(removeAttachScript)
end

return LocalScriptAttachController

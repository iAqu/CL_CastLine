--!strict
-- ZoneSign / SkinSign 切换时的白色高亮过渡，完整复刻 skin 切换（SkinTransitionController）的
-- 多阶段序列：旧牌白入 → 全白停留 → 新白剪影渐显 → 旧白淡出 → 新牌从白色淡回固有色 + 音效。
--
-- 与 skin 切换的差异：两块牌子模型同时存在，服务端只切换部件 Transparency（不销毁/新建模型），
-- 且 LocalTransparencyModifier 无法把已透明（Transparency=1）的旧牌变回可见，
-- 所以过渡期间本地直接写 Transparency 接管旧牌显隐，收尾时恢复成服务端的最终状态。

local Constants = require(script.Parent.Constants)
local SoundHelper = require(script.Parent.SoundHelper)
local WhiteFlashOverlayUtil = require(script.Parent.WhiteFlashOverlayUtil)

-- 时序对齐 SkinTransitionController / SkinService：
-- 白色 Highlight 渐入时长。
local FADE_IN = 0.25
-- 全白停留：skin 流程为 (SKIN_COVER_DELAY 0.35 - FADE_IN 0.25) + OLD_WHITE_HOLD 0.1。
local COVER_HOLD = 0.2
-- 新白剪影渐显时长：期间旧白保持全白，画面只会「长出」新轮廓。
local NEW_WHITE_FADE_IN = 0.25
-- 新白全显后旧白淡出的时长。
local OLD_FADE_OUT = 0.12
-- 新牌从全白淡回固有色的时长。
local FADE_OUT = 0.4

local SignSwitchTransitionUtil = {}

export type Callbacks = {
	-- 全白盖住、旧牌已本地隐藏时触发（此时应关掉旧牌 SurfaceGui）。
	onCovered: (() -> ())?,
	-- 新牌恢复可见（仍被全白 Highlight 盖住）时触发（此时应打开新牌 SurfaceGui）。
	onReveal: (() -> ())?,
	onComplete: (() -> ())?,
}

type TransitionState = {
	-- 旧牌上的白色 Highlight：渐入阶段的主体。
	oldHighlight: WhiteFlashOverlayUtil.HighlightOverlay?,
	-- 全白后创建的旧牌 Neon 克隆：盖住旧牌隐藏与新白渐显的全过程。
	cloneOverlay: WhiteFlashOverlayUtil.Overlay?,
	-- 新牌的白色 Neon 克隆：渐显阶段的主体（新牌本体此时仍本地隐藏）。
	newCloneOverlay: WhiteFlashOverlayUtil.Overlay?,
	-- 新牌上的白色 Highlight：收尾时无缝接管白色画面，再淡出露出固有色。
	newHighlight: WhiteFlashOverlayUtil.HighlightOverlay?,
	-- 渐显期间被本地隐藏（LocalTransparencyModifier）的新牌部件。
	hiddenNewParts: { BasePart }?,
	-- 过渡开始时被本地强制显示（Transparency=0）的旧牌元素，全白后恢复为 1。
	shownOldInstances: { Instance }?,
	callbacks: Callbacks,
}

local activeTransitions: { [Instance]: TransitionState } = {}

-- 本地把旧牌强制显示（服务端可能已把它切成透明），返回被改动的元素列表。
-- 与服务端 setSignModelVisible 覆盖同一批元素：BasePart / Decal / Texture。
local function forceSignVisibleLocally(model: Model): { Instance }
	local shown: { Instance } = {}
	for _, descendant in model:GetDescendants() do
		if descendant:IsA("BasePart") or descendant:IsA("Decal") or descendant:IsA("Texture") then
			descendant.Transparency = 0
			table.insert(shown, descendant)
		end
	end
	return shown
end

-- 把旧牌恢复成服务端的最终状态（隐藏）。
local function restoreOldSignHidden(state: TransitionState)
	if not state.shownOldInstances then
		return
	end
	for _, instance in state.shownOldInstances do
		if instance.Parent then
			(instance :: any).Transparency = 1
		end
	end
	state.shownOldInstances = nil
end

local function restoreNewSignVisible(state: TransitionState)
	if state.hiddenNewParts then
		WhiteFlashOverlayUtil.ShowModel(state.hiddenNewParts)
		state.hiddenNewParts = nil
	end
end

local function destroyVisuals(state: TransitionState)
	if state.oldHighlight then
		state.oldHighlight:Destroy()
		state.oldHighlight = nil
	end
	if state.cloneOverlay then
		state.cloneOverlay:Destroy()
		state.cloneOverlay = nil
	end
	if state.newCloneOverlay then
		state.newCloneOverlay:Destroy()
		state.newCloneOverlay = nil
	end
	if state.newHighlight then
		state.newHighlight:Destroy()
		state.newHighlight = nil
	end
end

-- 中断/收尾统一出口：把两块牌子都恢复成服务端最终状态，清掉所有白色覆盖。
local function completeTransition(zone: Instance, state: TransitionState)
	restoreOldSignHidden(state)
	restoreNewSignVisible(state)
	destroyVisuals(state)

	if activeTransitions[zone] == state then
		activeTransitions[zone] = nil
	end

	if state.callbacks.onComplete then
		state.callbacks.onComplete()
	end
end

-- 收尾：同帧完成「挂全白 Highlight → 恢复新牌可见 → 移除白色剪影克隆」，
-- 白色画面无缝切到实体新牌上，再淡出露出固有色。
local function finishReveal(zone: Instance, state: TransitionState, newSign: Model)
	if state.cloneOverlay then
		state.cloneOverlay:Destroy()
		state.cloneOverlay = nil
	end
	if state.oldHighlight then
		state.oldHighlight:Destroy()
		state.oldHighlight = nil
	end

	if not state.newHighlight and newSign.Parent then
		local newHighlight = WhiteFlashOverlayUtil.CreateHighlight(newSign)
		if newHighlight then
			newHighlight:SetTransparency(0)
			state.newHighlight = newHighlight
		end
	end

	restoreNewSignVisible(state)
	if state.callbacks.onReveal then
		state.callbacks.onReveal()
	end

	if state.newCloneOverlay then
		state.newCloneOverlay:Destroy()
		state.newCloneOverlay = nil
	end

	if state.newHighlight then
		state.newHighlight:FadeOut(FADE_OUT, function()
			if activeTransitions[zone] ~= state then
				return
			end
			completeTransition(zone, state)
		end)
	else
		completeTransition(zone, state)
	end
end

-- 全白已盖住：旧牌真正隐藏（恢复服务端状态），全白停留后新白剪影渐显，随后旧白淡出。
local function runCoveredPhase(zone: Instance, state: TransitionState, oldSign: Model, newSign: Model)
	-- 旧白克隆独立于旧牌本体，接管白色画面；旧牌本体随即恢复隐藏。
	if oldSign.Parent then
		local cloneOverlay = WhiteFlashOverlayUtil.Create(oldSign)
		if cloneOverlay then
			cloneOverlay:SetTransparency(0)
			state.cloneOverlay = cloneOverlay
		end
	end

	restoreOldSignHidden(state)
	if state.oldHighlight then
		state.oldHighlight:Destroy()
		state.oldHighlight = nil
	end
	if state.callbacks.onCovered then
		state.callbacks.onCovered()
	end

	task.delay(COVER_HOLD, function()
		if activeTransitions[zone] ~= state then
			return
		end
		if not newSign.Parent then
			completeTransition(zone, state)
			return
		end

		local newCloneOverlay = WhiteFlashOverlayUtil.Create(newSign)
		if not newCloneOverlay then
			finishReveal(zone, state, newSign)
			return
		end
		state.newCloneOverlay = newCloneOverlay
		newCloneOverlay:SetTransparency(1)

		newCloneOverlay:FadeIn(NEW_WHITE_FADE_IN, function()
			if activeTransitions[zone] ~= state then
				return
			end

			-- 新白已完全盖住，旧白这时才淡出消失。
			local oldOverlay = state.cloneOverlay
			if oldOverlay then
				oldOverlay:FadeOut(OLD_FADE_OUT, function()
					if activeTransitions[zone] ~= state then
						return
					end
					finishReveal(zone, state, newSign)
				end)
			else
				finishReveal(zone, state, newSign)
			end
		end)
	end)
end

function SignSwitchTransitionUtil.Play(zone: Instance, oldSign: Model, newSign: Model, callbacks: Callbacks?)
	local existing = activeTransitions[zone]
	if existing then
		completeTransition(zone, existing)
	end

	-- 地块牌子开始白入时立即播放切换音效，避免等到新牌显现后才有反馈。
	SoundHelper.PlaySound(Constants.SoundRes.GUI_FUSE_SUCCESS)

	local state: TransitionState = {
		oldHighlight = nil,
		cloneOverlay = nil,
		newCloneOverlay = nil,
		newHighlight = nil,
		hiddenNewParts = WhiteFlashOverlayUtil.HideModelLocally(newSign),
		shownOldInstances = forceSignVisibleLocally(oldSign),
		callbacks = callbacks or {},
	}
	activeTransitions[zone] = state

	-- 用 Highlight 渐白：直接作用在旧牌模型上，与 skin 切换的渐入阶段一致。
	local oldHighlight = WhiteFlashOverlayUtil.CreateHighlight(oldSign)
	if not oldHighlight then
		runCoveredPhase(zone, state, oldSign, newSign)
		return
	end

	state.oldHighlight = oldHighlight
	oldHighlight:FadeIn(FADE_IN, function()
		if activeTransitions[zone] ~= state then
			return
		end
		if not oldSign.Parent or not newSign.Parent then
			completeTransition(zone, state)
			return
		end
		runCoveredPhase(zone, state, oldSign, newSign)
	end)
end

return SignSwitchTransitionUtil

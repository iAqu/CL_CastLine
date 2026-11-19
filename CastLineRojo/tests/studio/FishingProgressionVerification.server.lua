-- Temporary Studio-only bootstrap: copy into ServerScriptService via Rojo, then remove after testing.
local RunService = game:GetService("RunService")
if not RunService:IsStudio() then return end
local HttpService = game:GetService("HttpService")
local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local Knit = require(RS.Packages.Knit)
local deadline = os.clock() + 50
local pd, player, original
repeat
 local ok, result = pcall(Knit.GetService, "PlayerDataService")
 if ok then pd = result end
 player = Players:GetPlayers()[1]
 original = pd and player and pd:GetProfile(player)
 if not original then task.wait(0.25) end
until original or os.clock() > deadline
local function report(result)
 workspace:SetAttribute("FishingProgressionVerification", HttpService:JSONEncode(result))
end
if not original then report({ok=false,error="Timed out waiting for the live server profile"}); return end
local function copy(value)
 if type(value) ~= "table" then return value end
 local result = {}; for k,v in pairs(value) do result[k] = copy(v) end
 return result
end
local P = require(RS.Modules.FishingProgression)
local A = require(RS.Modules.FishingAssets)
local F = require(game.ReplicatedFirst.Data.FishesData)
local R = require(game.ReplicatedFirst.Data.RodsData)
local Config = require(RS.Modules.FishingConfig)
local service = Knit.GetService("FishingService")
local grant = require(SSS.Services.ItemGrantUtil)
local originalGrant = grant.Grant
local plot = Knit.GetService("PlotSlotService"):GetPlayerPlot(player)
local spot = plot and plot:FindFirstChild("FishingStartPart", true)
local character = player.Character
local root = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not spot or not root or not humanoid then report({ok=false,error="Missing live fishing spot or character"}); return end
local oldPivot = character:GetPivot()
local existingTools = {}; for _,v in player.Backpack:GetChildren() do existingTools[v] = true end
local isolated = {Data=copy(original.Data),MetaData={SessionLoadCount=2},IsActive=function() return true end}
isolated.Data.Wins=100000
isolated.Data.Items={}; isolated.Data.PlotPlacements={}; isolated.Data.IndexDiscoveryLog={}; isolated.Data.NewItemTagSeenLog={}
isolated.Data.EquippedRodId="Rod_101"; isolated.Data.OwnedRods={Rod_101=true,Rod_102=true}
isolated.Data.FishingProgress=P.Ensure({})
local recordedDebit
local client=service.Client
local token
local checks={}
local function check(value, name) assert(value,name); table.insert(checks,name) end
local function begin(baitId)
 character:PivotTo(spot.CFrame + Vector3.new(0,spot.Size.Y/2+humanoid.HipHeight+root.Size.Y/2,0))
 root.AssemblyLinearVelocity=Vector3.zero
 local b=client:Begin(player); check(b.ok,"begin "..baitId); token=b.token
 local s=client:SelectBait(player,token,baitId); check(s.ok,"select "..baitId)
 local c=client:Cast(player,token,1); check(c.ok,"cast")
 local presentation=Config.GetCastProfile("GODLIKE")
 task.wait(presentation.LeadTime+presentation.ReleaseTime+2)
 local r=client:NextRound(player,token,0); check(r.ok,"schedule real bite")
 return r
end
local function hook(r)
 local biteEnds=r.retryAt-Config.Bite.EscapeTime
 task.wait(math.max(0,biteEnds-0.12-workspace:GetServerTimeNow()))
 isolated.Data.Wins=100000 -- Eliminate unrelated background income before the atomic debit.
 return client:Hook(player,token,r.round,workspace:GetServerTimeNow())
end
local ok,err=xpcall(function()
 pd._Profiles[player]=isolated
 grant.Grant=function(who,id,options)
  local commit=options.OnCommitted
  options.OnCommitted=function()
   local before=isolated.Data.Wins
   commit()
   recordedDebit=before-isolated.Data.Wins
  end
  return originalGrant(who,id,options)
 end
 local count=0
 for _,rod in pairs(R) do
  local pool=P.BuildPool(F,rod,R,A.GetFish)
  check(#pool>=9,"populated "..rod.RodID)
  for _,entry in ipairs(pool) do assert(entry.fish.Rarity==rod.Rarity) end
  count+=1
 end
 check(count==27,"all 27 rods")
 local r=begin("NONE")
 check(F[r.fishId].Rarity=="Common","strict rarity")
 client:Cancel(player,token)
 begin("Bait_102")
 check(isolated.Data.FishingProgress.Rods.Rod_101.Pending==nil,"re-enter with cash bait and no stored catch")
 local beforeCancel=isolated.Data.Wins
 client:Cancel(player,token)
 check(isolated.Data.Wins==beforeCancel and isolated.Data.FishingProgress.Count==0,"cancel leaves cash and catch count intact")
 local cashRound=begin("Bait_104")
 local result=hook(cashRound)
 check(result.ok and result.mutationId~=nil,"actual item grant with paid mutation")
 check(recordedDebit==20 and isolated.Data.FishingProgress.Count==1,"atomic payment and progress: "..tostring(isolated.Data.Wins).." / "..tostring(isolated.Data.FishingProgress.Count))
 check(not client:Hook(player,token,cashRound.round,workspace:GetServerTimeNow()).ok,"duplicate hook rejected")
 client:Cancel(player,token)
 local progress=isolated.Data.FishingProgress
 P.GrantReceipt(progress,"Rod_101","isolated-verification-receipt")
 local rainbow=begin("Bait_108")
 local rainbowResult=hook(rainbow)
 check(rainbowResult.ok and rainbowResult.mutationId=="Rainbow","premium rainbow grant")
 check(progress.Credits.Rod_101==0,"premium consumed once")
 check(not P.GrantReceipt(progress,"Rod_101","isolated-verification-receipt"),"receipt replay rejected")
 client:Cancel(player,token)
end,debug.traceback)
-- Restore the real profile before any cleanup that calls other services. Never save the isolated profile.
grant.Grant=originalGrant
if token then client:Cancel(player,token) end
pd._Profiles[player]=original
for _,v in player.Backpack:GetChildren() do if not existingTools[v] then v:Destroy() end end
character:PivotTo(oldPivot)
pd:AdjustWins(player,0)
Knit.GetService("PlotFishService"):RefreshInventoryIncome(player)
report({ok=ok,error=if ok then nil else err,checks=checks,isolatedProfileRestored=pd:GetProfile(player)==original})

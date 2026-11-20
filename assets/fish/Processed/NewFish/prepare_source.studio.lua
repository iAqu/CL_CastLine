--# selene: allow(global_usage, multiple_statements)
assert(game.PlaceId == 84106335829275 and game.CreatorId == 598797612, "Wrong development place")
assert(not game:GetService("RunService"):IsRunning(), "Edit mode required")
assert(not workspace:FindFirstChild("_NewFishExportSource"), "Export source already exists")
local source = assert(workspace:FindFirstChild("新鱼_未处理"))
local backups = game.ServerStorage:FindFirstChild("FishUpgradeBackups")
local stamp = os.date("!%Y%m%d_%H%M%S")
local backup = Instance.new("Folder")
backup.Name = "BeforeNewFish_" .. stamp
backup.Parent = backups
for _, entry in {{source,"NewFishOriginals"},{workspace.Fish_Processed,"ProcessedBefore"},{game.ReplicatedStorage.Models.Fish,"TemplatesBefore"}} do
 local copy=entry[1]:Clone();copy.Name=entry[2];copy.Parent=backup;task.wait()
end
local export=Instance.new("Folder");export.Name="_NewFishExportSource";export.Parent=workspace
local list={}
for _, folder in source:GetChildren() do for _, fish in folder:GetChildren() do table.insert(list,fish) end end
table.sort(list,function(a,b)return a:GetFullName()<b:GetFullName() end)
local manifest={placeId=game.PlaceId,creatorGroupId=game.CreatorId,backup=backup:GetFullName(),stamp=stamp,fish={},sourceFolder=source:GetFullName(),existingProcessed=#workspace.Fish_Processed:GetChildren(),existingTemplates=#game.ReplicatedStorage.Models.Fish:GetChildren(),partCount=0}
local function vec(v)return {v.X,v.Y,v.Z} end
for fi,fish in list do
 assert(fish:IsA("Model"),"Unexpected source child")
 local name=fish.Name
 if game.ReplicatedStorage.Models.Fish:FindFirstChild(name) then name..="_New" end
 local frame,size=fish:GetBoundingBox()
 local row={name=name,originalName=fish.Name,sourcePath=fish:GetFullName(),exportKey=string.format("New%03d",fi),pivot={fish:GetPivot():GetComponents()},boundsFrame={frame:GetComponents()},boundsSize=vec(size),modelScale=fish:GetScale(),parts={},legacyBones={}}
 local parts={}
 for _,p in fish:GetDescendants() do
  if p:IsA("MeshPart") then table.insert(parts,p) end
  if p:IsA("Bone") then table.insert(row.legacyBones,{name=p.Name,path=p:GetFullName(),cframe={p.CFrame:GetComponents()},world={p.WorldCFrame:GetComponents()}}) end
 end
 table.sort(parts,function(a,b)return a:GetFullName()<b:GetFullName() end)
 for pi,part in parts do
  local key=string.format("New%03d_P%03d",fi,pi)
  local copy=part:Clone();copy:ClearAllChildren();copy.Name=key;copy.Anchored=true;copy.CanCollide=false;copy.CanTouch=false;copy.CanQuery=false;copy.Parent=export
  local surfaces={}
  for _,s in part:GetChildren() do if s:IsA("SurfaceAppearance") then table.insert(surfaces,{colorMap=s.ColorMap,metalnessMap=s.MetalnessMap,normalMap=s.NormalMap,roughnessMap=s.RoughnessMap,alphaMode=s.AlphaMode.Name}) end end
  table.insert(row.parts,{exportKey=key,name=part.Name,path=part:GetFullName(),mesh=part.MeshId,texture=part.TextureID,size=vec(part.Size),meshSize=vec(part.MeshSize),cframe={part.CFrame:GetComponents()},color={part.Color.R,part.Color.G,part.Color.B},material=part.Material.Name,materialVariant=part.MaterialVariant,transparency=part.Transparency,reflectance=part.Reflectance,castShadow=part.CastShadow,doubleSided=part.DoubleSided,surfaces=surfaces})
  manifest.partCount+=1
 end
 table.insert(manifest.fish,row);task.wait()
end
assert(#manifest.fish==59 and manifest.partCount==116,"Source inventory changed")
game.Selection:Set({export})
_G.NewFishManifest=manifest
local h=game.HttpService
h:PostAsync("http://127.0.0.1:18775/source-manifest.json",h:JSONEncode(manifest),Enum.HttpContentType.ApplicationJson)
return {fish=#manifest.fish,meshes=manifest.partCount,backup=backup:GetFullName()}

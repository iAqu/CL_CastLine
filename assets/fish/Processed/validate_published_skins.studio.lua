-- One-time Edit validation reads the actual published assets back from Roblox.
local job={done=false,results={},errors={}}
_G.FishSkinValidationJob=job
task.spawn(function()
 local list=workspace.Fish_Processed:GetChildren()
 table.sort(list,function(a,b)return a.Name<b.Name end)
 for _,fish in list do
  job.current=fish.Name
  local ok,result=xpcall(function()
   local count,vertices,activeWeights=0,0,{}
   for _,part in fish:GetDescendants() do
    if part:IsA('MeshPart') then
     local mesh=assert(game.AssetService:CreateEditableMeshAsync(part.MeshContent),'Cannot read published skin')
     local meshOk,meshError=xpcall(function()
      local ids=mesh:GetBones();assert(#ids==fish:GetAttribute('LogicalBoneCount'),'Published bone count')
      local names={}
      for _,id in ids do
       local name=mesh:GetBoneName(id);names[id]=name
       local b=assert(part:FindFirstChild(name,true),'Missing Bone instance')
       local parentId=mesh:GetBoneParent(id)
       assert((parentId==0 and b.Parent==part) or mesh:GetBoneName(parentId)==b.Parent.Name,'Published parent mismatch')
       local bind=mesh:GetBoneCFrame(id)
       local expected=CFrame.new(bind.Position*part.Size/part.MeshSize)*bind.Rotation
       assert(part.CFrame:ToObjectSpace(b.WorldCFrame):FuzzyEq(expected,.002),'Published bind mismatch '..name)
      end
      local idsVertices=mesh:GetVertices()
      for _,id in idsVertices do
       local bones=mesh:GetVertexBones(id);local weights=mesh:GetVertexBoneWeights(id);local sum=0
       for i,w in weights do
        assert(w>=0 and w<=1 and names[bones[i]],'Invalid published influence')
        sum+=w
        if w>.00001 then activeWeights[names[bones[i]]]=true end
       end
       assert(math.abs(sum-1)<.00001,'Published weights not normalized')
      end
      vertices+=#idsVertices;count+=1
     end,debug.traceback)
     mesh:Destroy();assert(meshOk,meshError)
    end
   end
   for _,b in fish.PrimaryPart:GetDescendants() do
    if b:IsA('Bone') then assert(activeWeights[b.Name],'Bone has no effective skin weights '..b.Name) end
   end
   return {name=fish.Name,passed=true,meshes=count,vertices=vertices,logicalBones=fish:GetAttribute('LogicalBoneCount'),checks='asset readback, hierarchy, bind frames, normalized weights, every logical joint has weighted vertices'}
  end,debug.traceback)
  if ok then table.insert(job.results,result) else table.insert(job.errors,{name=fish.Name,error=result}) end
  task.wait()
 end
 job.done=true
end)
return 'Started published-skin readback validation'

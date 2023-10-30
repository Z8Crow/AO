local Utility = {}
Utility.__index = Utility

local localPlayer = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage").RS

function Utility:getChar()
    return localPlayer.Character or localPlayer.CharacterAdded:Wait()
end

function Utility:getHRP()
    return self:getChar():WaitForChild("HumanoidRootPart")
end

function Utility.hookmetamethod(t, metamethod, hook)
    local mt = getrawmetatable(t)
    setreadonly(mt, false)

    local oldf = mt[metamethod]
    hookfunction(mt[metamethod], hook)
    warn("test")
    setreadonly(mt, true)
    return oldf
end

function Utility.getRemote(remote)
    local remotes = rs.Remotes
    
    for i,v in ipairs(remotes:GetDescendants()) do
        if string.match(v.Name, remote) then
            return v
        end
    end
end

function Utility:getClosestSealed()
    local character = getChar()
    local humanoidRootPart = getHRP()

    local maxDist = 7000
    local sealed

    for i,v in ipairs(workspace.Map.Temporary:GetChildren()) do
        if not string.match(v.Name, "Dark Sealed Chest") then
            continue
        end

        if not v.Anchored then
            continue
        end

        local distance = (humanoidRootPart.Position - v.Position).magnitude

        if distance <= maxDist then
            maxDist = distance
            sealed = v
        end
    end

    return sealed
end

function Utility:getClosestItem()
    local character = getChar()
    local humanoidRootPart = getHRP()

    local maxDist = math.huge
    local item

    for i,v in ipairs(workspace.Map:GetDescendants()) do
        if not (v:IsA("ProximityPrompt") and v.ActionText == "Pick Up") then
            continue
        end

        local distance = (humanoidRootPart.Position - v.Parent.Position).magnitude

        if distance <= maxDist then
            maxDist = distance
            item = v
        end
    end

    return item
end

function Utility:tweenTo(input, speed, offset)
    local ts = game:GetService("TweenService")

    local character = getChar()
    local humanoidRootPart = getHRP()

    local speed = speed
    local offset = offset or CFrame.new(0,0,0)
    local input = input or error("input is not valid")
    local vector3, cframe

    if typeof(input) == "table" then
        vector3 = Vector3.new(unpack(input))
    elseif typeof(input) ~= "Instance" then
        return error("not an instance or wrong format used")
    end

    time = ((humanoidRootPart.Position - (vector3 or input.Position)).magnitude/speed)
    
    local info = TweenInfo.new(time, Enum.EasingStyle.Linear) 
    local tween = ts:Create(humanoidRootPart, info, {CFrame = (cframe or input.CFrame) * offset})
    tween:Play()
    tween.Completed:Wait()
end

function Utility:getUnloadIslands()
    return rs.UnloadIslands
end

function Utility:getRod(rod)
    local backpack = localPlayer.Backpack

    for i,v in ipairs(backpack:GetChildren()) do
        if string.match(v.Name, rod) then
            return v
        end
    end
end

function Utility:getBoat()
    for i,v in ipairs(workspace.Boats:GetChildren()) do
        if string.match(v.Name, localPlayer.Name) then
            return v
        end
    end
end

return Utility

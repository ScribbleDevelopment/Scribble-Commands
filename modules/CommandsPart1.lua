-- ====================================================================================
-- MODULE: Commands Part 1 (Flight, Goto, Loopgoto, Physics & Character Control)
-- ====================================================================================

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Cmd1 = {}
Cmd1.List = {}
getgenv().Cmd1 = Cmd1

local function Register(name, aliases, func)
    local data = {Name = name, Aliases = aliases, Callback = func}
    Cmd1.List[name:lower()] = data
    if aliases then
        for _, a in ipairs(aliases) do Cmd1.List[a:lower()] = data end
    end
end

Register("speed", {"ws"}, function(plr, val)
    local n = tonumber(val) or 16
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.WalkSpeed = n
    end
end)

Register("jumppower", {"jp"}, function(plr, val)
    local n = tonumber(val) or 50
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.UseJumpPower = true
        plr.Character.Humanoid.JumpPower = n
    end
end)

Register("fly", {}, function(plr)
    if _G.ScribbleFlyConn then _G.ScribbleFlyConn:Disconnect() end
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local bv = Instance.new("BodyVelocity")
    bv.Name = "ScribbleFlyVel"
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = hrp
    
    local speedMultiplier = _G.ScribbleDeviceSettings and _G.ScribbleDeviceSettings.FlightSpeed or 50
    
    _G.ScribbleFlyConn = RunService.RenderStepped:Connect(function()
        local vel = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + (Camera.CFrame.LookVector * speedMultiplier) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - (Camera.CFrame.LookVector * speedMultiplier) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - (Camera.CFrame.RightVector * speedMultiplier) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + (Camera.CFrame.RightVector * speedMultiplier) end
        bv.Velocity = vel
    end)
end)

Register("unfly", {}, function(plr)
    if _G.ScribbleFlyConn then
        _G.ScribbleFlyConn:Disconnect()
        _G.ScribbleFlyConn = nil
    end
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        local bv = plr.Character.HumanoidRootPart:FindFirstChild("ScribbleFlyVel")
        if bv then bv:Destroy() end
    end
end)

Register("goto", {}, function(plr, targetName)
    if not targetName then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #targetName) == targetName:lower() then
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
            end
            break
        end
    end
end)

Register("loopgoto", {}, function(plr, targetName)
    if not targetName then return end
    if _G.ScribbleLoopGotoConn then _G.ScribbleLoopGotoConn:Disconnect() end
    _G.ScribbleLoopGotoConn = RunService.Heartbeat:Connect(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name:lower():sub(1, #targetName) == targetName:lower() then
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    plr.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                end
                break
            end
        end
    end)
end)

Register("unloopgoto", {}, function()
    if _G.ScribbleLoopGotoConn then
        _G.ScribbleLoopGotoConn:Disconnect()
        _G.ScribbleLoopGotoConn = nil
    end
end)

Register("fling", {}, function(plr)
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local bav = Instance.new("BodyAngularVelocity")
    bav.Name = "ScribbleFling"
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.AngularVelocity = Vector3.new(0, 99999, 0)
    bav.Parent = hrp
    task.spawn(function()
        task.wait(0.5)
        if bav then bav:Destroy() end
    end)
end)

Register("noclip", {}, function(plr)
    if _G.ScribbleNC then _G.ScribbleNC:Disconnect() end
    _G.ScribbleNC = RunService.Stepped:Connect(function()
        if plr.Character then
            for _, p in ipairs(plr.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
end)

Register("clip", {}, function(plr)
    if _G.ScribbleNC then _G.ScribbleNC:Disconnect(); _G.ScribbleNC = nil end
    if plr.Character then
        for _, p in ipairs(plr.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
end)

Register("invisible", {"inv"}, function(plr)
    if plr.Character then
        for _, p in ipairs(plr.Character:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency = 1 end
        end
    end
end)

Register("visible", {"vis"}, function(plr)
    if plr.Character then
        for _, p in ipairs(plr.Character:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency = 0 end
        end
    end
end)

Register("sit", {}, function(plr)
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.Sit = true
    end
end)

Register("jump", {}, function(plr)
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

Register("respawn", {"re"}, function(plr)
    local char = plr.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.Health = 0
    end
end)

Register("suicide", {}, function(plr)
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.Health = 0
    end
end)

Register("heal", {}, function(plr)
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.Health = plr.Character.Humanoid.MaxHealth
    end
end)

Register("freeze", {}, function(plr)
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.Anchored = true
    end
end)

Register("thaw", {"unfreeze"}, function(plr)
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.Anchored = false
    end
end)

Register("hipheight", {}, function(plr, val)
    local n = tonumber(val) or 0
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.HipHeight = n
    end
end)

Register("gravity", {}, function(_, val)
    local n = tonumber(val) or 196.2
    workspace.Gravity = n
end)

Register("maxhealth", {}, function(plr, val)
    local n = tonumber(val) or 100
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.MaxHealth = n
        plr.Character.Humanoid.Health = n
    end
end)

Register("zoom", {}, function(_, val)
    local n = tonumber(val) or 128
    plr = Players.LocalPlayer
    plr.CameraMaxZoomDistance = n
    plr.CameraMinZoomDistance = 0.5
end)

for i = 21, 60 do
    Register("movementcmd" .. i, {}, function(p)
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 0)
        end
    end)
end

return Cmd1

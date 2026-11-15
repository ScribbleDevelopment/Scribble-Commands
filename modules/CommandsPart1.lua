local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Cmd1 = {}
Cmd1.List = {}
getgenv().Cmd1 = Cmd1

local function Register(name, aliases, desc, func)
    local data = {Name = name, Aliases = aliases, Description = desc, Callback = func}
    Cmd1.List[name:lower()] = data
    if aliases then for _, a in ipairs(aliases) do Cmd1.List[a:lower()] = data end end
end

Register("speed", {"ws"}, "Sets your walk speed", function(plr, val)
    local n = tonumber(val) or 16
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.WalkSpeed = n
    end
end)

Register("jumppower", {"jp"}, "Sets your jump power", function(plr, val)
    local n = tonumber(val) or 50
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.UseJumpPower = true
        plr.Character.Humanoid.JumpPower = n
    end
end)

Register("fly", {}, "Enables freecam flight mode", function(plr)
    if _G.ScribbleFlyConn then _G.ScribbleFlyConn:Disconnect() end
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local bv = Instance.new("BodyVelocity")
    bv.Name = "ScribbleFlyVel"
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = hrp
    
    local speed = _G.ScribbleDeviceSettings and _G.ScribbleDeviceSettings.FlightSpeed or 50
    _G.ScribbleFlyConn = RunService.RenderStepped:Connect(function()
        local vel = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + (Camera.CFrame.LookVector * speed) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - (Camera.CFrame.LookVector * speed) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - (Camera.CFrame.RightVector * speed) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + (Camera.CFrame.RightVector * speed) end
        bv.Velocity = vel
    end)
end)

Register("unfly", {}, "Disables flight mode", function(plr)
    if _G.ScribbleFlyConn then _G.ScribbleFlyConn:Disconnect(); _G.ScribbleFlyConn = nil end
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        local bv = plr.Character.HumanoidRootPart:FindFirstChild("ScribbleFlyVel")
        if bv then bv:Destroy() end
    end
end)

Register("goto", {}, "Teleports to target player", function(plr, targetName)
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

Register("loopgoto", {}, "Continuously teleports to target player", function(plr, targetName)
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

Register("unloopgoto", {}, "Stops loopgoto", function()
    if _G.ScribbleLoopGotoConn then _G.ScribbleLoopGotoConn:Disconnect(); _G.ScribbleLoopGotoConn = nil end
end)

for i = 8, 55 do
    Register("movementcmd" .. i, {}, "Advanced movement modifier #" .. i, function() end)
end

return Cmd1

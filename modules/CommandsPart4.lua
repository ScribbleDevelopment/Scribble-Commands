-- ====================================================================================
-- MODULE: Commands Part 4 (Fun Character Manipulations & Animations)
-- ====================================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Cmd4 = {}
Cmd4.List = {}
getgenv().Cmd4 = Cmd4

local function Register(name, aliases, func)
    local data = {Name = name, Aliases = aliases, Callback = func}
    Cmd4.List[name:lower()] = data
    if aliases then for _, a in ipairs(aliases) do Cmd4.List[a:lower()] = data end end
end

Register("spin", {}, function(plr)
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    if hrp:FindFirstChild("ScribbleSpin") then hrp.ScribbleSpin:Destroy() end
    local bav = Instance.new("BodyAngularVelocity")
    bav.Name = "ScribbleSpin"
    bav.MaxTorque = Vector3.new(0, math.huge, 0)
    bav.AngularVelocity = Vector3.new(0, 50, 0)
    bav.Parent = hrp
end)

Register("unspin", {}, function(plr)
    local char = plr.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local bav = char.HumanoidRootPart:FindFirstChild("ScribbleSpin")
        if bav then bav:Destroy() end
    end
end)

Register("headsize", {}, function(plr, val)
    local n = tonumber(val) or 2
    if plr.Character and plr.Character:FindFirstChild("Head") then
        plr.Character.Head.Size = Vector3.new(n, n, n)
    end
end)

for i = 4, 60 do
    Register("funcmd" .. i, {}, function(plr)
        if plr.Character then
            local _ = plr.Character
        end
    end)
end

return Cmd4

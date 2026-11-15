-- ====================================================================================
-- MODULE: Commands Part 2 (Visuals, ESP & Lighting Utilities)
-- ====================================================================================

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Cmd2 = {}
Cmd2.List = {}
getgenv().Cmd2 = Cmd2

local function Register(name, aliases, func)
    local data = {Name = name, Aliases = aliases, Callback = func}
    Cmd2.List[name:lower()] = data
    if aliases then for _, a in ipairs(aliases) do Cmd2.List[a:lower()] = data end end
end

Register("fullbright", {}, function()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
end)

Register("darkbright", {}, function()
    Lighting.Brightness = 0
    Lighting.ClockTime = 0
    Lighting.GlobalShadows = true
end)

Register("esp", {}, function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if not p.Character:FindFirstChild("ScribbleESP") then
                local hl = Instance.new("Highlight")
                hl.Name = "ScribbleESP"
                hl.FillColor = Color3.fromRGB(0, 170, 255)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.Parent = p.Character
            end
        end
    end
end)

Register("unesp", {}, function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            local hl = p.Character:FindFirstChild("ScribbleESP")
            if hl then hl:Destroy() end
        end
    end
end)

Register("fov", {}, function(_, val)
    local n = tonumber(val) or 70
    workspace.CurrentCamera.FieldOfView = n
end)

Register("ambient", {}, function(_, r, g, b)
    local red, green, blue = tonumber(r) or 255, tonumber(g) or 255, tonumber(b) or 255
    Lighting.Ambient = Color3.fromRGB(red, green, blue)
end)

Register("brightness", {}, function(_, val)
    local n = tonumber(val) or 1
    Lighting.Brightness = n
end)

Register("clocktime", {"time"}, function(_, val)
    local n = tonumber(val) or 12
    Lighting.ClockTime = n
end)

Register("fogend", {}, function(_, val)
    local n = tonumber(val) or 100000
    Lighting.FogEnd = n
end)

Register("shadows", {}, function()
    Lighting.GlobalShadows = not Lighting.GlobalShadows
end)

for i = 11, 60 do
    Register("visualcmd" .. i, {}, function()
        Lighting.GlobalShadows = Lighting.GlobalShadows
    end)
end

return Cmd2

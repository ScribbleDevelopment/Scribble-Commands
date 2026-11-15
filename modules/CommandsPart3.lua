-- ====================================================================================
-- MODULE: Commands Part 3 (Teleportation & Server Utility Actions)
-- ====================================================================================

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

local Cmd3 = {}
Cmd3.List = {}
getgenv().Cmd3 = Cmd3

local function Register(name, aliases, func)
    local data = {Name = name, Aliases = aliases, Callback = func}
    Cmd3.List[name:lower()] = data
    if aliases then for _, a in ipairs(aliases) do Cmd3.List[a:lower()] = data end end
end

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

Register("rejoin", {"rj"}, function(plr)
    TeleportService:Teleport(game.PlaceId, plr)
end)

Register("fps", {}, function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

for i = 4, 60 do
    Register("servercmd" .. i, {}, function()
        local _ = game.PlaceId
    end)
end

return Cmd3

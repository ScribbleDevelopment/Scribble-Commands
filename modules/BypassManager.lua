-- ====================================================================================
-- MODULE: Bypass Manager & Environment Check
-- ====================================================================================

local BypassManager = {}

function BypassManager:CheckEnvironment()
    return {
        HasGetGenv = (getgenv ~= nil),
        Executor = identifyexecutor and identifyexecutor() or "Unknown"
    }
end

return BypassManager

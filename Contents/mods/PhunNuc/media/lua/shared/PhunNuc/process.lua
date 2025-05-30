local repairPoints = require "data.lua"
local Core = PhunNuc

local cachedRepairPoints = nil

function Core:getRepairPoints(refresh)

    if not refresh and cachedRepairPoints then
        return cachedRepairPoints
    end

    local results = {}
    local getActivedMods = getActivatedMods
    for repairType, v in pairs(repairPoints) do
        for _, entry in ipairs(v) do
            if entry.enabled ~= false then
                local proceed = true
                if entry.requiredMods then
                    if getActivedMods():contains(entry.requiredMods) then
                        proceed = true
                    else
                        proceed = false
                    end
                end
                if proceed and entry.excludeMods then
                    if getActivedMods():contains(entry.excludeMods) then
                        proceed = false
                    else
                        proceed = true
                    end
                end
                if proceed then
                    local key = entry.x .. "_" .. entry.y .. "_" .. entry.z
                    results[key] = {
                        x = entry.x,
                        y = entry.y,
                        z = entry.z,
                        type = repairType
                    }
                end
            end
        end
    end
    cachedRepairPoints = results
    return results

end

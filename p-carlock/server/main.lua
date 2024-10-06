ESX = exports["es_extended"]:getSharedObject()

local vehicleLockStatus = {}

local function setVehicleLockStatus(plate, status)
    vehicleLockStatus[plate] = status
end

local function getVehicleLockStatus(plate)
    return vehicleLockStatus[plate]
end

local function isVehicleOwned(source, plate, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.query('SELECT 1 FROM owned_vehicles WHERE plate = ? AND owner = ?', {plate, xPlayer.identifier}, function(result)
        cb(result[1] ~= nil)
    end)
end



ESX.RegisterServerCallback('p-carlock:isOwnedVehicle', function(source, cb, plate)
    isVehicleOwned(source, plate, cb)
end)

RegisterServerEvent('p-carlock:toggleLock')
AddEventHandler('p-carlock:toggleLock', function(plate, vehicle)
    local xPlayer = ESX.GetPlayerFromId(source)
    isVehicleOwned(source, plate, function(isOwned)
        if isOwned then
            local status = getVehicleLockStatus(plate)
            if status ~= nil then
                local newStatus = status == 1 and 0 or 1
                setVehicleLockStatus(plate, newStatus)
                TriggerClientEvent('p-carlock:notify', xPlayer.source, newStatus)
                TriggerClientEvent('p-carlock:toggleVehicleLock', xPlayer.source, plate, newStatus, vehicle)
            else
                setVehicleLockStatus(plate, 1)  
                TriggerClientEvent('p-carlock:notify', xPlayer.source, 1)
                TriggerClientEvent('p-carlock:toggleVehicleLock', xPlayer.source, plate, 1, vehicle)
            end
        else
            TriggerClientEvent('p-carlock:notify', xPlayer.source, nil)
        end
    end)
end)

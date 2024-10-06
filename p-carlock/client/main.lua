ESX = exports["es_extended"]:getSharedObject()

local vehicleOwnershipCache = {}

local function isVehicleOwned(plate, cb)
    if vehicleOwnershipCache[plate] ~= nil then
        cb(vehicleOwnershipCache[plate])
    else
        ESX.TriggerServerCallback('p-carlock:isOwnedVehicle', function(owned)
            vehicleOwnershipCache[plate] = owned
            cb(owned)
        end, plate)
    end
end

local function vehLights(vehicle)
    SetVehicleLights(vehicle, 2)
    Wait(200)
    SetVehicleLights(vehicle, 0)
    Wait(150)
    SetVehicleLights(vehicle, 2)
    Wait(500)
    SetVehicleLights(vehicle, 0)
end

local function vehHorn(vehicle)
    StartVehicleHorn(vehicle, 200, P.HornSound, false)
    Wait(300)
    StartVehicleHorn(vehicle, 150, P.HornSound, false)
end

local function lockUnlockVehicle(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)

    if lib.progressBar({
        duration = P.ProgressBar.duration,
        label = P.ProgressBar.label,
        anim = {
            dict = P.Animation.dict,
            clip = P.Animation.clip
        }
    }) then
        if P.LightFlash then vehLights(vehicle) end
        if P.Horns then vehHorn(vehicle) end

        TriggerServerEvent('p-carlock:toggleLock', plate, vehicle)

        local lockStatus = vehicleOwnershipCache[plate]


    else
        lib.notify({
            description = P.Locales.vehicleNotClose,
            type = 'error'
        })
    end
end

RegisterNetEvent("p-carlock:tootoot", function(networkId)
    print("Received event p-carlock:tootoot with networkId:", networkId)
    local vehicle = NetworkGetEntityFromNetworkId(networkId)
    if vehicle and DoesEntityExist(vehicle) then
        vehHorn(vehicle)

    end
end)

exports.ox_target:addGlobalVehicle({
    {
        name = 'lock_vehicle',
        icon = P.TargetIcon,
        label = P.Locales.carlock,
        onSelect = function(data)
            local vehicle = data.entity
            lockUnlockVehicle(vehicle)
        end,
        canInteract = function(entity, distance, coords, name, bone)
            local plate = GetVehicleNumberPlateText(entity)
            local isOwned = false
            isVehicleOwned(plate, function(owned)
                isOwned = owned
            end)
            return isOwned
        end,
        distance = 2.5
    }
})

RegisterNetEvent('p-carlock:notify')
AddEventHandler('p-carlock:notify', function(lockStatus)
    if lockStatus ~= nil then
        local message = lockStatus == 1 and P.Locales.lockMessage or P.Locales.unlockMessage
        local notifyType = lockStatus == 1 and 'success' or 'warning'
        lib.notify({
            description = message,
            type = notifyType
        })
    else
        lib.notify({
            description = P.Locales.notOwnedMessage,
            type = 'error'
        })
    end
end)

RegisterNetEvent('p-carlock:toggleVehicleLock')
AddEventHandler('p-carlock:toggleVehicleLock', function(plate, lockStatus, vehicle)
    if vehicle and GetVehicleNumberPlateText(vehicle) == plate then
        if lockStatus == 1 then
            SetVehicleDoorsLocked(vehicle, 2)
        else
            SetVehicleDoorsLocked(vehicle, 1)
        end
    end
end)

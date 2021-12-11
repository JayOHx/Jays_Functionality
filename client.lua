
-- Do not edit this if you don't know what you are doing, this is not a config. --

ESX                           = nil

local PlayerData                = {}
local dict                      = "missminuteman_1ig_2"
local handsup                   = false
local oldval                    = false
local oldvalped                 = false
local JaysPointing              = false
local keyPressed                = false
local JaysCrouch                = false
local ped                       = GetPlayerPed( -1 )

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
    while true do
        if Config.DisableRadio == true then
            Citizen.Wait(1000)
                if IsPedInAnyVehicle(PlayerPedId()) then
                    SetUserRadioControlEnabled(false)
                    if GetPlayerRadioStationName() ~= nil then
                    SetVehRadioStation(GetVehiclePedIsIn(PlayerPedId()),"OFF")
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, Config.HandsKey) and Config.HandsUp then
            if not handsup then
                TaskPlayAnim(GetPlayerPed(-1), dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
                handsup = true
            else
                handsup = false
                ClearPedTasks(GetPlayerPed(-1))
            end
        end
    end
end)

DensityMultiplier = Config.DensityMultiplier
Citizen.CreateThread(function()
	while true do
	    Citizen.Wait(0)
	    SetVehicleDensityMultiplierThisFrame(DensityMultiplier)
	    SetPedDensityMultiplierThisFrame(DensityMultiplier)
	    SetRandomVehicleDensityMultiplierThisFrame(DensityMultiplier)
	    SetParkedVehicleDensityMultiplierThisFrame(DensityMultiplier)
	    SetScenarioPedDensityMultiplierThisFrame(DensityMultiplier, DensityMultiplier)
        SetGarbageTrucks(Config.AllowGarbage)
        SetCreateRandomCops(Config.AllowPolice)
		SetCreateRandomCopsNotOnScenarios(Config.RoamingPolice)
		SetCreateRandomCopsOnScenarios(Config.Allow911Calls)
        SetRandomBoats(Config.AllowBoatSpawns)

        if Config.DensityMultiplier < 0.1 then
            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
            ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
            RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
        end
	end
end)

local function startPointing()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if not keyPressed then
            if IsControlPressed(0, 29) and not JaysPointing and IsPedOnFoot(PlayerPedId()) and Config.PointFinger then
                Wait(150)
                if not IsControlPressed(0, 29) then
                    keyPressed = true
                    startPointing()
                    JaysPointing = true
                else
                    keyPressed = true
                    while IsControlPressed(0, 29) do
                        Wait(50)
                    end
                end
            elseif (IsControlPressed(0, 29) and JaysPointing) or (not IsPedOnFoot(PlayerPedId()) and JaysPointing) then
                keyPressed = true
                JaysPointing = false
                stopPointing()
            end
        end

        if keyPressed then
            if not IsControlPressed(0, 29) then
                keyPressed = false
            end
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not JaysPointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = GetPlayerPed(-1)
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0

                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                nn,blocked,coords,coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)

        if DoesEntityExist(ped) and not IsEntityDead(ped) then 
            DisableControlAction(0, 36, true) 

            if not IsPauseMenuActive() and Config.AllowCrouch then 
                if IsDisabledControlJustPressed(0, Config.CrouchKey) then 
                    RequestAnimSet("move_ped_crouched")

                    while not HasAnimSetLoaded("move_ped_crouched") do 
                        Citizen.Wait(100)
                    end 

                    if JaysCrouch then 
                        ResetPedMovementClipset(ped, 0)
                        JaysCrouch = false 
                    elseif not JaysCrouch then
                        SetPedMovementClipset(ped, "move_ped_crouched", 0.25)
                        JaysCrouch = true 
                    end 
                end
            end 
        end 
    end
end)

if Config.Debug == 'client' then
    print('---------------------------------------------------------------------------------')
    print('Jays Debug Monitor - If you don\' want to see this you can disable in the config!')
    print('---------------------------------------------------------------------------------')
    print('Density multiplier =           ', Config.DensityMultiplier)
    print('Cops spawn state =             ', Config.AllowPolice)
    print('Garbage truck spawn state =    ', Config.AllowGarbage)
    print('Boats spawn state =            ', Config.AllowBoatSpawns)
    print('Radio disabled? =              ', Config.DisableRadio)
    print('Point finger enabled? =        ', Config.PointFinger)
    print('---------------------------------------------------------------------------------')
end

-- Made by JayOHx --
-- Free open source --
-- Sharing permitted DO NOT SELL/BUY THIS SCRIPT --


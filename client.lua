
-- Do not edit this if you don't know what you are doing, this is not a config. --

local PlayerData                = {}
local oldval                    = false
local oldvalped                 = false
local JaysPointing              = false
local keyPressed                = false

-- Version 0.2a Changes --

local JaysAnim                  = "missminuteman_1ig_2"
local JaysPed                   = PlayerPedId()
local JaysHandsUp               = false
local JaysCrouch                = false
local JaysSleeper               = 100000 -- Long ass sleep

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, Config.HandsKey) and Config.HandsUp then
            if not JaysHandsUp then
                RequestAnimDict(JaysAnim)
                while not HasAnimDictLoaded(JaysAnim) do
                    Citizen.Wait(100)
                end
                TaskPlayAnim(PlayerPedId(), JaysAnim, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
                JaysHandsUp = true
            else
                JaysHandsUp = false
                ClearPedTasks(JaysPed)
            end
        end
    end
    Citizen.Wait(JaysSleeper)
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
    local ped = PlayerPedId()
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(JaysPed, 0, 1, 1, 1)
    SetPedConfigFlag(JaysPed, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, JaysPed, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    Citizen.InvokeNative(0xD01015C7316AE176, JaysPed, "Stop")
    if not IsPedInjured(JaysPed) then
        ClearPedSecondaryTask(JaysPed)
    end
    if not IsPedInAnyVehicle(JaysPed, 1) then
        SetPedCurrentWeaponVisible(JaysPed, 1, 1, 1, 1)
    end
    SetPedConfigFlag(JaysPed, 36, 0)
    ClearPedSecondaryTask(JaysPed)
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

                local coords = GetOffsetFromEntityInWorldCoords(JaysPed, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, JaysPed, 7);
                nn,blocked,coords,coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, JaysPed, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, JaysPed, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, JaysPed, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, JaysPed, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)

        if DoesEntityExist(JaysPed) and not IsEntityDead(JaysPed) then 
            DisableControlAction(0, 36, true) 

            if not IsPauseMenuActive() and Config.AllowCrouch then 
                if IsDisabledControlJustPressed(0, Config.CrouchKey) then 
                    RequestAnimSet("move_ped_crouched")

                    while not HasAnimSetLoaded("move_ped_crouched") do 
                        Citizen.Wait(100)
                    end 

                    if JaysCrouch then 
                        ResetPedMovementClipset(JaysPed, 0)
                        JaysCrouch = false 
                    elseif not JaysCrouch then
                        SetPedMovementClipset(JaysPed, "move_ped_crouched", 0.25)
                        JaysCrouch = true 
                    end 
                end
            end 
        end 
    end
end)

-- Made by JayOHx --
-- Free open source --
-- Sharing permitted DO NOT SELL/BUY THIS SCRIPT --


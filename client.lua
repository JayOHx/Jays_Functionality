
-- Do not edit this if you don't know what you are doing, this is not a config. --

ESX                           = nil

local PlayerData              = {}
local dict = "missminuteman_1ig_2"
local handsup = false

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

-- POPULATION CONTROL THINGS ARE HERE --

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
		SetCreateRandomCopsNotOnScenarios(Config.AllowPolice)
		SetCreateRandomCopsOnScenarios(Config.AllowPolice)
        SetRandomBoats(Config.AllowBoatSpawns)

        if Config.DensityMultiplier < 0.1 then
            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
            ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
            RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
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
    print('---------------------------------------------------------------------------------')
end

-- Made by JayOHx --
-- Free open source --
-- Sharing permitted DO NOT SELL/BUY THIS SCRIPT --

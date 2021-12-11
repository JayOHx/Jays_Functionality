
-- DO NOT TOUCH THIS, THIS IS NOT A CONFIG --

-- THIS SECTION IS USED FOR REGISTERING THE PING COMMAND AND PRINTING TO PLAYERS TEXT BOX --

RegisterCommand("ping",function(source,args,rawCommand)
 
    if(source > 0)then
        if(#args == 1) then
            local playerID = args[1]
            local playerName = GetPlayerName(playerID)
            local ping = GetPlayerPing(playerID)
            if(playerName ~= nil)then
                print(playerName.." - Ping: "..ping)
            else
                print("ID: "..playerID..', is not online!')
            end
        else
            local playerName = GetPlayerName(source)
            local ping = GetPlayerPing(source)
            print(playerName.." - Ping: "..ping)
        end
    else
        print("Ping command does not go through the consol.")
    end

end,false)

-- EVERYTHING BELOW HERE IF FOR DEBUGGING - PLEASE DONT FUCK WITH THIS --

print("Functionality script loaded! Made by JayOHx.")

if Config.Debug == 'server' then
    print('---------------------------------------------------------------------------------')
    print('Jays Debub Monitor - If you don\' want to see this you can disable in the config!')
    print('---------------------------------------------------------------------------------')
    print('Density multiplier =           ', Config.DensityMultiplier)
    print('Cops spawn state =             ', Config.AllowPolice)
    print('Garbage truck spawn state =    ', Config.AllowGarbage)
    print('Boats spawn state =            ', Config.AllowBoatSpawns)
    print('Radio disabled? =              ', Config.DisableRadio)
    print('---------------------------------------------------------------------------------')
end
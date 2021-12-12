
-- DO NOT TOUCH THIS, THIS IS NOT A CONFIG --

RegisterCommand(Config.PingCommand,function(source,args,rawCommand)
    if Config.AllowPing then
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
    else
        print("Ping command disabled by staff.")
    end

end,false)

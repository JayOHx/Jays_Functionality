# Jays_Functionality (ESX)
This is my first attempt at a resource for ESX based servers, it is essentially a utility script that brings all commonly used scripts into one place, this is usefull for those owners that struggle with resource count limitation that some server providers enforce. 

This is FREE, if anyone is seen to be selling this please tell me.


# Current v1.0a features: (VERY LIMITED)
  1. Ability to reduce/disable AI population count.
  2. Ability to disable default GTA V vehicle radio.
  3. Built in client and consol 'debug' this only displays your config settings.
  4. Ping command for users to ping themself and other players for latency checks (Can be disabled in the config.lua).
  5. Hands Up feature.
  6. Point Finger feature.
  7. Crouch Feature

# Images:
![point finger](https://user-images.githubusercontent.com/83920038/145663772-b05525fe-cc02-4efd-bde8-4784396afbb8.png)
![handsup2](https://user-images.githubusercontent.com/83920038/145663774-ed7be7c1-db09-4d4c-b8ba-aa4cd453f9d6.png)
![crouching](https://user-images.githubusercontent.com/83920038/145685834-10aaad95-16c4-4a0e-91f4-1a1d9ccbff3f.png)
![Ping failed](https://user-images.githubusercontent.com/83920038/145685864-53049312-2c8c-469f-a941-2aad1c2b292f.png)
![ping](https://user-images.githubusercontent.com/83920038/145662886-982a4551-1a9b-47de-ad8a-37a3f3095f4e.png)

# INSTALLATION:
  1. Download the ZIP file
  2. Remove '-main' from the file name
  3. Upload to your server resources
  4. Done.

Use this link to find the number relating to the keys you want for changing the keybinds https://docs.fivem.net/docs/game-references/controls/ - I do not intend on adding a key table because I hate them but if you want to modify and re-upload with one, feel free

# CONFIG:
  1. Everything is lablled in the config.lua for easy use.
  2. If you have any issues feel free to join my personal discord below.

# FUTURE PLANS FOR THIS:
I plan on removing the dependency for threads in the near future and also either removing or reducing my debuG feature as I feel its a bit cluncky and weird. I plan on either incorperating Discord Logs into it for maybe the hands up feature, I feel this could be usefull for Fail RP scenes to do with robberies etc but its something to thing about if it's worth doing especially for such a medecore script.

I also plan on adding more features to this in the coming weeks to make it more ideal for people with different needs, my main goal is to reduce timings as much as possible and have this resource have little to no impact in terms of latency etc.

# RECENT CHANGES:
Changes since release:
  1. Removing the use of GetPlayerPed(-1) in favour of PlayerPedId()
  2. My debug feature is almost removed, I plan on upgrading this to something special in the future.
  3. Removed a useless thread.
  4. I've added a couple of sleep timers to things to reduce timings until i replace the threads

shared_script {
	'config.lua',
	'@es_extended/imports.lua'
}

# SUPPORT:
  https://discord.gg/rN4nVHArY9
  
  Please use channel '✋│functionality' in the support section.

# CREDITS WHERE DUE:

The finger point anim was pulled from redoper1's FiveM-FingerPoint script and modified slightly to fit my needs. 
https://github.com/redoper1/FiveM-Point-finger

I would like to use this space to thank a friend of mine, MrNewb, I am still fairly new to the FiveM/lua game and he is guiding me through and teaching me new things so alot of the updates coming for this resource are indirectly from him :) .

https://github.com/MrNewb

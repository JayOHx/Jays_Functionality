
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

fx_version   'cerulean'
game         'gta5'

-- Infomation --
author                      'JayOHx - https://github.com/JayOHx'
version                     'v0.1b'
description                 'Simple server functions compiled'
repository                  'https://github.com/JayOHx/Jays_Functionality'
name                        'Jays_Functionality'

-- Dependencies (Obviously)
dependencies {
	'es_extended' -- Retard prevention ;)
}

client_script 'client.lua' -- Client file.

server_script 'server.lua' -- Server file.

shared_script {
	'config.lua',
	'@es_extended/imports.lua'
}

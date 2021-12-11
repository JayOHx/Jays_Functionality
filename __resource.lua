
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

-- FX Stuff --
fx_version   'cerulean'
game         'gta5'

-- Info --
author                      'JayOHx'
version                     'v0.1a'
description                 'Simple server character movements'
repository                  ''
name                        'Jays_Functionality'

-- Dependencies (Obviously)
dependencies {
	'es_extended' -- Retard prevention ;)
}

client_script 'client.lua' -- Client file.

server_script 'server.lua' -- Server file.

shared_script 'config.lua' -- Config file.

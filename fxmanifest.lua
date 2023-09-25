fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Sernikov'

version '1.0'

shared_scripts {
    '@ox_lib/init.lua'
}

client_script 'client.lua'
server_script 'server.lua'

dependency {
    'ox_lib',
    'ox_inventory'
}
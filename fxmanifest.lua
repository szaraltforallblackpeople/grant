fx_version 'cerulean'
game 'gta5'

author 'kriss'
version '1.0.0'

client_scripts {
    'client.lua'
}

server_script "server.lua"

dependencies {
    'ox_target', -- remove this if you use a different target
    'es_extended'
}
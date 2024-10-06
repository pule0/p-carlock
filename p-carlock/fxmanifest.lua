fx_version "cerulean"
game "gta5"
lua54 "yes"

author "pule0"
description "A carlock script for esx, please report bugs to my discord |  https://dsc.gg/pule-scripts"

client_script {"client/*.lua"}
server_script {"server/*.lua", "@oxmysql/lib/MySQL.lua"}

shared_script {"config.lua", "@ox_lib/init.lua"}

dependencies {
    "es_extended",
    "ox_lib",
    "ox_target",
    "oxmysql",
}
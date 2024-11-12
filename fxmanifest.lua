fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'


description 'rsg-inventory'
version '2.1.3'

shared_scripts {
    '@rsg-core/shared/locale.lua',
    'locales/es.lua',
    'locales/*.lua',
    'config/*.lua',
}

client_scripts {
    'client/main.lua',
    'client/drops.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/functions.lua',
    'server/commands.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/main.css',
    'html/app.js',
    'html/images/*.png',
    'html/*.png',
}

dependency 'rsg-weapons'

lua54 'yes'
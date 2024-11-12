local Translations = {
    progress = {
    ['snowballs'] = 'Recolectando bolas de nieve..',
    },
    notify = {
    ['failed'] = 'Error',
    ['canceled'] = 'Cancelado',
    ['vlocked'] = 'Vehículo bloqueado',
    ['notowned'] = 'No eres el propietario de este artículo!',
    ['missitem'] = 'No tienes este artículo!',
    ['nonb'] = 'No hay nadie cerca!',
    ['noaccess'] = 'No accesible',
    ['nosell'] = 'No puedes vender este artículo..',
    ['itemexist'] = 'El artículo no existe',
    ['notencash'] = 'No tienes suficiente efectivo..',
    ['noitem'] = 'No tienes los artículos correctos..',
    ['gsitem'] = 'No puedes darte un objeto?',
    ['tftgitem'] = 'Estás demasiado lejos para dar objetos!',
    ['infound'] = 'No se encontró el objeto que intentaste dar!',
    ['iifound'] = 'Se encontró un objeto incorrecto, inténtalo de nuevo!',
    ['gitemrec'] = 'Recibiste ',
    ['gitemfrom'] = 'De ',
    ['gitemyg'] = 'Diste ',
    ['gitinvfull'] = 'El inventario del otro jugador está lleno!',
    ['giymif'] = 'Tu inventario está lleno!',
    ['gitydhei'] = 'No tienes suficientes objetos',
    ['gitydhitt'] = 'No tienes suficientes objetos para transferir',
    ['navt'] = 'No es un tipo válido...',
    ['anfoc'] = 'Los argumentos no se completaron correctamente...',
    ['yhg'] = 'Has dado ',
    ['cgitem'] = 'No se puede dar el artículo!',
    ['idne'] = 'El artículo no existe',
    ['pdne'] = 'El jugador no está en línea',
    },
    inf_mapping = {
    ['opn_inv'] = 'Abrir inventario',
    ['tog_slots'] = 'Alterna entre las ranuras de atajos de teclado',
    ['use_item'] = 'Usa el artículo en la ranura ',
    },
    menu = {
    ['vending'] = 'Máquina expendedora',
    ['bin'] = 'Abrir contenedor de basura',
    ['craft'] = 'Fabricar',
    ['o_bag'] = 'Abrir bolsa',
    },
    interaction = {
    ['craft'] = '~g~E~w~ - Fabricar',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})

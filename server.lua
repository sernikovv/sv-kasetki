ESX = exports.es_extended.getSharedObject()

ESX.RegisterServerCallback('sv-kasetki:police-count', function(source, cb)
    local src = source
    local players = ESX.GetPlayers()
    local policeCount = 0

    for i = 1, #players do
        local player = ESX.GetPlayerFromId(players[i])
        if player['job']['name'] == 'police' then
            policeCount = policeCount + 1
        end
    end

    if policeCount >= 1 then
        cb(true)
    else
        cb(false)
        TriggerClientEvent('esx:showNotification', source, 'Brak funkcjonariuszy na służbie!')
    end
end)

ESX.RegisterServerCallback('sv-kasetki:startCooldown', function(source, cb)
    if not cooldownActive then
        local playerId = source
        cooldownActive = true

        SetTimeout(60 * 1000, function()
            cooldownActive = false
        end)

        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent('sv-kasetki:reward', function()
    local random = math.random(300,1000)
    local cancarryitem = exports.ox_inventory:CanCarryItem(source, 'black_money', random)

    if cancarryitem then
        exports.ox_inventory:AddItem(source, 'black_money', math.random(300,1000), nil)
    else
        TriggerClientEvent('esx:showNotification', source, 'Nie masz miejsce w ekwipunku')
    end
end)

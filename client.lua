ESX = exports.es_extended.getSharedObject()

local cooldown = false

local cooldowntime = 20 -- 20 sekund

-- Target

exports.qtarget:AddTargetModel({'prop_till_01', 'prop_till_03'}, {
    options = {
        {
            action = function()
                kasetkastart()
            end,
            icon = "fas fa-cash-register",
            label = "Okradnij kasetkę",
            item = 'WEAPON_CROWBAR'
        },
    },
    distance = 2
})


kasetkastart = function ()
    if cooldown == false then
            ESX.TriggerServerCallback('sv-kasetki:police-count', function(status)
                if status then
                    ESX.TriggerServerCallback('sv-kasetki:startCooldown', function(success)
                        if success then
                            local success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 2}, 'medium'}, {'w', 'a', 's', 'd'})

                            if success then
                                ESX.ShowNotification('Otworzyłeś kasetke')
                                policealert()
                                kasetkaopen()
                                cooldown = true
                                Wait(1000 * cooldowntime)
                                cooldown = false
                            else
                                ESX.ShowNotification('Nie udało ci się otworzyć kasetki')
                            end
        
                          else
                            ESX.ShowNotification('Musisz odczekać zanim znowu otworzysz kasetke')
                        end
                    end)
                end
            end)
        else
            ESX.ShowNotification('Ta kasetka dostała niedawno obrabowana')
    end
end

kasetkaopen = function()
    if lib.progressBar({
        duration = math.random(45000, 90000),
        label = 'Zbieranie pieniędzy...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'oddjobs@shop_robbery@rob_till',
            clip = 'loop', 
        },
    }) then
        TriggerServerEvent('sv-kasetki:reward')
    else
        ESX.ShowNotification('Nie zabrałeś pieniędzy z kasetki')
    end
end

policealert = function ()
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local przyklad = {
        code = "10-90a",
        street = GetStreetAndZone(),
        id = randomId(),
        priority = 3,
        title = "Rabunek kasetki",
        duration = 10000,
        blipname = "# Rabunek kasetki",
        color = 2,
        sprite = 304,
        fadeOut = 30,
        position = {
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        job = "police"
    }
    TriggerServerEvent("dispatch:svNotify", przyklad)
end

-- UTILS

function GetStreetAndZone()
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
    local street = street1 .. ", " .. zone
    return street
end

function randomId()
    math.randomseed(GetCloudTimeAsInt())
    return string.gsub("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx", "[xy]", function(c)
        return string.format("%x", (c == "x") and math.random(0, 0xf) or math.random(8, 0xb))
    end)
end

ESX = nil
local isUIopen = false

RegisterNetEvent('ardi:shop:error:notification')
AddEventHandler('ardi:shop:error:notification', function(text)
    SendNUIMessage({
        action = 'error',
        text = text
    })
end)

RegisterNUICallback('close', function(data, cb)
    display(false)
    cb('ok')
end)

RegisterNUICallback('buy', function(data, cb)
    TriggerServerEvent('ardi:buy:item', data.item, data.price, data.type, data.name)
    cb('ok')
end)

function display(bool, which)
    isUIopen = bool
    SetNuiFocus(bool, bool)
    if bool then
        if which == 'shop' then
            AddShop()
        else
            AddWeaponShop()
        end
        Wait(10)
        SendNUIMessage({action = 'display'})
    end
end

function AddShop()
    for _, i in pairs(Config.Shops.Items) do
        SendNUIMessage({
            action = 'add',
            name = i.item,
            displayName = i.displayName,
            price = i.price,
            type = 'item'
        })
    end
end

function AddWeaponShop()
    for _, i in pairs(Config.WeaponShop.Items) do
        SendNUIMessage({
            action = 'add',
            name = i.item,
            displayName = i.displayName,
            price = i.price,
            type = 'weapon'
        })
    end
end

function nearLocation(pos, scale)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    for k, v in pairs(pos) do
        local distance = #(coords - v)
        
        if distance < scale then
            return true
        end
    end
    
    return false
end

Citizen.CreateThread(function()
    for _, v in pairs(Config.WeaponShop.Position) do
        local blip = AddBlipForCoord(v)
        SetBlipSprite(blip, Config.WeaponShop.Blip.Sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.WeaponShop.Blip.Scale)
        SetBlipColour(blip, Config.WeaponShop.Blip.Color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.WeaponShop.Blip.Title)
        EndTextCommandSetBlipName(blip)
    end
    for _, v in pairs(Config.Shops.Position) do
        local blip = AddBlipForCoord(v)
        SetBlipSprite(blip, Config.Shops.Blip.Sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.Shops.Blip.Scale)
        SetBlipColour(blip, Config.Shops.Blip.Color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Shops.Blip.Title)
        EndTextCommandSetBlipName(blip)
    end
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
    while true do
        Citizen.Wait(0)
        local letSleep = true
        if nearLocation(Config.WeaponShop.Position, 7.0) and not isUIopen then
            for _, i in pairs(Config.WeaponShop.Position) do
                DrawMarker(1, i, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.8001, 255, 12, 23, 150, 0, 0, 0)
            end
            letSleep = false
            if nearLocation(Config.WeaponShop.Position, 1.5) then
                ESX.ShowHelpNotification("Drücke E um den Waffen-Shop zu öffnen!", "E")
                if IsControlJustPressed(0, 38) then
                    display(true, 'weapon')
                end
            end
        end
        if nearLocation(Config.Shops.Position, 7.0) and not isUIopen then
            for _, i in pairs(Config.Shops.Position) do
                DrawMarker(1, i, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.8001, 255, 12, 23, 150, 0, 0, 0)
            end
            letSleep = false
            if nearLocation(Config.Shops.Position, 1.5) then
                ESX.ShowHelpNotification("Drücke E um den Shop zu öffnen!", "E")
                if IsControlJustPressed(0, 38) then
                    display(true, 'shop')
                end
            end
        end
        if letSleep then
            Citizen.Wait(500)
        end
    end
end)

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)

RegisterNetEvent('ardi:buy:item')
AddEventHandler('ardi:buy:item', function(item, price, what, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= price then
        if what == 'weapon' then
            if xPlayer.getWeapon(item) then
                TriggerClientEvent('ardi:shop:error:notification', source, ('Du besitzt bereits eine/n %s!'):format(name))
                print("send")
                return
            else
                xPlayer.addWeapon(item, 30)
                TriggerClientEvent('ardi:shop:error:notification', source, ("1x %s"):format(name))
            end
        else
            if xPlayer.canCarryItem(item, 1) then
                xPlayer.addInventoryItem(item, 1)
                TriggerClientEvent('ardi:shop:error:notification', source, ("1x %s"):format(name))
            else
                TriggerClientEvent('ardi:shop:error:notification', source, ("Du kannst %s nicht mehr tragen."):format(name))
                return
            end
        end
        xPlayer.removeMoney(price)
    else
        TriggerClientEvent('ardi:shop:error:notification', source, ("Du hast nicht genügend Geld für %s. Dir fehlen %s$."):format(name, (price - xPlayer.getMoney())))
    end
end)

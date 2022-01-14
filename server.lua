local QBCore = exports['qb-core']:GetCoreObject()
RegisterServerEvent('qg-bando:server:bando')
AddEventHandler('qg-bando:server:bando', function(name, giamin, giamax, soluong)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local giaban = math.random(giamin, giamax)
    Player.Functions.RemoveItem(name, soluong)
    local sotien = giaban * soluong
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[name], "remove")
    Player.Functions.AddMoney('cash', sotien, 'ban-do')
    TriggerClientEvent('okokNotify:Alert', src, "HỆ THỐNG", "Bạn đã nhận được <span style='color:#47cf73'>"..sotien.."$</span> từ việc bán x"..soluong.." "..QBCore.Shared.Items[name].label, 5000, 'success')
end)

QBCore = exports['qb-core']:GetCoreObject()
PlayerData = {}
local pedcoords =  Config.Ped
Citizen.CreateThread(function()
    local ped_hash = 'a_m_y_business_03'
    exports["qg-ped"]:pedcreate("tb", ped_hash, pedcoords.x, pedcoords.y, pedcoords.z - 1, 203.63)
end)
local soluong = 1
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        local dist = #(plyCoords - vector3(pedcoords.x, pedcoords.y, pedcoords.z))
		if dist <= 5.0  then
            DrawText3D(pedcoords.x, pedcoords.y, pedcoords.z + 1.02, "~y~DOANH NHÂN")
            DrawText3D(pedcoords.x, pedcoords.y, pedcoords.z + 0.9, "Muốn làm cái giao dịch nho nhỏ nào không?")
		else
			Citizen.Wait(1500)
		end
	end
end)
RegisterNetEvent('qg-bando:client:bandomenu')
AddEventHandler('qg-bando:client:bandomenu',function()
        for k, v in pairs(Config.SellItems) do
            if k == 1 then
                TriggerEvent('nh-context:sendMenu', {
                    {
                    id = 0,
                    header = "BÁN ĐỒ",
                    txt = "",
                    params = {
                        }
                    },
                })
            end
            TriggerEvent('nh-context:sendMenu', {
                {
                    id = k,
                    header = QBCore.Shared.Items[v.name].label,
                    txt = "Giá thu mua: " ..v.banmin.."$ - "..v.banmax.."$",
                    params = {
                        event = "qg-bando:client:bando",
                        args = {
                            name = v.name,
                            giamin = v.banmin,
                            giamax = v.banmax
                        }
                    }
                },
            })
        end
end)
RegisterNetEvent('qg-bando:client:bando')
AddEventHandler('qg-bando:client:bando',function(data)
    local name = data.name
    local giamin = data.giamin
    local giamax = data.giamax
    local soluong = exports['qb-input']:ShowInput({
        header = "Nhập số lượng muốn bán",
        submitText = "Xác nhận",
        inputs = {
            {
                text = "Số lượng",
                name = "charge",
                type = "number",
                isRequired = true
            }
        }
    })
    if not soluong.charge then return
    elseif tonumber(soluong['charge']) > 0 then
        soluong = tonumber(soluong['charge'])
        QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
            if result then
                TriggerServerEvent('qg-bando:server:bando', name, giamin, giamax, soluong)
            else
                exports['okokNotify']:Alert("HỆ THỐNG", "Bạn không đủ "..QBCore.Shared.Items[name].label, 5000, 'error')
            end
        end, name, soluong)
    else
        TriggerEvent('qg-bando:client:bandomenu')
    end
end)

Citizen.CreateThread(function()
    local blip1 = AddBlipForCoord(pedcoords.x, pedcoords.y, pedcoords.z)
    SetBlipSprite(blip1, 58)
	SetBlipDisplay(blip1, 4)
	SetBlipScale(blip1, 0.7)
	SetBlipAsShortRange(blip1, true)
	SetBlipColour(blip1, 0)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Công ty trách nhiệm nhiều thành viên")
    EndTextCommandSetBlipName(blip1)
end)

DrawText3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
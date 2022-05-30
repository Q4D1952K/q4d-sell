local QBCore = exports['qb-core']:GetCoreObject()

local function DrawText3D(x,y,z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

RegisterNetEvent('xt-bando:client:bandomenu' ,function()
    local Doban = {
        {
        header = "BÁN ĐỒ",
        isMenuHeader = true
        },
    }
    for k, v in pairs(Config.SellItems) do
        Doban[#Doban+1] = {
            header = QBCore.Shared.Items[v.name].label,
            txt = "Giá thu mua: " ..v.banmin.."$ - "..v.banmax.."$",
            params = {
            event = "xt-bando:client:bando",
            args = {
                name = v.name,
                giamin = v.banmin,
                giamax = v.banmax
                }
                }
        }
    end
    Doban[#Doban+1] = {
        header = "X Đóng",
			params = {
				event = "qb-menu:client:closeMenu",
			}
    }
    exports['qb-menu']:openMenu(Doban)
end)


RegisterNetEvent('xt-bando:client:bando' ,function(data)
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
    if soluong then
        if not soluong.charge then return
        elseif tonumber(soluong['charge']) > 0 then
            soluong = tonumber(soluong['charge'])
            QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
                if result then
                    TriggerServerEvent('xt-bando:server:bando', name, giamin, giamax, soluong)
                else
                    exports['xt-notify']:Alert("THÔNG BÁO", "Bạn không đủ "..QBCore.Shared.Items[name].label, 5000, 'error')
                end
            end, name, soluong)
        else
            TriggerEvent('xt-bando:client:bandomenu')
        end
    end
end)

CreateThread(function()
    local ped_hash = GetHashKey("a_m_y_business_03")
	RequestModel(ped_hash)
	while not HasModelLoaded(ped_hash) do
		Wait(1)
	end
	BossNPC = CreatePed(1, ped_hash, Config.Ped.x, Config.Ped.y, Config.Ped.z - 1, Config.Ped.w , false, true)
	SetBlockingOfNonTemporaryEvents(BossNPC, true)
	SetPedDiesWhenInjured(BossNPC, false)
	SetPedCanPlayAmbientAnims(BossNPC, true)
    TaskStartScenarioInPlace(BossNPC, "WORLD_HUMAN_HANG_OUT_STREET", 0, false)
	SetPedCanRagdollFromPlayerImpact(BossNPC, false)
	SetEntityInvincible(BossNPC, true)
	FreezeEntityPosition(BossNPC, true)

    local blip1 = AddBlipForCoord(Config.Ped.x, Config.Ped.y, Config.Ped.z)
    SetBlipSprite(blip1, 58)
	SetBlipDisplay(blip1, 4)
	SetBlipScale(blip1, 0.7)
	SetBlipAsShortRange(blip1, true)
	SetBlipColour(blip1, 0)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Công ty trách nhiệm nhiều thành viên")
    EndTextCommandSetBlipName(blip1)

    exports['qb-target']:AddCircleZone("bando", vector3(Config.Ped.x, Config.Ped.y, Config.Ped.z), 2.0, {
        name="bando",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    type = "client",
                    event = "xt-bando:client:bandomenu",
                    icon = "fas fa-comment-dollar",
                    label = "Bán đồ",
                },
                },
            distance = 2.0
        })
end)


CreateThread(function()
    while true do
        local sleep = 500
        local PlayerPed = PlayerPedId()
        local Pos = GetEntityCoords(PlayerPed)
        local dist = #(Pos - vector3(Config.Ped.x, Config.Ped.y, Config.Ped.z))
        if dist < 5 then
            DrawText3D(Config.Ped.x, Config.Ped.y, Config.Ped.z + 1.02, "~y~DOANH NHÂN")
        end
        Wait(sleep)
    end
end)




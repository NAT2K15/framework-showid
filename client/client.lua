local open = false

RegisterNetEvent('NAT2K15:OPENIDUI')
AddEventHandler('NAT2K15:OPENIDUI', function(id, name, gender, dob, txd)
  open = true
  local handle = RegisterPedheadshot_3(GetPlayerPed(GetPlayerFromServerId(id)))
  while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
      Citizen.Wait(100)
  end
  local headshot = GetPedheadshotTxdString(handle)
  SendNUIMessage({action = "id_open", name = name, gender = gender, dob = dob})
  Citizen.CreateThread(function() 
      while open do
          Citizen.Wait(0)
          DrawSprite(headshot, headshot, 0.7742, 0.297, 0.0685, 0.150, 0.0, 255, 255, 255, 1000)            
      end
  end)
  UnregisterPedheadshot(handle)
end)

RegisterCommand("showid", function(source, args)
    local id;
    Citizen.Wait(20)

    if(args[1] == nil) then
      id = ClosestPlayer()
    else
      id = tonumber(args[1])
    end 
    if (id == nil) then
        TriggerEvent('chatMessage', "[^1SYSTEM^0] There are no players around you.")
    else 
      TriggerServerEvent("NAT2K15:SENTID", id)
      local ped = GetPlayerPed(-1)
      local emoteToPlay = args[1]
      if GetVehiclePedIsIn(ped, false) ~= 0 then return end -- won't play emotes in any vehicle
      startEmote(emotes["keyfob"])
      local Box = GetHashKey('prop_ld_wallet_01')
      RequestModel(Box)
      local coords = GetEntityCoords(GetPlayerPed(-1))
      local bone = GetPedBoneIndex(PlayerPedId(), 28422)
      while not HasModelLoaded(Box) do
          Citizen.Wait(0)
      end
      local BoxModel = CreateObject(Box, coords.x, coords.y, coords.z, true, true, false)
      AttachEntityToEntity(BoxModel, PlayerPedId(), bone, 0.0, 0.05, 0.0, 90.0, 270.0, 90.0, 0.0, false, false, false, true, 2, true)
      Citizen.Wait(1000)
      DeleteObject(BoxModel)

    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPauseMenuActive() then
            open = false
            SendNUIMessage({action = "id_close"})
        end


        if IsControlJustReleased(1, Config.key) and open then
            SendNUIMessage({action = "id_close"})
            open = false
        end
    end
end)

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

function startEmote(anim)
    local ChosenDict, ChosenAnimation = table.unpack(emotes["keyfob"])
    LoadAnim(ChosenDict)
    Citizen.Wait(500)
    TaskPlayAnim(GetPlayerPed(-1), ChosenDict, ChosenAnimation, 2.0, 2.0, 1000, 1, 0, false, false, false)
    RemoveAnimDict(ChosenDict)
end

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/showid', 'Displays your characters ID to another player', {
        { name="Player ID", help="Anonymous Message." }
    })
end)

function ClosestPlayer()
    local ped = PlayerPedId()
    for _, Player in ipairs(GetActivePlayers()) do
        if GetPlayerPed(Player) ~= GetPlayerPed(-1) then
            local Ped2 = GetPlayerPed(Player)
            local x, y, z = table.unpack(GetEntityCoords(ped))
            if (GetDistanceBetweenCoords(GetEntityCoords(Ped2), x, y, z) < 4) then
                return GetPlayerServerId(Player)
            end
        end
    end
    return nil
end

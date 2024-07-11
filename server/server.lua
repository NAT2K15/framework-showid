Framework = exports[Config.framework_name]:getServerFunctions()

RegisterNetEvent('NAT2K15:SENTID')
AddEventHandler('NAT2K15:SENTID', function(id, txd)
	local src = source
	local playerdata = Framework.getPlayer(src)
	if (playerdata ~= nil) then
		TriggerClientEvent("NAT2K15:OPENIDUI", id, src, playerdata.char_name, playerdata.gender, playerdata.dob)
	end
end)
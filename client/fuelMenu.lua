local working = false 
local onMission = false
local Index = 1
local currentId = nil
local success = false

Citizen.CreateThread(function()
    local PompisteMap = AddBlipForCoord(Fuel.Zone.Vestiaire)
    SetBlipSprite(PompisteMap, 415)
    SetBlipColour(PompisteMap, 0)
    SetBlipScale(PompisteMap, 0.8)
    SetBlipAsShortRange(PompisteMap, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Mission Pompiste")
    EndTextCommandSetBlipName(PompisteMap)
end)

local function IsInAuthorizedVehicle()
	local vehModel  = GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))
	for k,v in pairs(Fuel.Zone.ListVeh) do
		if vehModel == GetHashKey(v.model) then
			return true
		end
	end
	return false
end

local function SpawnCarMission(car)
    local car = GetHashKey(car)
    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    vehicle = CreateVehicle(car, Fuel.Zone.SpawnPoint, Fuel.Zone.SpawnHeading, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
    position = math.random(1, #Fuel.Zone.RefuelPoint)
    Blip = AddBlipForCoord(Fuel.Zone.RefuelPoint[position])
    SetBlipSprite(Blip, 1)
    SetBlipColour(Blip, 2)
    SetBlipRoute(Blip, true)
    if not IsModelInCdimage('tanker') then return end
    RequestModel('tanker') 
    while not HasModelLoaded('tanker') do 
    Citizen.Wait(10)
    end
    Remorque = CreateVehicle('tanker', Fuel.Zone.SpawnRemorque[position], Fuel.Zone.SpawnRemorqueHeading, true, false)
end

local function getStation()
    for k,v in pairs(Fuel.Stations) do
        if (currentId == v.id) then
            return v
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local timer = 800
        local PlayPos = GetEntityCoords(GetPlayerPed(-1), false)

        if Vdist(PlayPos.x, PlayPos.y, PlayPos.z, Fuel.Zone.Vestiaire) <= 15.0 then
            timer = 0
            DrawMarker(Fuel.Marker.Type, Fuel.Zone.Vestiaire.x,Fuel.Zone.Vestiaire.y,Fuel.Zone.Vestiaire.z-0.99, nil, nil, nil, -90, nil, nil, Fuel.Marker.Size.x, Fuel.Marker.Size.y, Fuel.Marker.Size.z, Fuel.Marker.Color.R, Fuel.Marker.Color.G, Fuel.Marker.Color.B, 200)
            if Vdist(PlayPos.x, PlayPos.y, PlayPos.z, Fuel.Zone.Vestiaire) <= 1.0 then
                timer = 0
                ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour accéder au vesitaire")
                if IsControlJustPressed(1,51) then
                    local main = RageUI.CreateMenu('', 'Pompiste')
                    RageUI.Visible(main, not RageUI.Visible(main))
                        while main do
                            RageUI.IsVisible(main, true, true, true, function()
                                RageUI.ButtonWithStyle('Commencer le travaille', nil, {RightLabel = "→→"}, not working, function(Hovered, Active, Selected)
                                    if (Selected) then  
                                        working = true
                                        Notify("~g~Vous avez pris votre service.")
                                    end
                                end)
                                RageUI.ButtonWithStyle("Arrêter le travaille", nil, {RightLabel = "→→"}, working, function(Hovered, Active, Selected)
                                    if (Selected) then  
                                        working = false
                                        RemoveBlip(Blip)
                                        Notify("~r~Vous avez quitter votre service.")
                                    end
                                end) 
                            end)
                            Citizen.Wait(0)
                            if not RageUI.Visible(main) then
                            main = RMenu:DeleteType(main, true)
                        end
                    end
                end   
            end
        end

        if working then
            if Vdist(PlayPos.x, PlayPos.y, PlayPos.z, Fuel.Zone.PointStation) <= 15.0 then
                timer = 0
                DrawMarker(Fuel.Marker.Type, Fuel.Zone.PointStation.x,Fuel.Zone.PointStation.y,Fuel.Zone.PointStation.z-0.99, nil, nil, nil, -90, nil, nil, Fuel.Marker.Size.x, Fuel.Marker.Size.y, Fuel.Marker.Size.z, Fuel.Marker.Color.R, Fuel.Marker.Color.G, Fuel.Marker.Color.B, 200)
                if Vdist(PlayPos.x, PlayPos.y, PlayPos.z, Fuel.Zone.PointStation) <= 1.0 then
                    timer = 0
                    ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour accéder aux points des stations")
                    if IsControlJustPressed(1,51) then
                        local main = RageUI.CreateMenu('', 'Liste des stations')
                        RageUI.Visible(main, not RageUI.Visible(main))
                            while main do
                            Citizen.Wait(0)
                                RageUI.IsVisible(main, true, true, true, function()
                                    if (onMission or success) then
                                        RageUI.ButtonWithStyle("~r~Arrêter la mission", nil, {RightLabel = "→→"}, working, function(Hovered, Active, Selected)
                                            if (Selected) then  
                                                onMission = false
                                                RemoveBlip(Blip)
                                                DeleteVehicle(vehicle)
                                                DeleteVehicle(Remorque)
                                                Notify("~r~Vous avez arrêté la mission.")
                                                if (success) then
                                                    local salary = math.random(Fuel.MinSalary, Fuel.MaxSalary)
                                                    Notify("Vous avez gagné ~g~"..salary.."$.")
                                                    TriggerServerEvent("Fuel:Salary", salary)
                                                end
                                                success = false
                                            end
                                        end) 
                                        RageUI.Separator("")
                                    end
                                    for k,v in pairs(Fuel.Stations) do
                                        RageUI.List("Station N°~y~"..(k), {"Lancer mission", "Mettre GPS"}, Index, "ID : ~r~"..(v.id).."~s~\nNombre de litre(s) disponible(s) : ~b~"..(v.fuel or 0.0), {}, not onMission, function(Hovered, Active, Selected, _index)
                                            Index = _index
                                            if (Selected) then  
                                                if (Index == 1) then
                                                    RemoveBlip(Blip)
                                                    SpawnCarMission("phantom")
                                                    Notify("~g~Vous avez lancer une mission.")
                                                    currentId = v.id
                                                    onMission = true
                                                else
                                                    RemoveBlip(Blip)
                                                    Blip = AddBlipForCoord(v.pos)
                                                    SetBlipSprite(Blip, 1)
                                                    SetBlipColour(Blip, 2)
                                                    SetBlipRoute(Blip, true)
                                                    Notify("~g~Station d'essence mit sur votre GPS.")
                                                end
                                            end
                                        end) 
                                    end
                                end) 
                                if not RageUI.Visible(main) then
                                main = RMenu:DeleteType(main, true)
                            end
                        end
                    end   
                end
            end

            if Vdist(PlayPos.x, PlayPos.y, PlayPos.z, Fuel.Zone.RefuelPoint[position]) <= 15.0 and onMission then
                timer = 0
                DrawMarker(20, Fuel.Zone.RefuelPoint[position], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 250, 3, 200, 255, 0, 1, 2, 0, nil, nil, 0)
                if Vdist(PlayPos.x, PlayPos.y, PlayPos.z, Fuel.Zone.RefuelPoint[position]) <= 5.0 then
                    timer = 0
                    if IsPedSittingInAnyVehicle(PlayerPedId()) then
                        ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour attacher la remorque à votre camion")
                        if IsControlJustPressed(1,51) then
                            if IsInAuthorizedVehicle() then 
                                AttachVehicleToTrailer(vehicle, Remorque, 1.1)
                                Notify("Vous avez remorqué la bombonne, dirigez-vous à la station.")
                                onMission = false
                                local onFinishMission = true
                                Citizen.CreateThread(function()
                                    local station = getStation()
                                    while station == nil do Citizen.Wait(100) end
                                    RemoveBlip(Blip)
                                    Blip = AddBlipForCoord(station.pos)
                                    SetBlipSprite(Blip, 1)
                                    SetBlipColour(Blip, 2)
                                    SetBlipRoute(Blip, true)
                                    while onFinishMission do
                                        local _time = 800
                                        if (station ~= nil) then
                                            if Vdist(GetEntityCoords(PlayerPedId()), station.pos) <= 15.0 then
                                                _time = 0
                                                ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour remplir la station d'essence")
                                                if IsControlJustPressed(1,51) then
                                                    DetachVehicleFromTrailer(vehicle)
                                                    DeleteVehicle(Remorque)
                                                    Notify("~g~Vous avez rempli la station (~y~"..Fuel.FuelAddedOnStationMission.."~s~ litres), dirigez-vous à la rafinirie pour finir la mission.")
                                                    TriggerServerEvent("Fuel:AddStationFuel", Fuel.FuelAddedOnStationMission, currentId)
                                                    RemoveBlip(Blip)
                                                    Blip = AddBlipForCoord(Fuel.Zone.PointStation)
                                                    SetBlipSprite(Blip, 1)
                                                    SetBlipColour(Blip, 2)
                                                    SetBlipRoute(Blip, true)
                                                    success = true
                                                    onFinishMission = false
                                                end
                                            end
                                        end
                                        Citizen.Wait(_time)
                                    end
                                end)
                            else
                                Notify("Vous n'avez pas votre véhicule de service.")
                            end
                        end 
                    else
                        ShowHelpNotification("Vous devez être dans votre véhicule pour attacher la remorque")
                    end
                end
            end
        end
            
        Citizen.Wait(timer)
    end
end)
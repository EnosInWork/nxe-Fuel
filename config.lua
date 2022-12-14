Fuel = {

	UseESX = "esx:getSharedObject"; -- or nil for not used esx

	LiterList = {1, 10, 15, 20, 25, 50, 75, 100};
	LiterIndex = 1;

	PriceForOneLiter = 2;

	MaxSalary = 1000;
	MinSalary = 500;

	FuelAddedOnStationMission = 10.0;

	Stations = {
		{pos = vector3(264.95275878906,-1259.4567871094,29.142911911011), id = 1},
		{pos = vector3(819.61047363281,-1028.2071533203,26.404321670532), id = 2},
		{pos = vector3(1208.6068115234,-1402.2863769531,35.224140167236), id = 3},
		{pos = vector3(1180.9593505859,-329.84280395508,69.316436767578), id = 4},
		{pos = vector3(620.80499267578,268.73849487305,103.08948516846), id = 5},
		{pos = vector3(2581.1779785156,362.01254272461,108.46883392334), id = 6},
		{pos = vector3(175.55857849121,-1562.2135009766,29.264209747314), id = 7},
		{pos = vector3(-319.42581176758,-1471.8182373047,30.548692703247), id = 8},
		{pos = vector3(1785.9000244141,3330.9035644531,41.377250671387), id = 9},
		{pos = vector3(49.802303314209,2779.318359375,58.043937683105), id = 10},
		{pos = vector3(263.92358398438,2607.4140625,44.983062744141), id = 11},
		{pos = vector3(1039.1220703125,2671.30859375,39.550872802734), id = 12},
		{pos = vector3(1208.0380859375,2660.4892578125,37.899772644043), id = 13},
		{pos = vector3(2539.3337402344,2594.61328125,37.944820404053), id = 14},
		{pos = vector3(2679.9396972656,3264.0981445313,55.240585327148), id = 15},
		{pos = vector3(2005.0074462891,3774.2006835938,32.40393447876), id = 16},
		{pos = vector3(1687.263671875,4929.6328125,42.078086853027), id = 17},
		{pos = vector3(1702.0052490234,6416.9975585938,32.763767242432), id = 18},
		{pos = vector3(179.82470703125,6602.8408203125,31.868196487427), id = 19},
		{pos = vector3(-94.206100463867,6419.4975585938,31.489490509033), id = 20},
		{pos = vector3(-2555.1257324219,2334.2705078125,33.078022003174), id = 21},
		{pos = vector3(-1799.4152832031,802.8154296875,138.65368652344), id = 22},
		{pos = vector3(-1436.9724121094,-276.55426025391,46.207653045654), id = 23},
		{pos = vector3(-2096.5913085938,-321.48611450195,13.168619155884), id = 24},
		{pos = vector3(-723.298828125,-935.55322265625,19.213928222656), id = 25},
		{pos = vector3(-525.35266113281,-1211.3215332031,18.184829711914), id = 26},
		{pos = vector3(-70.514175415039,-1761.2590332031,29.655626296997), id = 27},
	};

	Zone = {
		Vestiaire = vector3(-588.81707763672,333.35189819336,85.092803955078),
		PointStation = vector3(-582.30328369141,332.36990356445,84.861320495605),
		SpawnPoint = vector3(-571.32794189453,334.42471313477,84.530090332031),
		SpawnHeading = 169.44, 
		RefuelPoint = {
			vector3(-2076.1225585938,-308.30545043945,13.145595550537),
		},
		SpawnRemorque = {
			vector3(-2074.8395996094,-302.30142211914,13.156882286072),
		},
		SpawnRemorqueHeading = 168.73,
		ListVeh = {
			{nom = "Phantom sans remorque", model = "phantom"},
		},
	};

	Language = {
		Exit_Vehicle_for_Add = "Sortez du v??hicule pour acheter de l'essence.",
		FullFuel = "~g~Votre r??servoir est plein",
		SuccessFuelAdd = "~g~Vous avez remplis votre v??hicule",
		StationNotHave = "~r~La station n'a pas assez d'essence !",
	};

	Marker = {
		Type = 6,
		Color = {R = 255, G = 0, B = 0},
		Size =  {x = 1.0, y = 1.0, z = 1.0},
		DrawDistance = 20,
		DrawInteract = 1.5, -- int??raction marker
	};

}
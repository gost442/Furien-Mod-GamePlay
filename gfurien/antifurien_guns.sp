
char G_AntiFurien_Guns[][] = 
{
	// Name On Menu, Weapon, How Many Cost
	"MAG7", "weapon_mag7", "100", 
	"Sawed-off", "weapon_sawedoff", "200", 
	"MP5", "weapon_mp5sd", "200", 
	"MP7", "weapon_mp7", "200", 
	"MP9", "weapon_mp9", "200", 
	"Mac-10", "weapon_mac10", "200", 
	"P90", "weapon_p90", "400", 
	"Famas", "weapon_famas", "400", 
	"Galil", "weapon_galilar", "700", 
	"Nova", "weapon_nova", "700", 
	"AWP", "weapon_awp", "1300", 
	"M4A4", "weapon_m4a1", "1800", 
	"M4A1-S", "weapon_m4a1_silencer", "2000", 
	"AK47", "weapon_ak47", "2000", 
	"XM1014", "weapon_xm1014", "2300", 
};

char G_AntiFurien_Secundary_Guns[][] = 
{
	// Name On Menu, Weapon, How Many Cost
	"Glock - Com Melancia", "weapon_glock", "100", 
	"P2000", "weapon_hkp2000", "100", 
	"USP", "weapon_usp_silencer", "200", 
	"P250", "weapon_p250", "200", 
	"Five-Seven", "weapon_fiveseven", "300", 
	"Tec-9", "weapon_tec9", "300", 
	"Deagle", "weapon_deagle", "500", 
	"Dual Barettas", "weapon_elite", "700", 
};

// All Guns ID in sequence up to down  G_AntiFurien_Guns + G_AntiFurien_Secundary_Guns
int G_AntiFurien_Weapons_Id[] = 
{
	27, 29, 23, 33, 34, 17, 19, 10, 13, 35, 9, 16, 60, 7, 25, 4, 32, 61, 36, 3, 30, 1, 2
};
// All Ammo Give in sequence up to down  G_AntiFurien_Guns + G_AntiFurien_Secundary_Guns
int G_AntiFurien_Weapons_Ammo_Secondary[] = 
{
	32, 32, 130, 130, 130, 130, 300, 200, 300, 60, 60, 350, 400, 400, 500, 40, 40, 40, 30, 30, 30, 30, 50
};

public void Menu_SelectWeapon(int client)
{
	char buffer[90], temp[60], ch_int[30];
	Menu menu = CreateMenu(h_AF_SelectWeapon);
	menu.SetTitle("Choise Your First Weapon\nYour Money: %i\n \n", Furien_GetClientMoney(client));
	for (int i; i < sizeof(G_AntiFurien_Guns); i += 3)
	{
		IntToString(i, ch_int, sizeof(ch_int));
		Format(temp, sizeof(temp), "[%s$]", G_AntiFurien_Guns[i + 2]);
		Format(buffer, sizeof(buffer), "%s %s", G_AntiFurien_Guns[i], StringToInt(G_AntiFurien_Guns[i + 2]) > 0 ? temp:"");
		menu.AddItem(ch_int, buffer, Furien_GetClientMoney(client) < StringToInt(G_AntiFurien_Guns[i + 2]) ? ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
	}
	menu.ExitButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public void Menu_SelectSecondaryWeapon(int client)
{
	char buffer[90], temp[60], ch_int[30];
	Menu menu = CreateMenu(h_AF_SelectSecondaryWeapon);
	menu.SetTitle("Choise Your Secundary Weapon\nYour Money: %i\n \n", Furien_GetClientMoney(client));
	for (int i; i < sizeof(G_AntiFurien_Secundary_Guns); i += 4)
	{
		
		IntToString(i, ch_int, sizeof(ch_int));
		Format(temp, sizeof(temp), "[%s$]", G_AntiFurien_Secundary_Guns[i + 2]);
		Format(buffer, sizeof(buffer), "%s %s", G_AntiFurien_Secundary_Guns[i], StringToInt(G_AntiFurien_Secundary_Guns[i + 2]) > 0 ? temp:"");
		menu.AddItem(ch_int, buffer, Furien_GetClientMoney(client) < StringToInt(G_AntiFurien_Secundary_Guns[i + 2]) ? ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
	}
	menu.Display(client, MENU_TIME_FOREVER);
	menu.ExitButton = true;
}


public int h_AF_SelectWeapon(Menu menu, MenuAction action, int client, int Position)
{
	if (IsValidClient(client, true))
	{
		if (GetClientTeam(client) == CS_TEAM_CT)
		{
			if (action == MenuAction_Select)
			{
				char Item[10];
				menu.GetItem(Position, Item, sizeof(Item));
				int index = StringToInt(Item);
				Furien_TakeClientMoney(client, StringToInt(G_AntiFurien_Guns[index + 2]));
				GivePlayerItem(client, G_AntiFurien_Guns[index + 1]);
				Menu_SelectSecondaryWeapon(client);
			}
		}
	}
}

public int h_AF_SelectSecondaryWeapon(Menu menu, MenuAction action, int client, int Position)
{
	if (IsValidClient(client, true))
	{
		if (GetClientTeam(client) == CS_TEAM_CT)
		{
			if (action == MenuAction_Select)
			{
				char Item[10];
				menu.GetItem(Position, Item, sizeof(Item));
				int index = StringToInt(Item);
				Furien_TakeClientMoney(client, StringToInt(G_AntiFurien_Secundary_Guns[index + 2]));
				GivePlayerItem(client, G_AntiFurien_Secundary_Guns[index + 1]);
			}
		}
	}
} 
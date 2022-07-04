public void Menu_F_Shop(int client)
{
	// i_bShop[client].Shop_HeGrenade < 3 this means you can buy 3 times he you can custumize by your self how mush time client can buy he and other itens of shop
	char buffer[128];
	int i_Money = Furien_GetClientMoney(client);
	
	Menu menu = CreateMenu(m_F_Shop);
	menu.SetTitle("Furien Shop\nYour Money: %i\n \n", i_Money);
	
	Format(buffer, sizeof(buffer), "HE - %i$", i_F_Shop.F_Item_HeGrenade);
	menu.AddItem("hegrenade", buffer, (i_bShop[client].Shop_HeGrenade < 3 && i_Money >= i_F_Shop.F_Item_HeGrenade) ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	
	Format(buffer, sizeof(buffer), "Molotof - %i$", i_F_Shop.F_Item_Molotov);
	menu.AddItem("molotof", buffer, (i_bShop[client].Shop_Molotov < 2 && i_Money >= i_F_Shop.F_Item_Molotov) ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	
	Format(buffer, sizeof(buffer), "+50 HP - %i$", i_F_Shop.F_Item_50hp);
	menu.AddItem("50hp", buffer, (i_bShop[client].Shop_50hp < 3 && i_Money >= i_F_Shop.F_Item_50hp) ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	
	Format(buffer, sizeof(buffer), "Regenerate HP - %i$", i_F_Shop.F_Item_RegenerateHP);
	menu.AddItem("RegenerateHP", buffer, i_bShop[client].Shop_RegenerateHP < 1 && i_Money >= i_F_Shop.F_Item_RegenerateHP ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	
	Format(buffer, sizeof(buffer), "Knife Level 1 +DMG - %i$", i_F_Shop.F_Item_knife_level_1);
	menu.AddItem("knife_level_1", buffer, (i_bShop[client].Shop_knife_level_1 < 1 && i_Money >= i_F_Shop.F_Item_knife_level_1) ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	
	Format(buffer, sizeof(buffer), "Knife Level 2 ++DMG - %i$", i_F_Shop.F_Item_knife_level_2);
	menu.AddItem("knife_level_2", buffer, i_bShop[client].Shop_knife_level_2 < 1 && i_Money >= i_F_Shop.F_Item_knife_level_2 ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	
	menu.ExitButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int m_F_Shop(Menu menu, MenuAction action, int client, int Position)
{
	if (IsValidClient(client, true))
	{
		if (action == MenuAction_Select)
		{
			if (GetClientTeam(client) == CS_TEAM_T)
			{
				char Item[20];
				menu.GetItem(Position, Item, sizeof(Item));
				if (StrEqual(Item, "hegrenade"))
				{
					GivePlayerItem(client, "weapon_hegrenade");
					Furien_TakeClientMoney(client, i_F_Shop.F_Item_HeGrenade);
					i_bShop[client].Shop_HeGrenade++;
				}
				if (StrEqual(Item, "molotof"))
				{
					GivePlayerItem(client, "weapon_molotov");
					Furien_TakeClientMoney(client, i_F_Shop.F_Item_Molotov);
					i_bShop[client].Shop_Molotov++;
				}
				if (StrEqual(Item, "50hp"))
				{
					if (GetClientHealth(client) < Max_Health[client])
					{
						if (GetClientHealth(client) + 50 >= Max_Health[client])
						{
							SetEntityHealth(client, Max_Health[client]);
						}
						else
						{
							SetEntityHealth(client, GetClientHealth(client) + 50);
							Furien_TakeClientMoney(client, i_F_Shop.F_Item_50hp);
							i_bShop[client].Shop_50hp++;
						}
					}
				}
				if (StrEqual(Item, "RegenerateHP"))
				{
					bRegenerateHP[client] = true;
					Furien_TakeClientMoney(client, i_F_Shop.F_Item_RegenerateHP);
					i_bShop[client].Shop_RegenerateHP++;
				}
				if (StrEqual(Item, "knife_level_1"))
				{
					bKnife_level_1[client] = true;
					bKnife_level_2[client] = false;
					Furien_TakeClientMoney(client, i_F_Shop.F_Item_knife_level_1);
					i_bShop[client].Shop_knife_level_1++;
				}
				if (StrEqual(Item, "knife_level_2"))
				{
					bKnife_level_2[client] = true;
					bKnife_level_1[client] = false;
					Furien_TakeClientMoney(client, i_F_Shop.F_Item_knife_level_2);
					i_bShop[client].Shop_knife_level_2++;
				}
			}
		}
		SetEntProp(client, Prop_Send, "m_iHideHUD", SHOWHUD_RADAR);
	}
	return 0;
} 

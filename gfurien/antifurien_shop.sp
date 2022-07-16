
public void Menu_AF_Shop(int client)
{
	char buffer[64];
	int i_Money = Furien_GetClientMoney(client);
	
	Menu menu = CreateMenu(m_AF_Shop);
	menu.SetTitle("Anti-Furien Shop\nYour Money: %i$\n \n", i_Money);
	
	Format(buffer, sizeof(buffer), "Defuse Kit - %i$", i_AF_Shop.AF_Item_Defuse);
	menu.AddItem("defuse", buffer, (GetClientDefuse(client) != 1 && i_Money >= i_AF_Shop.AF_Item_Defuse) ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	
	Format(buffer, sizeof(buffer), "+100 AP - %i$", i_AF_Shop.AF_Item_100ap);
	menu.AddItem("100ap", buffer, (GetClientArmor(client) != 100 && i_Money >= i_AF_Shop.AF_Item_100ap) ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	
	Format(buffer, sizeof(buffer), "+50 HP - %i$", i_AF_Shop.AF_Item_50hp);
	menu.AddItem("50hp", buffer, (i_bShop[client].Shop_50hp < 4 && i_Money >= i_AF_Shop.AF_Item_50hp) ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	
	Format(buffer, sizeof(buffer), "Furien Laser - %i$", i_AF_Shop.AF_Item_Furien_Laser);
	menu.AddItem("Furien_Laser", buffer, (i_bShop[client].Shop_Furien_Laser < 1 && i_Money >= i_AF_Shop.AF_Item_Furien_Laser) ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	
	Format(buffer, sizeof(buffer), "Regenerate HP - %i$", i_AF_Shop.AF_Item_RegenerateHP);
	menu.AddItem("AT_RegenerateHP", buffer, i_bShop[client].Shop_RegenerateHP < 1 && i_Money >= i_AF_Shop.AF_Item_RegenerateHP ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	
	Format(buffer, sizeof(buffer), "Tactical Granade - %i$", i_AF_Shop.AF_Item_Tactical_Granade);
	menu.AddItem("TacticalGranade", buffer, i_bShop[client].Shop_Tactical_Granade < 2 && i_Money >= i_AF_Shop.AF_Item_Tactical_Granade ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	menu.ExitButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int m_AF_Shop(Menu menu, MenuAction action, int client, int Position)
{
	if (IsValidClient(client, true))
	{
		if (action == MenuAction_Select)
		{
			if (GetClientTeam(client) == CS_TEAM_CT)
			{
				char Item[20];
				menu.GetItem(Position, Item, sizeof(Item));
				if (StrEqual(Item, "defuse"))
				{
					SetEntProp(client, Prop_Send, "m_bHasDefuser", 1);
					Furien_TakeClientMoney(client, i_AF_Shop.AF_Item_Defuse);
					
					CPrintToChat(client, "\x02[AntiFurien-Shop] \x01You buy \x04Defuse Kit!");
				}
				if (StrEqual(Item, "100ap"))
				{
					SetEntProp(client, Prop_Send, "m_ArmorValue", 100);
					SetEntProp(client, Prop_Send, "m_bHasHelmet", 1);
					Furien_TakeClientMoney(client, i_AF_Shop.AF_Item_100ap);
					
					CPrintToChat(client, "\x02[AntiFurien-Shop] \x01You buy \x04+100AP!");
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
						}
						
						Furien_TakeClientMoney(client, i_AF_Shop.AF_Item_50hp);
						i_bShop[client].Shop_50hp++;
							
						CPrintToChat(client, "\x02[AntiFurien-Shop] \x01You buy \x04+50hp!");
					}
					else
					{
					CPrintToChat(client, "You Have Max Health");
					}
				}
				
				if (StrEqual(Item, "Furien_Laser"))
				{
					bFurien_Laser[client] = true;
					Furien_TakeClientMoney(client, i_AF_Shop.AF_Item_Furien_Laser);
					i_bShop[client].Shop_Furien_Laser++;
					
					CPrintToChat(client, "\x02[AntiFurien-Shop] \x01You buy \x04Furien Laser!");
				}
				if (StrEqual(Item, "AT_RegenerateHP"))
				{
					bRegenerateHP[client] = true;
					Furien_TakeClientMoney(client, i_AF_Shop.AF_Item_RegenerateHP);
					i_bShop[client].Shop_RegenerateHP++;
					
					CPrintToChat(client, "\x02[AntiFurien-Shop] \x01You buy \x04Regenerare Hp!");
				}
				if (StrEqual(Item, "TacticalGranade"))
				{
					GivePlayerItem(client, "weapon_tagrenade");
					Furien_TakeClientMoney(client, i_AF_Shop.AF_Item_Tactical_Granade);
					i_bShop[client].Shop_Tactical_Granade++;
					
					CPrintToChat(client, "\x02[AntiFurien-Shop] \x01You buy \x04TaticalGranade!");
				}
			}
		}
	}
	return 0;
} 

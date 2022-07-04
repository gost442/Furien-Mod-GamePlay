public Action Command_BlockRadio(int client, const char[] command, int args)
{
	return Plugin_Handled;
}
public Action Command_Kill(int client, const char[] command, int args)
{
	return Plugin_Handled;
}

public Action Command_Guns(int client, int args)
{
	if (IsValidClient(client))
	{
		if (IsPlayerAlive(client) && GetClientTeam(client) == CS_TEAM_CT)
		{
			SetEntProp(client, Prop_Send, "m_iHideHUD", HIDEHUD_RADAR);
			Menu_SelectWeapon(client);
		}
	}
	return Plugin_Handled;
}

public Action Command_Shop(int client, int args)
{
	if (IsValidClient(client))
	{
		if (IsPlayerAlive(client))
		{
			if (GetClientTeam(client) == CS_TEAM_CT)
			{
				Menu_AF_Shop(client);
			}
			if (GetClientTeam(client) == CS_TEAM_T)
			{
				Menu_F_Shop(client);
			}
			SetEntProp(client, Prop_Send, "m_iHideHUD", HIDEHUD_RADAR);
		}
	}
	return Plugin_Handled;
} 

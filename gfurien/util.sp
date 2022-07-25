stock bool IsClientMoveButtonsPressed(int client)
{
	int buttons = GetClientButtons(client);
	return (buttons & IN_FORWARD || buttons & IN_BACK || buttons & IN_MOVELEFT || buttons & IN_MOVERIGHT);
}

public Action CreateBeam(any client)
{
	int target = TraceClientViewEntity(client);
	float f_playerViewOrigin[3];
	GetClientAbsOrigin(client, f_playerViewOrigin);
	if (GetClientButtons(client) & IN_DUCK)
		f_playerViewOrigin[2] += 40;
	else
		f_playerViewOrigin[2] += 60;
	
	float f_playerViewDestination[3];
	GetPlayerEye(client, f_playerViewDestination);
	
	float distance = GetVectorDistance(f_playerViewOrigin, f_playerViewDestination);
	
	float percentage = 0.4 / (distance / 100);
	
	float f_newPlayerViewOrigin[3];
	f_newPlayerViewOrigin[0] = f_playerViewOrigin[0] + ((f_playerViewDestination[0] - f_playerViewOrigin[0]) * percentage);
	f_newPlayerViewOrigin[1] = f_playerViewOrigin[1] + ((f_playerViewDestination[1] - f_playerViewOrigin[1]) * percentage) - 0.08;
	f_newPlayerViewOrigin[2] = f_playerViewOrigin[2] + ((f_playerViewDestination[2] - f_playerViewOrigin[2]) * percentage);
	
	int color[4];
	if (target > 0 && target <= MaxClients && GetClientTeam(target) == CS_TEAM_T)
	{
		color[0] = 255;
		color[1] = 0;
		color[2] = 0;
		color[3] = 200;
	}
	else
	{
		color[0] = 0;
		color[1] = 255;
		color[2] = 0;
		color[3] = 200;
	}
	
	float life;
	life = 0.1;
	
	float width;
	width = 0.48;
	float dotWidth;
	dotWidth = 0.12;
	
	TE_SetupBeamPoints(f_newPlayerViewOrigin, f_playerViewDestination, NC_GunFurien_LaserSprite, 0, 0, 0, life, width, 0.0, 1, 0.0, color, 0);
	TE_SendToAll();
	
	TE_SetupGlowSprite(f_playerViewDestination, NC_GunGlowSprite, life, dotWidth, color[3]);
	TE_SendToAll();
	
	return Plugin_Continue;
}


public int TraceClientViewEntity(int client)
{
	float m_vecOrigin[3];
	float m_angRotation[3];
	
	GetClientEyePosition(client, m_vecOrigin);
	GetClientEyeAngles(client, m_angRotation);
	
	Handle tr = TR_TraceRayFilterEx(m_vecOrigin, m_angRotation, MASK_VISIBLE, RayType_Infinite, TRDontHitSelf, client);
	int pEntity = -1;
	
	if (TR_DidHit(tr))
	{
		pEntity = TR_GetEntityIndex(tr);
		CloseHandle(tr);
		return pEntity;
	}
	
	if (tr != INVALID_HANDLE)
	{
		CloseHandle(tr);
	}
	
	return -1;
}



public bool TRDontHitSelf(int entity, int contentsMask, any client)
{
	return entity != client;
}


public Action Timer_CTRefillAmmo(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (IsValidClient(client, true))
	{
		if (GetClientTeam(client) == CS_TEAM_CT)
		{
			int cWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
			if (IsValidEntity(cWeapon))
			{
				int iWeaponindex = GetEntProp(cWeapon, Prop_Send, "m_iItemDefinitionIndex");
				for (int i; i < sizeof(G_AntiFurien_Weapons_Id); i++)
				{
					if (iWeaponindex == G_AntiFurien_Weapons_Id[i])
					{
						SetEntProp(cWeapon, Prop_Send, "m_iPrimaryReserveAmmoCount", G_AntiFurien_Weapons_Ammo_Secondary[i]);
						break;
					}
				}
			}
		}
		else
		{
			return Plugin_Stop;
		}
	}
	else
	{
		return Plugin_Stop;
	}
	return Plugin_Continue;
}



stock int[] Beacon_RandomColor()
{
	int color[4];
	color[0] = GetRandomInt(1, 255);
	color[1] = GetRandomInt(1, 255);
	color[2] = GetRandomInt(1, 255);
	color[3] = 255;
	return color;
}

stock bool GetPlayerEyeViewPoint(int client, float pos[3])
{
	float f_Angles[3];
	float f_Origin[3];
	GetClientEyeAngles(client, f_Angles);
	GetClientEyePosition(client, f_Origin);
	Handle h_TraceFilter = TR_TraceRayFilterEx(f_Origin, f_Angles, MASK_SOLID, RayType_Infinite, TraceEntityFilterPlayer);
	if (TR_DidHit(h_TraceFilter))
	{
		TR_GetEndPosition(pos, h_TraceFilter);
		CloseHandle(h_TraceFilter);
		return true;
	}
	CloseHandle(h_TraceFilter);
	return false;
}

public bool TraceEntityFilterPlayer(int iEntity, int iContentsMask)
{
	return iEntity > MaxClients;
}
public bool TraceRayTryToHit(int entity, int mask)
{
	if (entity > 0 && entity <= MaxClients)
	{
		return false;
	}
	return true;
}
stock void F_GetEntityRenderColor(int entity, int color[4])
{
	static bool gotconfig = false;
	static char prop[32];
	
	if (!gotconfig) {
		Handle gc = LoadGameConfigFile("core.games");
		bool exists = GameConfGetKeyValue(gc, "m_clrRender", prop, sizeof(prop));
		CloseHandle(gc);
		
		if (!exists) {
			strcopy(prop, sizeof(prop), "m_clrRender");
		}
		
		gotconfig = true;
	}
	
	int offset = GetEntSendPropOffs(entity, prop);
	
	if (offset <= 0) {
		ThrowError("SetEntityRenderColor not supported by this mod");
	}
	
	for (int i = 0; i < 4; i++)
	{
		color[i] = GetEntData(entity, offset + i, 1);
	}
}

public int SlotByName(int client, const char[] szName)
{
	char szClassname[36];
	int entity = -1;
	
	for (int i; i <= 5; i++)
	{
		if ((entity = GetPlayerWeaponSlot(client, i)) <= MaxClients || !IsValidEntity(entity))
			continue;
		
		GetEntityClassname(entity, szClassname, sizeof szClassname);
		
		if (strcmp(szName, szClassname) == 0)
			return i;
	}
	
	return -1;
}

public void delete_shadow()
{
	int i = -1;
	while ((i = FindEntityByClassname(i, "env_cascade_light")) != -1) {
		AcceptEntityInput(i, "Kill");
	}
	
} 

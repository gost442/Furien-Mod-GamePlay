stock void Furien_TakeClientMoney(int client, int amount)
{
	int money = GetEntProp(client, Prop_Send, "m_iAccount");
	money = money - amount;
	SetEntProp(client, Prop_Send, "m_iAccount", money);
}
stock int Furien_GetClientMoney(int client)
{
	return GetEntProp(client, Prop_Send, "m_iAccount");
}
stock void Furien_AddClientMoney(int client, int amount)
{
	int money = GetEntProp(client, Prop_Send, "m_iAccount");
	money = money + amount;
	money = money > 16000 ? 16000 : money;
	SetEntProp(client, Prop_Send, "m_iAccount", money);
}

stock bool GetPlayerEye(int client, float pos[3])
{
	float vAngles[3];
	float vOrigin[3];
	GetClientEyePosition(client, vOrigin);
	GetClientEyeAngles(client, vAngles);
	
	Handle trace = TR_TraceRayFilterEx(vOrigin, vAngles, MASK_SHOT, RayType_Infinite, TRDontHitSelf, client);
	
	if (TR_DidHit(trace))
	{
		TR_GetEndPosition(pos, trace);
		CloseHandle(trace);
		return true;
	}
	CloseHandle(trace);
	return false;
}

public void ResetItems(int client)
{
	bFurien_Laser[client] = false;
	bRegenerateHP[client] = false;
	bKnife_level_1[client] = false;
	bKnife_level_2[client] = false;
}



public Action Timer_BombBeacon(Handle timer, any index)
{
	TE_SetupBeamRingPoint(f_BombBeaconPos, 1.0, cVf_BombBeacon_Radius, i_BeamIndex, -1, 0, 32, cVf_BombBeacon_Life, cVf_BombBeacon_Width, 1.0, cVb_BombBeacon_RandomColor ? Beacon_RandomColor():cVi_BombBeacon_Color, 0, 0);
	TE_SendToAll();
	return Plugin_Continue;
}
public Action Timer_CTSpawnPost(Handle timer, any client)
{
	SetEntProp(client, Prop_Send, "m_iHideHUD", GetEntProp(client, Prop_Send, "m_iHideHUD") | HIDE_RADAR);
	if (IsWarmUp() == false)
	{
		Menu_SelectWeapon(client);
	}
	return Plugin_Stop;
}


stock bool IsClientInAir(int client, int flags)
{
	return !(flags & FL_ONGROUND || b_ClientWallHang[client]);
}
stock bool IsClientNotMoving(int buttons)
{
	return !IsMoveButtonsPressed(buttons);
}
stock bool IsMoveButtonsPressed(int buttons)
{
	return buttons & IN_FORWARD || buttons & IN_BACK || buttons & IN_MOVELEFT || buttons & IN_MOVERIGHT;
}


stock bool IsClientVIP(int client, AdminFlag type)
{
	if (GetAdminFlag(GetUserAdmin(client), type))
	{
		return true;
	}
	return false;
}

stock int GetLastPlayerOfTeam(int team)
{
	int lastclient = 0;
	LoopAliveClients(i)
	{
		if (GetClientTeam(i) == team)
		{
			lastclient = i;
			break;
		}
	}
	return lastclient;
}

stock void ChangeTeamScore(int index, int score)
{
	CS_SetTeamScore(index, score);
	SetTeamScore(index, score);
}
stock void StripAllWeapons(int client)
{
	int ent;
	for (int i = 0; i <= 4; i++)
	{
		while ((ent = GetPlayerWeaponSlot(client, i)) != -1)
		{
			RemovePlayerItem(client, ent);
			RemoveEdict(ent);
		}
	}
}
stock void StripWeapons(int client)
{
	int wepIdx;
	for (int x = 0; x <= 5; x++)
	{
		if (x != 2 && (wepIdx = GetPlayerWeaponSlot(client, x)) != -1)
		{
			RemovePlayerItem(client, wepIdx);
			RemoveEdict(wepIdx);
		}
	}
}

stock void RoundStartVariableUpdate(int client)
{
	i_bShop[client].Shop_50hp = 0;
	i_bShop[client].Shop_Furien_Laser = 0;
	i_bShop[client].Shop_RegenerateHP = 0;
	i_bShop[client].Shop_Tactical_Granade = 0;
	i_bShop[client].Shop_HeGrenade = 0;
	i_bShop[client].Shop_knife_level_2 = 0;
	i_bShop[client].Shop_mariawild = 0;
	i_bShop[client].Shop_knife_level_1 = 0;
	i_bShop[client].Shop_terrasdodemo = 0;
	i_bShop[client].Shop_balaspotentes = 0;
	i_bShop[client].Shop_Molotov = 0;
	i_bShop[client].Shop_Wallhang = 0;
	
}

stock int CountPlayersInTeam(int team = 0)
{
	int x = 0;
	LoopClients(i)
	{
		if (team != 0)
		{
			if (GetClientTeam(i) == team)
			{
				x++;
			}
		}
		else
		{
			x++;
		}
	}
	return x;
}
stock int CountAlivePlayersInTeam(int team = 0)
{
	int x = 0;
	LoopAliveClients(i)
	{
		if (team != 0)
		{
			if (GetClientTeam(i) == team)
			{
				x++;
			}
		}
		else
		{
			x++;
		}
	}
	return x;
}
stock bool IsWarmUp()
{
	if (GameRules_GetProp("m_bWarmupPeriod") == 1)
	{
		return true;
	}
	return false;
}
stock int GetClientDefuse(int client)
{
	return GetEntProp(client, Prop_Send, "m_bHasDefuser");
}
stock void FadeClient(int client, int r = 0, int g = 0, int b = 0, int a = 0)
{
	#define FFADE_STAYOUT 0x0008
	#define	FFADE_PURGE 0x0010
	Handle hFadeClient = StartMessageOne("Fade", client);
	if (GetUserMessageType() == UM_Protobuf)
	{
		int color[4];
		color[0] = r;
		color[1] = g;
		color[2] = b;
		color[3] = a;
		PbSetInt(hFadeClient, "duration", 0);
		PbSetInt(hFadeClient, "hold_time", 0);
		PbSetInt(hFadeClient, "flags", (FFADE_PURGE | FFADE_STAYOUT));
		PbSetColor(hFadeClient, "clr", color);
	}
	else
	{
		BfWriteShort(hFadeClient, 0);
		BfWriteShort(hFadeClient, 0);
		BfWriteShort(hFadeClient, (FFADE_PURGE | FFADE_STAYOUT));
		BfWriteByte(hFadeClient, r);
		BfWriteByte(hFadeClient, g);
		BfWriteByte(hFadeClient, b);
		BfWriteByte(hFadeClient, a);
	}
	EndMessage();
}


stock void SetCvarStr(char[] scvar, char[] svalue)
{
	SetConVarString(FindConVar(scvar), svalue, true);
}
stock void SetCvarInt(char[] scvar, int svalue)
{
	SetConVarInt(FindConVar(scvar), svalue, true);
}
stock void SetCvarFloat(char[] scvar, float svalue)
{
	SetConVarFloat(FindConVar(scvar), svalue, true);
}

stock void GetConVarColor(ConVar &convar, int color[4])
{
	char buffer[32];
	char e_buffer[4][24];
	GetConVarString(convar, buffer, sizeof(buffer));
	if (ExplodeString(buffer, " ", e_buffer, sizeof(e_buffer), sizeof(e_buffer[])) == 4)
	{
		color[0] = StringToInt(e_buffer[0]);
		color[1] = StringToInt(e_buffer[1]);
		color[2] = StringToInt(e_buffer[2]);
		color[3] = StringToInt(e_buffer[3]);
	}
}

stock void WipeHandle(Handle &handle)
{
	if (handle != null)
	{
		CloseHandle(handle);
		handle = null;
	}
}


stock bool IsValidClient(int client, bool alive = false)
{
	if (0 < client && client <= MaxClients && IsClientInGame(client) && IsFakeClient(client) == false && (alive == false || IsPlayerAlive(client)))
	{
		return true;
	}
	return false;
} 

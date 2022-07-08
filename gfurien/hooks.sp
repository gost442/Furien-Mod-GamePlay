
public Action Event_OnRoundPreStart(Event event, const char[] name, bool dontBroadcast)
{
	if (b_F_RoundSwtichTeams)
	{
		int ctscore = CS_GetTeamScore(CS_TEAM_CT);
		int tscore = CS_GetTeamScore(CS_TEAM_T);
		ChangeTeamScore(CS_TEAM_T, ctscore);
		ChangeTeamScore(CS_TEAM_CT, tscore);
		i_F_RoundWinStream = 0;
		LoopClients(i)
		{
			if (IsValidClient(i))
			{
				if (GetClientTeam(i) == CS_TEAM_CT)
				{
					CS_SwitchTeam(i, CS_TEAM_T);
					ResetItems(i);
				}
				else if (GetClientTeam(i) == CS_TEAM_T)
				{
					CS_SwitchTeam(i, CS_TEAM_CT);
					ResetItems(i);
				}
			}
		}
		b_F_RoundSwtichTeams = false;
	}
	return Plugin_Continue;
}
public Action Event_OnRoundStart(Event event, const char[] name, bool dontBroadcast)
{
	
	SetCvarInt("sv_enablebunnyhopping", 1);
	SetCvarInt("sv_staminamax", 0);
	SetCvarInt("sv_staminajumpcost", 0);
	SetCvarInt("sv_staminalandcost", 0);
	
	if (cVi_DisableBomb > -1)
	{
		int index = -1;
		while ((index = FindEntityByClassname(index, "func_bomb_target")) != -1)
		{
			AcceptEntityInput(index, "Disable");
			if (cVi_DisableBomb > 0)
			{
				f_DisableBomb = GetEngineTime();
				b_DisableBomb = true;
			}
		}
	}
	if (cVb_BombBeacon == true)
	{
		WipeHandle(h_BombBeacon);
	}
	return Plugin_Continue;
}
public Action Event_OnRoundEnd(Event event, const char[] name, bool dontBroadcast)
{
	int winner = event.GetInt("winner");
	b_DisableBomb = false;
	
	WipeHandle(h_BombBeacon);
	if (winner == CS_TEAM_CT)
	{
		i_F_RoundWinStream++;
		if (i_F_RoundWinStream <= 1)
		{
			char buffer[512];
			Format(buffer, sizeof(buffer), "<font color='#0066cc'><b>Anti-Furiens WIN</b></font>");
			Format(buffer, sizeof(buffer), "%s\n<font color='#2cf812'><b>| SwitchSides |</b></font>", buffer);
			PrintHintTextToAll(buffer);
			if (i_F_RoundWinStream == 1)
			{
				PrintHintTextToAll(buffer);
				b_F_RoundSwtichTeams = true;
				if (IsWarmUp() == false)
				{
					LoopClients(i)
					{
						if (GetClientTeam(i) == CS_TEAM_CT)
						{
							Furien_AddClientMoney(i, WINNER_FURIEN_3STREAK);
						}
						SetEntProp(i, Prop_Send, "m_iHideHUD", SHOWHUD_RADAR);
					}
				}
			}
		}
		else b_F_RoundSwtichTeams = false;
	}
	else if (winner == CS_TEAM_T)
	{
		char buffer[512];
		Format(buffer, sizeof(buffer), "<font color='#d43556' size='20'><b>Furiens WINS</b></font>");
		PrintHintTextToAll(buffer);
		i_F_RoundWinStream = 0;
		b_F_RoundSwtichTeams = false;
	}
	return Plugin_Continue;
}
public Action Event_OnPlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (IsValidClient(client, true))
	{
		StripWeapons(client);
		RoundStartVariableUpdate(client);
		SetEntityMoveType(client, MOVETYPE_WALK);
		SetEntityRenderMode(client, RENDER_TRANSCOLOR);
		SetEntityRenderColor(client);
		b_ClientWallHang[client] = false;
		b_ClientMovedAfterSpawn[client] = false;
		if (GetClientTeam(client) == CS_TEAM_CT)
		{
			Furien_AddClientMoney(client, MONEY_GIVE_ANTIFURIEN_IN_SPAWN);
			CreateTimer(0.2, Timer_CTSpawnPost, client);
			CreateTimer(1.0, Timer_CTRefillAmmo, GetClientUserId(client), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
			GivePlayerItem(client, "weapon_flashbang");
			SetEntityGravity(client, 1.0);
			SetEntProp(client, Prop_Send, "m_ArmorValue", 50);
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.0);
			Max_Health[client] = 200;
			MaxHealth[client] = 135;
		}
		if (GetClientTeam(client) == CS_TEAM_T)
		{
			Furien_AddClientMoney(client, MONEY_GIVE_FURIEN_IN_SPAWN);
			SetEntProp(client, Prop_Send, "m_ArmorValue", 50);
			SetEntProp(client, Prop_Send, "m_bHasHelmet", 0);
			FadeClient(client);
			MaxHealth[client] = 115;
			Max_Health[client] = 150;
		}
		if (SlotByName(client, "weapon_knife") == -1)
		{
			GivePlayerItem(client, "weapon_knife");
		}
	}
	return Plugin_Continue;
}
public Action Event_OnPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int victim = GetClientOfUserId(event.GetInt("userid"));
	int attacker = GetClientOfUserId(event.GetInt("attacker"));
	if (IsValidClient(victim))
	{
		if (IsValidClient(attacker))
		{
			if (IsWarmUp() == false)
			{
				if (GetClientTeam(victim) != GetClientTeam(attacker))
				{
					
					if (GetClientTeam(victim) == CS_TEAM_T)
					{
						Furien_AddClientMoney(attacker, ANTIFURIEN_KILL_MONEY);
					}
					if (GetClientTeam(victim) == CS_TEAM_CT)
					{
						Furien_AddClientMoney(attacker, FURIEN_KILL_MONEY);
					}
				}
			}
		}
	}
	ResetItems(victim);
	return Plugin_Continue;
}
public void Event_OnPlayerHurt(Event event, const char[] name, bool dontbroadcast)
{
	int victim = GetClientOfUserId(event.GetInt("userid"));
	int attacker = GetClientOfUserId(event.GetInt("attacker"));
	if (IsValidClient(victim))
	{
		if (IsValidClient(attacker))
		{
			if (GetClientTeam(attacker) != GetClientTeam(victim))
			{
				if (GetClientTeam(attacker) == CS_TEAM_CT)
				{
					float f_vector[3];
					GetEntPropVector(victim, Prop_Data, "m_vecVelocity", f_vector);
					NormalizeVector(f_vector, f_vector);
					ScaleVector(f_vector, 230.0);
					TeleportEntity(victim, NULL_VECTOR, NULL_VECTOR, f_vector);
				}
			}
		}
	}
}
public Action Event_OnPlayerPreTeam(Event event, const char[] name, bool dontbroadcast)
{
	dontbroadcast = true;
	return Plugin_Changed;
}
public Action Event_OnBombPlanted(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (IsWarmUp() == false)
	{
		Furien_AddClientMoney(client, FURIEN_BOMB_PLANTED);
	}
	if (cVb_BombBeacon == true)
	{
		int index = -1;
		while ((index = FindEntityByClassname(index, "planted_c4")) != -1)
		{
			GetEntPropVector(index, Prop_Send, "m_vecOrigin", f_BombBeaconPos);
			h_BombBeacon = CreateTimer(cVf_BombBeacon_Delay, Timer_BombBeacon, index, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	return Plugin_Continue;
}

public Action Event_OnBombDefused(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (IsWarmUp() == false)
	{
		Furien_AddClientMoney(client, FURIEN_BOMB_DEFUSED);
	}
	if (cVb_BombBeacon == true)
	{
		WipeHandle(h_BombBeacon);
	}
	return Plugin_Continue;
}
public Action Event_OnBombExploded(Event event, const char[] name, bool dontBroadcast)
{
	if (cVb_BombBeacon == true)
	{
		WipeHandle(h_BombBeacon);
	}
	return Plugin_Continue;
}

public Action OnNormalSoundPlayed(int clients[64], int &numClients, char sample[PLATFORM_MAX_PATH], int &entity, int &channel, float &volume, int &level, int &pitch, int &flags)
{
	if (cVb_Footsteps == true)
	{
		if (StrContains(sample, "land") != -1)
		{
			return Plugin_Stop;
		}
		if (entity && entity <= MaxClients && StrContains(sample, "footsteps") != -1)
		{
			if (GetClientTeam(entity) == CS_TEAM_CT)
			{
				EmitSoundToAll(sample, entity, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.5);
				return Plugin_Handled;
			}
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}

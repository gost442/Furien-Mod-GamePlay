
public void EventSDK_OnClientThink(int client)
{
	if (IsValidClient(client))
	{
		if (IsPlayerAlive(client))
		{
			if (GetClientTeam(client) == CS_TEAM_T)
			{
				SetEntityGravity(client, cVf_Gravity);
				SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", cVf_Speed);
			}
		}
	}
}
public void EventSDK_OnPostThinkPost(int client)
{
	if (IsValidClient(client, true))
	{
		SetEntProp(client, Prop_Send, "m_bInBuyZone", 0);
		if (GetClientTeam(client) == CS_TEAM_T)
		{
			SetEntProp(client, Prop_Send, "m_iAddonBits", 0);
		}
		else if (GetClientTeam(client) == CS_TEAM_CT)
		{
			SetEntProp(client, Prop_Send, "m_iAddonBits", 1);
		}
	}
}

public Action EventSDK_OnWeaponCanUse(int client, int weapon)
{
	if (IsValidClient(client, true))
	{
		if (GetClientTeam(client) == CS_TEAM_T)
		{
			if (IsValidEntity(weapon))
			{
				char s_weapon[128];
				GetEntityClassname(weapon, s_weapon, sizeof(s_weapon));
				if (StrEqual(s_weapon, "weapon_knife"))
				{
					return Plugin_Continue;
				}
				else if (StrEqual(s_weapon, "weapon_hegrenade"))
				{
					return Plugin_Continue;
				}
				else if (StrEqual(s_weapon, "weapon_molotov"))
				{
					return Plugin_Continue;
				}
				else if (StrEqual(s_weapon, "weapon_c4"))
				{
					return Plugin_Continue;
				}
				else if (StrEqual(s_weapon, "weapon_taser"))
				{
					return Plugin_Continue;
				}
				else if (StrEqual(s_weapon, "weapon_healthshot"))
				{
					return Plugin_Continue;
				}
				else return Plugin_Handled;
			}
		}
		else if (GetClientTeam(client) == CS_TEAM_CT)
		{
			if (IsValidEntity(weapon))
			{
				char s_weapon[128];
				GetEntityClassname(weapon, s_weapon, sizeof(s_weapon));
				if (StrEqual(s_weapon, "weapon_taser"))
				{
					return Plugin_Handled;
				}
				else return Plugin_Continue;
			}
		}
	}
	return Plugin_Continue;
}
public Action EventSDK_OnTraceAttack(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &ammotype, int hitbox, int hitgroup)
{
	if (IsValidClient(victim) && IsValidClient(attacker))
	{
		if (GetClientTeam(attacker) == CS_TEAM_CT && GetClientTeam(victim) == CS_TEAM_T)
		{
			int i_Weapon = GetEntPropEnt(attacker, Prop_Data, "m_hActiveWeapon");
			char wepname[128];
			if (IsValidEntity(i_Weapon))
			{
				GetEntityClassname(i_Weapon, wepname, sizeof(wepname));
			}
			if (StrEqual(wepname, "weapon_mag7"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.4);
				damage *= 0.6;
				return Plugin_Changed;
			}
			if (StrEqual(wepname, "weapon_taser"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.4);
				damage *= 0.5;
				return Plugin_Changed;
			}
			else if (StrEqual(wepname, "weapon_p90"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.6);
				damage *= 0.8;
				return Plugin_Changed;
			}
			else if (StrEqual(wepname, "weapon_mp5sd"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.6);
				damage *= 0.7;
				return Plugin_Changed;
			}
			else if (StrEqual(wepname, "weapon_bizon"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.6);
				damage *= 1.0;
				return Plugin_Changed;
			}
			else if (StrEqual(wepname, "weapon_mp9"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.6);
				damage *= 0.7;
				return Plugin_Changed;
			}
			else if (StrEqual(wepname, "weapon_awp"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.9);
				damage *= 2.0;
				return Plugin_Changed;
			}
			else if (StrEqual(wepname, "weapon_mp7"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*1.2);
				damage *= 0.9;
				return Plugin_Changed;
			}
			else if (StrEqual(wepname, "weapon_m4a1"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.9);
				damage *= 0.9;
				return Plugin_Changed;
			}
			else if (StrEqual(wepname, "weapon_ak47"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.9);
				damage *= 1.4;
				return Plugin_Changed;
			}
			else if (StrEqual(wepname, "weapon_xm1014"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.9);
				damage *= 1.5;
				return Plugin_Changed;
			}
			else if (StrEqual(wepname, "weapon_glock"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.9);
				damage *= 0.4;
				return Plugin_Changed;
			}
			else if (StrEqual(wepname, "weapon_hkp2000"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.8);
				damage *= 0.4;
				return Plugin_Changed;
			}
			else if (StrEqual(wepname, "weapon_usp"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.7);
				damage *= 0.4;
				return Plugin_Changed;
			}
			else if (StrEqual(wepname, "weapon_p250"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.7);
				damage *= 0.7;
				return Plugin_Changed;
			}
			else if (StrEqual(wepname, "weapon_fiveseven"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.6);
				damage *= 0.8;
				return Plugin_Changed;
			}
			else if (StrEqual(wepname, "weapon_elite"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.6);
				damage *= 1.5;
				return Plugin_Changed;
			}
		}
	}
	return Plugin_Continue;
}
public Action EventSDK_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3])
{
	if (IsValidClient(victim))
	{
		char wepname[128];
		if (IsValidEntity(weapon))
		{
			GetEntityClassname(weapon, wepname, sizeof(wepname));
		}
		if (IsValidClient(attacker))
		{
			if (GetClientTeam(attacker) == CS_TEAM_T && GetClientTeam(victim) == CS_TEAM_CT)
			{
				if (bKnife_level_1[attacker])
				{
					if (StrEqual(wepname, "weapon_knife") && GetClientButtons(attacker) & IN_ATTACK2)
					{
						damage = 105.0;
						return Plugin_Changed;
					}
				}
				if (bKnife_level_2[attacker])
				{
					if (StrEqual(wepname, "weapon_knife") && GetClientButtons(attacker) & IN_ATTACK2)
					{
						damage = 120.0;
						return Plugin_Changed;
					}
				}
			}
		}
	}
	return Plugin_Continue;
}
// ate aki nao

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2])
{
	if (IsValidClient(client))
	{
		if (IsPlayerAlive(client))
		{
			//-- BHOP

			if (GetClientTeam(client) == CS_TEAM_T)
			{
				if (buttons & IN_JUMP && !(GetEntityFlags(client) & FL_ONGROUND) && !(GetEntityMoveType(client) & MOVETYPE_LADDER) && b_ClientWallHang[client] == false)
				{
					buttons &= ~IN_JUMP;
				}
				
			}
			
			
			//--
			char weapon_name[32];
			int cFlags = GetEntityFlags(client);
			int cButtons = GetClientButtons(client);
			GetClientWeapon(client, weapon_name, sizeof(weapon_name));
			if (GetClientTeam(client) == CS_TEAM_CT)
			{
			}
			else if (GetClientTeam(client) == CS_TEAM_T)
			{
				if (b_ClientMovedAfterSpawn[client] == false)
				{
					if (buttons & IN_FORWARD || buttons & IN_BACK || buttons & IN_LEFT || buttons & IN_RIGHT)
					{
						b_ClientMovedAfterSpawn[client] = true;
					}
				}
				if (cVb_FallDownSpeed == true)
				{
					if (IsClientInAir(client, cFlags))
					{
						float vVel[3];
						GetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel);
						if (vVel[2] < -1.0)
						{
							vVel[2] += cVf_FallDown;
							//SetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel); not need
							TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vVel);
						}
						else if (vVel[2] > 200.0)
						{
							vVel[2] -= 20.0;
							//SetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel); not need
							TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vVel);
						}
					}
				}
				if (cVb_WallHang == true)
				{
					if (buttons & IN_USE && b_ClientWallHang[client] == false)
					{
						float f_FinallVector[3];
						float f_EyePosition[3];
						float f_EyeViewPoint[3];
						GetClientEyePosition(client, f_EyePosition);
						GetPlayerEyeViewPoint(client, f_EyeViewPoint);
						MakeVectorFromPoints(f_EyeViewPoint, f_EyePosition, f_FinallVector);
						if (GetVectorLength(f_FinallVector) < 30)
						{
							b_ClientWallHang[client] = true;
						}
					}
					else if (buttons & IN_JUMP && b_ClientWallHang[client] == true)
					{
						SetEntityMoveType(client, MOVETYPE_WALK);
						float f_cLoc[3];
						float f_cAng[3];
						float f_cEndPos[3];
						float f_vector[3];
						GetClientEyePosition(client, f_cLoc);
						GetClientEyeAngles(client, f_cAng);
						TR_TraceRayFilter(f_cLoc, f_cAng, MASK_ALL, RayType_Infinite, TraceRayTryToHit);
						TR_GetEndPosition(f_cEndPos);
						MakeVectorFromPoints(f_cLoc, f_cEndPos, f_vector);
						NormalizeVector(f_vector, f_vector);
						ScaleVector(f_vector, 320.0);
						TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, f_vector);
						b_ClientWallHang[client] = false;
					}
					if (b_ClientWallHang[client] == true)
					{
						SetEntityMoveType(client, MOVETYPE_NONE);
						float f_Velocity[3] = { 0.0, 0.0, 0.0 };
						TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, f_Velocity);
					}
				}
			}
			if (cVb_DoubleJump == true)
			{
				if (b_ClientWallHang[client] == false)
				{
					if (i_dJlFlags[client] & FL_ONGROUND)
					{
						if (!(cFlags & FL_ONGROUND) && !(i_dJlButtons[client] & IN_JUMP) && cButtons & IN_JUMP)
						{
							i_dJjCount[client]++;
						}
					}
					else if (cFlags & FL_ONGROUND)
					{
						i_dJjCount[client] = 0;
					}
					else if (!(i_dJlButtons[client] & IN_JUMP) && cButtons & IN_JUMP)
					{
						if (1 <= i_dJjCount[client] <= cVi_DoubleJump_MaxJump)
						{
							i_dJjCount[client]++;
							float vVel[3];
							GetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel);
							vVel[2] = cVf_DoubleJump_JumpHeight;
							TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vVel);
						}
					}
					i_dJlFlags[client] = cFlags;
					i_dJlButtons[client] = cButtons;
				}
			}
			if (GetClientHealth(client) < MaxHealth[client] && bRegenerateHP[client] && IsPlayerAlive(client))
			{
				float time = 1.5;
				float timeleft = PlayerRegenHPStart[client] - GetGameTime() + time;
				if (timeleft < 0.01)
				{
					if (GetClientHealth(client) + 4 >= MaxHealth[client])
					{
						SetEntityHealth(client, MaxHealth[client]);
					}
					else
					{
						SetEntityHealth(client, GetClientHealth(client) + 4);
						PlayerRegenHPStart[client] = GetGameTime();
					}
				}
			}
			g_cLastButtons[client] = buttons;
		}
	}
	return Plugin_Continue;
}

public void OnGameFrame()
{
	float f_EngineTime = GetEngineTime();
	if (b_DisableBomb == true)
	{
		float timeleft = f_DisableBomb - f_EngineTime + float(cVi_DisableBomb);
		if (timeleft < 0.01)
		{
			int index = -1;
			while ((index = FindEntityByClassname(index, "func_bomb_target")) != -1)
			{
				AcceptEntityInput(index, "Enable");
				LoopClients(i)
				{
					if (IsPlayerAlive(i) && GetClientTeam(i) == CS_TEAM_T)
					{
						SetHudTextParams(0.4, 0.7, 3.0, 255, 0, 0, 1, 0, 0.1, 0.1, 0.2);
						ShowHudText(i, -1, "[ BombSite Activated ]");
					}
				}
			}
			b_DisableBomb = false;
		}
	}
	LoopClients(client)
	{
		if (bFurien_Laser[client] && IsPlayerAlive(client) && GetClientTeam(client) == CS_TEAM_CT)
		{
			CreateBeam(client);
		}
	}
	
	bool setvisible;
	char weaponname[64];
	for (int client = 1; client <= MaxClients; client++)
	{
		if (!IsClientInGame(client))
			continue;
		
		if (!IsPlayerAlive(client))
			continue;
		
		if (GetClientTeam(client) != 2)
			continue;
		
		setvisible = (IsClientMoveButtonsPressed(client));
		
		if (!setvisible)
		{
			GetClientWeapon(client, weaponname, sizeof(weaponname));
			
			if (StrEqual(weaponname, "weapon_hegrenade") || StrEqual(weaponname, "weapon_c4") || StrEqual(weaponname, "weapon_molotov") || StrEqual(weaponname, "weapon_taser"))
				setvisible = true;
		}
		
		if (setvisible)
		{
			gc_fLastIdle[client] = 0.0;
			SetEntityRenderMode(client, RENDER_NORMAL);
			SetEntityRenderColor(client, 255, 255, 255, 255);
			FadeClient(client);
			
			int wepIdx;
			for (int s = 0; s < 5; s++)
			{
				if ((wepIdx = GetPlayerWeaponSlot(client, s)) != -1)
				{
					SetEntityRenderMode(wepIdx, RENDER_NORMAL);
					SetEntityRenderColor(wepIdx, 255, 255, 255, 255);
				}
			}
		}
		else
		{
			if (gc_fLastIdle[client] == 0.0)
			{
				gc_fLastIdle[client] = GetGameTime();
				return;
			}
			
			if (GetGameTime() - gc_fLastIdle[client] < DELAY_INVIS)
				return;
			
			SetEntityRenderMode(client, RENDER_TRANSCOLOR);
			SetEntityRenderColor(client, 255, 255, 255, 0);
			FadeClient(client, 35, 0, 130, 30);
			
			int wepIdx;
			
			for (int s = 0; s < 5; s++)
			{
				if ((wepIdx = GetPlayerWeaponSlot(client, s)) != -1)
				{
					SetEntityRenderMode(wepIdx, RENDER_TRANSCOLOR);
					SetEntityRenderColor(wepIdx, 255, 255, 255, 0);
				}
			}
		}
	}
} 

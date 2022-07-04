
public void OnConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if (convar == cV_DisableBomb)
	{
		cVi_DisableBomb = GetConVarInt(cV_DisableBomb);
	}
	else if (convar == cV_Gravity)
	{
		cVf_Gravity = GetConVarFloat(cV_Gravity);
	}
	else if (convar == cV_Speed)
	{
		cVf_Speed = GetConVarFloat(cV_Speed);
	}
	else if (convar == cV_Footsteps)
	{
		cVb_Footsteps = GetConVarBool(cV_Footsteps);
	}
	else if (convar == cV_BombBeacon)
	{
		cVb_BombBeacon = GetConVarBool(cV_BombBeacon);
	}
	else if (convar == cV_BombBeacon_Delay)
	{
		cVf_BombBeacon_Delay = GetConVarFloat(cV_BombBeacon_Delay);
	}
	else if (convar == cV_BombBeacon_Radius)
	{
		cVf_BombBeacon_Radius = GetConVarFloat(cV_BombBeacon_Radius);
	}
	else if (convar == cV_BombBeacon_Life)
	{
		cVf_BombBeacon_Life = GetConVarFloat(cV_BombBeacon_Life);
	}
	else if (convar == cV_BombBeacon_Width)
	{
		cVf_BombBeacon_Width = GetConVarFloat(cV_BombBeacon_Width);
	}
	else if (convar == cV_BombBeacon_Color)
	{
		GetConVarColor(cV_BombBeacon_Color, cVi_BombBeacon_Color);
	}
	else if (convar == cV_BombBeacon_RandomColor)
	{
		cVb_BombBeacon_RandomColor = GetConVarBool(cV_BombBeacon_RandomColor);
	}
	else if (convar == cV_FallDownSpeed)
	{
		cVb_FallDownSpeed = GetConVarBool(cV_FallDownSpeed);
	}
	else if (convar == cV_WallHang)
	{
		cVb_WallHang = GetConVarBool(cV_WallHang);
	}
	else if (convar == cV_DoubleJump)
	{
		cVb_DoubleJump = GetConVarBool(cV_DoubleJump);
	}
	else if (convar == cV_DoubleJump_MaxJump)
	{
		cVi_DoubleJump_MaxJump = GetConVarInt(cV_DoubleJump_MaxJump);
	}
	else if (convar == cV_DoubleJump_JumpHeight)
	{
		cVf_DoubleJump_JumpHeight = GetConVarFloat(cV_DoubleJump_JumpHeight);
	}
	else if (convar == cV_FallDown)
	{
		cVf_FallDown = GetConVarFloat(cV_FallDown);
	}
}


public void OnPluginStart()
{
	HookEvent("round_prestart", Event_OnRoundPreStart);
	HookEvent("round_start", Event_OnRoundStart);
	HookEvent("round_end", Event_OnRoundEnd);
	HookEvent("player_spawn", Event_OnPlayerSpawn);
	HookEvent("player_death", Event_OnPlayerDeath);
	HookEvent("player_team", Event_OnPlayerPreTeam, EventHookMode_Pre);
	HookEvent("player_hurt", Event_OnPlayerHurt);
	HookEvent("bomb_planted", Event_OnBombPlanted);
	HookEvent("bomb_defused", Event_OnBombDefused);
	HookEvent("bomb_exploded", Event_OnBombExploded);
	
	RegConsoleCmd("sm_shop", Command_Shop);
	RegConsoleCmd("sm_fshop", Command_Shop);
	RegConsoleCmd("sm_ashop", Command_Shop);
	
	RegConsoleCmd("sm_guns", Command_Guns);
	RegConsoleCmd("sm_gun", Command_Guns);
	
	
	AddNormalSoundHook(OnNormalSoundPlayed);
	for (int i; i < sizeof(g_sRadioCommands); i++)
	{
		AddCommandListener(Command_BlockRadio, g_sRadioCommands[i]);
	}
	AddCommandListener(Command_Kill, "kill");
	
	cV_DisableBomb = CreateConVar("furien_disablebomb", "70", "For how many seconds after round starts will be unable to plant bomb / -1 = 'Able to plant everytime', 0 = 'Forever'");
	cVi_DisableBomb = GetConVarInt(cV_DisableBomb);
	HookConVarChange(cV_DisableBomb, OnConVarChanged);
	cV_Gravity = CreateConVar("furien_gravity", "0.2", "Furiens gravity multiplier");
	cVf_Gravity = GetConVarFloat(cV_Gravity);
	HookConVarChange(cV_Gravity, OnConVarChanged);
	cV_Speed = CreateConVar("furien_speed", "2.0", "Furiens speed multiplier");
	cVf_Speed = GetConVarFloat(cV_Speed);
	HookConVarChange(cV_Speed, OnConVarChanged);
	cV_Footsteps = CreateConVar("furien_footsteps", "1", "Disable furiens footsteps, 1 = 'Enable' 0 = 'Disable'");
	cVb_Footsteps = GetConVarBool(cV_Footsteps);
	HookConVarChange(cV_Footsteps, OnConVarChanged);
	cV_BombBeacon = CreateConVar("furien_bombbeacon", "1", "Enable beacon from bomb when planted, 1 = 'Enable' 0 = 'Disable'");
	cVb_BombBeacon = GetConVarBool(cV_BombBeacon);
	HookConVarChange(cV_BombBeacon, OnConVarChanged);
	cV_BombBeacon_Delay = CreateConVar("furien_bombbeacon_delay", "1.0", "Delay between beacons (in seconds)");
	cVf_BombBeacon_Delay = GetConVarFloat(cV_BombBeacon_Delay);
	HookConVarChange(cV_BombBeacon_Delay, OnConVarChanged);
	cV_BombBeacon_Radius = CreateConVar("furien_bombbeacon_radius", "250.0", "Beacon radius");
	cVf_BombBeacon_Radius = GetConVarFloat(cV_BombBeacon_Radius);
	HookConVarChange(cV_BombBeacon_Radius, OnConVarChanged);
	cV_BombBeacon_Life = CreateConVar("furien_bombbeacon_life", "1.5", "Beacon life");
	cVf_BombBeacon_Life = GetConVarFloat(cV_BombBeacon_Life);
	HookConVarChange(cV_BombBeacon_Life, OnConVarChanged);
	cV_BombBeacon_Width = CreateConVar("furien_bombbeacon_width", "8.0", "Beacon width");
	cVf_BombBeacon_Width = GetConVarFloat(cV_BombBeacon_Width);
	HookConVarChange(cV_BombBeacon_Width, OnConVarChanged);
	cV_BombBeacon_Color = CreateConVar("furien_bombbeacon_color", "255 0 255 255", "Beacon color [R G B A] if randomcolor = '0'");
	GetConVarColor(cV_BombBeacon_Color, cVi_BombBeacon_Color);
	HookConVarChange(cV_BombBeacon_Color, OnConVarChanged);
	cV_BombBeacon_RandomColor = CreateConVar("furien_bombbeacon_randomcolor", "0", "Beacon randomcolor");
	cVb_BombBeacon_RandomColor = GetConVarBool(cV_BombBeacon_RandomColor);
	HookConVarChange(cV_BombBeacon_RandomColor, OnConVarChanged);
	cV_FallDownSpeed = CreateConVar("furien_falldownspeed", "1", "Enable furiens low falldown speed, 1 = 'Enabled' 0 = 'Disabled'");
	cVb_FallDownSpeed = GetConVarBool(cV_FallDownSpeed);
	HookConVarChange(cV_FallDownSpeed, OnConVarChanged);
	cV_WallHang = CreateConVar("furien_wallhang", "1", "Enable furiens wallhang, 1 = 'Enabled' 0 = 'Disabled'");
	cVb_WallHang = GetConVarBool(cV_WallHang);
	HookConVarChange(cV_WallHang, OnConVarChanged);
	cV_DoubleJump = CreateConVar("furien_doublejump", "1", "Enable furiens doublejump, 1 = 'Enabled' 0 = 'Disabled'");
	cVb_DoubleJump = GetConVarBool(cV_DoubleJump);
	HookConVarChange(cV_DoubleJump, OnConVarChanged);
	cV_DoubleJump_MaxJump = CreateConVar("furien_doublejump_maxjump", "1", "How many times you can jump in air");
	cVi_DoubleJump_MaxJump = GetConVarInt(cV_DoubleJump_MaxJump);
	HookConVarChange(cV_DoubleJump_MaxJump, OnConVarChanged);
	cV_DoubleJump_JumpHeight = CreateConVar("furien_doublejump_jumpheight", "250.0", "Height of doublejump");
	cVf_DoubleJump_JumpHeight = GetConVarFloat(cV_DoubleJump_JumpHeight);
	HookConVarChange(cV_DoubleJump_JumpHeight, OnConVarChanged);
	cV_FallDown = CreateConVar("furien_falldown", "1.3", "Falldown speed");
	
	cVf_FallDown = GetConVarFloat(cV_FallDown);
	HookConVarChange(cV_FallDown, OnConVarChanged);
	
	i_AF_Shop.AF_Item_Defuse = 50;
	i_AF_Shop.AF_Item_100ap = 150;
	i_AF_Shop.AF_Item_50hp = 300;
	i_AF_Shop.AF_Item_Furien_Laser = 1000;
	i_AF_Shop.AF_Item_RegenerateHP = 1500;
	i_AF_Shop.AF_Item_Tactical_Granade = 2000;
	
	
	i_F_Shop.F_Item_HeGrenade = 1000;
	i_F_Shop.F_Item_50hp = 600;
	i_F_Shop.F_Item_knife_level_1 = 2000;
	i_F_Shop.F_Item_knife_level_2 = 4000;
	i_F_Shop.F_Item_Molotov = 1200;
	i_F_Shop.F_Item_RegenerateHP = 3000;
}
public void OnMapStart()
{
	SetCvarStr("mp_teamname_1", "ANTI-FURIENS");
	SetCvarStr("mp_teamname_2", "FURIENS");
	SetCvarInt("sv_ignoregrenaderadio", 1);
	SetCvarInt("sv_disable_immunity_alpha", 1);
	SetCvarInt("mp_solid_teammates", 0);
	SetCvarInt("mp_maxrounds", 0);
	SetCvarInt("mp_startmoney", 0);
	
	SetCvarInt("mp_playercashawards", 0);
	SetCvarInt("mp_teamcashawards", 0);
	SetCvarInt("mp_maxmoney", 0);
	
	SetCvarFloat("mp_roundtime", 2.5);
	SetCvarFloat("mp_roundtime_defuse", 2.5);

	SetCvarInt("mp_defuser_allocation", 0);
	SetCvarInt("sv_deadtalk", 1);
	SetCvarInt("sv_alltalk", 0);
	SetCvarInt("mp_autokick", 0);
	SetCvarInt("sv_allow_thirdperson", 1);
	SetCvarInt("mp_free_armor", 0);
	SetCvarInt("mp_buytime", 0);
	SetCvarInt("mp_force_assign_teams", 1);
	SetCvarInt("mp_halftime", 0);
	SetCvarInt("mp_halftime_duration", 5);
	
	
	i_F_RoundWinStream = 0;
	
	AddFileToDownloadsTable("materials/sprites/redglow1.vmt");
	AddFileToDownloadsTable("materials/sprites/bluelaser1.vmt");
	AddFileToDownloadsTable("materials/sprites/laserbeam.vmt");
	AddFileToDownloadsTable("materials/sprites/purplelaser1.vmt");
	NC_GunGlowSprite = PrecacheModel("materials/sprites/redglow1.vmt");
	NC_GunFurien_LaserSprite = PrecacheModel("materials/sprites/bluelaser1.vmt");
	i_BeamIndex = PrecacheModel("materials/sprites/laserbeam.vmt");
	AddFileToDownloadsTable("materials/sprites/purplelaser1.vmt");
	AddFileToDownloadsTable("materials/sprites/laserbeam.vtf");
	AddFileToDownloadsTable("materials/sprites/bluelaser1.vtf");
	
	
	LoopAllClients(i)
	{
		ResetItems(i);
	}
	
	i_AF_Shop.AF_Item_Defuse = 50;
	i_AF_Shop.AF_Item_100ap = 150;
	i_AF_Shop.AF_Item_50hp = 300;
	i_AF_Shop.AF_Item_Furien_Laser = 1000;
	i_AF_Shop.AF_Item_RegenerateHP = 1500;
	i_AF_Shop.AF_Item_Tactical_Granade = 2000;
	
	
	i_F_Shop.F_Item_HeGrenade = 1000;
	i_F_Shop.F_Item_50hp = 600;
	i_F_Shop.F_Item_knife_level_1 = 2000;
	i_F_Shop.F_Item_knife_level_2 = 4000;
	i_F_Shop.F_Item_Molotov = 1200;
	i_F_Shop.F_Item_RegenerateHP = 3000;
}
public void OnMapEnd()
{
	LoopAllClients(i)
	{
		ResetItems(i);
	}
}

public void OnClientPutInServer(int client)
{
	if (IsValidClient(client))
	{
		if (cVb_Footsteps == true)
		{
			SendConVarValue(client, FindConVar("sv_footsteps"), "0");
		}
		SDKHook(client, SDKHook_PreThink, EventSDK_OnClientThink);
		SDKHook(client, SDKHook_PostThinkPost, EventSDK_OnPostThinkPost);
		SDKHook(client, SDKHook_WeaponCanUse, EventSDK_OnWeaponCanUse);
		SDKHook(client, SDKHook_OnTakeDamage, EventSDK_OnTakeDamage);
		SDKHook(client, SDKHook_TraceAttack, EventSDK_OnTraceAttack);
		
		Player_Money[client] = 0;
	}
}

public void OnClientDisconnect_Post(int client)
{
	g_cLastButtons[client] = 0;
}
public void OnClientDisconnected(int client)
{
	ResetItems(client);
}

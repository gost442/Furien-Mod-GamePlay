#include <sourcemod>
#include <cstrike>
#include <sdktools>
#include <sdkhooks>

#pragma newdecls required

#define LoopAllClients(%1) for(int %1 = 1;%1 <= MaxClients;%1++)
#define LoopClients(%1) for(int %1 = 1;%1 <= MaxClients;%1++) if(IsValidClient(%1))
#define LoopAliveClients(%1) for(int %1 = 1;%1 <= MaxClients;%1++) if(IsValidClient(%1, true))


#define WINNER_FURIEN_3STREAK 300
#define FURIEN_BOMB_PLANTED 600
#define FURIEN_BOMB_DEFUSED 600

#define FURIEN_KILL_MONEY 150
#define ANTIFURIEN_KILL_MONEY 250


#define DELAY_INVIS     0.3


float gc_fLastIdle[MAXPLAYERS+1];


char g_sRadioCommands[][] = { "coverme", "takepoint", "holdpos", "regroup", "followme", "takingfire", "go", "fallback", "sticktog", "getinpos", "stormfront", "report", "roger", "enemyspot", "needbackup", "sectorclear", 
	"inposition", "reportingin", "getout", "negative", "enemydown", "compliment", "thanks", "cheer" };

ConVar cV_DisableBomb;
int cVi_DisableBomb;
ConVar cV_Gravity;
float cVf_Gravity;
ConVar cV_Speed;
float cVf_Speed;
ConVar cV_FallDown;
float cVf_FallDown;
ConVar cV_Footsteps;
bool cVb_Footsteps;
ConVar cV_BombBeacon;
bool cVb_BombBeacon;
ConVar cV_BombBeacon_Delay;
float cVf_BombBeacon_Delay;
ConVar cV_BombBeacon_Radius;
float cVf_BombBeacon_Radius;
ConVar cV_BombBeacon_Life;
float cVf_BombBeacon_Life;
ConVar cV_BombBeacon_Width;
float cVf_BombBeacon_Width;
ConVar cV_BombBeacon_Color;
int cVi_BombBeacon_Color[4];
ConVar cV_BombBeacon_RandomColor;
bool cVb_BombBeacon_RandomColor;
ConVar cV_FallDownSpeed;
bool cVb_FallDownSpeed;
ConVar cV_WallHang;
bool cVb_WallHang;
ConVar cV_DoubleJump;
bool cVb_DoubleJump;
ConVar cV_DoubleJump_MaxJump;
int cVi_DoubleJump_MaxJump;
ConVar cV_DoubleJump_JumpHeight;
float cVf_DoubleJump_JumpHeight;


int NC_GunFurien_LaserSprite;
bool bFurien_Laser[MAXPLAYERS + 1] = { false, ... };
int NC_GunGlowSprite;

float PlayerRegenHPStart[MAXPLAYERS + 1];
int MaxHealth[MAXPLAYERS + 1];
int Max_Health[MAXPLAYERS + 1];
bool bRegenerateHP[MAXPLAYERS + 1] = { false, ... };

bool bKnife_level_2[MAXPLAYERS + 1] = { false, ... };
bool bKnife_level_1[MAXPLAYERS + 1] = { false, ... };

float f_DisableBomb;
bool b_DisableBomb;

Handle h_BombBeacon = null;
int i_BeamIndex;
float f_BombBeaconPos[3];
bool b_ClientMovedAfterSpawn[MAXPLAYERS + 1] = { false, ... };
bool b_ClientWallHang[MAXPLAYERS + 1] = { false, ... };
int i_dJjCount[MAXPLAYERS + 1];
int i_dJlButtons[MAXPLAYERS + 1];
int i_dJlFlags[MAXPLAYERS + 1];
int i_F_RoundWinStream = 0;
bool b_F_RoundSwtichTeams = false;


#define HIDE_ALL 1<<2
#define HIDE_RADAR 1<<12


enum struct AF_Shop
{
	int AF_Item_Defuse;
	int AF_Item_100ap;
	int AF_Item_50hp;
	int AF_Item_Furien_Laser;
	int AF_Item_RegenerateHP;
	int AF_Item_Tactical_Granade;
}
AF_Shop i_AF_Shop;




enum struct F_Shop
{
	int F_Item_HeGrenade;
	int F_Item_50hp;
	int F_Item_knife_level_1;
	int F_Item_knife_level_2;
	int F_Item_Molotov;
	int F_Item_RegenerateHP;
}
F_Shop i_F_Shop;


enum struct ShopBought
{
	int Shop_50hp;
	int Shop_Furien_Laser; 
	int Shop_RegenerateHP; 
	int Shop_Tactical_Granade; 
	int Shop_HeGrenade; 
	int Shop_knife_level_2;
	int Shop_mariawild;
	int Shop_knife_level_1; 
	int Shop_terrasdodemo; 
	int Shop_balaspotentes; 
	int Shop_Molotov; 
	int Shop_Wallhang;
}
ShopBought i_bShop[MAXPLAYERS + 1];


#define MAX_BUTTONS 25
int g_cLastButtons[MAXPLAYERS + 1];


#include "gfurien/antifurien_guns.sp"
#include "gfurien/antifurien_shop.sp"
#include "gfurien/commands.sp"
#include "gfurien/events.sp"
#include "gfurien/furien_shop.sp"
#include "gfurien/helpers.sp"
#include "gfurien/hooks.sp"
#include "gfurien/sdk.sp"
#include "gfurien/util.sp"

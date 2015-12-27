#include <voiceannounce_ex>
#include <sourcemod>
#include <cstrike>
#include <sdkhooks>
#include <sdktools>
#include <warden>
#include <basecomm>

Handle h_Type = INVALID_HANDLE;

bool hint = true;

public Plugin:myinfo = {
	name = "JailBreak - Be quiet, please!",
	author = "Fastmancz",
	description = "Be quiet, please!",
	url = "cmgportal.cz"
};

public void OnPluginStart()
{
	h_Type = CreateConVar("jbbqp_notify_type", "1", "Notification type: 1 = notifiy muted client when he tries speak, 2 = notifiy all clients when warden speaks");
}

//When Warden speaks or muted client wants to speak
public bool OnClientSpeakingEx(client)
{
    if (warden_iswarden(client))
    {
        for (int i = 1; i <= MaxClients; i++)
        {
            if(IsValidClient(i, true))
            {
                if (GetClientTeam(i) == CS_TEAM_T && GetUserAdmin(i) == INVALID_ADMIN_ID)
                {
					MuteClient(i);
					if (GetConVarInt(h_Type) == 2)
					{
						PrintCenterText(i, "Warden speaks, you have been muted.");
					}
                }
            }
        }
    }
	if (GetConVarInt(h_Type) == 1)
	{
		if(IsValidClient(i, true))
		{
			if (hint && IsClientMuted(client))
			{
				PrintCenterText(client, "Warden speaks, you have been muted.");
				hint = false;
			}
		}
	}
}
 
// When client stops ta
public OnClientSpeakingEnd(client)
{  
    for (int i = 1; i <= MaxClients; i++)
    {
        if(IsValidClient(i, true))
        {
            if (GetClientTeam(i) == CS_TEAM_T && !BaseComm_IsClientMuted(client))
            {
                UnmuteClient(i)
            }
        }
    }
	if (GetConVarInt(h_Type) == 1)
	{
		if (warden_iswarden(client))
		{
			hint = true;
		}
	}
}

stock void MuteClient(client)
{
	SetClientListeningFlags(client, VOICE_MUTED);
}

stock void UnmuteClient(client)
{
	SetClientListeningFlags(client, VOICE_NORMAL);
}

stock bool IsClientMuted(client)
{
	if ( GetClientListeningFlags(client) == VOICE_MUTED)
	{
		return true;
	}
	
	return false;
}

stock bool IsValidClient(client, bool alive = false)
{
    if(client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && (alive == false || IsPlayerAlive(client)))
    {
        return true;
    }

    return false;
}
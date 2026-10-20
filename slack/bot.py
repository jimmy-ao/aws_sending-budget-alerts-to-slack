# bot

from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError


# Get Bot User ID
def get_bot_user_id(client: WebClient, bot_name: str = "Amazon Q") -> tuple[str, str]:
    print("\n ### \n Looking for Slack bot...\n ### \n ")

    for page in client.users_list():
        for member in page["members"]:
            if member.get("is_bot") and not member.get("deleted") and (member.get("real_name") == bot_name or member.get("name") == "amazonq"):
                return member["id"], member["real_name"]
    raise ValueError(f"Bot '{bot_name}' not found in workspace.")


# Invite Bot to Channel
def invite_bot_to_channel(client: WebClient, channel_id: str, bot_user_id: str) -> bool:
    print("\n ### \n Inviting bot to channel Slack...\n ### \n ")

    try:
        print(f"Trying to invite bot {bot_user_id} to channel {channel_id}.")
        client.conversations_invite(channel=channel_id, users=bot_user_id)
    except SlackApiError as e:
        if e.response["error"] == "already_in_channel":
            print(f"Bot {bot_user_id} is already in channel {channel_id}.")
            return True
        print(f"Error: {e.response['error']}.")
        return False

    print(f"Successfully invited bot {bot_user_id} to channel {channel_id}.")
    return True

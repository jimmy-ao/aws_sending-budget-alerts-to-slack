# users

from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError


# Function used to retrieve the User ID from an email address.
def get_user (client: WebClient, email: str):
    print(f"\n ### \n Searching for user with email: {email}...\n ### \n ")

    try:
        response = client.users_lookupByEmail(email=email)
    except SlackApiError as e:
        print(f"'{email} - {e.response['error']}")
    else:
        print(f"'{email}' - {response['user']['id']}")
        return ((response["user"]["id"], response["user"]["name"]))
    return None


# Function used to invite users to a channel
def invite_users(client: WebClient, channel_id: str, user_id: str) -> bool:
    print(f"\n ### \n Processing with user {user_id}...\n ### \n ")

    try:
        client.conversations_invite(channel=channel_id, users=user_id)
    except SlackApiError as e:
        if e.response["error"] == "already_in_channel":
            print(f"User {user_id} is already in the channel.")
            return True
        print(f"Invite failed: {e.response['error']}")
        return False

    print("User has been invited to channel.")
    return True

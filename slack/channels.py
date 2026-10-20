# channels

from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError


# Function used to verify if the Slack channel already exists.
# Read-only by design: returns (channel_id, is_archived), or None if not found.
# It never modifies the channel; the caller decides what to do with an archived one.
def find_slack_channels(client: WebClient, name: str) -> tuple[str, bool] | None:
    print(f"\n ### \n Looking for Slack channel: #{name}...\n ### \n ")

    for page in client.conversations_list(types=["public_channel", "private_channel"], limit=200):
        for channel in page["channels"]:
            if channel["name"] == name:
                print(f"\nFound target channel: {channel['name']} • ({channel['id']})")
                return channel["id"], channel.get("is_archived", False)

    return None


# Function used to unarchive a Slack channel. Only called on explicit request (--unarchive).
def unarchive_slack_channel(client: WebClient, channel_id: str) -> bool:
    try:
        client.conversations_unarchive(channel=channel_id)
    except SlackApiError as e:
        print(f"Unarchive failed: {e.response['error']}.")
        return False

    print(f"Channel {channel_id} unarchived.")
    return True


# Function used to list members of the Slack channel
def list_slack_channel_members(client: WebClient, channel_id: str, member_id: str):
    print("\n ### \n Looking for Slack channel members...\n ### \n ")

    for page in client.conversations_members(channel=channel_id):
        if member_id in page["members"]:
            print(f"Member {member_id} is in channel {channel_id}.")
            return True

    return False


# Function used to create the Slack channel.
def create_slack_channel(client: WebClient, name: str, is_private: bool = True, description: str | None = None):
    print(f"\n ### \n Creating Slack channel • #{name} • Private: {is_private}...\n ### \n ")

    try:
        response = client.conversations_create(name=name, is_private=is_private)

        channel = response["channel"]
        channel_id = channel["id"]

        print(f"Channel {name} created: {channel_id}")
        print(f"Desc: {description}")

        if description != None:
            client.conversations_setTopic(channel=channel_id, topic=description)
            print(f"Topic for {name} set to: {description}")
        else:
            print(f"No description provided for {name}.")

        return channel_id

    except SlackApiError as e:
        error = e.response["error"]
        if error == "name_taken":
            print(f"Channel #{name} already exists.")
        elif error == "invalid_name":
            print(f"Invalid channel name: {name}.")
        else:
            print(f"Slack API error: {error}.")
        return None


import argparse
import os
import sys

from slack_sdk import WebClient

from bot import get_bot_user_id, invite_bot_to_channel
from channels import (
    create_slack_channel,
    find_slack_channels,
    list_slack_channel_members,
    unarchive_slack_channel,
)
from users import get_user, invite_users

token = os.environ.get("SLACK_BOT_TOKEN")
if not token:
    sys.exit("SLACK_BOT_TOKEN is not set.")

client = WebClient(token=token)

parser=argparse.ArgumentParser()
parser.add_argument("--channel_name", required=True)
parser.add_argument("--channel_description")
parser.add_argument("--channel_member")
parser.add_argument("--unarchive", action="store_true", help="Unarchive the channel if it exists but is archived.")
args = parser.parse_args()

emails = [
    "jimmy@archnops.com",
    "jimmy@sparotechnologies.com",
    "toto@archnops.com"
]

# Every step that doesn't reach its goal is recorded here.
# If anything failed, the script exits with code 1 so a wrapper or CI can detect it.
failures: list[str] = []

# Channel creation

print("\n=====> main.py - channel creation <=====")

channel_id = None
found = find_slack_channels(client, args.channel_name)

if found is None:
    print("Channel does not exist.")
    channel_id = create_slack_channel(client, name=args.channel_name, is_private=True, description=args.channel_description)
    if channel_id is None:
        failures.append(f"create channel #{args.channel_name}")
    else:
        print(f"Channel #{args.channel_name} has been created.")
else:
    found_id, is_archived = found
    if not is_archived:
        print(f"Channel #{args.channel_name} already exists.")
        channel_id = found_id
    elif args.unarchive:
        print(f"Channel #{args.channel_name} is archived, unarchiving (--unarchive given)...")
        if unarchive_slack_channel(client, found_id):
            channel_id = found_id
        else:
            failures.append(f"unarchive channel #{args.channel_name}")
    else:
        failures.append(f"channel #{args.channel_name} is archived (re-run with --unarchive to restore it)")


# Bot invitation

print("\n=====> main.py - bot invitation <=====")

if channel_id is not None:
    try:
        bot_user_id, bot_real_name = get_bot_user_id(client)
    except ValueError as e:
        failures.append(str(e))
    else:
        if list_slack_channel_members(client, channel_id, bot_user_id):
            print(f"Bot is already member of the channel {args.channel_name}.")
        else:
            print(f"Invite bot {bot_real_name} to the channel {args.channel_name}.")
            if not invite_bot_to_channel(client, channel_id, bot_user_id):
                failures.append(f"invite bot {bot_real_name}")
else:
    print("Skipping bot invitation: no usable channel.")


# Users invitation

print("\n=====> main.py - users invitation <=====")

if channel_id is not None:
    for email in emails:
        member = get_user(client, email)

        if not member:
            failures.append(f"no Slack user with email <{email}>")
            continue

        user_id, user_name = member
        print(f">>>>> Member: {user_name}[{user_id}] <<<<<")

        if list_slack_channel_members(client, channel_id, user_id):
            print(f"User {user_name} is already member of the channel.")
        else:
            print(f"Invite {user_name} to the channel.")
            if not invite_users(client, channel_id, user_id):
                failures.append(f"invite {user_name} <{email}>")
else:
    print("Skipping users invitation: no usable channel.")


# Summary

print("\n=====> main.py - summary <=====")

if failures:
    print(f"{len(failures)} step(s) failed:", file=sys.stderr)
    for failure in failures:
        print(f"  x {failure}", file=sys.stderr)
    sys.exit(1)

print("All steps succeeded.")

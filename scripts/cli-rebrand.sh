#!/bin/bash
# Apply Meridian branding to fresh upstream checkout
set -euo pipefail

echo "=== Applying Meridian CLI branding ==="

# 1. pyproject.toml — name, authors, Python version, entry points
sed -i '' 's/^name = "hermes-agent"/name = "meridian-agent"/' pyproject.toml
sed -i '' 's/authors = \[{ name = "Nous Research" }\]/authors = [{ name = "Meridian AI" }]/' pyproject.toml
sed -i '' 's/authors = \[{ name = "Nous Research" },{ name = "Nous Research" }\]/authors = [{ name = "Meridian AI" }]/' pyproject.toml
sed -i '' 's/requires-python = ">=3.11,<3.14"/requires-python = ">=3.11"/' pyproject.toml
sed -i '' 's/^hermes = "hermes_cli.main:main"/meridian = "hermes_cli.main:main"/' pyproject.toml
sed -i '' 's/^hermes-agent = "run_agent:main"/meridian-agent = "run_agent:main"/' pyproject.toml

# 2. hermes_cli/__init__.py — docstring command names
sed -i '' '1,15s/hermes chat/meridian chat/g' hermes_cli/__init__.py
sed -i '' '1,15s/hermes gateway/meridian gateway/g' hermes_cli/__init__.py
sed -i '' '1,15s/hermes setup/meridian setup/g' hermes_cli/__init__.py
sed -i '' '1,15s/hermes status/meridian status/g' hermes_cli/__init__.py
sed -i '' '1,15s/hermes cron/meridian cron/g' hermes_cli/__init__.py
sed -i '' '1,15s/\.\/hermes/\.\/meridian/g' hermes_cli/__init__.py
sed -i '' '1,10s/Hermes CLI/Meridian CLI/g' hermes_cli/__init__.py
sed -i '' '1,10s/Hermes Agent/Meridian Agent/g' hermes_cli/__init__.py

# 3. hermes_constants.py — .meridian home directory + docstring header
sed -i '' 's|return Path.home() / ".hermes"|return Path.home() / ".meridian"|' hermes_constants.py
sed -i '' 's/"Shared constants for Hermes Agent/"Shared constants for Meridian Agent/' hermes_constants.py
sed -i '' 's/default: platform-native path/default: ~\/.meridian/' hermes_constants.py
sed -i '' 's/Reads HERMES_HOME env var, falls back to the platform-native default/Reads HERMES_HOME env var, falls back to ~\/.meridian/' hermes_constants.py

# 4. hermes_cli/banner.py — MERIDIAN logo
sed -i '' 's/"Hermes Agent"/"Meridian Agent"/g' hermes_cli/banner.py
sed -i '' 's/HERMES_AGENT_LOGO/MERIDIAN_AGENT_LOGO/g' hermes_cli/banner.py
sed -i '' 's/HermesCLI state dependency/MeridianCLI state dependency/' hermes_cli/banner.py
sed -i '' 's/"Top banner - Hermes wordmark/"Top banner - Meridian wordmark/' hermes_cli/banner.py
sed -i '' 's/f"Hermes Agent v{VERSION}/f"Meridian Agent v{VERSION}/' hermes_cli/banner.py
sed -i '' 's/"Left panel - Hermes signal mark/"Left panel - Meridian signal mark/' hermes_cli/banner.py

# 5. hermes_cli/skin_engine.py — skin defaults and path references
sed -i '' 's/agent_name: "Hermes Agent"/agent_name: "Meridian Agent"/' hermes_cli/skin_engine.py
sed -i '' 's/goodbye: "Hermes session closed."/goodbye: "Goodbye! ⚕"/' hermes_cli/skin_engine.py
sed -i '' 's/response_label: " ◆ Hermes "/response_label: " ⚕ Meridian "/' hermes_cli/skin_engine.py
sed -i '' 's|~/.hermes/skins/|~/.meridian/skins/|g' hermes_cli/skin_engine.py

# 6. hermes_cli/status.py
sed -i '' 's/Hermes Agent/Meridian Agent/g' hermes_cli/status.py
sed -i '' 's/Hermes CLI/Meridian CLI/g' hermes_cli/status.py
sed -i '' 's/Hermes Agent Status/Meridian Agent Status/g' hermes_cli/status.py

# 7. hermes_cli/env_loader.py
sed -i '' 's/Helpers for loading Hermes/Helpers for loading Meridian/' hermes_cli/env_loader.py

# 8. hermes_cli/telegram_managed_bot.py — user-facing strings
sed -i '' 's/DEFAULT_BOT_NAME = "Hermes Agent"/DEFAULT_BOT_NAME = "Meridian Agent"/' hermes_cli/telegram_managed_bot.py
sed -i '' 's/Contacting Hermes Telegram onboarding service/Contacting Meridian Telegram onboarding service/' hermes_cli/telegram_managed_bot.py
sed -i '' 's/Could not reach the Hermes Telegram onboarding service/Could not reach the Meridian Telegram onboarding service/' hermes_cli/telegram_managed_bot.py

# 9. hermes_cli/setup.py — user-facing strings
sed -i '' 's/Hermes Setup — Non-interactive mode/Meridian Setup — Non-interactive mode/' hermes_cli/setup.py
sed -i '' 's/Configure Hermes using/Configure Meridian using/' hermes_cli/setup.py
sed -i '' 's/Choose where Hermes runs/Choose where Meridian runs/' hermes_cli/setup.py
sed -i '' 's/where Hermes delivers/where Meridian delivers/g' hermes_cli/setup.py
sed -i '' 's/bot_name="Hermes"/bot_name="Meridian"/' hermes_cli/setup.py
sed -i '' 's/bot_description="Your Hermes agent on Slack"/bot_description="Your Meridian agent on Slack"/' hermes_cli/setup.py
sed -i '' 's/Hermes can keep multiple/Meridian can keep multiple/' hermes_cli/setup.py
sed -i '' 's/Interactive setup wizard for Hermes Agent/Interactive setup wizard for Meridian Agent/' hermes_cli/setup.py

echo "=== Done ==="
python3 -c "
import subprocess
r = subprocess.run(['grep', '-rn', \"'Hermes\\|\\\"Hermes\\|Hermes Agent\\|Hermes session\\|Hermes CLI\\|Hermes can\\|Hermes Setup\\|Choose where Hermes\\|where Hermes\\|bot_name=\\\\\"Hermes\\|DEFAULT_BOT_NAME = 'Hermes'\"], 'hermes_cli', 'hermes_constants.py', 'pyproject.toml'], capture_output=True, text=True)
lines = [l for l in r.stdout.split(chr(10)) if l and 'import ' not in l and 'HERMES' not in l and 'HERMES_' not in l and l.strip()]
if lines:
    print('REMAINING:', len(lines))
    for l in lines[:15]:
        print('  ', l)
else:
    print('All clean')
"

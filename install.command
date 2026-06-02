#!/bin/bash
echo "🔧 Installing Meridian..."

# Get the directory where this script is located
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

# Step 1: Create virtual environment
echo "📦 Creating Python environment..."
python3 -m venv .venv
source .venv/bin/activate

# Step 2: Install dependencies
echo "📥 Installing dependencies..."
pip install -e . --quiet

echo ""
echo "✅ Meridian is installed!"
echo ""
echo "🚀 Run the setup wizard:"
echo "   source .venv/bin/activate"
echo "   python3 -m hermes_cli.main setup"
echo "   # or: meridian setup"
echo ""
echo "It will walk you through:"
echo "   • Model provider & API key"
echo "   • Telegram bot connection"
echo "   • Terminal setup"
echo "   • And more"
echo ""

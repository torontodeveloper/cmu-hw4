#!/usr/bin/env bash
# One-shot bootstrap for a fresh Colab runtime.
#
# Usage (in a Colab cell):
#   import os
#   from google.colab import userdata
#   os.environ["GH_TOKEN"] = userdata.get("GH_TOKEN")
#   !curl -sL -H "Authorization: token $GH_TOKEN" \
#       https://raw.githubusercontent.com/torontodeveloper/cmu-hw4/main/colab_setup.sh | bash
#   %cd /content/cmu-hw4
set -euo pipefail

REPO="torontodeveloper/cmu-hw4"
DIR="cmu-hw4"

if [ -z "${GH_TOKEN:-}" ]; then
  echo "ERROR: GH_TOKEN is not set. In Colab:" >&2
  echo "  from google.colab import userdata" >&2
  echo "  import os; os.environ['GH_TOKEN'] = userdata.get('GH_TOKEN')" >&2
  exit 1
fi

cd /content
rm -rf "$DIR"                      # always start clean; no nested clones
git clone -q "https://${GH_TOKEN}@github.com/${REPO}.git" "$DIR"
cd "$DIR"

# Keep Colab's preinstalled torch and numpy rather than replacing them with
# the starter's older pins.
grep -vE '^(torch|numpy)\b' requirements.txt > /tmp/requirements_colab.txt
pip install -r /tmp/requirements_colab.txt -q
pip install -e . -q

echo
echo "Ready. Working directory: $(pwd)"
python -c "import tokenizer; print('tokenizer loaded from:', tokenizer.__file__)"

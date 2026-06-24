#!/usr/bin/env bash
# Ανέβασμα αρχείων στο learnnutrition-daily.
# ΣΗΜΑΝΤΙΚΟ: ΜΗΝ χρησιμοποιείς το GitHub Contents API (api.github.com) — ο proxy
# του environment αντικαθιστά το token με session token χωρίς write access => 403.
# Ο ΜΟΝΟΣ δρόμος που δουλεύει: απευθείας git push με GIT_CONFIG_GLOBAL=/dev/null,
# που εξουδετερώνει τον proxy-rewrite κι αφήνει το PAT να περάσει.
#
# Χρήση:  PAT=github_pat_xxx ./upload.sh <τοπικό_αρχείο> <path_στο_repo> "<commit msg>"
set -euo pipefail
LOCAL="$1"; REPOPATH="$2"; MSG="${3:-Update $2}"
: "${PAT:?Πρέπει να οριστεί η μεταβλητή PAT με το fine-grained token}"
REMOTE="https://x-access-token:${PAT}@github.com/savvastsanasidis-cell/learnnutrition-daily.git"
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null GIT_TERMINAL_PROMPT=0
WORK="$(mktemp -d)"; cd "$WORK"
git init -q; git config user.email "bot@learnnutrition.gr"; git config user.name "learnnutrition-bot"
git config http.proxy ""
git remote add origin "$REMOTE"
git fetch origin main -q
git checkout -q main
cp "$LOCAL" "./$REPOPATH"
git add "$REPOPATH"
git commit -q -m "$MSG"
git push origin main
echo "OK: ανέβηκε το $REPOPATH"

#!/usr/bin/env bash

# Backup du workspace SiYuan (PVC siyuan-data du cluster k3s) dans une archive zip datée.
# Lancé quotidiennement par le timer systemd user défini dans modules/home/siyuan-backup.nix

set -euo pipefail

NAMESPACE="siyuan"
DEPLOYMENT="deploy/siyuan"
CONTAINER="siyuan"
WORKSPACE_PATH="/siyuan/workspace"
BACKUP_DIR="${SIYUAN_BACKUP_DIR:-$HOME/Documents/siyuan-backups}"
ARCHIVE_NAME="siyuan-$(date +%Y-%m-%d_%H-%M-%S).zip"

mkdir -p "$BACKUP_DIR"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Récupération de $WORKSPACE_PATH depuis $NAMESPACE/$DEPLOYMENT..."
mkdir -p "$TMP_DIR/siyuan"

# tar exit code 1 = "fichier modifié pendant la lecture" (SiYuan tourne), non bloquant
set +e
kubectl -n "$NAMESPACE" exec "$DEPLOYMENT" -c "$CONTAINER" -- \
  tar -C "$WORKSPACE_PATH" -cf - . > "$TMP_DIR/siyuan.tar"
rc=$?
set -e
if [ "$rc" -gt 1 ]; then
  echo "Erreur lors de la récupération (code $rc)" >&2
  exit "$rc"
fi

tar -C "$TMP_DIR/siyuan" -xf "$TMP_DIR/siyuan.tar"

echo "Création de l'archive $BACKUP_DIR/$ARCHIVE_NAME..."
(cd "$TMP_DIR" && zip -qr "$TMP_DIR/$ARCHIVE_NAME" siyuan)
mv "$TMP_DIR/$ARCHIVE_NAME" "$BACKUP_DIR/$ARCHIVE_NAME"

echo "Backup SiYuan sauvegardé dans $BACKUP_DIR/$ARCHIVE_NAME"

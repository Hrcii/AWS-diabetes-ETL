#!/usr/bin/env bash
set -euo pipefail

# --- CONFIG ---
PYTHON="/usr/bin/python3"
SCRIPT="/home/ec2-user/files/scripts/run.py"
S3_PREFIX="s3://s3-diabetes-bucket"

#----RUN SCRIPT------#
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT")" && pwd)"

cd "$SCRIPT_DIR"

echo "Running python script..."
"$PYTHON" "$SCRIPT"

#----COPY HYPERPARAMETER DIMENSION DATA TO S3-----#
JSON_FILE="$(ls *_hyper.json)"

DEST="${S3_PREFIX%/}/hyper/"
echo "Uploading to S3: $DEST"
echo "$JSON_FILE"

aws s3 cp "$JSON_FILE" "$DEST" --quiet

#---COPY FACT TABLE DATA TO S3-------------#
JSON_FILE="$(ls *_fact.json)"

DEST="${S3_PREFIX%/}/fact/"
echo "Uploading to S3: $DEST"
echo "$JSON_FILE"

aws s3 cp "$JSON_FILE" "$DEST" --quiet


#---CLEANUP AND FINAL MESSAGE--------#
echo "Upload successful. Deleting local files."
rm -f *.json

echo "Done."

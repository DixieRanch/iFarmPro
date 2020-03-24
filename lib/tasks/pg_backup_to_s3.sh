set -eu
set -o pipefail

#!/bin/sh

# Download the latest backup from
# Heroku and gzip it

heroku pg:backups:download --output=/tmp/pg_backup.dump --app $APP_NAME
gzip /tmp/pg_backup.dump

# Encrypt the gzipped backup file
# using GPG passphrase

gpg --yes --batch --passphrase=$PG_BACKUP_PASSWORD -c /tmp/pg_backup.dump.gz

# Remove the plaintext backup file

rm /tmp/pg_backup.dump.gz

# Generate backup filename based
# With the timestamp on the current date

BACKUP_FILE_NAME="ifarmpro-backup-$(date '+%Y-%m-%d_%H.%M').gpg"

# Generate S3 signature needed
# to upload file to the bucket
# Make sure to use the UTC
# date for S3 signature!

MD5="$(openssl md5 -binary < "/tmp/pg_backup.dump.gz.gpg" | base64)"
CONTENT_TYPE="application/octet-stream"
DATE=`date -R -u`
S3_PATH="${BACKUP_S3_BUCKET}/${BACKUP_FILE_NAME}"
S3_STRING="PUT\n${MD5}\n${CONTENT_TYPE}\n${DATE}\n/${S3_PATH}"

S3_SIGNATURE="$(printf "${S3_STRING}" \
                | openssl sha1 -binary -hmac "${BACKUP_S3_SECRET}" \
                | base64)"

# Upload the file to S3 using
# the signature auth header

curl -X PUT -T "/tmp/pg_backup.dump.gz.gpg" \
  -H "Host: ${BACKUP_S3_BUCKET}.s3-us-west-2.amazonaws.com" \
  -H "Date: ${DATE}" \
  -H "Content-Type: ${CONTENT_TYPE}" \
  -H "Content-MD5: ${MD5}" \
  -H "Authorization: AWS ${BACKUP_S3_KEY}:${S3_SIGNATURE}" \
  https://${BACKUP_S3_BUCKET}.s3-us-west-2.amazonaws.com/${BACKUP_FILE_NAME}

# Remove the encrypted backup file

rm /tmp/pg_backup.dump.gz.gpg
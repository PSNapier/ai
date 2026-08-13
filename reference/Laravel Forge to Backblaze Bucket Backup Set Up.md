# 'Laravel Forge -> Backblaze Bucket' Backup Set Up

A walkthrough of how to set up a Laravel Forge to Backblaze bucket backup set up. Final backup is automatic. Less expensive than the Laravel Forge business plan backups and allows far more flexibility (such as image backups) through the same system. 

## DB Backup

Backs up all of the databases on the server. 

Server-side B2 wiring. Do all of this over SSH on the Forge box.

**1. Get your credentials**

In Backblaze, Application Keys → Add a New Application Key. Scope it to the one bucket, allow Read and Write. Copy `keyID` and `applicationKey` now, the secret is shown once. Also note the bucket's Endpoint from Bucket Details, it looks like `s3.us-west-004.backblazeb2.com`.

**2. Install AWS CLI (if not present)**

```bash
which aws || (sudo apt update && sudo apt install -y awscli)
```

**3. Credentials file**

*You do not need to add any quotation marks around the keys!*

```bash
mkdir -p ~/.aws && chmod 700 ~/.aws
nano ~/.aws/credentials
```

```ini
[b2]
aws_access_key_id = YOUR_KEY_ID
aws_secret_access_key = YOUR_APPLICATION_KEY
```

```bash
chmod 600 ~/.aws/credentials
```

**4. MySQL credentials**

*You do not need to add any quotation marks around the keys!*

```bash
nano ~/.my.cnf
```

```ini
[client]
user=forge
password=YOUR_FORGE_DB_PASSWORD
```

```bash
chmod 600 ~/.my.cnf
```

Forge's DB password is under the server's Database tab, or in `/home/forge/.forge/database-password` on some provisions, or visible in a working site ENV.

**5. Verify the connection before writing the script**

```bash
aws s3 ls s3://YOUR-BUCKET/ --profile b2 --endpoint-url https://s3.us-west-004.backblazeb2.com; echo "exit: $?"
```

Empty output with exit code 0 is success. An error here is a credentials or endpoint problem, fix it now rather than debugging inside a cron job.

**6. The script**

*Replace a server name with the name of your relevant server in order to not have any collisions, backing up multiple servers to the same bucket. Alternatively you could set up separate buckets.*

```bash
mkdir -p ~/scripts
nano ~/scripts/backup.sh
```

```bash
#!/usr/bin/env bash
set -euo pipefail

ENDPOINT="https://s3.us-west-004.backblazeb2.com"
BUCKET="s3://YOUR-BUCKET/server-name/mysql"
PROFILE="b2"
TMP="/home/forge/backups"
STAMP=$(date +%F-%H%M)

mkdir -p "$TMP"

DBS=$(mysql --defaults-file=/home/forge/.my.cnf -N -e "SHOW DATABASES" \
  | grep -Ev '^(information_schema|performance_schema|mysql|sys)$')

for DB in $DBS; do
  FILE="$TMP/${DB}-${STAMP}.sql.gz"
  mysqldump --defaults-file=/home/forge/.my.cnf \
    --single-transaction --quick --routines --triggers --events "$DB" \
    | gzip -9 > "$FILE"

  if [ ! -s "$FILE" ] || [ $(stat -c%s "$FILE") -lt 1024 ]; then
    echo "WARN: $DB dump suspiciously small, skipping upload" >&2
    continue
  fi

  aws s3 cp "$FILE" "$BUCKET/$DB/" --profile "$PROFILE" --endpoint-url "$ENDPOINT"
  rm -f "$FILE"
done

echo "Backup complete: $STAMP"
```

```bash
chmod +x ~/scripts/backup.sh
```

**7. Run it manually once**

```bash
~/scripts/backup.sh
```

Then confirm in the B2 web UI that you see five folders with one `.sql.gz` each.

**8. Add to Forge Scheduler**

Forge → Server → Scheduler → New Scheduled Job.

| Field | Value |
| --- | --- |
| Command | `/home/forge/scripts/backup.sh` |
| User | `forge` |
| Frequency | Daily |

**9. Lifecycle rule**

In the B2 bucket, Lifecycle Settings → custom rule, `daysFromUploadingToHiding: 30`, `daysFromHidingToDeleting: 1`. Without this the bucket grows forever. Alternatively just set 'keep prior versions'.

**10. Restore**

```bash
aws s3 cp s3://BUCKET/server-name/mysql/DBNAME/FILE.sql.gz . --profile b2 --endpoint-url ENDPOINT
gunzip -c FILE.sql.gz | mysql -u forge -p SCRATCH_DB
```

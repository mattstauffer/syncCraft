#!/bin/sh

# Check for, and load, local syncCraft.cfg
if [ -r ./syncCraft.cfg ]; then
	. syncCraft.cfg
else
	echo "No syncCraft.cfg found in the current directory."
	exit
fi

# Set defaults
: ${mysql_path:='mysql'}
: ${local_db_username:='root'}
: ${local_db_password:='root'}

# Sync database and import
echo "Syncing database down..."

ssh $ssh_string "mysqldump $remote_db_name --quote-names --opt --hex-blob --add-drop-database -u$remote_db_username -p$remote_db_password" | $mysql_path -D$local_db_name -u$local_db_username -p$local_db_password
echo "Database synced and imported." >&2

# Sync assets
# @todo: Allow for an array of options
echo "Syncing assets down..."
rsync -auv $ssh_string:$remote_assets_path $local_assets_path
echo "Done syncing assets down."
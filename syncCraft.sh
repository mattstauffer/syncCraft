#!/bin/sh

function error_exit
{
#   ----------------------------------------------------------------
#   Function for exit due to fatal program error
#   	Accepts 1 argument:
#   		string containing descriptive error message
#   ----------------------------------------------------------------

    echo "${1:-"Unknown Error"}" 1>&2
    exit 1
}

# Check for, and load, local syncCraft.cfg
if [ -r ./syncCraft.cfg ]; then
	. syncCraft.cfg
else
	error_exit "No syncCraft.cfg found in the current directory."
fi

# Set defaults
: ${mysql_path:='mysql'}
: ${remote_db_host:='localhost'}
: ${local_db_username:='root'}
: ${local_db_password:='root'}

# Sync database and import
echo -e "\nSyncing database down...\n"

ssh $ssh_string "mysqldump $remote_db_name --quote-names --opt --hex-blob --add-drop-database -h$remote_db_host -u$remote_db_username -p\"$remote_db_password\"" | $mysql_path -D$local_db_name -u$local_db_username -p$local_db_password
echo -e "Database synced and imported.\n"

# Sync assets
echo -e "Syncing assets down...\n"

# Ensure remote_paths and local_paths are arrays, and have the same length
declare -p remote_paths 2> /dev/null | grep -q 'declare \-a' && echo 'Remote_paths is an array. Good.' || error_exit "Remote_paths is not an array. Exiting."
declare -p local_paths 2> /dev/null | grep -q 'declare \-a' && echo 'Local_paths is an array. Good.' || error_exit "Local_paths is not an array. Exiting."

rLen=${#remote_paths[@]}
lLen=${#local_paths[@]}
if [ "$rLen" -ne "$lLen" ]; then
	error_exit "Sorry, but remote_paths and local_paths need to have the same number of paths. Can't sync."
fi

# Sync
for (( i = 0 ; i < $rLen ; i++ )) do
	rPath=${remote_paths[$i]}
	lPath=${local_paths[$i]}
	echo -e "\nSyncing $rPath to $lPath"
	rsync -auv $ssh_string:$rPath $lPath
done

echo -e "\n\nDone syncing assets down."
syncCraft
=========

SyncCraft is a command-line shell script for sites powered by [Craft](http://buildwithcraft.com/) that makes it simple to sync your database and assets to your local machine from a remote server. This is geeky and could go wrong if you aren't familiar with shell scripts. Please use with extreme caution.

## What does it do?

SyncCraft downloads your remote database, deletes your local database, and imports the remote database into your local database. It then syncs down *any new/unchanged* assets from the folders you provide. It does this all via `ssh`, `mysqldump`, and `rsync`.

## Notes

 - This is in alpha
 - Newer versions will probably rely on `my.cnf` files to set MySQL authentication, rather than setting them as variables in `syncCraft.cfg`, but I'm open to suggestsions
 - **This is in alpha. BEWARE.**

## Instructions - alias

The easiest way to run the installer is to copy `syncCraft.cfg` into each site directory, and for each: fill in the variables, and then copy the following line and run it from your terminal from that directory.

```bash
bash <(curl -s https://raw.githubusercontent.com/mattstauffer/syncCraft/master/syncCraft.sh)
```

You could even add that line as an "alias" to your shell. Edit your `~/.bash_profile` (or `~/.zshrc` if you use Zsh) and add this line at the bottom to make this a powerful and simple shortcut:

```bash
alias syncCraft="bash <(curl -s https://raw.githubusercontent.com/mattstauffer/syncCraft/master/syncCraft.sh)"
```

Now close `~/.bash_profile` and restart your terminal window. You can now run this command from any of your site directories just by running the command `syncCraft`. That's it!

## Instructions - local copy

1. Download [syncCraft.sh][1] and place it somewhere you can access it easily from your Terminal. Consider your home folder (`~/`)
2. Make sure your permissions are set so it's executable: `chmod +x ~/syncCraft.sh`
3. Copy `syncCraft.cfg` into your site directory and fill in the variables
4. Run syncCraft from that directory: `~/syncCraft.sh` every time you want to sync it
5. That's it!


## GIF

![Animation showing syncCraft running](https://raw.githubusercontent.com/mattstauffer/syncCraft/master/syncCraft.gif)

[1]: https://raw.githubusercontent.com/mattstauffer/syncCraft/master/syncCraft.sh

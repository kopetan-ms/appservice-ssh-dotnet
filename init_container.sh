#!/usr/bin/env bash
cat >/etc/motd <<EOL 
  _____                               
  /  _  \ __________ _________   ____  
 /  /_\  \\___   /  |  \_  __ \_/ __ \ 
/    |    \/    /|  |  /|  | \/\  ___/ 
\____|__  /_____ \____/ |__|    \___  >
        \/      \/                  \/ 
A P P   S E R V I C E   O N   L I N U X
Documentation: http://aka.ms/webapp-linux
Dotnet quickstart: https://aka.ms/dotnet-qs
ASP .NETCore Version: `ls -X /usr/share/dotnet/shared/Microsoft.NETCore.App | tail -n 1`
Note: Any data outside '/home' is not persisted
EOL
cat /etc/motd

# Get environment variables to show up in SSH session
eval $(printenv | sed -n "s/^\([^=]\+\)=\(.*\)$/export \1=\2/p" | sed 's/"/\\\"/g' | sed '/=/s//="/' | sed 's/$/"/' >> /etc/profile)

# starting sshd process
/usr/sbin/sshd

# Format : coredump.hostname.processid.time 
# Example: coredump.7d77b4ff1fea.15.1571222166
containerName=`hostname`
export COMPlus_DbgMiniDumpName="$DUMP_DIR/coredump.$containerName.%d.$(date +%s)"

dotnet /app/DotnetContainers.dll
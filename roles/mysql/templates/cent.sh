########################################
# MySQL | MariaDB autologin
# License: GNU GPL v3+
# Author: Valerio Bozzolan
########################################
cat /var/log/messages | grep "A temporary password is generated for" | awk '{print $NF}' | xargs echo -e "username=root\npassword=$NF" >> /root/test.s
file=/root/test.s

while [ -z "$user" ] && read ln; do
        [[ "$ln" =~ user\ *=\ (.*)$ ]]
        user="${BASH_REMATCH[1]}"
done < $file

while [ -z "$pass" ] && read ln; do
        [[ "$ln" =~ password\ *=\ (.*)$ ]]
        pass="${BASH_REMATCH[1]}"
done < $file
mysql --connect-expired-password --user="$user" --password="$pass" -e "SET PASSWORD = PASSWORD('{{ mysql_password }}');" $@

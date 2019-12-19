#! /bin/bash
yum -y install vsftpd
systemctl start vsftpd.service
systemctl status vsftpd.service
getsebool -a | grep ftp
setsebool -P ftpd_full_access on
firewall-cmd --permanent --zone=public --add-service=ftp
firewall-cmd --reload
firewall-cmd --list-all
echo "# Example config file /etc/vsftpd/vsftpd.conf
#
# The default compiled in settings are fairly paranoid. This sample file
# loosens things up a bit, to make the ftp daemon more usable.
# Please see vsftpd.conf.5 for all compiled in defaults.
#
# READ THIS: This example file is NOT an exhaustive list of vsftpd options.
# Please read the vsftpd.conf.5 manual page to get a full idea of vsftpd's
# capabilities.
#
# Allow anonymous FTP? (Beware - allowed by default if you comment this out).
anonymous_enable=NO
#
# Uncomment this to allow local users to log in.
# When SELinux is enforcing check for SE bool ftp_home_dir
local_enable=YES
#
# Uncomment this to enable any form of FTP write command.
write_enable=YES
#
# Default umask for local users is 077. You may wish to change this to 022,
# if your users expect that (022 is used by most other ftpd's)
local_umask=022
#
# Uncomment this to allow the anonymous FTP user to upload files. This only
# has an effect if the above global write enable is activated. Also, you will
# obviously need to create a directory writable by the FTP user.
# When SELinux is enforcing check for SE bool allow_ftpd_anon_write, allow_ftpd_full_access
#anon_upload_enable=YES
#
# Uncomment this if you want the anonymous FTP user to be able to create
# new directories.
#anon_mkdir_write_enable=YES
#
# Activate directory messages - messages given to remote users when they
# go into a certain directory.
dirmessage_enable=YES
#
# Activate logging of uploads/downloads.
xferlog_enable=YES
#
# Make sure PORT transfer connections originate from port 20 (ftp-data).
connect_from_port_20=YES
#
# If you want, you can arrange for uploaded anonymous files to be owned by
# a different user. Note! Using "root" for uploaded files is not
# recommended!
#chown_uploads=YES
#chown_username=whoever
#
# You may override where the log file goes if you like. The default is shown
# below.
#xferlog_file=/var/log/xferlog
#
# If you want, you can have your log file in standard ftpd xferlog format.
# Note that the default log file location is /var/log/xferlog in this case.
xferlog_std_format=YES
#
# You may change the default value for timing out an idle session.
#idle_session_timeout=600
#
# You may change the default value for timing out a data connection.
#data_connection_timeout=120
#
# It is recommended that you define on your system a unique user which the
# ftp server can use as a totally isolated and unprivileged user.
#nopriv_user=ftpsecure
#
# Enable this and the server will recognise asynchronous ABOR requests. Not
# recommended for security (the code is non-trivial). Not enabling it,
# however, may confuse older FTP clients.
#async_abor_enable=YES
#
# By default the server will pretend to allow ASCII mode but in fact ignore
# the request. Turn on the below options to have the server actually do ASCII
# mangling on files when in ASCII mode.
# Beware that on some FTP servers, ASCII support allows a denial of service
# attack (DoS) via the command "SIZE /big/file" in ASCII mode. vsftpd
# predicted this attack and has always been safe, reporting the size of the
# raw file.
# ASCII mangling is a horrible feature of the protocol.
#ascii_upload_enable=YES
#ascii_download_enable=YES
#
# You may fully customise the login banner string:
#ftpd_banner=Welcome to blah FTP service.
#
# You may specify a file of disallowed anonymous e-mail addresses. Apparently
# useful for combatting certain DoS attacks.
#deny_email_enable=YES
# (default follows)
#banned_email_file=/etc/vsftpd/banned_emails
#
# You may specify an explicit list of local users to chroot() to their home
# directory. If chroot_local_user is YES, then this list becomes a list of
# users to NOT chroot().
# (Warning! chroot'ing can be very dangerous. If using chroot, make sure that
# the user does not have write access to the top level directory within the
# chroot)
#chroot_local_user=YES
#chroot_list_enable=YES
# (default follows)
#chroot_list_file=/etc/vsftpd/chroot_list
#
# You may activate the "-R" option to the builtin ls. This is disabled by
# default to avoid remote users being able to cause excessive I/O on large
# sites. However, some broken FTP clients such as "ncftp" and "mirror" assume
# the presence of the "-R" option, so there is a strong case for enabling it.
#ls_recurse_enable=YES
#
# When "listen" directive is enabled, vsftpd runs in standalone mode and
# listens on IPv4 sockets. This directive cannot be used in conjunction
# with the listen_ipv6 directive.
listen=NO
#
# This directive enables listening on IPv6 sockets. By default, listening
# on the IPv6 "any" address (::) will accept connections from both IPv6
# and IPv4 clients. It is not necessary to listen on *both* IPv4 and IPv6
# sockets. If you want that (perhaps because you want to listen on specific
# addresses) then you must run two copies of vsftpd with two configuration
# files.
# Make sure, that one of the listen options is commented !!
listen_ipv6=YES

pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES

#NEXT IS ADDED

ascii_upload_enable=YES
ascii_download_enable=YES

chroot_local_user=YES
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/chroot_list

guest_enable=YES
guest_username=ftpuser
user_config_dir=/etc/vsftpd/vuser_conf
allow_writeable_chroot=YES" > /etc/vsftpd/vsftpd.conf
mkdir /home/vsftpd
useradd -g root -M -d /home/vsftpd -s /sbin/nologin ftpuser
echo "虚拟用户的密码：为123456"
echo "123456" | passwd --stdin ftpuser
chown -R ftpuser.root /home/vsftpd
touch /etc/vsftpd/vuser_passwd
echo "user1
123456
user2
123456" > /etc/vsftpd/vuser_passwd
echo "初始帐号密码为：
user1
123456
user2
123456
"
db_load -T -t hash -f /etc/vsftpd/vuser_passwd /etc/vsftpd/vuser_passwd.db
chmod 600 /etc/vsftpd/vuser_passwd.db
echo "#%PAM-1.0
session    optional     pam_keyinit.so    force revoke
#auth       required    pam_listfile.so item=user sense=deny file=/etc/vsftpd/ftpusers onerr=succeed
#auth       required    pam_shells.so
#auth       include     password-auth
#account    include     password-auth
session    required     pam_loginuid.so
session    include      password-auth
auth    required        /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser_passwd
account required        /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser_passwd
" > /etc/pam.d/vsftpd
mkdir /home/vsftpd/user1 /home/vsftpd/user2
chmod 755 ftp-user1
chmod 755 ftp-user2
mkdir /etc/vsftpd/vuser_conf
touch /etc/vsftpd/vuser_conf/user1 /etc/vsftpd/vuser_conf/user2
echo "local_root=/home/vsftpd/user1

write_enable=YES

anon_umask=022

anon_world_readable_only=NO

anon_upload_enable=YES

anon_mkdir_write_enable=YES

anon_other_write_enable=YES" > /etc/vsftpd/vuser_conf/user1
echo "local_root=/home/vsftpd/user2

write_enable=YES

anon_umask=022

anon_world_readable_only=NO

anon_upload_enable=YES

anon_mkdir_write_enable=YES

anon_other_write_enable=YES" > /etc/vsftpd/vuser_conf/user2
touch /etc/vsftpd/chroot_list
echo "user1
user2" > /etc/vsftpd/chroot_list
systemctl restart vsftpd
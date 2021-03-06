#!/bin/sh
export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical
apt-get clean -y
apt-get autoremove -y --purge

# Set up the machine to regenerate its SSH host keys on boot.
rm /etc/ssh/ssh_host_*
touch /etc/ssh/regenerate_host_keys
cat >/etc/rc.local <<EOM
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.

if [ -f /etc/ssh/regenerate_host_keys ]; then
  rm -f /etc/ssh/ssh_host_*
  /usr/sbin/dpkg-reconfigure openssh-server
  rm /etc/ssh/regenerate_host_keys
fi

exit 0
EOM
chmod +x /etc/rc.local

# Set up some sensible default nameservers
cat >/etc/resolvconf/resolv.conf.d/original <<EOM
# To change this, see /etc/resolvconf/resolv.conf.d/original
nameserver 8.8.8.8
nameserver 8.8.4.4
search localdomain
EOM

# Allow ubuntu to sudo without a password
cat >/etc/sudoers.d/ubuntu <<EOM
ubuntu ALL=(ALL) NOPASSWD: ALL
EOM
chmod 0440 /etc/sudoers.d/ubuntu
chown root /etc/sudoers.d/ubuntu

cat >>/etc/sudoers <<EOM
#includedir /etc/sudoers.d
EOM


# And, finally, truncate any and all log files
find /var/log/ -name "*log" -type f | xargs -I % sh -c "cat /dev/null >%"
[ -f /var/log/wtmp ] && cat /dev/null >/var/log/wtmp || true
[ -f /var/log/syslog ] && cat /dev/null >/var/log/syslog || true
[ -f /var/log/auth.log ] && cat /dev/null >/var/log/auth.log || true
[ -f /root/.bash_history ] && cat /dev/null >/root/.bash_history || true

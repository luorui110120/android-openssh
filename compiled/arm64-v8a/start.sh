#!/system/bin/sh
echo $0
if echo $0|grep "start.sh$">/dev/null ; then
ROOTPATH=$(dirname $(realpath "$0"))
cd $ROOTPATH
chmod 755 $ROOTPATH/bin/* >/dev/null 2>&1
res=`$ROOTPATH/bin/id | wc -l`
if [ $res -eq 0 ]; then
  rm -R $ROOTPATH/bin > /dev/null 2>&1
  cp -R $ROOTPATH/bin_back $ROOTPATH/bin
  chmod 755 $ROOTPATH/bin/*
	$ROOTPATH/bin/busybox --install -s $ROOTPATH/bin
	##del reboot  Incompatible
	rm $ROOTPATH/bin/reboot > /dev/null 2>&1
fi

chmod 600 $ROOTPATH/.ssh/*

cat>$ROOTPATH/sshd.config<<EOF
Port 17999
AddressFamily inet
ListenAddress 0.0.0.0

Protocol 2
HostKey $ROOTPATH/.ssh/ssh_host_rsa_key
LoginGraceTime 2m

PidFile $ROOTPATH/sshd.pid
LogLevel INFO

StrictModes no
PermitRootLogin yes

PubkeyAuthentication yes
ChallengeResponseAuthentication no
PasswordAuthentication no

PermitUserEnvironment yes

ClientAliveInterval 30
ClientAliveCountMax 3
GatewayPorts yes
PrintMotd no

AuthorizedKeysFile $ROOTPATH/.ssh/authorized_keys
Subsystem sftp internal-sftp
EOF

export LD_LIBRARY_PATH=$ROOTPATH/lib
export PATH=$ROOTPATH/bin:$PATH
$ROOTPATH/bin/sshd -f $ROOTPATH/sshd.config
fi
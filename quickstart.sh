#!/bin/bash
if [ -e /home/jovyan/verticace/vertica.deb ] && [ ! -e /opt/vertica/sbin/install_vertica ]; then
	echo "will install Vertica server and create database 'docker'"
	sudo /usr/sbin/groupadd -r verticadba 
	sudo /usr/sbin/useradd -r -m -s /bin/bash -g verticadba dbadmin 
	sudo /usr/sbin/locale-gen en_US en_US.UTF-8 
	sudo /usr/bin/dpkg -i /home/jovyan/verticace/vertica.deb 
	sudo /opt/vertica/sbin/install_vertica --license CE --accept-eula --hosts 127.0.0.1 --dba-user-password-disabled --failure-threshold NONE --no-system-configuration 
	sudo /bin/bash /tmp/debian_cleaner.sh
	echo 'Fixing filesystem permissions'
	gosu root chown -R dbadmin:verticadba "/home/jovyan/verticace"
	gosu root chown dbadmin:verticadba /opt/vertica/config/admintools.conf
	echo 'Creating database'
	gosu dbadmin bash -c "/opt/vertica/bin/admintools -t create_db --skip-fs-checks -s localhost -d docker -c /home/jovyan/verticace/catalog -D /home/jovyan/verticace/data"
	echo 'Starting Database'
	gosu dbadmin bash -c '/opt/vertica/bin/admintools -t start_db -d docker -i'
else
	echo "Vertica server is installed"
fi
if [ -e /home/jovyan/verticace/vertica-mc.deb ] && [ ! -e /opt/vconsole/bin/mctl ]; then
	echo "will install Vertica MC"
	gosu root /usr/bin/dpkg -i /home/jovyan/verticace/vertica-mc.deb 
else
	echo "Vertica MC is installed"
fi
fabmanager create-admin --app superset --username admin --firstname admin --lastname admin --email admin@fab.org --password admin
superset runserver -d &
jupyter notebook &


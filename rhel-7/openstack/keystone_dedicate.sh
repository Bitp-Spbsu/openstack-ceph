yum -y install `cat packages-keystone_only`

cp /etc/keystone/keystone.conf  /etc/keystone/keystone.conf.save.`date +%d.%m.%y-%H.%M`
openstack-config --set /etc/keystone/keystone.conf DEFAULT admin_token $sslkey
openstack-config --set /etc/keystone/keystone.conf DEFAULT verbose True
openstack-config --set /etc/keystone/keystone.conf database connection  "mysql://keystone:$KEYSTONE_DBPASS@$CONTROLLER/keystone"
openstack-config --set /etc/keystone/keystone.conf memcache servers "localhost:11211"
openstack-config --set /etc/keystone/keystone.conf token provider "keystone.token.providers.uuid.Provider"
openstack-config --set /etc/keystone/keystone.conf token driver "keystone.token.persistence.backends.memcache.Token"
openstack-config --set /etc/keystone/keystone.conf revoke driver "keystone.contrib.revoke.backends.sql.Revoke"


cat > /etc/httpd/conf.d/wsgi-keystone.conf << EOF
Listen 5000
Listen 35357

<VirtualHost *:5000>
    WSGIDaemonProcess keystone-public processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
    WSGIProcessGroup keystone-public
    WSGIScriptAlias / /var/www/cgi-bin/keystone/main
    WSGIApplicationGroup %{GLOBAL}
    WSGIPassAuthorization On
    LogLevel info
    ErrorLogFormat "%{cu}t %M"
    ErrorLog /var/log/httpd/keystone-error.log
    CustomLog /var/log/httpd/keystone-access.log combined
</VirtualHost>

<VirtualHost *:35357>
    WSGIDaemonProcess keystone-admin processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
    WSGIProcessGroup keystone-admin
    WSGIScriptAlias / /var/www/cgi-bin/keystone/admin
    WSGIApplicationGroup %{GLOBAL}
    WSGIPassAuthorization On
    LogLevel info
    ErrorLogFormat "%{cu}t %M"
    ErrorLog /var/log/httpd/keystone-error.log
    CustomLog /var/log/httpd/keystone-access.log combined
</VirtualHost>
EOF

mkdir -p /var/www/cgi-bin/keystone
curl http://git.openstack.org/cgit/openstack/keystone/plain/httpd/keystone.py?h=stable/kilo | tee /var/www/cgi-bin/keystone/main /var/www/cgi-bin/keystone/admin


chown -R keystone:keystone /var/www/cgi-bin/keystone
chmod 755 /var/www/cgi-bin/keystone/*
touch /var/log/keystone/keystone.log      
chown keystone: /var/log/keystone/keystone.log             

systemctl enable httpd.service
systemctl restart httpd.service

export OS_URL=http://$keystonehost:35357/v2.0
export OS_TOKEN=$sslkey


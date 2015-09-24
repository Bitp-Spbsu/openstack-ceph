#/bin/bash!


#cat >  /etc/yum.repos.d/ceph.repo << EOF
#[ceph-noarch]
#name=Ceph noarch packages
#baseurl=http://ceph.com/rpm-firefly/el7/noarch
#enabled=1
#gpgcheck=1
#type=rpm-md
#gpgkey=https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc
#EOF
yum -y install http://ceph.com/rpm-hammer/el7/noarch/ceph-release-1-0.el7.noarch.rpm

yum update -y 
yum -y  reinstall ceph-deploy

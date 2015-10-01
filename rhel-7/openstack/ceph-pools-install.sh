ceph osd pool create volumes 128
ceph osd pool create images 128
ceph osd pool create backups 128
ceph osd pool create vms 128

ceph auth get-or-create client.cinder mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=volumes, allow rwx pool=vms, allow rx pool=images'
ceph auth get-or-create client.glance mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=images'
ceph auth get-or-create client.cinder-backup mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=backups'

ceph auth get-or-create client.glance | ssh alice01 sudo tee /etc/ceph/ceph.client.glance.keyring
ssh alice01 sudo chown glance:glance /etc/ceph/ceph.client.glance.keyring
ceph auth get-or-create client.cinder | ssh alice01 sudo tee /etc/ceph/ceph.client.cinder.keyring
ssh alice01 sudo chown cinder:cinder /etc/ceph/ceph.client.cinder.keyring
ceph auth get-or-create client.cinder-backup | ssh alice01 sudo tee /etc/ceph/ceph.client.cinder-backup.keyring
ssh alice01 sudo chown cinder:cinder /etc/ceph/ceph.client.cinder-backup.keyring

for i in `cat osd.list`; do ceph auth get-key client.cinder | ssh $i sudo tee /etc/ceph/ceph.client.cinder.keyring; done


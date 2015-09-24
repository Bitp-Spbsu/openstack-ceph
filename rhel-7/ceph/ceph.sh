#/bin/sh!

#firwall:
firewall-cmd --zone=public --add-port=6789/tcp --permanent
firewall-cmd --zone=public --add-port=6800-7100/tcp --permanent
firewall-cmd --reload

#user:
useradd -m ceph

#sudo:
echo -e "Defaults:ceph !requiretty" > /etc/sudoers.d/ceph
echo -e "ceph\t\tALL=(ALL)\tNOPASSWD: ALL" >> /etc/sudoers.d/ceph

#hosts
cat /net/192.168.200.254/scratch/scripts/systeminst/hosts.templ > /etc/hosts

#Keys feom alice01
mkdir -p /home/ceph/.ssh/
chmod 700 /home/ceph/.ssh/
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqQY2yNZD0Sc8vG3LYq/n/0nXuaoWrEjay8N15OxCJZu8Wbg/U8BsmrBavwHCIX7YGKb21mCPlcYqjODQ298VK5zEirZF0d+5aNo/x/FhMvRIcLRo/gM8dZyKRQSLoRZ/8Eotg5cnvRfup9DneWC7RTvD/vLkxh2Or3joTl1qj1Gklt00KoZTBBWmEqjCMPtlWaYofIuveRqmkt+WPhLjjEe3kDMm4mlfAkF/bMHg/SCg4lt47V/LZd9dgvur3Z73GJq6BKyURG+4iai81MTwZxg7JLSQ+gPfF+Sx4P4VYzzw+2BwRCfYBOF0GX7HHrs3TDM3Nzoe/yhts5l2w84Yr ceph@alice01 " > /home/ceph/.ssh/authorized_keys
chown -R ceph: /home/ceph/.ssh



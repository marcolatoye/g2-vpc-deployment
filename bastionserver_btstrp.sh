#!/bin/bash 

sudo su -

####### Mounting EBS volumes and partioning them for webserver
# Set the variables for the EBS volumes and the logical volume
echo "Mounting EBS Volumes"

for vol in sdf sdg sdh sdi sdj
do
sudo parted /dev/$vol mklabel gpt

parted /dev/$vol mkpart primary ext4 0% 100%
done

#Create physical volume
pvcreate /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1

#Create the Volume Group: 
vgcreate stack_vg /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1

#create the Logical Volumes (LUNS) with about 5G of space allocated initially: 
for LUN in u01 u02 u03 u04 backups
do
lvcreate -L 5G -n Lv_$LUN stack_vg

#create est4 file system
mkfs.ext4 /dev/stack_vg/Lv_$LUN

mkdir /$LUN

mount /dev/stack_vg/Lv_$LUN /$LUN

lvextend -L +3G /dev/mapper/stack_vg-Lv_$LUN

resize2fs /dev/mapper/stack_vg-Lv_$LUN

echo "/dev/stack_vg/Lv_$LUN    /$LUN    ext4    defaults,noatime   0   2" >> /etc/fstab

mount -a
done

##Install the needed packages and enable the services(MariaDb, Apache)
sudo yum update -y
sudo yum install git -y
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd mariadb-server
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl is-enabled httpd


mkdir -p ${MOUNT_POINT}
chown ec2-user:ec2-user ${MOUNT_POINT}
chmod -R 755 /var/www/html

##Add ec2-user to Apache group and grant permissions to /var/www
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
cd /var/www/html
 
##Grant file ownership of /var/www & its contents to apache user
sudo chown -R apache /var/www
 
##Grant group ownership of /var/www & contents to apache group
sudo chgrp -R apache /var/www
 
##Change directory permissions of /var/www & its subdir to add group write 
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
 
##Recursively change file permission of /var/www & subdir to add group write perm
sudo find /var/www -type f -exec sudo chmod 0664 {} \;
 
##Restart Apache
sudo systemctl restart httpd
sudo service httpd restart
 
##Enable httpd 
sudo systemctl enable httpd 
sudo /sbin/sysctl -w net.ipv4.tcp_keepalive_time=200 net.ipv4.tcp_keepalive_intvl=200 net.ipv4.tcp_keepalive_probes=5

DD_API_KEY=${DD_KEY} DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"

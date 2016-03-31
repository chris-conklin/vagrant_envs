# Samba Configuration

## UPDATE 

It ends up that even though I can map the share on my mac, I could not get 
eclipse ide to all it as a workspace. 

sudo useradd cconklin
sudo passwd cconklin
sudo usermod -aG vagrant cconklin
sudo chmod -R 777 /var/www
sudo chmod g+s /var/www

none of this worked!

so then I tried to install Remote System Explorer from eclipse marketplace
I also installed php tools for the php perspective

I am not sure which of the above worked but once I entered the remote system 
perspective and created another connection, it defaulted to cconklin
but I was able to view the entire filesystem. I was also able to write to the
/var/www directory due to the above changes. I am not sure how to clean this up
properly.

## Installation

**sudo apt-get install -y samba samba-client samba-common**

## Config file

**sudo vim /etc/samba/smb.conf**

Either add the following or overwrite the default with this content:

```
[global]
workgroup = homenet 
server string = Samba Server %v
netbios name = vagrant php box
security = user
map to guest = bad user
dns proxy = no
#============================ Share Definitions ==============================
[webroot]
path = /var/www
browsable =yes
writable = yes
guest ok = yes
read only = no
```

This makes your web root writeable once you setup a password for an authorized user

## Access

**sudo smbpasswd -a vagrant**

It appears that the easiest way to enable both writing of the directory by vagrant and php
is to use the /var/www/ as the document store with the vagrant user (have not tested apache writes)

chown -R vagrant:vagrant /var/www


Once all of this is completed then you can restart and begin testing

**sudo service smbd restart**

## Additional commands

### Available Shares:

**smbclient -L yourhostname**

### Test Access:

**smbclient  //localhost/webroot**

### Check configuration

**testparm /etc/samba/smb.conf**
## Resources

<https://www.samba.org/samba/docs/man/Samba-HOWTO-Collection/install.html>

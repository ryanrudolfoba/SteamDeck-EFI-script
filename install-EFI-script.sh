#!/bin/bash

clear

echo SteamDeck EFI Script by ryanrudolf
echo https://github.com/ryanrudolfoba/SteamDeck-EFI-script
sleep 2

# Password sanity check - make sure sudo password is already set by end user!

if [ "$(passwd --status deck | tr -s " " | cut -d " " -f 2)" == "P" ]
then
	read -s -p "Please enter current sudo password: " current_password ; echo
	echo Checking if the sudo password is correct.
	echo -e "$current_password\n" | sudo -S -k ls &> /dev/null

	if [ $? -eq 0 ]

	then
		echo Sudo password is good!
	else
		echo Sudo password is wrong! Re-run the script and make sure to enter the correct sudo password!
		exit
	fi

else
	echo Sudo password is blank! Setup a sudo password first and then re-run script!
	passwd
	exit
fi

# sudo password is already set by the end user, all good let's go!
echo -e "$current_password\n" | sudo -S ls &> /dev/null
if [ $? -eq 0 ]
then
	echo 1st sanity check. So far so good!
else
	echo Something went wrong on the 1st sanity check! Re-run script!
	exit
fi

# Sanity check - is SteamOS EFI entry exists?
efibootmgr | grep "Steam" &> /dev/null

if [ $? -eq 0 ]
then
	echo SteamOS EFI entry is good, no action needed!
else
	echo SteamOS EFI entry does not exist! Re-creating SteamOS EFI entry.
	sudo efibootmgr -c -d /dev/nvme0n1 -p 1 -L "SteamOS" -l "\EFI\steamos\steamcl.efi" &> /dev/null
fi

# make SteamOS the next boot option!
Steam=$(efibootmgr | grep -i Steam | colrm 9 | colrm 1 4)
sudo efibootmgr -n $Steam &> /dev/null

sleep 2
echo \****************************************************************************
echo Post install scripts saved in 1SteamDeck-EFI. Use them as needed -
echo \****************************************************************************
echo uninstall-EFI.sh     -   Use this to completely uninstall the EFI script.
echo \****************************************************************************
echo \****************************************************************************

#################################################################################
################################ post install ###################################
#################################################################################

# create ~/1SteamDeck-EFI and place the scripts in there
mkdir -p ~/1SteamDeck-EFI/ &> /dev/null

# uninstall-EFI.sh
cat > ~/1SteamDeck-EFI/uninstall-EFI.sh << EOF
#!/bin/bash

grep -v 1SteamDeck-EFI ~/.bash_profile > ~/.bash_profile.temp
mv ~/.bash_profile.temp ~/.bash_profile

rm -rf ~/1SteamDeck-EFI/*

# make Windows the next boot option!
Windows=\$(efibootmgr | grep -i Windows | colrm 9 | colrm 1 4)
sudo efibootmgr -n \$Windows &> /dev/null
echo SteamDeck EFI tools has been uninstalled and the Windows EFI entry has been restored!
EOF

# post-install-EFI.sh
cat > ~/1SteamDeck-EFI/post-install-EFI.sh << EOF
#!/bin/bash
echo -e "$current_password\n" | sudo -S ls &> /dev/null

date  > ~/1SteamDeck-EFI/status.txt

echo BIOS Version : \$(sudo dmidecode -s bios-version) >> ~/1SteamDeck-EFI/status.txt

# Sanity Check - are the needed EFI entries available?

efibootmgr | grep -i Steam &> /dev/null
if [ \$? -eq 0 ]
then
	echo SteamOS EFI entry exists! No need to re-add SteamOS. >> ~/1SteamDeck-EFI/status.txt
else
	echo SteamOS EFI entry is not found. Need to re-add SteamOS. >> ~/1SteamDeck-EFI/status.txt
	sudo efibootmgr -c -d /dev/nvme0n1 -p 1 -L "SteamOS" -l "\EFI\steamos\steamcl.efi" &> /dev/null
fi

# make SteamOS the next boot option!
Steam=\$(efibootmgr | grep -i Steam | colrm 9 | colrm 1 4)
sudo efibootmgr -n \$Steam &> /dev/null

echo "*** Current state of EFI entries ****" >> ~/1SteamDeck-EFI/status.txt
efibootmgr >> ~/1SteamDeck-EFI/status.txt
EOF

grep 1SteamDeck-EFI ~/.bash_profile &> /dev/null
if [ $? -eq 0 ]
then
	echo Post install script already present no action needed! SteamDeck-EFI-script install is done!
else
	echo Post install script not found! Adding post install script!
	echo "~/1SteamDeck-EFI/post-install-EFI.sh" >> ~/.bash_profile
	echo Post install script added! SteamDeck-EFI-script install is done!
fi

chmod +x ~/1SteamDeck-EFI/*

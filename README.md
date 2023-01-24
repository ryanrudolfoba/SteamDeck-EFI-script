# Steam Deck - Dual Boot Script Without a Graphical Boot Manager


## About

This repository containts the instructions and scripts that will mostly benefit Steam Deck users who have setup a dual boot - SteamOS and Windows but does not want to use a graphical boot manager like [Clover](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot) or [rEFInd.](https://github.com/ryanrudolfoba/SteamDeck-rEFInd-dualboot)

Once the script is active, the default behavior is that it will always boot to SteamOS.

If user wants to use Windows - power off the Steam Deck and while powered off, press VOLDOWN + POWER then select Windows.

The script is also smart enough so that when a BIOS / SteamOS update breaks the EFI entries, just manually boot via steamcl.efi and it will automatically re-create the SteamOS EFI entries.


## Disclaimer

1. Do this at your own risk!
2. This is for educational and research purposes only!


## !!! WARNING - WARNING - WARNING !!!
> **WARNING!**\
> Please carefully read the items below!
1. The script has been thoroughly tested on a fresh SteamOS and Windows install.
2. If your SteamOS has prior traces of rEFInd or scripts / systemd services related to rEFInd, it is suggested to uninstall / remove those first before proceeding.
3. If your Windows install has scripts or programs related to rEFInd / EasyUEFI, it is suggested to uninstall / remove those first before proceeding.


## Prerequisites for SteamOS and Windows
**Prerequisites for SteamOS**
1. No prior traces of rEFInd or scripts / systemd services related to rEFInd.
2. sudo password should already be set by the end user. If sudo password is not yet set, the script will ask to set it up.

**Prerequisites for Windows**
1. No scripts / scheduled tasks related to rEFInd or EasyUEFI.
        

## Using the Script
> **NOTE1 - Make sure you fully read and understand the disclaimer, warnings and prerequisites!**

> **NOTE2**\
> The installation is divided into 2 parts - 1 for SteamOS, and 1 for Windows.\
> The recommended way is to do the steps on SteamOS first, and then do the steps for Windows.

> **For the SteamOS side**\
> Extra scripts are saved in ~/1SteamDeck-EFI that contains additional scripts to automatically recreate the EFI entries and an uninstall to reverse any changes made.\
> There are no extra systemd scripts created.

> **For the Windows side**\
> The script creates a folder called C:\1SteamDeck-EFI and creates a Scheduled Task.\
> The Scheduled Task runs the powershell script saved in C:\1SteamDeck-EFI-script. The powershell script queries the EFI entries and sets SteamOS to be the next boot entry.


**Installation Steps for SteamOS**

1. Go into Desktop Mode and open a konsole terminal.
2. Clone the github repo. \
   cd ~/ \
   git clone https://github.com/ryanrudolfoba/SteamDeck-EFI-script
   
3. Execute the script! \
   cd ~/SteamDeck-EFI \
   chmod +x install-EFI.sh \
   ./install-EFI.sh
   ![image](https://user-images.githubusercontent.com/98122529/214392697-2b378402-99c3-483c-8e15-9422e2df11ed.png)

4. The script will check if sudo passwword is already set.\
   **4a.**
         If it is already set, enter the current sudo password and the script will continue.\
         If wrong password is provided the script will exit immdediately. Re-run the script and enter the correct sudo password!
         ![image](https://user-images.githubusercontent.com/98122529/214392794-2347c305-d229-487a-b51f-685201bc1ff8.png)

   **4b.**
         If the sudo password is blank / not yet set by the end user, the script will prompt to setup the sudo password. Re-run the script to continue.
         ![image](https://user-images.githubusercontent.com/98122529/214393036-bdb53ad5-5a1e-4d47-81bc-e63f02cb7fa9.png)

   **4c.**
         Script will continue to run and perform sanity checks all throughout the install process. Once done, reboot the Steam Deck and it will automatically boot to SteamOS.
         ![image](https://user-images.githubusercontent.com/98122529/214392892-7e835a81-c371-4931-b32e-402dfc6224f3.png)
     


**Installation Steps for Windows**
1. Download the ZIP by pressing the GREEN CODE BUTTON, then select Download ZIP.
![image](https://user-images.githubusercontent.com/98122529/213036054-581579ff-ea23-4a0e-a9ca-f9020a7b7d25.png)

2. Go to your Downloads folder and then extract the zip.
3. Right click rEFIndWindows.bat and select RUNAS Administrator.

![image](https://user-images.githubusercontent.com/98122529/213036416-c306e095-34ec-4ec2-83a9-4d864ea0ecd9.png)

4. The script will automatically create the C:\1SteamDeck-EFI-script folder and copy the files in there.\
5. It will also automatically create the Scheduled Task called SteamOS-Task-donotdelete
![image](https://user-images.githubusercontent.com/98122529/213036461-cf81f8f8-6ef5-42af-b3c8-9ba91596da64.png)

6. Go to Task Scheduler and the SteamOS-Task will show up in there.
7. Right-click the SteamOS-Task and select Properties.
![image](https://user-images.githubusercontent.com/98122529/213036710-e1b4c0b6-e42e-4d16-a1c2-8f3a38590472.png)

8. Under the General tab, make sure it looks like this. Change it if it doesn't then press OK.
![image](https://user-images.githubusercontent.com/98122529/213036769-87cfb18e-b423-48f5-8d1e-cd9434bdfa52.png)

9. Right click the task and select RUN.

![image](https://user-images.githubusercontent.com/98122529/213036820-ec06a5fb-55d7-42f1-9cfb-d11ec500ef06.png)

10. Close Task Scheduler. Go to C:\1SteamDeck-EFI and look for the file called status.txt.

11. Open status.txt and the SteamOS GUID should be the same as the bootsequence. Sample below.
![image](https://user-images.githubusercontent.com/98122529/213036895-fd7f5f00-e263-47aa-b5da-0accc476d848.png)

12. Reboot the Steam Deck and it will automatically boot into SteamOS.


## FAQ / Troubleshooting
Read this for your Common Questions and Answers! This will be regularly updated and some of the answers in here are contributions from the [WindowsOnDeck reddit community!](https://www.reddit.com/r/WindowsOnDeck/)

    
### Q1. I reinstalled Windows and now it boots directly to Windows instead of rEFInd!

1. Follow the steps for the Windows scheduled task install.

### Q2. There was a SteamOS update and it wiped all my boot entries!
1. Turn OFF the Steam Deck. While powered OFF, press VOLUP + POWER.
2. Go to Boot from File > efi > steamos > steamcl.efi
3. Wait until SteamOS boots up and it will automatically fix the EFI entries.
4. On the next reboot it will go to SteamOS.

### Q7. I hate this script / I want to just dual boot the manual way / A better script came along and I want to uninstall your work!

1. Boot into SteamOS.
2. Open a konsole terminal and run the uninstall script - \
   cd ~/1SteamDeck-EFI \
   ./uninstall-EFI.sh\
   ![image](https://user-images.githubusercontent.com/98122529/214394045-43d5f458-5717-4ce0-a75b-ab37dc2a702f.png)
   
3. Reboot the Steam Deck and it will automatically load Windows.

4. Go to Task Scheduler. Delete the SteamOS-Task.

5. Go to C: and delete the SteamDeck-EFI-script folder.

6. Script has been uninstalled on both SteamOS and Windows!

### Q8. I like your work how do I show a token of appreciation?
You can send me a message on reddit / discord to say thanks!

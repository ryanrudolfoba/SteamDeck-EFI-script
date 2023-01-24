# This will make the SteamOS boot entry to be the next available option on boot!
# sleep 60
#
# some crazy string manipulation to filter for the SteamOS EFI entry
$SteamOSstatus="C:\1SteamDeck-EFI\status.txt"
$SteamOStmp="C:\1SteamDeck-EFI\SteamOStmp.txt"
$querySteamOS = bcdedit.exe /enum firmware | Select-String -pattern steamcl.efi -Context 2 | out-file $SteamOStmp
$SteamOS = get-content $SteamOStmp | select-string -pattern Volume -context 2 | findstr "{" ; `
$SteamOS = $SteamOS -replace '.*\{' -replace '\}.*'
rm $SteamOStmp
bcdedit /set "{fwbootmgr}" bootsequence "{$SteamOS}" /addfirst
#
# create log file for troubleshooting
"*** SteamOS log file for troubleshooting ***" | out-file $SteamOSstatus
"Provide the contents of this text file when reporting issues." | out-file -append $SteamOSstatus
get-date | out-file -append $SteamOSstatus
"SteamOS GUID $SteamOS" | out-file -append $SteamOSstatus
bcdedit /enum firmware | Select-String -pattern bootsequence | out-file -append $SteamOSstatus

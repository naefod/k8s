$v = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' # get the version of os
$version ='{0}' -f $v.DisplayVersion 
echo $version
echo $this
if ($version -eq '22H2'){
     echo "you dont have the last version of build os, will update now!"
     Install-Module PSWindowsUpdate -AcceptAll
     Get-WindowsUpdate
     Install-WindowsUpdate -AcceptAll 
     Restart-Computer
     Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'| Select DisplayVersion
     echo "happy update !"
} else {"you have the last version of build os "}

#Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'| Select DisplayVersion # get the version of os 



$wmiQuery = "SELECT * FROM AntiVirusProduct"
$AntivirusProduct = Get-WmiObject -Namespace "root\SecurityCenter2" -Query $wmiQuery  @psboundparameters
$AntivirusNames = $AntivirusProduct.displayName 
$AntivirusNames
if ($AntivirusNames -eq 'Windows Defender'){
     "you have antiverus, will delete it"
     Get-Command -Module Defender
     Get-Service Windefend, SecurityHealthService, wscsvc| Select Name,DisplayName, Status
}else {"you dont have antineruse"}


#$AVList = @(Get-CimInstance -Namespace 'root/SecurityCenter2' -ClassName 'AntivirusProduct')

#switch ($AVList.Count)
##switch (0)
##switch (3)
#    {
#    0 {Write-Warning 'No AV product detected.'}
#    1 {
#        Write-Host 'There is just one AV product installed.'
#        Write-Host ('    DisplayName = {0}' -f $AVList.displayName)
#        }
#    default
#        {
#        Write-Warning ('There are {0} AV products installed on this system.' -f $AVList.Count)
#        Write-Warning ('    DisplayNames = {0}' -f ($AVList.displayName -join ', '))
#        }
#    }


#Get-Command -Module Defender
#Get-Service Windefend, SecurityHealthService, wscsvc| Select Name,DisplayName, Status
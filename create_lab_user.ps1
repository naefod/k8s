
# to create the lab user
secedit /export /cfg c:\secpol.cfg
(gc C:\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\secpol.cfg
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY
rm -force c:\secpol.cfg -confirm:$false

NET ACCOUNTS /MINPWLEN:4

NET ACCOUNTS


# create the lab user 

$Password = Read-Host -AsSecureString

New-LocalUser "lab" -Password $Password -Description "Add lab user under Administrators group" # create a user 



# add a user to a group.
Add-LocalGroupMember -Group "Administrators" -Member "lab"  



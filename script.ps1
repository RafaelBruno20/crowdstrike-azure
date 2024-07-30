#Connect to Azure
$tenantID = ""
$subscriptionID = @(
    "",
    ""
)
$appClientID = ""
$appSecretValue = ""

$securePassword = ConvertTo-SecureString -String $appSecretValue

#Create a diagnostics VM



#Turn off all VMs that are affected
try {
   foreach ($vm in $affectedVMs) {
        $vmStatus = Get-AzVM | Where-Object {$_.Name -match $vm} -ErrorAction SilentlyContinue

        if ($null -eq $vmStatus) {
            Write-Output "${$vm} does not exist. Please check the name and try again!"
        }
        else {
            if ($null -eq $vmStatus.StatusCode) {
                
            }
        }
    }
}
catch {
    <#Do this if a terminating exception happens#>
}



#Create a snapshot and a new disk of C Drive





#Attached to the new diagnostics VM as a data disk





#Remote PS connect to the VM



#Activate new disk and delete broken file




#Detach the disk from the VM




#Swap the OS Disk

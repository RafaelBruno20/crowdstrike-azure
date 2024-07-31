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
        $vmTrue = Get-AzVM | Where-Object {$_.Name -match $vm} -ErrorAction SilentlyContinue

        if ($null -eq $vmTrue) {
            Write-Output "$vm does not exist. Please check the name and try again!"
        }
        else {
            $vmStatus = Get-AzVm -Name $vmTrue.Name -Status

            if ($vmStatus.Statuses[1].Code -match "running") {
                Write-Host "$($vmTrue.Name) is running. Turning it off now..." -ForegroundColor Yellow

                Stop-AzVM -Name $vmTrue.Name -ResourceGroupName $vmTrue.ResourceGroupName
                Start-Sleep 30

                Write-Host "$($vmTrue.Name) is now shutting down!" -ForegroundColor Green
            }
            else {
                Write-Host "$($vmTrue.Name) is already off."
            }
        }
    }

    Write-Host "All affected VMs have been turned off, creating a snapshot of the C drive now!" -ForegroundColor Blue
}
catch {
}

#Create a snapshot and a new disk of C Drive
try {
    foreach ($vm in $affectedVMs) {
        $vmStatus = Get-AzVm -Name $vm -Status

        #Confirm if the VM is stopped
        if ($vmStatus.Statuses[1].Code -match "stopped") {
            
            Write-Host "$vm is stopped. Creating a snapshot of the C drive..." -ForegroundColor Yellow

            $vmID = Get-AzVM -Name $vm

            $snapName = "$vm" + "-c-snap"
            $createOption = "Copy"
            
            $snapshotConfig = New-AzSnapshotConfig `
            -SourceUri $vmId.StorageProfile.OsDisk.ManagedDisk.Id `
            -Location $vmID.Location `
            -CreateOption $createOption `
            -SnapshotName $snapName `
            -ResourceGroupName $vmID.ResourceGroupName

            New-AzSnapshot -Snapshot $snapshotConfig

            #Confirm if snapshot was created correctly

            $snapConfirm = Get-AzSnapshot -SnapshotName $snapName
            $snapConfirm.Name

            if ($null -eq $snapConfirm) {
                Write-Host "Snapshot $snapName was not created..." -ForegroundColor Red
            }

            Write-Host "Snapshot $($snapConfirm.Name) was create sucessufully!" -ForegroundColor Green
            
        }
        else {
            Write-Host "Not able to create a snapshot of C Drive for $vm" -ForegroundColor Red
        }
    }
}
catch {
    <#Do this if a terminating exception happens#>
}




#Attached to the new diagnostics VM as a data disk





#Remote PS connect to the VM



#Activate new disk and delete broken file




#Detach the disk from the VM




#Swap the OS Disk

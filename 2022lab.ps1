$vms = "SERVER01","SERVER02"

foreach($vm in $vms){
$path = "D:\Hyper-V\" + $vm + "\Virtual Hard Disks\"
md $path
New-VHD -ParentPath "D:\Hyper-V\base2022\Virtual Hard Disks\base2022.vhdx" -Path ($path + "\" + $vm + ".vhdx") -Differencing
}
foreach($vm in $vms){
#$path = "D:\Hyper-V\Virtual Machines\"
$path = "D:\Hyper-V\"
$target = "D:\Hyper-V\" + $vm + "\Virtual Hard Disks\" + $vm + ".vhdx"
new-vm -name $vm -MemoryStartupBytes 2GB -Path $path -VHDPath $target -generation 2 -SwitchName LAN
Set-VMMemory $vm -DynamicMemoryEnabled $true -MinimumBytes 2GB -StartupBytes 2GB -MaximumBytes 4GB -Priority 50 -Buffer 20
$dpath = "D:\Hyper-V\" + $vm + "\Virtual Hard Disks\" + $vm + "_1.vhdx"
new-vhd -Path $dpath -SizeBytes 107374182400 -dynamic
Add-VMHardDiskDrive -ControllerType SCSI -Path $dpath -VMname $vm
#Start-VM $vm
}


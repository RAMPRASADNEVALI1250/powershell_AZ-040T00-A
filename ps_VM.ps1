param (
    [parameter(Mandatory = $true)]
    [string] $vm_name = "prod-eastus-1",

    [parameter(Mandatory = $true)]
    [string] $rg_name = "prod"
)

#other param
$location = "eastus"
$vnet = "prod"
$subnet = "subnet1"

$cred = Get-Credential

if (!(get-azvm -name $vm_name -ResourceGroupName $rg_name -ErrorAction SilentlyContinue)) {
    New-AzVM -ResourceGroupName $rg_name `
            -Location $location -Name $vm_name `
            -VirtualNetworkName $vnet -SubnetName $subnet `
            -ImageName Ubuntu2204 -Size standard_ds1_v2 -Credential $cred `
            -OpenPorts 22
    }

#create a public ip, thiscould be done during vm creation as well
$publicip = New-AzPublicIpAddress -Name "ubip" -ResourceGroupName $rg_name `
            -Location "eastus" -AllocationMethod Static `
            -sku Basic

$nic = Get-AzNetworkInterface -ResourceGroupName $rg_name -Name prod-eastus-1

$nic.IpConfigurations[0].PublicIpAddress = $publicip
Set-AzNetworkInterface -NetworkInterface $nic
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

if (!(get-azvm -name $vm_name -ResourceGroupName $rg_name -ErrorAction SilentlyContinue)) {
    New-AzVM -ResourceGroupName $rg_name `
            -Location $location -Name $vm_name `
            -VirtualNetworkName $vnet -SubnetName $subnet `
            -ImageName Ubuntu2204 -Size standard-ds1_v5 -Credential (Get-Credential) `
            -OpenPorts 22
    }
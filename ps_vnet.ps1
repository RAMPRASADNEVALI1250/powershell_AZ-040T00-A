param (
    [Parameter(Mandatory = $true)]
    [string]$vnet_name,

    [Parameter(Mandatory = $true)]
    [string]$rg_name,

    [Parameter(Mandatory = $true)]
    [string]$vnet_location,

    [string]$addr_prefix = "10.0.0.0/16"
    )

function check-vnetExist {
    
    param (
    [Parameter(Mandatory = $true)]
    [string]$vnet_name,

    [Parameter(Mandatory = $true)]
    [string]$rg_name
    )

    if (Get-AzResourceGroup -name $rg_name -ErrorAction SilentlyContinue){
        if (Get-AzVirtualNetwork -name $vnet_name -ResourceGroupName $rg_name -ErrorAction SilentlyContinue){
            Write-Host "Vnets $vnet_name exists in Rg $rg_name"
            return $true
        }
    } else {
        Write-Host "Resource group $rg_name doesnt exists"
        return $false
    }
}

$tags = @{ 
            env= "dev"
            owner = "ram"
        }

$subnet = New-AzVirtualNetworkSubnetConfig -Name "subnet1" -AddressPrefix "10.0.0.0/24"

if (!(check-vnetExist $vnet_name $rg_name )) {
    New-AzVirtualNetwork `
        -Name $vnet_name -ResourceGroupName $rg_name -Location $vnet_location -Tag $tags `
        -AddressPrefix $addr_prefix -Subnet $subnet
    #Write-Host "Vnet $vnet_name creating...."

} else {
    Write-Host "Vnet $vnet_name already exits"
}

#Remove-AzVirtualNetwork -Name dev-test -ResourceGroupName Role-Test -Force

#.\ps_vnet.ps1 dev-test role-test eastus
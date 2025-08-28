#Connect-AzAccount -Tenant "86c18b2a-5e00-4f70-af18-d39bb64a6c49"

function azure-rg {
   param (
    #[Parameter(Mandatory = $true)]
    [string] $RG_listpath = "D:\ps_practice\RG_list.txt",

    [Parameter(Mandatory = $true)]
    [ValidateSet("create", "delete")]
    [string]$Action
   )
   $location = "canadacentral"
    $existingRG = Get-AzResourceGroup | Select-Object -ExpandProperty ResourceGroupName

    $requiredRG = Get-Content -Path $RG_listpath
    switch ($Action)
       {
           "create" {
            foreach ($rg in $requiredRG){
                if ($rg -notin $existingRG){
                    New-AzResourceGroup -Name $rg -Location $location
                } else {
                    Write-Host "RG $rg already exits" -ForegroundColor Green
                }}
                }
           "delete" {
                foreach ($rg in $requiredRG){
                if ($rg -in $requiredRG){
                    Remove-AzResourceGroup -Name $rg -Force
                } else {
                    Write-Host "RG $rg doesnt exits in Azure" -ForegroundColor Yellow
                }
           }
           }
           default {
            Write-Host "Provide either create or delete only" 
            }
       }
    

    }


Measure-Command { azure-rg -Action create}
Measure-Command {azure-rg -Action delete}

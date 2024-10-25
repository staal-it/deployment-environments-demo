'Az.ImageBuilder', 'Az.ManagedServiceIdentity' | ForEach-Object {Install-Module -Name $_ -AllowPrerelease}
Import-Module Az.ManagedServiceIdentity
# Get your current subscription ID  
$subscriptionID="f317d45c-55f5-4341-8d49-990b06d1c9a5"
# Destination image resource group  
$imageResourceGroup="rg-innoday-deployenvironments"  
# Location  
$location="westeurope"  
# Image distribution metadata reference name  
$runOutputName="aibCustWinManImg01"  
# Image template name  
$imageTemplateName="vscodeWinTemplate"

# Gallery name 
$galleryName= "devboxGallery" 

# Image definition name 
$imageDefName ="vscodeImageDef" 

# Additional replication region 
$replRegion2="northeurope"

# Set up role def names, which need to be unique 
$timeInt=$(get-date -UFormat "%s") 
$identityName="aibIdentity"+$timeInt 

## Add an Azure PowerShell module to support AzUserAssignedIdentity 
Install-Module -Name Az.ManagedServiceIdentity 

# Create an identity 
New-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName -Location $location

$identityNameResourceId=$(Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).Id 
$identityNamePrincipalId=$(Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).PrincipalId

Write-Host "Identity Resource ID: $identityNameResourceId"

New-AzRoleAssignment -ObjectId $identityNamePrincipalId -RoleDefinitionName "Contributor" -Scope "/subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup" 

# Create the gallery 
New-AzGallery -GalleryName $galleryName -ResourceGroupName $imageResourceGroup -Location $location 

$SecurityType = @{Name='SecurityType';Value='TrustedLaunch'}  
$features = @($SecurityType) 

# Create the image definition
New-AzGalleryImageDefinition -GalleryName $galleryName -ResourceGroupName $imageResourceGroup  -Location $location  -Name $imageDefName  -OsState generalized  -OsType Windows  -Publisher 'myCompany'  -Offer 'vscodebox'  -Sku '1-0-0' -Feature $features -HyperVGeneration "V2"

$templateFilePath = "./Images/image-dev.json"

(Get-Content -path $templateFilePath -Raw ) -replace '<subscriptionID>',$subscriptionID | Set-Content -Path $templateFilePath 
(Get-Content -path $templateFilePath -Raw ) -replace '<rgName>',$imageResourceGroup | Set-Content -Path $templateFilePath 
(Get-Content -path $templateFilePath -Raw ) -replace '<runOutputName>',$runOutputName | Set-Content -Path $templateFilePath  
(Get-Content -path $templateFilePath -Raw ) -replace '<imageDefName>',$imageDefName | Set-Content -Path $templateFilePath  
(Get-Content -path $templateFilePath -Raw ) -replace '<sharedImageGalName>',$galleryName| Set-Content -Path $templateFilePath  
(Get-Content -path $templateFilePath -Raw ) -replace '<region1>',$location | Set-Content -Path $templateFilePath  
(Get-Content -path $templateFilePath -Raw ) -replace '<region2>',$replRegion2 | Set-Content -Path $templateFilePath  
((Get-Content -path $templateFilePath -Raw) -replace '<imgBuilderId>',$identityNameResourceId) | Set-Content -Path $templateFilePath

New-AzResourceGroupDeployment  -ResourceGroupName $imageResourceGroup  -TemplateFile $templateFilePath  -Api-Version "2020-02-14"  -imageTemplateName $imageTemplateName  -svclocation $location

Invoke-AzResourceAction  -ResourceName $imageTemplateName  -ResourceGroupName $imageResourceGroup  -ResourceType Microsoft.VirtualMachineImages/imageTemplates  -ApiVersion "2020-02-14"  -Action Run
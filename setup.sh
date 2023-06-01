set -e

rg=apphostdemo
location=eastus
env=$rg-env
storage=rgstoredw
functionappimage=docker.io/davidxw/azurefunctionsimage:v1.0.0
containerappimage=docker.io/davidxw/webtest:latest
springjar=spring-petclinic-3.1.0-SNAPSHOT.jar

# resource group

az group create --name $rg --location $location

# container app environment

az containerapp env create --name $env --resource-group $rg --location $location

envid=$(az containerapp env show --name $env --resource-group $rg --query id --output tsv)

###### deploy function app

# storage account (required for functions runtime)

az storage account create --name $storage --resource-group $rg --location $location  \
    --sku Standard_LRS

az functionapp create --name functionapp --resource-group $rg \
    --storage-account $storage \
    --environment $env  \
    --functions-version 4 --runtime dotnet-isolated \
    --image $functionappimage \
    --min-replicas 1 --max-replicas 5 

###### deploy container app

az containerapp create --name containerapp \
  --resource-group $rg \
  --environment $env \
  --target-port 80 \
  --ingress external \
  --image $containerappimage

  ##### deploy spring app

az spring create --name springappdw \
    --resource-group $rg \
    --location $location \
    --managed-environment $envid \
    --sku StandardGen2 

az spring app create --name petclinic \
    --resource-group $rg \
    --service springappdw \
    --runtime-version Java_17 \
    --assign-endpoint true

az spring app deploy \
    --resource-group $rg \
    --service springappdw \
    --name petclinic \
    --artifact-path $springjar

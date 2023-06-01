# Container App Host Demo

A simple demo showing how Azure Container App environments can host Container Apps, Azure Functions and Spring Apps

setup.sh contains the CLI required to create the environment, however some setup is required:

## Function App

The src/funcca directory contains a sample function app with a HTTP Trigger.  The container needs to be built and deployed to a container registry, and the "functionappimage" variable in the setup.sh file updated.

Full instructions to build and deploy a container app hosted Function are here:

https://learn.microsoft.com/en-us/azure/azure-functions/functions-deploy-container-apps?pivots=programming-language-csharp&tabs=docker%2Cbash

## Spring App

Copy a jar file to the root directory and update the "springjar" variable.  This is a good app to use:

https://github.com/spring-projects/spring-petclinic/tree/main

## Container App

The container image deployed to the container app is specified in the "containerappimage" variable. Update as required.




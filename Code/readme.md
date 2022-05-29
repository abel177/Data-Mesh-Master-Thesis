# innomesh 

Goals of this repository is to provide implementation example of the data mesh concept in Azure Cloud.Specifically, in contains implementation of the Data Domain with two Data Products using Azure Purview as governance solution.

## Structure

The modules folder contains modules that are used in the main infrastructure file. The modules are for the API Management, Private DNS Zone, Storage Account and Virtual Network. 

The infrastructure folder contains the files for provisioning the infrastructure for the use case in the thesis. The files are structured as follows:

- The main.tf file contains the code for the infrastructure. 
- The terraform.tf file contains the terraform configuration
- The variables.tf file contains the variables that need to be declared for deployment. 
- The dp1_api.json 
- The dp1_policy.xml contains the XML policy for authentication of the API providing access to the data product. 


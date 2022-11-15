# Terraform - Performance analysis and comparison of Infrastructure as Code (IaC) Tools
The lab environment used for this research was built by following the best practices towards having a practical workbench that would allow the benchmark tests to be conducted in consideration of an impartial implementation, avoiding noise by external factors like variations in the network bandwidth external to the cloud platform, the use of a single command line interface for both implementation and the definition of the very same cloud services with the very same configurations.

## Pre-requisites

If you're using Azure Cloud Shell, Terraform is already installed by default. In case you want to execute the commands from your local CLI tool (bash, Windows CMD), you have to install the Azure CLI and Terraform as a first step. 

* [Terraform installation](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* [Azure CLI - installation](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

Check the Terraform installation:

```powershell

terraform version

```

Check the Azure CLI installation:

```powershell

az version

```

If you're using a local installation on your own workstation, remember that you also have to be logged in to Azure.
Otherwise, if you're  using Azure Cloud Shell you can proceed to the next topic.

```powershell

az login

```


## Test workbench
A representation of our benchmark workbench is below. Visual Studio Code was used to implement the Terraform scripts. Then Azure Cloud Shell was used to execute the scripts.
<p align="center">
  <img alt ="Test workbench" width="275" height="175" src="/media/test-workbench.png">
</p>

## Azure cloud services
The following Azure cloud services have been specified and the respective scripts for Terraform have been implemented:

* Azure Application Insights (part of Azure Monitor)
* Azure Spring Apps – runtime environment for Java workloads, Kubernetes-based
* Azure Database for MySQL single server
* Azure Blob Storage

Azure Spring Cloud runtime, one Azure storage account, one MySQL server, and one Azure App Insights component was used for all the scenarios with both IaC tools. The services for Terraform are below. 

<p align="center">
  <img alt ="Azure Services – Terraform definitions" src="/media/azure-services-tf-definitions.png">
</p>

## Command line interface
The executions were controlled and timed with Powershell and the Measure-Command cmdlet. A cmdlet is a lightweight command used in the PowerShell environment. Such strategy also provided an impartial way of starting the execution scripts for Terraform.

<p align="center">
  <img alt ="Azure Services – Terraform definitions" src="/media/lyit-perf-tf-RUNNING.png">
</p>

## Terraform scripts
Terraform modules were used to promote isolation, reusability, and modularity. Below we have the scripts for each Azure cloud service as implemented.

### Main Terraform project files
The following Terraform scripts were created for the main Terraform project:
* main.tf
* variables.tf
* outputs.tf

### Azure Application Insights
The following Terraform scripts were created for Azure Application Insights:
* main.tf
* variables.tf
* outputs.tf

### MySQL database
The following Terraform scripts were created for MySQL:
* main.tf
* variables.tf
* outputs.tf

### Azure Spring Cloud
The following Terraform scripts were created for Azure Spring Cloud:
* main.tf
* variables.tf
* outputs.tf

### Azure Storage
The following Terraform scripts were created for Azure Storage Blob:
* main.tf
* variables.tf
* outputs.tf

The benchmarks considered a warm-up run to make sure that internally the components would be ready as expected, and then a test harness with 40 executions for each implemented was executed. 

Terraform provides a flag (command line switch) that can be activated with the -parallelism=<NUMBER_OF_GRAPH_NODES> to modify the number of concurrent nodes that can be started.
Terraform considers 10 nodes by default, with a maximum number of 256 nodes. 

## Architectural representation - Terraform

An architectural representation was created as seen below for Terraform, derived from the scripts and configuration files. 

To create the diagram, it is required to execute the terraform plan phase, then extract a JSON file that can be uploaded to an online tool called Terraform Visual. The tool also provides its source code as an open-source project on GitHub. To create the diagram, it is required to execute the commands below to create an intermediate JSON file. 

```powershell

terraform plan -out=plan.out
terraform show -json plan.out > plan.json

```

<p align="center">
  <img alt ="Terraform - Architectural representation" src="/media/lyit-perf-tf-DIAGRAM.png">
</p>


## Tests and metrics - Terraform

To execute the deployment scripts for Terraform, it is required to access the Azure Portal, then start a session with the Azure Cloud Shell. Select the option to use Powershell instead of the standard bash option as shown below.

<p align="center">
  <img alt ="Terraform - Architectural representation" src="/media/azure-portal-powershell.png">
</p>

Then create an empty directory, and then clone the respective GitHub repository:

```powershell

mkdir lyit-perf-tf
cd lyit-perf-tf
git clone https://github.com/L00162879/lyit-perf-tf.git

```

Note that when you're using Azure Cloud Shell, you're already logged in. In case you want to execute the commands from your local CLI tool (bash, Windows CMD), remember to login in first:

```powershell

az login

```

Execute the usual terraform commands like init, fmt, validate and plan.

```powershell

terraform init
terraform fmt
terraform validate
terraform plan -out terraform.plan

```

After that, it is possible to start the benchmark tests. They will be timed with the support of a cmdlet provided by Powershell called Measure-Command as shown below: 

The next step is to start the provisioning of the desired Azure services:

```powershell

Measure-Command { terraform apply "terraform.plan" }

```

If you want to run with the switch for parallelism:

```powershell

Measure-Command { terraform apply -parallelism=200 "terraform.plan" }

```

As soon as the execution completes, a message is shown as below. You can then extract the metrics to compose the benchmark analysis:

<p align="center">
  <img alt ="Terraform - Architectural representation" src="/media/lyit-perf-tf-SUCCESS.png">
</p>

After many runs, you can aggregate and analyse the results as required. A sample Excel spreadsheet is below along
with a couple of charts.

<p align="center">
  <img alt ="Terraform - Architectural representation" src="/media/terraform-SAMPLES.png">
</p>

<p align="center">
  <img alt ="Terraform - Architectural representation" src="/media/terraform-CHART-1.png">
</p>

<p align="center">
  <img alt ="Terraform - Architectural representation" src="/media/terraform-CHART-2.png">
</p>

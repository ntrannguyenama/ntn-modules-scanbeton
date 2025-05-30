locals {
  resource_types = {
    rg     = "rg"    # Resource Group
    kv     = "kv"    # Key Vault
    vnet   = "vnet"  # Virtual Network
    nsg    = "nsg"   # Network Security Group
    pe     = "pe"    # Private Endpoint
    sa     = "sa"    # Storage Account
    cdn    = "cdn"   # Content Delivery Network
    sql    = "sql"   # SQL Server
    sqldb  = "sqldb" # SQL Database
    appsp   = "appsp"  # App Service Plan
    app    = "app"   # App Service
    adx    = "adx"   # Azure Data Explorer
    adxdb  = "adxdb" # Azure Data Explorer Database
    adxpe  = "adxpe" # Azure Data Explorer Private Endpoint
    iothub = "iot"   # IoT Hub
    eh     = "eh"    # Event Hub
    ehns   = "ehns"  # Event Hub Namespace
    kvpe   = "kvpe"  # Key Vault Private Endpoint
    sqlpe  = "sqlpe" # SQL Private Endpoint
    stpe   = "stpe"  # Storage Private Endpoint
    appip  = "appip" # App Service IP
    adxip  = "adxip" # Azure Data Explorer IP
    iotpe  = "iotpe" # IoT Hub Private Endpoint
    ehpe   = "ehpe"  # Event Hub Private Endpoint
    storage = "sa"   # Storage Account (alias)
    rt     = "rt"    # Route Table
    nic    = "nic"   # Network Interface
    pip    = "pip"   # Public IP
    lnx    = "lnx"   # Linux Virtual Machine
    win    = "win"   # Windows Virtual Machine
    vmss   = "vmss"  # Virtual Machine Scale Set
    func   = "func"  # Function App
    apim   = "apim"  # API Management
    cosmos = "cosmos" # Cosmos DB
    adu    = "adu"   # Device Update Account
    adupe  = "adupe" # Device Update Private Endpoint
    role   = "role"  # Role Assignment
    openai = "openai"   # Azure OpenAI Service
    search = "srch"  # Azure Cognitive Search
    speech = "speech"
    frontdoor = "fd" # Azure Frontdoor
  }

  resource_name = "${var.app_name}-${var.environment}-${lookup(local.resource_types, var.resource_type)}${var.suffix != null ? "-${var.suffix}" : ""}"
  
  storage_name = lower(replace("${var.app_name}${var.environment}st${var.suffix != null ? var.suffix : ""}", "-", ""))

  storage_endpoint_name = lower(replace("${var.app_name}${var.environment}step${var.suffix != null ? var.suffix : ""}", "-", ""))
}

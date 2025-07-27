# Create ARM template for storage account
cat > /tmp/storage-template.json << 'EOF'
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "storageAccountName": {
            "type": "string"
        }
    },
    "resources": [
        {
            "type": "Microsoft.Storage/storageAccounts",
            "apiVersion": "2021-09-01",
            "name": "[parameters('storageAccountName')]",
            "location": "East US",
            "sku": {
                "name": "Standard_LRS"
            },
            "kind": "StorageV2",
            "properties": {
                "supportsHttpsTrafficOnly": true,
                "minimumTlsVersion": "TLS1_2"
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts/blobServices/containers",
            "apiVersion": "2021-09-01",
            "name": "[concat(parameters('storageAccountName'), '/default/tfstate')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccountName'))]"
            ],
            "properties": {
                "publicAccess": "None"
            }
        }
    ],
    "outputs": {
        "storageAccountName": {
            "type": "string",
            "value": "[parameters('storageAccountName')]"
        }
    }
}
EOF

# Deploy using ARM template
STORAGE_ACCOUNT_NAME="tfstatejafar$(date +%M%S)"
echo "Creating storage account: $STORAGE_ACCOUNT_NAME"

az deployment group create \
    --resource-group rg-terraform-state \
    --template-file /tmp/storage-template.json \
    --parameters storageAccountName=$STORAGE_ACCOUNT_NAME

echo "Storage account created: $STORAGE_ACCOUNT_NAME"
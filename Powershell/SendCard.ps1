# Read the content of a JSON file into a variable named $card
# Card Action - Disable User has HTTP Trigger link from Logic App
$card = Get-Content '.\card.json'

# Define the webhook URL where the JSON content will be sent
# Teams Incoming Webhook - https://shorturl.at/nxYZ8
$webhook = 'https://devtobi.webhook.office.com/webhookb2/1e08ef97-f710-462b-9a69-0f353d355e37@5d8b74a9-cfa0-4f65-9d4f-56b92787a8c3/IncomingWebhook/bb6b1b1c7a6c48b8bcc7b1ccaf885b7e/1faefaf7-f845-4c31-a5bf-254ac1768ba0'

#Relative Path that is expected by the LogicApp
# Needs to be double Encoded
$actionURL = "XY_INCI/XY_TITL/XY_TIME/XY_RECI/XY_SEND/XY_SEVE"

# Define a hashtable of replacements to be made in the JSON content
$replacments = @{
    "XY_INCI"= [System.Web.HttpUtility]::UrlEncode("/subscriptions/8140799d-d299-4b7a-a726-57dd828bb63d/resourceGroups/sentinel/providers/Microsoft.OperationalInsights/workspaces/sentinelworkspace/providers/Microsoft.SecurityInsights/Incidents/a434bd5a-1694-4933-a485-e84c0237c7eb") #looks like /subscriptions/8140799d-d299-4b7a-a726-57dd828bb63d/resourceGroups/sentinel/providers/Microsoft.OperationalInsights/workspaces/sentinelworkspace/providers/Microsoft.SecurityInsights/Incidents/a434bd5a-1694-4933-a485-e84c0237c7eb
    "XY_LINK"= "https://portal.azure.com"
    "XY_TITL"= "Cooler Incident"
    "XY_RECI"= "RECIPIENT"
    "XY_SEND"= "SENDER"
    "XY_TIME"= Get-Date -Format "dd-MM-yyyyTHH:mm:ss"
    "XY_SEVE"= "High"
    "XY_DESC"= "Came from Powershell"
}

# Iterate through each key in the hashtable and replace occurrences in the JSON content
foreach ($repl in $replacments.Keys) {
    $encoded = $replacments[$repl]
    $card = $card.Replace($repl, $encoded) 
    $actionURL = $actionURL.Replace($repl, [System.Web.HttpUtility]::UrlEncode($encoded))
}

$card = $card.Replace("XY_ACTION", [System.Web.HttpUtility]::UrlEncode($actionURL))

# Invoke a REST method to send the modified JSON content to the specified webhook URL
Invoke-RestMethod -Method post -ContentType 'Application/Json' -Body $card -Uri $webhook

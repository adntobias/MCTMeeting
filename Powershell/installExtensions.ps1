$extensions=
"ms-vscode.powershell", 
"msazurermtools.azurerm-vscode-tools",
"ms-azuretools.vscode-bicep", #optional
"ms-azuretools.vscode-docker" #optional

foreach ($ext in $extensions) {
      Write-Host "Installing" $ext "..." -ForegroundColor White
      code --install-extension $ext
}
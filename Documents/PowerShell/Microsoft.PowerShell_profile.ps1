
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module
#Import-Module -Name Microsoft.WinGet.CommandNotFound
$MaximumHistoryCount = 32767
#f45873b3-b655-43a6-b217-97c00aa0db58

. "$profile/../psreadline.ps1"

## starship
Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

function Toggle-Proxy {
    param (
        [string]$proxy = 'http://127.0.0.1:10809'
    )

    if ($ENV:HTTP_PROXY -or $ENV:HTTPS_PROXY) {
        $ENV:HTTP_PROXY = $null
        $ENV:HTTPS_PROXY = $null
        git config --global --unset http.proxy
        git config --global --unset https.proxy
        Write-Host "Proxy cleared."
    } else {
        $ENV:HTTP_PROXY = $proxy
        $ENV:HTTPS_PROXY = $proxy
        git config --global http.proxy $proxy
        git config --global https.proxy $proxy
        Write-Host "Proxy set to: $proxy"
    }
}

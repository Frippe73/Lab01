
Function GetUserData { 
    $MyUserListFile = "/Users/fredrik.nystrand/PS/Lab01/LabFiles/MyLabFile.csv"
    $MyUserList = Get-Content -Path $MyUserListFile | ConvertFrom-Csv
    $MyUserList
}

function Get-CourseUser {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Name,

        [Parameter()]
        [int]$OlderThan,

        [Parameter()]
        [switch]$Retired
    )
    
    $Result = GetUserData

    if ($Name) {
        $Result = $Result | Where-Object -Property Name -Like "*$Name*"
    }
    
    if ($Retired) {
        $OlderThan = 65
    }

    if ($OlderThan) {
        $Result = $Result | Where-Object -Property Age -ge $OlderThan
    }
    
    $Result
}

function Add-CourseUser {
    [CmdletBinding()]
    param (
        $MyUserListFile = "/Users/fredrik.nystrand/PS/Lab01/LabFiles/MyLabFile.csv",
        
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [Int]$Age,

        [Parameter(Mandatory)]
        [ValidateSet('red', 'green', 'blue', 'yellow')]
        [string]$Color,

        $UserID = (Get-Random -Minimum 10 -Maximum 100000)
    )
    
    $MyCsvUser = "$Name,$Age,$Color,$UserId"
    
    #Write-Output $MyCsvUser 

    $NewCSv = Get-Content $MyUserListFile -Raw
    $NewCSv += $MyCsvUser
    
    #Write-Output $NewCSv
    Set-Content -Value $NewCSv -Path $MyUserListFile

}


function Remove-CourseUser {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        $MyUserListFile = "/Users/fredrik.nystrand/PS/Lab01/LabFiles/MyLabFile.csv"
    )
    
    $MyUserList = Get-Content -Path $MyUserListFile | ConvertFrom-Csv
    $RemoveUser = $MyUserList | Out-ConsoleGridView
    
    if ($PSCmdlet.ShouldProcess($MyUserListFile)) {
        $MyUserList = $MyUserList | Where-Object {
            -not (
                $_.Name -eq $RemoveUser.Name -and
                $_.Age -eq $RemoveUser.Age -and
                $_.Color -eq $RemoveUser.Color -and
                $_.Id -eq $RemoveUser.Id
            )
        }
        Set-Content -Value $($MyUserList | ConvertTo-Csv -notypeInformation) -Path $MyUserListFile -WhatIf
    }
    else {
        Write-Output "Did not remove user $($RemoveUser.Name)"
    }
}
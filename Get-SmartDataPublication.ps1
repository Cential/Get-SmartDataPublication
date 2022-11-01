#!/usr/bin/env pwsh
#requires -version 2

<#
.SYNOPSIS
  Download Smart Data Publication File from Archer SaaS Instance
.DESCRIPTION
  Using REST API retrieve an authentication token and then download the Smart Data Publication File
.PARAMETER InstanceName
  The Instance Name (Integer value) of the Archer SaaS Instance (ex. 50000)
.PARAMETER InstanceID
  The left-most segment of the Archer SaaS Instance, i.e. "acme-test" if the instance is https://acme-test.rsa.archer.com
.PARAMETER SDPID
  The ID of the Smart Data Publication file (ex. 10)
.PARAMETER Username
  The username of the Archer SaaS user
.PARAMETER Password
  The password of the Archer SaaS user
.PARAMETER OutputFilename
  The filename to save the Smart Data Publication file to
.INPUTS
  None
.OUTPUTS
  Creates files in current folder with the name of the Smart Data Publication file
.NOTES
  Version:        0.2
  Author:         Roy Verrips
  Creation Date:  2022-11-01
  Purpose/Change: Public release on Github along with Public release of Archer 6.12 with DPS

  Version:        0.1
  Author:         Roy Verrips
  Creation Date:  2022-10-10
  Purpose/Change: Initial script development

.EXAMPLE
  Get-GetSmartDataPublication -InstanceID acme-test -InstanceName 50000 -SDPID 100 -Username xxxxx -Password xxxxx

#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------
[CmdletBinding()]

Param(
    [string]$InstanceName   = '50000',
    [string]$InstanceID     = 'acme-test',
    [int]$SDPID             = 1,
    [string]$Username       = '',
    [string]$Password       = '',
    [string]$OutputFilename = 'SDP-'+(Get-Date -Format “yyyy-MM-dd_HH-mm-ss”)+'.zip'
)

# Set Error Action to Stop
$ErrorActionPreference = "Stop"

# Password must be specified as it doesn't have a default value
If ([string]::IsNullOrEmpty($Password)) {
  Write-Output 'Please specify user Password e.g. Get-SmartDataPublication -Password xxxxx'
  Exit $LASTEXITCODE
}

# Username must be specified as it doesn't have a default value
If ([string]::IsNullOrEmpty($Username)) {
  Write-Output 'Please specify user Username e.g. Get-SmartDataPublication -Username xxxxx'
  Exit $LASTEXITCODE
}

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Base URL of the Archer API
$BaseURI = 'https://'+$InstanceID+'.archer.rsa.com/'

#-----------------------------------------------------------[Functions]------------------------------------------------------------
function Out-Attachments{
  param(
    [Parameter(Mandatory=$true)]
    [String[]]
    $AppID,
    [Parameter(Mandatory=$true)]
    [String[]]
    $RecordID,
    [Parameter(Mandatory=$true)]
    [String[]]
    $FieldID,
    [Parameter(Mandatory=$true)]
    [String[]]
    $FileID,
    [Parameter(Mandatory=$true)]
    [String[]]
    $FileName
  )
  process {
      try {
          Invoke-RestMethod -Uri ($BaseURI+'files/'+$AppID+'/'+$RecordID+'/'+$FieldID+'?fileId='+$FileID) -Method GET -Headers $Headers -Outfile $FileName.replace(" ","_")
      }
      catch {
          Write-Output $_.Exception.Response.StatusCode
          exit $LASTEXITCODE
      }
  }
}

function GetAuthenticationToken {
  param(
    [Parameter(Mandatory=$true)]
    [String[]]
    $Username,
    [Parameter(Mandatory=$true)]
    [String[]]
    $Password,
    [Parameter(Mandatory=$true)]
    [String[]]
    $InstanceName,
    [Parameter(Mandatory=$true)]
    [String[]]
    $InstanceID
  )
  process {
    $Url = $BaseURI + 'api/core/security/login'
    $Header = @{
      'Content-Type' = 'application/json'
    }
    $Body = @{
      InstanceName = "$InstanceName"
      Username = "$Username"
      Password = "$Password"
    } | ConvertTo-Json
    try {
        $Response = Invoke-RestMethod -Uri $Url -Method POST -Body $Body -Headers $Header
    } catch {
        # Dig into the exception to get the Response details.
        # Note that value__ is not a typo.
        Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__
        Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
        exit $LASTEXITCODE
    }
    return $Response.RequestedObject.SessionToken
  }
}

function GetDSPFile {
    param(
      [Parameter(Mandatory=$true)]
      [String[]]
      $InstanceName,
      [Parameter(Mandatory=$true)]
      [String[]]
      $InstanceID,
      [Parameter(Mandatory=$true)]
      [String[]]
      $Username,
      [Parameter(Mandatory=$true)]
      [String[]]
      $Password,
      [Parameter(Mandatory=$true)]
      [int]
      $SDPID,
      [Parameter(Mandatory=$true)]
      [String[]]
      $OutputFilename
    )
    process {
      $Url = $BaseURI + 'api/core/smartdatapublication/download/' + $SDPID
      $SessionID = GetAuthenticationToken `
        -Username $Username `
        -Password $Password `
        -InstanceName $InstanceName `
        -InstanceID $InstanceID
      $Headers = @{
        'Authorization' = 'Archer session-id=' + $SessionID
        'Accept' = 'application/octet-stream'
      }
      try {
          $Response = Invoke-RestMethod `
            -Uri $Url `
            -Method GET `
            -Headers $Headers `
            -ResponseHeadersVariable ResponseHeaders `
            -Outfile $OutputFilename.replace(" ","_")
      } catch {
          # Dig into the exception to get the Response details.
          # Note that value__ is not a typo.
          Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__
          Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
          exit $LASTEXITCODE
      }
      Write-Host "File downloaded to: " $OutputFilename
      Write-Host "File zip-crc is: " $ResponseHeaders['zip-crc']
    }
  }

#-----------------------------------------------------------[Execution]------------------------------------------------------------

GetDSPFile `
    -Username $Username `
    -Password $Password `
    -InstanceName $InstanceName `
    -InstanceID $InstanceID `
    -SDPID $SDPID `
    -OutputFilename $OutputFilename

# /Users/roy/Code/GetSmartDataPublication/Get-SmartDataPublication.ps1
## SYNOPSIS
Download Smart Data Publication File from Archer SaaS Instance

## SYNTAX
```powershell
./Get-SmartDataPublication.ps1 [[-InstanceName] <String>] [[-InstanceID] <String>] [[-SDPID] <Int32>] [[-Username] <String>] [[-Password] <String>] [[-OutputFilename] <String>] [<CommonParameters>]
```

## DESCRIPTION
Using REST API retrieve an authentication token and then download the Smart Data Publication File

## PARAMETERS
### -InstanceName &lt;String&gt;
The Instance Name (Integer value) of the Archer SaaS Instance (ex. 50000)
```
-InstanceName <String>
    The Instance Name (Integer value) of the Archer SaaS Instance (ex. 50000)

    Required?                    false
    Position?                    1
    Default value                50000
    Accept pipeline input?       false
    Accept wildcard characters?  false
```

### -InstanceID &lt;String&gt;
The left-most segment of the Archer SaaS Instance, i.e. "acme-test" if the instance is https://acme-test.rsa.archer.com
```
-InstanceID <String>
    The left-most segment of the Archer SaaS Instance, i.e. "acme-test" if the instance is https://acme-test.rsa.archer.com

    Required?                    false
    Position?                    2
    Default value                acme-test
    Accept pipeline input?       false
    Accept wildcard characters?  false
```

### -SDPID &lt;Int32&gt;
The ID of the Smart Data Publication file (ex. 10)
```
-SDPID <Int32>
    The ID of the Smart Data Publication file (ex. 10)

    Required?                    false
    Position?                    3
    Default value                1
    Accept pipeline input?       false
    Accept wildcard characters?  false
```

### -Username &lt;String&gt;
The username of the Archer SaaS user
```
-Username <String>
    The username of the Archer SaaS user

    Required?                    false
    Position?                    4
    Default value
    Accept pipeline input?       false
    Accept wildcard characters?  false
```

### -Password &lt;String&gt;
The password of the Archer SaaS user
```
-Password <String>
    The password of the Archer SaaS user

    Required?                    false
    Position?                    5
    Default value
    Accept pipeline input?       false
    Accept wildcard characters?  false
```

### -OutputFilename &lt;String&gt;
The filename to save the Smart Data Publication file to
```
-OutputFilename <String>
    The filename to save the Smart Data Publication file to

    Required?                    false
    Position?                    6
    Default value                'SDP-'+(Get-Date -Format “yyyy-MM-dd_HH-mm-ss”)+'.zip'
    Accept pipeline input?       false
    Accept wildcard characters?  false
```

## INPUTS
None

## OUTPUTS
Creates files in current folder with the name of the Smart Data Publication file

## NOTES
Version:        0.2
Author:         Roy Verrips
Creation Date:  2022-11-01
Purpose/Change: Public release on Github along with Public release of Archer 6.12 with DPS

Version:        0.1
Author:         Roy Verrips
Creation Date:  2022-10-10
Purpose/Change: Initial script development

## EXAMPLES
### EXAMPLE 1
```powershell
PS > Get-GetSmartDataPublication -InstanceID acme-test -InstanceName 50000 -SDPID 100 -Username xxxxx -Password xxxxx
```

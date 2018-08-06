# Script to move files from src location to destination 1 then move
#    select files to destination 2, then delete what wasn't moved
# Written By: Samuel Pittman
# Date Last Modified: 2 August 2018
# Powershell Version 5.1

#Example Usage:
# . ./moveFiles.ps1
# Move-Files -SourcePath .\Source -DestinationAL .\TestLoc1 -DestinationMZ .\TestLoc2

Function Move-Files {
    [CmdletBinding()]
    Param([string]$SourcePath, [string]$DestinationAL, [string]$DestinationMZ)

    PROCESS {
        $files = Get-ChildItem $SourcePath
        $count = $files.Count 
         
        Write-Host "Files in sourcePath: " $count
        If ($count -eq 0){
            #Statement to log error in console if not files are in defined SourcePath
            #Write-Host "No Files Found for Processing."

            "No files found for processing" | Write-Warning 3>&1 | %{$_.message}
        }
        Else {
            Write-Host "Beginning Sort and Move..."
            for ($i=0; $i -lt $count; $i++){

                #Move files to destination1 if file name starts with a-l
                if ($files[$i].Name[0] -match "[a-l]"){
                    #Write-Host "It's between a and l"
                    Move-Item -Path $files[$i].FullName -Destination $DestinationAL
                }
                elseif ($files[$i].Name[0] -match "[m-z]"){
                    #Write-Host "Between m and z"
                    Move-Item -Path $files[$i].FullName -Destination $DestinationMZ
                }
                else{
                    #Write-Host "Delete this file"
                    Remove-Item $files[$i].Fullname
                }
            }
            Write-Host "Done sorting and moving files!"
        }
    }
}

Function Return-Files {
    [CmdletBinding()]
    Param()

    PROCESS {
        #Script to move all files back to the source folder after testing
        $TestLoc1 = Get-ChildItem ".\TestLoc1"
        $countLoc1 = $TestLoc1.Count
        $TestLoc2 = Get-ChildItem ".\TestLoc2"
        $countLoc2 = $TestLoc2.Count

        for ($i=0; $i -lt $countLoc1; $i++){
            Move-Item -Path $TestLoc1[$i].FullName -Destination ".\Source"
        }

        for ($i=0; $i -lt $countLoc2; $i++){
            Move-Item -Path $TestLoc2[$i].FullName -Destination ".\Source"
        }
        New-Item -Path "./Source" -Name "1234.txt" -ItemType "file"
    }
}
# Tests using Pester (link below) for moveFiles.ps1
# Tests the 3 following scenarios:
# 1. No files exist in the source folder, run test and confirm that error is given
# 2. The following files are in the source folder (apple.txt, pear.txt, 1234.txt), run function,
#    test that output matches expected behavoir
# 3. The following files are in the source folder (apple.txt, bobcat.txt), run function,
#    test that output matches expected behavoir
#
# Uses Pester: https://github.com/pester/Pester
#
# Written By: Samuel Pittman
# Date Last Modified: 6 August 2018
# Powershell Version 5.1

New-Fixture deploy Clean

<#
Creates two files:
./deploy/Clean.ps1
#>

function Clean {

}

# ./deploy/Clean.Tests.ps1

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Move-Files" {
    It "Confirms error given if no files in source folder" {
        #Checks to see if the folder is empty before running this test
        $files = Get-ChildItem ".\Source"
        if ($count = $files.Count -eq 0) {
            (Move-Files -SourcePath .\Source -DestinationAL .\TestLoc1 -DestinationMZ .\TestLoc2 3>&1) -match "No files found for processing" | Should Be $true
        }
    }

    It "Confirms correct behavior when apple.txt, pear.txt, 1234.txt are in the source folder" {

        Move-Files -SourcePath .\Source -DestinationAL .\TestLoc1 -DestinationMZ .\TestLoc2

        $TestLoc1 = Get-ChildItem ".\TestLoc1"
        $appleExists = $false
        $pearExists = $false
        $numFileExists = $false

        $countLoc1 = $TestLoc1.Count
       
        for ($i=0; $i -lt $countLoc1; $i++){
            if( $TestLoc1[$i].Name -match "apple.txt"){
                $appleExists = $true
            }
        }
        
        if ($appleExists -eq 0) {Write-Host "ERROR: apple.txt not found"}

        $TestLoc2 = Get-ChildItem ".\TestLoc2"
        $countLoc2 = $TestLoc2.Count

        for ($i=0; $i -lt $countLoc2; $i++){
            if( $TestLoc2[$i].Name -match "pear.txt"){
                $pearExists = $true
            }
        }
        if ($pearExists -eq 0) {Write-Host "ERROR: pear.txt not found"}

        $Source = Get-ChildItem ".\Source"
        $countSource = $Source.Count

        for ($i=0; $i -lt $countSource; $i++){
            if( $Source[$i].Name -match "1234.txt"){
                $numFileExists = $true
            }
        }

        if ($numFileExists -eq 1) {Write-Host "ERROR: 1234.txt was still present"}
        
        $appleExists | should be $true
        $pearExists | should be $true
        $numFileExists | should be $false
    }

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

    It "Confirms correct behavior when apple.txt, bobcat.txt are in the source folder" {

        Move-Files -SourcePath .\Source -DestinationAL .\TestLoc1 -DestinationMZ .\TestLoc2

        $TestLoc1 = Get-ChildItem ".\TestLoc1"
        $appleExists = $false
        $bobcatExists = $false

        $countLoc1 = $TestLoc1.Count
       
        for ($i=0; $i -lt $countLoc1; $i++){
            if( $TestLoc1[$i].Name -match "apple.txt"){
                $appleExists = $true
            }
            if( $TestLoc1[$i].Name -match "bobcat.txt"){
                $bobcatExists = $true
            }
        }
        
        if ($appleExists -eq 0) {Write-Host "ERROR: apple.txt not found"}
        if ($bobcatExists -eq 0) {Write-Host "ERROR: bobcat.txt not found"}
        
        $appleExists | should be $true
        $bobcatExists | should be $true
    }
}

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
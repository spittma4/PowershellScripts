
---To Run Script---
. .\test.ps1
Move-Files -SourcePath .\Source -DestinationAL .\TestLoc1 -DestinationMZ .\TestLoc2

#Where -SourcePath is the source folder, DestinationAL is the folder for files starting with A-L, DestinationMZ is the folder for files starting with M-Z 

---To put all folders back into Source and create a "1234.txt" in Source---
(if not ran in same session already:) . .\test.ps1
Return-Files

---To Run Pester Test---
Invoke-Pester .\moveFiles.Tests.ps1
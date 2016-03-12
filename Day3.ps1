#This is solution for day 3
#Created by Rodrigo Ribeiro Gomes
#Based on @luticm version, because it ran in less time than another versions! Check Day3-Luticm.ps1

#Stops on error!
$ErrorActionPreference="Stop";

#Puts current location on the location stack, before we change current location
push-location

#Get the directory of this script and change to it!
set-location (Split-Path -Parent $MyInvocation.MyCommand.Definition )

#Read file!
$InputData = Get-Content Day3Input.txt


#This is our grid database. GRID property will store houses, where key is the coords in X:Y format!
$HOUSE_GRID = New-Object PSObject -Prop @{  GRID=@{}  }

#This function encapsulates logic to visit a house!
#We just check if hash table contains the key...
Function VisitHouse {
	param($X,$Y)
	
	$HouseCoord = "$($X):$($Y)"
	
	#Check if house already some value!
	if(!$HOUSE_GRID.GRID.Contains($HouseCoord)){
		#if not, then mark as visited!
		$HOUSE_GRID.GRID[$HouseCoord] = 1;
		return 1;
	}
	
	return 0;
}

#Visit the house 0 becausa it our start location!
$CurrentX = 0
$CurrentY = 0;
VisitHouse -X $CurrentX  -Y $CurrentY;
$VisitedHouseCount = 1;

#Start the fun! For each char in input data, thar represent the directions...
$InputData.toCharArray() | %{
	
	switch($_){
		"^" {
			$CurrentY++;
		}
		"V" {
			$CurrentY--;
		}
		">" {
			$CurrentX++;
		}
		"<" {
			$CurrentX--;
		}
	}
	
	$VisitedHouseCount += VisitHouse -X $CurrentX  -Y $CurrentY;
}

#Prints house info! Because a house only exists if receive a present, then, all HOUSE have a least one present!
write-host "Total houses with least one present: $VisitedHouseCount"

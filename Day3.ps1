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

#Visit the house 0 because it our start location!
$VISITORS = @{
	SANTA = @{X=0;Y=0}
	ROBOT = @{X=0;Y=0}
}
VisitHouse -X $VISITORS.SANTA.X  -Y $VISITORS.SANTA.X; #SANTA
VisitHouse -X $VISITORS.ROBOT.X  -Y $VISITORS.ROBOT.Y; #ROBOT
$VisitedHouseCount = 1;

#Generate a list of visitors!
$VisitorsNames = @($VISITORS.Keys | %{$_})
#Indicates current visitor index!
$CurrentVisitor = 0;

#Start the fun! For each char in input data, thar represent the directions...
$InputData.toCharArray() | %{
	
	#Choose the visitor based on current visitor index.
	$CURRENT_VISTOR = $VISITORS[$VisitorsNames[$CurrentVisitor]];
	
	switch($_){
		"^" {
			$CURRENT_VISTOR.Y++;
		}
		"V" {
			$CURRENT_VISTOR.Y--;
		}
		">" {
			$CURRENT_VISTOR.X++;
		}
		"<" {
			$CURRENT_VISTOR.X--;
		}
	}
	
	$VisitedHouseCount += VisitHouse -X $CURRENT_VISTOR.X  -Y $CURRENT_VISTOR.Y;
	#Inverts current visitor!
	$CurrentVisitor = [int]-not([bool]$CurrentVisitor)
}

#Prints house info! Because a house only exists if receive a present, then, all HOUSE have a least one present!
write-host "Total houses with least one present: $VisitedHouseCount"

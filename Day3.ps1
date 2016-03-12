#This is solution for day 3
#Created by Rodrigo Ribeiro Gomes

#Stops on error!
$ErrorActionPreference="Stop";

#Puts current location on the location stack, before we change current location
push-location

#Get the directory of this script and change to it!
set-location (Split-Path -Parent $MyInvocation.MyCommand.Definition )

#Read file!
$InputData = Get-Content Day3Input.txt

#This will store all visited houses!;
$HOUSE_GRID = [System.Collections.ArrayList]@();

#This will create a new house object!
#Each house have a X and Y coordinate that indicates where house is. It identifies house uniquely!
Function NewHouse($X=0,$Y=0){ return New-Object PSObject -Prop @{X=$X;Y=$Y;PresentCount=[int]0} }

#This finds a house and retrieve it.
#If no house found in specified coordinate, a new is created and added to the house grid.
Function GetHouse {
	param($X,$Y)
	
	$FoundHouse = $null;
	$HOUSE_GRID | %{
		#If house found, then returns it.
		if($_.X -eq $X -and $_.Y -eq $Y){
			$FoundHouse = $_;
			return;
		}
	}
	
	if($FoundHouse){
		return $FoundHouse;
	}

	#If code arrive in this point, no house exists in specified X,Y pair. Then, initializes a new one.
	$NewHouse = NewHouse -X $X -Y $Y
	[void]$HOUSE_GRID.add($NewHouse); 
	return $NewHouse;
}


$CurrentX = 0
$CurrentY = 0;
$CurrentHouse = GetHouse -X $CurrentX  -Y $CurrentY;
$CurrentHouse.PresentCount++; #Start location receives a present!

#Start the fun!
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
	
	#Get house at updated X,Y pair...;
	$CurrentHouse = GetHouse -X $CurrentX  -Y $CurrentY;
	#Current house always receive the present...
	$CurrentHouse.PresentCount++;
}

#Prints house info! Because a house only exists if receive a present, then, all HOUSE have a least one present!
$HOUSE_GRID | %{
	write-host "X: $($_.X) Y:$($_.Y) Total Presents: $($_.PresentCount)"
}
write-host "Total houses with least one present: $($HOUSE_GRID.GRID.count)"

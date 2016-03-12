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

#This will represent our house grid! This our database of houses.
#The logic is simple: two properties will maintain the house list.
#The GRID property store house in a grid way using a hashtable. Each key of this table is a X coordinate.
#And the value of the a X coordinate, is a another hashtable. This another hash table stores all Y coordiantes for a X coordiante.
#For example, the house at 5,4 can be accessed using $HOUSE_GRID.GRID.5.4
#Thus, just with coordinates, we can access position directly, without additional code to search... This helps reduce search time.
#The search work is made by powershell core to find a key in two hashtable.
#The ALL property is a simple array list of all houses. It is useful for retrieve all house, without navigating by GRID.
#The Day 3 dont ask for anything that require access to ALL houses, but i included it just for fun...
$HOUSE_GRID = New-Object PSObject -Prop @{  GRID=@{};ALL=[System.Collections.ArrayList]@()  }

#This function will create a new house object!
#Each house have a X and Y coordinate that indicates where house are. It identifies house uniquely!
Function NewHouse($X=0,$Y=0){ return New-Object PSObject -Prop @{X=$X;Y=$Y;PresentCount=[int]0} }

#This function encapsulates logic to finds a house and retrieve it. If house isn't found a new one is created.
Function GetHouse {
	param($X,$Y)
	
	$FoundHouse = $null;
	#Get the hashtable that represent current X  coordinate!
	#This hashtable will contains all Y coordinate paired with it.
	$YCoordinatess = $HOUSE_GRID.GRID.Item($X);
	
	#If a hashtable is found, lets try get the house object stored on current Y coordiante.
	#This is house that we want.
	if($YCoordiantes){
		$FoundHouse = $YCoordinates.Item($Y);
	} 
	
	if($FoundHouse){
		return $FoundHouse;
	}
	
	#If house not found, this part of code will execute!
	#Just call the function responsible for add a new house. It handles a logic necessary.
	$NewHouse 	= NewHouse -X $X -Y $Y;
	AddHouseToGrid -House $NewHouse;
	return $NewHouse;
}

#This function ecapsulate logic necessary to add a house to grid.
#If house already in grid, the function do nothing.
Function AddHouseToGrid {
	param($House)
	
	#This flag will indicates if a house was added to GRID. If yes, we must add house to ALL LIST!
	$houseAdded = $false;
	
	#First, lets check if GRID hashtable contains the current value of X as key.
	#If it have, then will retrieve the corresponding hashtable and extract object from hashtable stored on it.
	#This second hashtable in indexed by Y coordinate that pair with X.
	if($HOUSE_GRID.GRID.Contains($House.X)){
		#Get the hashtable of current X coordinate.
		$XValue = $HOUSE_GRID.GRID.Item($House.X);
		#If Y slot dont exists, we add it together with the object.
		if(!$XValue.Contains($House.Y)){
			$XValue.add($House.Y,$House);
			$houseAdded = $true; 
		}
	}
	else {
		#If X slot dont exists, create a new one with the Y slot and the object.
		$XValue = @{};
		$XValue.add($House.Y,$House);
		$HOUSE_GRID.GRID.add($House.X,$XValue);
		$houseAdded = $true; 
	}
	
	#Adds the slot to general!
	if($houseAdded){
		[void]$HOUSE_GRID.ALL.add($House);
	}
	
	return;
}

#Returns a array with all house objects!
Function GetAllHouses {
	return $HOUSE_GRID.ALL;
}

#Starting in position 0... Current house 0;0 receive the present! So...
$CurrentX = 0
$CurrentY = 0;
$CurrentHouse = GetHouse -X $CurrentX  -Y $CurrentY;
$CurrentHouse.PresentCount++; #Start location receives a present!

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
	
	#Get house at updated X,Y pair...;
	$CurrentHouse = GetHouse -X $CurrentX  -Y $CurrentY;
	#Current house always receive the present...
	$CurrentHouse.PresentCount++;
}

#Prints house info! Because a house only exists if receive a present, then, all HOUSE have a least one present!
$AllHouses = GetAllHouses;
write-host "Total houses with least one present: $($AllHouses.count)"

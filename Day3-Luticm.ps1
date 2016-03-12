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


$HOUSE_GRID = @{}

#This function encapsulates logic to finds a house and retrieve it. If house isn't found a new one is created.
Function VisitaCasa {
	param($X,$Y)
	
	$coord = "$($X):$($Y)";
	if($HOUSE_GRID[$coord] -eq $null){
		$HOUSE_GRID[$coord] = 1;
		return 1;
	}
	return 0;
}


#Starting in position 0... Current house 0;0 receive the present! So...
$CurrentX = 0
$CurrentY = 0;
$resultado += VisitaCasa -X $CurrentX  -Y $CurrentY;

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
	
	$resultado += VisitaCasa -X $CurrentX  -Y $CurrentY;
}

write-host "Total houses with least one present: $resultado"

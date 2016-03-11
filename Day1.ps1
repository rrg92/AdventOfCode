#This is solution for day 1.
#Created by Rodrigo Ribeiro Gomes
#This new version attemps avoid repetitie

#Stops on error!
$ErrorActionPreference="Stop";

#Puts current location on the location stack, before we change current location
push-location

#Get the directory of this script and change to it!
set-location (Split-Path -Parent $MyInvocation.MyCommand.Definition )

#Read file!
$InputData = Get-Content Day1INput.txt

$CurrentFloor = 0;

#Added to support part 2!
$FirstBasementPosition = $null;
$currentPosition = 0;

$InputData.ToCharArray() | %{

	#Added to suport part 2!
	$currentPosition++;

	#Assume that exists just
	if($_ -eq "("){
		$CurrentFloor++;
	} 
	elseif ($_ -eq ")") {
		$CurrentFloor--;
	}
	
	#Added to support part 2!
	if($CurrentFloor -eq -1 -and $FirstBasementPosition -eq $null){
		$FirstBasementPosition = $currentPosition;
	}

}

write-host "Part 1) Floor is: $CurrentFloor"
write-host "Part 2) First Basement position is: $FirstBasementPosition";
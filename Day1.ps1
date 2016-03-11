#This is solution for day 1.
#Created by Rodrigo Ribeiro Gomes

#Stops on error!
$ErrorActionPreference="Stop";

#Puts current location on the location stack, before we change current location
push-location

#Get the directory of this script and change to it!
set-location (Split-Path -Parent $MyInvocation.MyCommand.Definition )

#Read file!
$Input = Get-Content Day1INput.txt

$CurrentFloor = 0;

$Input.ToCharArray() | %{

	#Assume that exists just
	if($_ -eq "("){
		$CurrentFloor++;
	} 
	elseif ($_ -eq ")") {
		$CurrentFloor--;
	}

}

write-host "Floor is: $CurrentFloor"
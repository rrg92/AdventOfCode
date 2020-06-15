#This is solution for day 2
#Created by Rodrigo Ribeiro Gomes

#Stops on error!
$ErrorActionPreference="Stop";

#Puts current location on the location stack, before we change current location
push-location

#Get the directory of this script and change to it!
set-location (Split-Path -Parent $MyInvocation.MyCommand.Definition )

#Read file!
$InputData = Get-Content Day2Input.txt

$TotalSquareFeet = 0;
$TotalRibbonFeet = 0;

#Foreach line (each present dimenstion)
$InputData | %{

	#Separate each area...
	$Parts = $_ -Split "x"
	[int]$l = $Parts[0]
	[int]$w = $Parts[1]
	[int]$h = $Parts[2]
	
	#Calculates each area...
	$lw = $l*$w
	$wh = $w*$h
	$hl = $h*$l
	
	#Calculates total area.
	$area = 2*$lw + 2*$wh + 2*$hl;
	

	#Calculate smallest area
	$smallestArea = @($lw,$wh,$hl | sort)[0];
	
	$TotalSquareFeet += $area + $smallestArea;
	
	#For part 2: Get the 2 smallest metrics and calculates the feet to wrap the present... 
	$smallestMetrics = @($l,$w,$h | sort | select -first 2)
	$feetRibonForPresent = $smallestMetrics[0]*2 + $smallestMetrics[1]*2
	$feetRibbonForBow = $l*$w*$h;
	$TotalRibbonFeet += $feetRibonForPresent + $feetRibbonForBow;
}

write-host "total square feet: $TotalSquareFeet"
write-host "total feet of ribbon: $TotalRibbonFeet"
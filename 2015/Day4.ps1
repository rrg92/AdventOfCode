#This is solution for day 4
#Created by Rodrigo Ribeiro Gomes

#Stops on error!
$ErrorActionPreference="Stop";

#Puts current location on the location stack, before we change current location
push-location

#Get the directory of this script and change to it!
set-location (Split-Path -Parent $MyInvocation.MyCommand.Definition )

#Read file!
$InputData = "yzbqklnj"
#$InputData = "abcdef"
#$InputData = "pqrstuv"

$i = 0;
$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider

do{

	$ToHash = "$InputData"+"$i";
	
	$MD5Hash 	= $md5.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($ToHash)) 
	
	$startsWithZero = $false;
	if($MD5Hash[0] -eq 0 -and $MD5Hash[1] -eq 0 -and $MD5Hash[2] -eq 0){ #Changed last comparison to support part 2. Original right is 15
		$startsWithZero = $true;
	}
	
	if($startsWithZero){break} else {$i++}

} while($true)

write-host $i $ToHash $MD5HASH;
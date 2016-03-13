#This is solution for day 5
#Created by Rodrigo Ribeiro Gomes
[CmdLetBinding()]
param()

#Stops on error!
$ErrorActionPreference="Stop";

#Puts current location on the location stack, before we change current location
push-location

#Get the directory of this script and change to it!
set-location (Split-Path -Parent $MyInvocation.MyCommand.Definition )

#Read file!
$InputData = Get-Content Day5Input.txt

#Lets build our database of testes. In future implementations, it easy add another test.
#The main engine will test each script bellow on input string. Only if all test result in $true, the string will be a nice string!
$TESTS = @{
	MINIMUM_VOWEL = {$_ -match '(.*[aeiou].*){3,}'}
	DOUBLE_LETTER = {$_ -match '([a-z])\1'}
	DISALLOWED 	= {-not($_ -match 'ab|cd|pq|xy')}
}

#New rules, for PART 2
$TESTS = @{
	NOOVERLAP_PAIR = {$_ -match '.*([a-z]{2}).*\1.*'}
	INTRUSE_REPEAT = {$_ -match '([a-z])[a-z]\1' }
}

#Lets generate a array with all tests name, for iterate over it!
$TESTS_NAME = @($TESTS.GetEnumerator() | %{ $_.Key })

#Out nice string count!
$NiceStrings = 0;

#For each input string!
$InputData | %{
	
	#Store current string pointer in a variable, because special variable "$_" will be overwrite...
	$CurrentString = $_;
	
	#This is represent partial result.
	$TestsResult = $true;
	
	#For each test...
	$TESTS_NAME | %{
		#Store current test name because we will reuse the special variable...
		$CurrentTest = $_;
		
		#We call the test script passing current string in a pipeline. Inside of test script, it will be accessed by special variable $_
		#The result of script is compared with partial result. If result was false, then, partial result will be false...
		$TestsResult = $TestsResult -band ($CurrentString | % {. $TESTS[$CurrentTest] });
		
		write-verbose "STRING: $CurrentString TEST: $CurrentTest RESULT: $TestsResult"
	}
	
	#At this point, the partial result represent final result. If it is true, all testes was sucessfully (the string meets the requeriments for be nice!)
	if($TestsResult){
		$NiceStrings++;
	}
	
}

write-host "Nice string count: $NiceStrings "
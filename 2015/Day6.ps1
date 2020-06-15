

$MAX_X = 999
$MAX_Y = 999

$Panel = @($null) * ($MAX_Y + 1);

0..$MAX_Y  | %{
	$Panel[$_] = @($false)*($MAX_X + 1)
}



function ParseIntrunction{
	param($instrunction)
	
	if($instrunction -match '(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)'){
		return @{
				action = $matches[1].replace('turn ','')
				sx 		= $matches[2]
				sy 		= $matches[3]
				ex 		= $matches[4]
				ey 		= $matches[5]
			}
	} else {
		throw "INVALID_INSTRUNCTION: $instrunction"
	}
	
}


function DoAction {
	param([int]$sx,[int]$sy,[int]$ex,[int]$ey,$action)
	
	$y = $sy;
	while($y -le $ey){
		$x = $sx;
		
		while( $x -le $ex ){
			switch($action){
				"on" {
					$Panel[$y][$x] = $true
				}
				
				"off" {
					$Panel[$y][$x] = $false
				}
				
				"toggle" {
					$Panel[$y][$x] = -not($Panel[$y][$x])
				}
			}
			$x++;
		}
			
		$y++;
	}

}

function ExecuteInstrunctions {
	param($instrunctions)
	
	$instrunctions | %{
		$p = ParseIntrunction $_;
		DoAction @p;
	}
}

function PrintPanel{
	param()
	
	$Rows = @("") * ($MAX_Y + 1);
	
	0..$MAX_Y | %{
		$y = $_;
		0..$MAX_X | %{
			$x = $_;
			$Rows[$y] += [int]($Panel[$y][$x]);
		}
	}
	
	return $Rows;
}

function CountOn {
	param()
	
	$count = 0;

	0..$MAX_Y | %{
		$y = $_;
		0..$MAX_X | %{
			$x = $_;
			$count += [int]($Panel[$y][$x]);
		}
	}
	
	return $count;
}



$SantaInstrunctions = Get-content Day6Input.txt;

$re = [regex]'\d+'
$fn = {
	param($m)
	
	$v = [int]($m.Value/100)
	
	if($v -gt $MAX_X){
		$v = $MAX_X
	}
	
	return $v;
}

$SantaInstrunctions2 = $SantaInstrunctions | %{ $re.Replace($_, $fn) }


ExecuteInstrunctions $SantaInstrunctions;









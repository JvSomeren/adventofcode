<?php

$input = file_get_contents( "input" );
$input_length = strlen($input);

$sum = 0;

$prevNum = 0;

for($i = 0; $i < $input_length; $i++) {
    if((int)$input[$i] == $prevNum) {
        $sum += (int)$input[$i];
    }
    
    $prevNum = (int)$input[$i];
}

if((int)$input[0] == $prevNum) {
    $sum += $prevNum;
}

echo $sum . "\n\r";


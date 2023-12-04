<?php

$input = file_get_contents( "input" );
$input_length = strlen($input);
$nextDigitOffset = $input_length / 2;

function getDigit($input, $input_length, $nextDigitOffset, $i) {
  
  $offset = $i + $nextDigitOffset;
  if($offset >= $input_length) {
    $digit = $offset % $input_length;
  } else {
    $digit = $offset;
  }
  
  return (int)$input[$digit];
}

$sum = 0;

for($i = 0; $i < $input_length; $i++) {
  if((int)$input[$i] == getDigit($input, $input_length, $nextDigitOffset, $i)) {
    $sum += (int)$input[$i];
  }
}

echo $sum . "\n\r";

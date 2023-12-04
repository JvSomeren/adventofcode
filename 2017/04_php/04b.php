<?php

function is_anagram($a, $b) {
  return(count_chars($a, 1) === count_chars($b, 1));
}

$input = file("input");
$inputSize = count($input);

$valid = 0;

for($i = 0; $i < $inputSize; $i++) {
  $row = array_map('trim', explode(" ", $input[$i]));
  $isValid = true;
  
  while($row) {
    $pop = array_pop($row);
    $rowSize = count($row);
    
    for($j = 0; $j < $rowSize; $j++)
      if(is_anagram($pop, $row[$j]))
        $isValid = false;
  }

  $isValid ? ++$valid : NULL;
}

echo $valid . "\n\r";

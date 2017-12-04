<?php

$input = file("input");
$inputSize = count($input);

$valid = 0;

for($i = 0; $i < $inputSize; $i++) {
  $row = array_map('trim', explode(" ", $input[$i]));
  
  while($row) {
    if(in_array(array_pop($row), $row))
      break;
  }

  $row ? NULL : ++$valid;
}

echo $valid . "\n\r";

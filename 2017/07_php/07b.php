<?php

class Program2 {
  public $name = '';

  public $weight = '';

  public $sum_weight = '';

  public $children = [];

  function __construct($row) {
    $this->name = $row[0];

    preg_match('/(\d+)/', $row[1], $match);
    $this->weight = $match[0];

    $this->sum_weight = $match[0];

    for($i = 3; $i < count($row); $i++) {
      preg_match('/(\w+)/', $row[$i], $match);
      $this->children[$match[0]] = $match[0];
    }
  }
}

$input = file("input");
$inputSize = count($input);

$programs = [];

for($i = 0; $i < $inputSize; $i++) {
  $row = array_map('trim', explode(" ", $input[$i]));
  
  $program = new Program2($row);

  $programs[$program->name] = $program;
}

foreach ($programs as $programName => $program) {
  foreach ($program->children as $childName => $child) {
    $program->children[$childName] = $programs[$childName];
    unset($programs[$childName]);
  }
}

function calculateChildWeight($prog) {
  $sum = $prog->weight;

  return $sum;
}

// progWeight + childProgWeight
function calculateProgramWeight(&$prog) {
  $sum = $prog->weight;
  $answer = 0;
  $childIndex = -1;

  foreach ($prog->children as $childName => $child) {
    calculateProgramWeight($child);
  }

  foreach ($prog->children as $childName => $child) {
    $sum += $child->weight;
  }

  $prog->weight = $sum;

  $children = [];

  foreach ($prog->children as $childName => $child) {
    array_push($children, calculateChildWeight($child));
  }

  for($i = 0; $i < count($children); $i++) {
    $unique = 0;

    for($j = 0; $j < count($children); $j++) {
      if($children[$i] == $children[$j])
        $unique++;
    }

    if($unique == 1) {
      $tmp = ($i == 0) ? $children[1] : $children[0];
      $childIndex = $i;
      $answer = $children[$i] - $tmp;
      break;
    }
  }

  if($answer != 0) {
    $result = array_values($prog->children)[$childIndex]->name . (array_values($prog->children)[$childIndex]->sum_weight - $answer);
    echo $result . "\n\r";
    return;
  }
}

$botProgName = array_values($programs)[0]->name;

calculateProgramWeight($programs[$botProgName]);

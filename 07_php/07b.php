<?php

class Program2 {
  public $name = '';

  public $weight = '';

  public $children = [];

  function __construct($row) {
    $this->name = $row[0];

    preg_match('/(\d+)/', $row[1], $match);
    $this->weight = $match[0];

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

  foreach ($prog->children as $childName => $child) {
    $sum += $child->weight;
  }

  return $sum;
}

// progWeight + childProgWeight
function calculateProgramWeight($prog) {
  $sum = $prog->weight;
  $answer = 0;
  $childIndex = -1;

  foreach ($prog->children as $childName => $child) {
    $sum += $child->weight;
  }

  $children = [];

  foreach ($prog->children as $childName => $child) {
    array_push($children, calculateChildWeight($child));
  }

  if($children[0] != $children[1] &&
     $children[0] != $children[2]) {
    $answer = $children[1] - $children[0];
    $childIndex = 0;
  } else if($children[1] != $children[0] &&
            $children[1] != $children[2]) {
    $answer = $children[0] - $children[1];
    $childIndex = 1;
  } else if($children[2] != $children[0] &&
            $children[2] != $children[1]) {
    $answer = $children[0] - $children[2];
    $childIndex = 2;
  } else if($children[3] != $children[0] &&
            $children[3] != $children[1]) {
    $answer = $children[0] - $children[3];
    $childIndex = 3;
  } else if($children[4] != $children[0] &&
            $children[4] != $children[1]) {
    $answer = $children[0] - $children[4];
    $childIndex = 4;
  } else if($children[5] != $children[0] &&
            $children[5] != $children[1]) {
    $answer = $children[0] - $children[5];
    $childIndex = 5;
  }

  if($answer != 0) {
    $result = array_values($prog->children)[$childIndex]->weight + $answer;
    echo $result . "\n\r";
    return;
  }

  foreach ($prog->children as $childName => $child) {
    calculateProgramWeight($child);
  }
}

$botProgName = array_values($programs)[0]->name;

calculateProgramWeight($programs[$botProgName]);

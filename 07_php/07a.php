<?php

class Program {
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
  
  $program = new Program($row);

  $programs[$program->name] = $program;
}

foreach ($programs as $programName => $program) {
  foreach ($program->children as $childName => $child) {
    $program->children[$childName] = $programs[$childName];
    unset($programs[$childName]);
  }
}

echo array_values($programs)[0]->name . "\n\r";

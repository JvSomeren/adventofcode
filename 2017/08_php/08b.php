<?php

function getRegisterValue2(&$regs, $reg) {
  if(isset($regs[$reg]))
    return $regs[$reg];

  return $regs[$reg] = 0;
}

function evaluateCondition2(&$regs, $reg, $cond, $val) {
  $regVal = getRegisterValue2($regs, $reg);

  switch($cond) {
    case "==":  return $regVal == $val;
    case "!=":  return $regVal != $val;
    case ">":   return $regVal >  $val;
    case ">=":  return $regVal >= $val;
    case "<":   return $regVal <  $val;
    case "<=":  return $regVal <= $val;
  }
}

$input = file("input");
$inputSize = count($input);

$actionReg = 0;
$action = 1;
$actionValue = 2;
$conditionReg = 4;
$condition = 5;
$conditionValue = 6;

$registers = [];
$largest = 0;

for($i = 0; $i < $inputSize; $i++) {
  $row = array_map('trim', explode(" ", $input[$i]));
  
  if(evaluateCondition2($registers, $row[$conditionReg], $row[$condition], $row[$conditionValue])) {
    if($row[$action] == "inc")
      $registers[$row[$actionReg]] = getRegisterValue2($registers, $row[$actionReg]) + $row[$actionValue];
    else
      $registers[$row[$actionReg]] = getRegisterValue2($registers, $row[$actionReg]) - $row[$actionValue];
  }

  $tmp = max($registers);

  if($tmp > $largest)
    $largest = $tmp;
}

echo $largest . "\n\r";

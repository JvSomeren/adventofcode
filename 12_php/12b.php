<?php

function getConnections2($line) {
  $expr = '/(\d+) <-> (.+)/';

  preg_match($expr, $line, $res);

  return explode(', ', $res[2]);
}

$input = file("input");
$inputSize = count($input);
$range = range(0, $inputSize-1);

$groups = 0;
$queue = array(0);
$visited = array();

while(count($visited) < $inputSize) {
  while(!empty($queue)) {
    $i = array_pop($queue);
  
    if(in_array($i, $visited)) {
      continue;
    }
  
    $conn = getConnections2($input[$i]);
    $queue = array_merge($queue, $conn);

    array_push($visited, $i);
  }

  $groups++;
  $missing = array_diff($range, $visited);
  if(!empty($missing)) {
    $next = min($missing);
    array_push($queue, $next);
  }
}

echo $groups . "\r\n";

<?php

function getConnections($line) {
  $expr = '/(\d+) <-> (.+)/';

  preg_match($expr, $line, $res);

  return explode(', ', $res[2]);
}

$input = file("input");
$inputSize = count($input);

$group_total = 0;
$queue = array(0);
$visited = array();

while(!empty($queue)) {
  $i = array_pop($queue);

  if(in_array($i, $visited)) {
    continue;
  }

  $conn = getConnections($input[$i]);
  $queue = array_merge($queue, $conn);
  $group_total++;

  array_push($visited, $i);
}
echo $group_total . "\r\n";

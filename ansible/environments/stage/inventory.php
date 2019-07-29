#!/usr/bin/php
<?php

function example_inventory() {
return readfile('inventory.json');
}

/**
* Empty inventory for testing.
*
* @return array
*   An empty inventory.
*/
function empty_inventory() {
return ['_meta' => ['hostvars' => new stdClass()]];
}

/**
* Get inventory.
*
* @param array $argv
*   Array of command line arguments (as returned by $_SERVER['argv']).
*
* @return array
*   Inventory of groups or vars, depending on arguments.
*/
function get_inventory($argv = []) {
$inventory = new stdClass();

// Called with `--list`.
if (!empty($argv[1]) && $argv[1] == '--list') {
$inventory = example_inventory();
}
// Called with `--host [hostname]`.
elseif ((!empty($argv[1]) && $argv[1] == '--host') && !empty($argv[2])) {
// Not implemented, since we return _meta info `--list`.
$inventory = empty_inventory();
}
// If no groups or vars are present, return an empty inventory.
else {
$inventory = empty_inventory();
}

print json_encode($inventory);
}

// Get the inventory.
get_inventory($_SERVER['argv']);

?>

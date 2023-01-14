#!/bin/bash

if [[ $# == 1 ]]; then
	value=$1
	if [[ $value =~ [^0-9] ]]; then
		echo "$value"
	else
		echo "Error, invalid input."
	fi
else
	echo "Error, invalid number of arguments."
fi

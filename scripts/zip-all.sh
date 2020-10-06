#!/bin/bash
  
find . -type f -execdir zip '{}.zip' '{}' \; -execdir rm '{}' \;

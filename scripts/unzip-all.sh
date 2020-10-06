#!/bin/bash
  
find . -type f -name "*.zip" -execdir unzip '{}' \; -execdir rm '{}' \;

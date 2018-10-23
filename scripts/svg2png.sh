# Params

dpi=200
# dpi=60

# Args

if [ ! $# -eq 2 ]; then
  echo Usage: `basename $0` 'INPUT-DIR' 'OUTPUT-DIR'
  echo
  echo Take each .svg file in the INPUT-DIR directory and echo convert
  echo it to the corresponding .png file in the INPUT-DIR directory.
  echo
  exit
fi

input=$1
output=$2

# Script

for svg in "$input"/*.svg; do
    png="$output"/$(basename "$svg" .svg).png
    echo === EXPORT "$svg" TO "$png" ===
    inkscape -z "$svg" -D -d "$dpi" -e "$png"
done

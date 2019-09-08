
# Args

if [ ! $# -eq 3 ]; then
  echo Usage: `basename $0` 'SEGMENT-LENGTH' 'INPUT-FILE' 'OUTPUT-PREF'
  echo
  echo Split the given input audio file into segments.
  echo
  exit
fi

length=$1
input=$2
output=$3

# extension
ext="${input##*.}"

ffmpeg -i $input -f segment -segment_time $length -c copy $output%03d.$ext

#!/bin/bash

# Check if directory argument is provided
if [ $# -ne 3 ]; then
  echo "Usage: $0 <directory>"
  echo "Usage: $1 year"
  echo "Usage: $0 month"
  exit 1
fi

directory="$1"
year="$2"
month="$3"

# Check if the directory exists
if [ ! -d "$directory" ]; then
  echo "Directory $directory does not exist."
  exit 1
fi

# Change to the specified directory
cd "$directory" || exit 1

# Create an associative array to store file sizes
declare -A file_sizes
count=0
deleteCount=0

# Loop through files in the directory
for file in *; do
  # Check if file is a regular file
  if [ -f "$file" ]; then
    # Get the file size
    size=$(stat -c%s "$file")

    # Check if the file size is already in the array
    if [ -n "${file_sizes[$size]}" ]; then
      ((count++))
      kb=$((size / 1024))
      ((kb++))
      printf "\n$file \n${file_sizes[$size]}\n@ $kb KB\n"
	  
	  fileInArray=${file_sizes[$size]}
	  lengthFile=${#file}
	  lengthFileInArray=${#filename}	  

	  if [[ "$file" == *"$year-"* && "$file" == *"$month-"* && $lengthFileInArray == 12 ]]; then
		((deleteCount++))
	  elif [[ "$fileInArray" == *"$year-"* && "$fileInArray" == *"$month-"* && $lengthFile == 12 ]]; then
		((deleteCount++))
	  fi
    else
      # Store the file size in the array
      file_sizes[$size]="$file"
    fi
  fi
done

printf "\nTotal duplicates: $count\n"
printf "\nTotal duplicates to delete: $deleteCount\n"

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
deleteCount=0

# Loop through files in the directory
for file in *; do
  # Check if file is a regular file
  if [ -f "$file" ]; then
    # Get the file size
    size=$(stat -c%s "$file")
	
	fileInArray=${file_sizes[$size]}
	lengthFile=${#file}
	lengthFileInArray=${#filename}

    # Check if the file size is already in the array
    if [ -n "${file_sizes[$size]}" ]; then
	  kb=$((size / 1024))
      ((kb++))

      if [[ "$file" == *"IMG_"* && "$fileInArray" != *"IMG_"* ]]; then
        # Delete the file containing "IMG_"
        rm "$file"
      elif [[ "$file" != *"IMG_"* && "$fileInArray" == *"IMG_"* ]]; then
        # Delete the other file containing "IMG_"
        rm "${file_sizes[$size]}"
	  elif [[ "$fileInArray" == *"$year-"* && "$fileInArray" == *"$month-"* && $lengthFile == 12 ]]; then
		# Delete the file that is 8 random letters/numbers
		# ((deleteCount++))
		rm "$file"
	  elif [[ "$file" == *"$year-"* && "$file" == *"$month-"* && $lengthFileInArray == 12 ]]; then
		# Delete the file that is 8 random letters/numbers
		# ((deleteCount++))
		rm "${file_sizes[$size]}"
      else
        # Output duplicate file names if don't match above patterns
        echo "Duplicate files found:"
        echo "$file"
        echo "$fileInArray"
		echo "@ $kb KB"
		echo ""
      fi
    else
      # Store the file size in the array
      file_sizes[$size]="$file"
    fi
  fi
done

# printf "\n\nTotal duplicates to delete: $deleteCount\n"

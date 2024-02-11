#!/bin/bash

# Get a list of all user directories in the home folder
user_directories=$(ls -d /home/*/)

# Set the target folder
target_folder=".local/share/Trash/files/"

# Set the desired total size in bytes (1 GB = 1,073,741,824 bytes)
#10Gb
desired_size=10737418240

for user_dir in $user_directories; do
    # Check if the "test" folder exists in the user's home directory
    if [ -d "$user_dir/$target_folder" ]; then
     
    #go into target folder
    cd  "$user_dir/$target_folder"
    

    # Get the current total size of the folder
    current_size=$(du -sb . | awk '{print $1}')

    # Check if the current size is already within the desired limit
    if [ $current_size -le $desired_size ]; then
       echo "The current size is already within the desired limit."
       exit 0
    fi

    # Sort the files and folders in the target folder by modification time (oldest first)
    sorted_files=$(find  .  -type f -o -type d -printf '%T@ %p\n' | sort -n | awk '{print $2}')
   

    # Iterate through the sorted files and folders, removing the oldest ones until the desired size is reached
    for file in $sorted_files; do
        if [ $current_size -le $desired_size ]; then
            break
        fi
  
       

       # Remove the file or folder
       rm -rf "$file"

       # Update the current size
       current_size=$(du -sb . | awk '{print $1}')
    done
    echo "The total size has been reduced to the requested size by removing the oldest files and folders."

   fi
done

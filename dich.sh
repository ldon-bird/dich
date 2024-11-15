#!/bin/bash

CONFIG_FILE="config.json"

read_json_config() {
  suffix=$(jq -r '.suffix' "$CONFIG_FILE")
  directory=$(jq -r '.directory' "$CONFIG_FILE")
  target=$(jq -r '.target' "$CONFIG_FILE")
}

initialize_config_file() {
  if [ ! -s "$CONFIG_FILE" ]; then
    echo '{"suffix": "", "directory": "", "target": "", "files": []}' > "$CONFIG_FILE"
  fi
}

init_mode() {
  initialize_config_file
  read_json_config

  if [ -d "$directory" ]; then
    files=($(find "$directory" -type f -name "${suffix}*"))

    if [ ${#files[@]} -eq 0 ]; then
      echo "No files with suffix '$suffix' found in directory '$directory'."
      exit 1
    fi

    jq --argjson files "$(printf '%s\n' "${files[@]}" | jq -R . | jq -s .)" \
      '.files = $files' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && \
    mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"

    echo "File list initialized and saved to $CONFIG_FILE."

    if [ ! -f "$target" ]; then
      cp "${files[0]}" "$target"
      echo "Target file not found. Created target by copying ${files[0]} to $target."
    fi
  else
    echo "Directory '$directory' not found."
    exit 1
  fi
}

get_mode() {
  read_json_config

  files=$(jq -r '.files[]' "$CONFIG_FILE")

  for file in $files; do
    if cmp -s "$file" "$target"; then
      echo "Match found: $file"
      return 0
    fi
  done

  echo "No matching file found."
}

next_mode() {
  read_json_config

  files=($(jq -r '.files[]' "$CONFIG_FILE"))

  match_found=false
  for i in "${!files[@]}"; do
    if cmp -s "${files[$i]}" "$target"; then
      next_index=$(( (i + 1) % ${#files[@]} ))
      cp "${files[$next_index]}" "$target"
      echo "Copied ${files[$next_index]} to $target."
      match_found=true
      break
    fi
  done

  if ! $match_found; then
    echo "No matching file found for $target. No changes made."
  fi
}

set_mode() {
  read_json_config

  files=($(jq -r '.files[]' "$CONFIG_FILE"))

  echo "Choose a file to set as the target:"
  select choice in "${files[@]}"; do
    if [ -n "$choice" ]; then
      cp "$choice" "$target"
      echo "Copied $choice to $target."
      return 0
    else
      echo "Invalid selection. Please try again."
    fi
  done
}

help_mode() {
  echo "Usage: $0 [options]"
  echo
  echo "Options:"
  echo "  -i      Initialize mode: Reads the configuration, lists files with a given suffix,"
  echo "          and stores them in the configuration file. If the target file does not exist,"
  echo "          it will create one by copying the first file in the list."
  echo
  echo "  -g      Get mode: Compares each file in the list to the target file and outputs the"
  echo "          filename of the matching file, if found."
  echo
  echo "  -n      Next mode: Finds the file in the list that matches the target, then copies"
  echo "          the next file in the list to overwrite the target."
  echo
  echo "  -s      Set mode: Interactively allows the user to choose a file from the list to"
  echo "          set as the target, overwriting the current target file."
  echo
  echo "  -h      Display this help message and exit."
}

while getopts ":ignsh" opt; do
  case $opt in
    i)
      init_mode
      ;;
    g)
      get_mode
      ;;
    n)
      next_mode
      ;;
    s)
      set_mode
      ;;
    h)
      help_mode
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      help_mode
      exit 1
      ;;
  esac
done


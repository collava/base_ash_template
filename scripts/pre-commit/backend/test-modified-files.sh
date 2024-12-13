#!/bin/bash

modified_files=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.ex(s)?$')

test_files=()

for file in $modified_files; do
		echo "files detected: $modified_files"

    if [[ $file == *_test.exs ]]; then
        test_files+=("$file")
    fi

    if [[ $file == *.ex ]]; then
				fixed_path_file="${file/lib/test}"
				# echo "Replaced folder: $fixed_path_file"
        test_file="${fixed_path_file%.ex}_test.exs"
				# echo "Testing full file: $test_file"
				# check for the corresponding test file
				echo "Checking for tests file: $test_file"
        if [[ -f $test_file ]]; then
            test_files+=("$test_file")
        fi
    fi
done

if [ ${#test_files[@]} -eq 0 ]; then
    echo "No relevant tests found."
    exit 0
fi

mix test --max-failures 1 "${test_files[@]}" --color

test_exit_code=$?

exit $test_exit_code

#!/usr/bin/env bash

set -e

file=$1

if [ -z "$file" ]; then
    echo 'Input a log file name as argument.' 1>&2
    exit 1
fi

declare -A test_map || (echo 'Bash error has occured. Update Bash version to 4 or higher.' 1>&2 && exit 1)
failed_test_count=0
failed_test_id_list=()
line_no=1

while read -r line; do
    # example: 12:00:00 PM - Running test:  foo-bar - pAAb2yW9K3Hxtaf4wjU0eg-j
    if [[ $line =~ Running\ test:\ \ (.+)\ -\ ([A-Za-z0-9-]+)$ ]]; then
        test_name=${BASH_REMATCH[1]}
        test_id=${BASH_REMATCH[2]}
        test_map["$test_name"]=${test_id}

    # example: Failed: 3
    elif [[ $line =~ ^Failed:\ ([0-9]+)$ ]]; then
        failed_test_count=${BASH_REMATCH[1]}

        # substring next line to n line
        sed -n "$((line_no + 1)),$((line_no + "${BASH_REMATCH[1]}"))p" "$file" >tmp.log
        while read -r line2; do
            # example: - foo-bar (35.547s)
            if [[ $line2 =~ -\ (.+)\ \([0-9]+ ]]; then
                failed_test_name=${BASH_REMATCH[1]}
                failed_test_id=${test_map[$failed_test_name]}
                failed_test_id_list+=("$failed_test_id")
            fi
        done <tmp.log
        rm tmp.log
    fi
    line_no=$((line_no + 1))
done <"$file"

# consistency check
if [ "$failed_test_count" -ne ${#failed_test_id_list[@]} ]; then
    echo 'Invalid log file format.' 1>&2
    exit 1
fi

for test_id in "${failed_test_id_list[@]}"; do
    echo "$test_id"
done

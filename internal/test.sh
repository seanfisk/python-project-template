# Source this file to run it in your shell:
#
#     source internal/test.sh
#

# We just want the name of the directory to pass to the Python
# script. So rmdir it, then let the Python script re-create. Not the
# prettiest or safest operation, but it should be fine.
PPT_TEMP_DIR=$(mktemp -d /tmp/python-project-template-XXXXXXXXXX)
rmdir "$PPT_TEMP_DIR"

python internal/test.py "$PPT_TEMP_DIR"
pushd "$PPT_TEMP_DIR"

ppt_finished() {
	popd
	rm -rf "$PPT_TEMP_DIR"
}

echo
echo "Run \`ppt_finished' when done to return to the template project and delete this directory."

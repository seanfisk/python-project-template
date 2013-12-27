# Source this file to run it in your shell:
#
#     source internal/test.sh
#
# Any arguments passed will go directly to the tox command line, e.g.:
#
#     source internal/test.sh -e py27
#
# Which would test just Python 2.7.

PPT_TEMP_DIR=$(mktemp -d /tmp/python-project-template-XXXXXXXXXX)

python internal/test.py "$PPT_TEMP_DIR" "$@"
pushd "$PPT_TEMP_DIR"

ppt_finished() {
	popd
	rm -rf "$PPT_TEMP_DIR"
}

echo
echo "Run \`tox' or \`detox' to test the project."
echo "Run \`ppt_finished' when done to return to the template project and delete this directory."

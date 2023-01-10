#!/bin/bash
source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

files_url=(
	"https://pmb.let.rug.nl/releases/pmb-4.0.0.zip pmb-4.0.0.zip")

# There seam to be something preventing to download the file without
# allowed-ip-addresses=all and web-options="--insecure" on
git-annex addurl --fast -c annex.largefiles=anything --raw --batch --with-files \
	-c annex.security.allowed-ip-addresses=all \
	-c annex.web-options="--insecure" <<EOF
$(for file_url in "${files_url[@]}" ; do echo "${file_url}" ; done)
EOF
git-annex get --fast -J8 \
	-c annex.security.allowed-ip-addresses=all \
	-c annex.web-options="--insecure"
git-annex migrate --fast -c annex.largefiles=anything *

[[ -f md5sums ]] && md5sum -c md5sums
[[ -f md5sums ]] || md5sum $(list -- --fast) > md5sums

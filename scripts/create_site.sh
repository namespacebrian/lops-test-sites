#!/usr/bin/env bash

# parallel --tmuxpane --fg --delay 0.1 -j 8 ./scripts/create_site.sh mytestsites {} ::: $(seq 1 16)

site_name=$(printf "$1-%03d" $2)

# Use the formatted number in your output
date;
echo "=== ${site_name} ===";

terminus site:create $site_name $site_name lops-test-sites --org=initech-bw


terminus drush ${site_name}.dev -- site-install standard --yes --account-name=brian.weaver@pantheon.io --account-mail=brian.weaver@pantheon.io --site-mail=brian.weaver@pantheon.io --site-name=${site_name}

terminus env:deploy $site_name.test --updatedb --cc --note="Initial site setup" --yes

terminus env:deploy $site_name.live --updatedb --cc --note="Initial site setup" --yes


echo "Done";

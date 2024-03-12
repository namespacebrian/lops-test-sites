#!/usr/bin/env bash

## Install supporting packages
# brew install tmux parallel gnu-sed

## Fix parallel to work with tmux - see https://savannah.gnu.org/bugs/?64993
# sed -i.bak 's/\$len = ::min(\$len,int(\$tmux_len\/4-33));/\$len = ::min(\$len,\$tmux_len-33);/' $(readlink -f $(which parallel))

## Create 16 sites named `mytestsites-001` to `mytestsites-016`, running 8 parallel jobs
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

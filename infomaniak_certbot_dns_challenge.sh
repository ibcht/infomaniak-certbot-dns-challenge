#!/bin/bash
set -e

# Infomaniak API base URL
api_url="https://api.infomaniak.com"

# set by certbot
domain_id="$CERTBOT_DOMAIN"
[[ -z $domain_id ]] && echo "domain is missing !" >&2 && exit 1

# DNS record to update
challenge_record="_acme-challenge" 

# path to secret token
secret_token_path="$(dirname ${BASH_SOURCE[0]})/secret_token"
echo $secret_token_path
secret_token=$(cat $secret_token_path)

# set by certbot
new_challenge_value="$CERTBOT_VALIDATION"
[[ -z $new_challenge_value ]] && echo "token is missing !" >&2 && exit 1

for record_id in $(curl -s "${api_url}/1/domain/${domain_id}/dns/record" -H "Authorization: Bearer $secret_token" | jq ".data[].id" | sed "s/\"//g")
do
  source=$(curl -s "${api_url}/1/domain/${domain_id}/dns/record/${record_id}" -H "Authorization: Bearer $secret_token" | jq ".data.source" | sed "s/\"//g")
  if [[ $source == $challenge_record ]] 
  then
    result=$(curl -s -X PUT -H "Authorization: Bearer $secret_token" -d target=${new_challenge_value} -d ttl=7200 "${api_url}/1/domain/${domain_id}/dns/record/${record_id}" | jq ".result" | sed "s/\"//g")
    # sleep est requis le temps que la zone soit propagée
    [[ $result == "success" ]] && systemctl restart apache2 && sleep 30 && exit 0 
  fi
done

echo "record '$challenge_record' not found !" >&2 && exit 1


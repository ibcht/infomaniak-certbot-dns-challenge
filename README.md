# Infomaniak Certbot DNS challenge

Renew a Let's Encrypt certificate with certbot using manual authentication and DNS challenge, for Infomaniak domains owners.

This script must be used as `--manual-auth-hook` script. It's using the Infomaniak API to update the DNS record.

## Usage

As a prerequisite, you must get an API token at https://manager.infomaniak.com/v3/infomaniak-api with the scope "Domain". This token must be written in the file `./secret_token`. This file should be limited in read-access to user running certbot.

jq is used to parse json responses.

Set-up a cron to execute periodically the renew command : `sudo certbot renew --manual-auth-hook /path/to/infomaniak_certbot_dns_challenge.sh`

## Other

* Certbot validation hook documentation : https://certbot.eff.org/docs/using.html#pre-and-post-validation-hooks
* Infomaniak API doc : https://api.infomaniak.com/doc

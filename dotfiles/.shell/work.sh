# PKD
pkd-site-of() { okta-cli users list -s "profile.pkUsername eq \"$1\"" --output-fields profile.site }

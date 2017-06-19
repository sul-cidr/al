server 'cidr-authorial-prod.stanford.edu', user: 'cidr', roles: %w{app db web}

Capistrano::OneTimeKey.generate_one_time_key!

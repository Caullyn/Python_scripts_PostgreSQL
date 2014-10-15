To install the entire stack and run locally:

1. Deploy DB Schema.
Create a PostgreSQL Database, and run tools/deploy_ploy.py against in (additional packages may be required)
ex.
cd tools/
python deploy_ploy.py -t2 fully_awesome postgres

2. Deploy DB functions
ex.
cd tools/
sh deploy.sh 

3. Run nodeJS api and http-server (http-server may be required)
cd node/
node api.js
http-server (may need new terminal window, or run prev command as daemon)

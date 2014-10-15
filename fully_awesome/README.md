To install the entire stack and run locally:

Deploy DB Schema.
Create a PostgreSQL Database, and run tools/deploy_ploy.py against in (additional packages may be required)

    cd tools/
    python deploy_ploy.py -t2 fully_awesome postgres

Deploy DB functions

    cd tools/
    sh deploy.sh 

Run nodeJS api and http-server

    cd node/
    node api.js
    http-server 

Open http://localhost:8080/login.html in browser
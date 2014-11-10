To install the entire stack and run locally:

Deploy DB Schema.
Create a PostgreSQL Database, and run deploy_tool.py for schema and deploy.sh for DB Functions (additional python packages may be required)

    psql -c 'create database fullyawesome'
    cd tools/
    python deploy_tool.py -t2 fully_awesome postgres
    sh deploy.sh 
    
Run nodeJS api

    cd node/
    node api.js

Run http-server

    cd public/
    http-server 

Open http://localhost:8080/event.html in browser
To install the entire stack and run locally:

Deploy DB Schema.
Create a PostgreSQL Database, and run deploy_tool.py for schema and deploy.sh for DB Functions (additional python packages may be required). Also optional fixture examples.

    psql -c 'create database wotjam'
    cd tools/
    python deploy_tool.py -t2 wotjam postgres
    sh deploy.sh 
    psql -f fixtures.sql wotjam
    
Run nodeJS api

    cd node/
    node api.js

In a new terminal window, Run http-server

    cd public/
    http-server 

Open http://localhost:8080/event.html in browser
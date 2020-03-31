# Services Spanning Multiple Contianers

> Creating a service that spans across multiple containers in docker. The 2 containers used are postgres and flask application and they communicate over the docker network.

1. Images pulled:

        docker pull postgres
        docker pull python:alpine-3.7

2. Creating a special docker network:

        docker network create pgnet
3. Execute the postgres server in ”pgnet”.

        docker run --network pgnet --name mypg -e POSTGRES PASSWORD=mysecret -d postgres

    This runs the container in with the default user as ”Postgres”, default database as ”Postgres” with the password as ”mysecret” and the default port ”5432”.

4. Add a new table pathcount in the postgres database. The pathcount table has 2 columns ”path” and ”count”. 

        docker exec -it mypg /bin/sh

        # \c postgres
        # CREATE TABLE IF NOT EXISTS pathcount (
            path TEXT PRIMARY KEY,
            count INT DEFAULT 0,
        );

5. Check the IP address of the postgres container.

        docker container inspect mypg -f ’{{.NetworkSettings.Networks.pgnet.IPAddress}}’

6. Construct code for Flask server - `main.py`
7. Creating and building the docker file.

        docker build -t server:v1 .
8. Running the server:v1 image.

        docker run --rm -p 9090:8080 --network pgnet -e POSTGRES DB=postgres -e POSTGRES PW=mysecret -e POSTGRES USER=postgres -e POSTGRES URL=172.20.0.2 server:v1

9. The multiple containers communicate with each other and the service runs properly. Each GET request made to the server causes an updation of count in the database associated to the path name. The SQL injection attack is prevented by using the %s literal and {} in the SQL queries in the server code.
# DoS pg_dump Data Export Scripts

Running the follow scripts on a DoS dev database will produce a DoS database with a small subset of tables (services, servicecapacities, capacitystatuses)

Note: the env variables can be changed to make it possible to run this against other DoS databases versions e.g. non-prod or prod.

 To successfully extract the roles the script must be be run with the DB user as postgres

    DB_DOS_HOST=localhost DB_DOS_PASSWORD=password DB_DOS_USERNAME=postgres DB_DOS_PORT=5432 sh dos-export-roles.sh

To successfully extract the schema the script must be run with the DB user as postgres

    DB_DOS_HOST=localhost DB_DOS_PASSWORD=password DB_DOS_USERNAME=postgres DB_DOS_PORT=5432 DB_DOS_NAME=pathwaysdos_dev sh dos-export-db-schema.sh

To successfully extract the selective database tables the script must be run with the DB user as release_manager

    DB_DOS_HOST=localhost DB_DOS_PASSWORD=password DB_DOS_USERNAME=release_manager DB_DOS_PORT=5432 DB_DOS_NAME=pathwaysdos_dev sh dos-export-selective-db-tables.sh

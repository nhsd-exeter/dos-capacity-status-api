# DoS pg_dump Data Export Scripts

Running the follow scripts on a DoS dev database will produce a DoS database with a small subset of tables (services, servicecapacities, capacitystatuses)

Note: the env variables can be changed to make it possible to run this against other DoS databases versions e.g. non-prod or prod.

 To successfully extract the roles the script must be be run with the DB user as postgres

    DOS_DB_HOST=localhost DOS_DB_PASSWORD=password DOS_DB_USERNAME=postgres DOS_DB_PORT=5432 sh dos-export-roles.sh

To successfully extract the schema the script must be run with the DB user as postgres

    DOS_DB_HOST=localhost DOS_DB_PASSWORD=password DOS_DB_USERNAME=postgres DOS_DB_PORT=5432 DOS_DB_NAME=pathwaysdos_dev sh dos-export-db-schema.sh

To successfully extract the selective database tables the script must be run with the DB user as release_manager

    DOS_DB_HOST=localhost DOS_DB_PASSWORD=password DOS_DB_USERNAME=release_manager DOS_DB_PORT=5432 DOS_DB_NAME=pathwaysdos_dev sh dos-export-selective-db-tables.sh

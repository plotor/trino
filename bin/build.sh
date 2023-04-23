#!/bin/bash

#prepare env
PROJECT_ROOT=$(
    cd "$(dirname "$0")/.."
    pwd
)

# download maven
./mvnw -version
PROJECT_VERSION=$(./mvnw -Dexec.executable='echo' -Dexec.args='${project.version}' --non-recursive exec:exec -q)

# ./mvnw clean package -pl core/trino-parser -Dair.check.skip-all=true -Dmaven.javadoc.skip=true -DskipTests
./mvnw clean package -pl '!docs,
                          !:trino-server-rpm,
                          !:trino-server-dev,
                          !:trino-tests,
                          !:trino-testing-kafka,
                          !:trino-faulttolerant-tests,
                          !:trino-product-tests,
                          !:trino-product-tests-launcher,
                          !:trino-test-jdbc-compatibility-old-driver,
                          !:trino-test-jdbc-compatibility-old-server,
                          !:trino-benchmark,
                          !:trino-benchmark-queries,
                          !:trino-benchto-benchmarks,
                          !:trino-phoenix5,
                          !:trino-phoenix5-patched,
                          !:trino-redshift,
                          !:trino-accumulo,
                          !:trino-accumulo-iterators,
                          !:trino-oracle,
                          !:trino-atop,
                          !:trino-kinesis,
                          !:trino-hudi,
                          !:trino-ml,
                          !:trino-ignite,
                          !:trino-pinot,
                          !:trino-google-sheets,
                          !:trino-druid,
                          !:trino-kafka,
                          !:trino-clickhouse,
                          !:trino-mongodb,
                          !:trino-iceberg,
                          !:trino-postgresql,
                          !:trino-elasticsearch,
                          !:trino-kudu,
                          !:trino-bigquery,
                          !:trino-delta-lake,
                          !:trino-prometheus,
                          !:trino-cassandra,
                          !:trino-sqlserver,
                          !:trino-mariadb,
                          !:trino-redis,
                          !:trino-sqlserver' -Dair.check.skip-all=true -Dmaven.javadoc.skip=true -DskipTests

# clean up output folder to help local development
rm -rf output
mkdir -p output
mv core/trino-server/target/trino-server-$PROJECT_VERSION ./output/
mv client/trino-cli/target/trino-cli-$PROJECT_VERSION-executable.jar ./output/
mv client/trino-jdbc/target/trino-jdbc-$PROJECT_VERSION.jar ./output/

# generate image ready tar package for trino
cd ./output
mv trino-server-$PROJECT_VERSION trino
rm -rf trino/plugin/kinesis
cp $PROJECT_ROOT/licenses.txt trino/
cp trino-cli-*-executable.jar trino/
COPYFILE_DISABLE=1 tar zcvf trino-$PROJECT_VERSION.tar.gz trino
rm -rf trino
rm -rf trino-cli-*-executable.jar

# generate image ready tar for trino-jdbc
mkdir trino-jdbc
cp trino-jdbc-$PROJECT_VERSION.jar trino-jdbc
COPYFILE_DISABLE=1 tar zcvf trino-jdbc-$PROJECT_VERSION.tar.gz trino-jdbc
rm -rf trino-jdbc
rm -rf trino-jdbc-*.jar

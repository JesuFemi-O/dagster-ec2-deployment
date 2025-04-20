ARG PYTHON_IMAGE=python:3.10-slim
FROM $PYTHON_IMAGE

RUN pip install \
    dagster \
    dagster-graphql \
    dagit \
    dagster-postgres \
    dagster-docker \
    dagster-dbt \
    dbt-snowflake

# Set $DAGSTER_HOME and copy dagster instance and workspace YAML there
ENV DAGSTER_HOME=/opt/dagster/dagster_home/

RUN mkdir -p $DAGSTER_HOME

# Copy dagster instance YAML to $DAGSTER_HOME
COPY dagster.yaml $DAGSTER_HOME
# Copy your workspace file to $DAGSTER_HOME
COPY workspace.yaml $DAGSTER_HOME

WORKDIR $DAGSTER_HOME
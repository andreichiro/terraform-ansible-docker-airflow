FROM apache/airflow:2.6.3

ARG APPLICATION_NAME=Handlers-Airflow
ARG DATE=$(date +%Y-%m-d%-%H%M)
ARG AIRFLOW_USER_HOME=/usr/local/airflow

LABEL maintaner="andreichiro@gmail.com"
LABEL .br.com.andreichiro-schema.date=$DATE
LABEL .br.com.andreichiro-schema.application=$APPLICATION_NAME

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV AIRFLOW_HOME=${AIRFLOW_USER_HOME}

WORKDIR /handlers
RUN apt-get update && apt-get install -y --no-install-recommends postgresql-client && rm -rf /var/lib/apt/lists/*
RUN apt update && apt install git -y
COPY . .
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt --no-cache-dir
RUN pip3 install "apache-airflow[postgres, celery, redis]==2.6.2" --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.6.2/constraints-3.7.txt"

#COPY --chown=airflow:root test_dag.py /opt/airflow/dags
#COPY /root/airflow/config/variables.json variables.json
#COPY /root/airflow/config/connections.yml connections.yml
#COPY /root/airflow/config/setup_connections.py setup_connections.py
#COPY /root/airflow/config/requirements.txt requirements.txt
#COPY /root/airflow/entrypoint.sh entrypoint.sh
#COPY /root/airflow/dags/ dags
#ENTRYPOINT ["./entrypoint.sh"]

COPY config/airflow.cfg ${AIRFLOW_USER_HOME}/airflow.cfg
RUN chown -R airflow: ${AIRFLOW_USER_HOME}

EXPOSE 8080

USER airflow

CMD ["webserver"]
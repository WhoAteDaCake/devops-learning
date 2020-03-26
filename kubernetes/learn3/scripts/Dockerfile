FROM ubuntu

ENV EXE "mocky-1.0.0"

RUN apt-get update && \
        apt-get install -y curl gnupg2 openjdk-8-jre-headless openjdk-8-jdk-headless unzip

WORKDIR /worker

RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list && \
        curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add && \
        apt-get update && apt-get install -y sbt && \
        git clone https://github.com/julien-lafont/Mocky.git

WORKDIR /worker/Mocky

RUN sbt run && \
        sed -i 's/v2/beta\/v1/g' conf/application.conf && \
        sbt dist && \
        unzip target/universal/$EXE.zip 

ENTRYPOINT ["./$EXE/bin/mocky"]
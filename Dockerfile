FROM nerc/spark-core

LABEL maintainer "gareth.lloyd@stfc.ac.uk"

ENV ZEPPELIN_VER 0.7.2
ENV ZEPPELIN_HOME=/opt/zeppelin

RUN mkdir -p /opt

RUN wget -O /tmp/zeppelin-${ZEPPELIN_VER}-bin-all.tgz http://archive.apache.org/dist/zeppelin/zeppelin-${ZEPPELIN_VER}/zeppelin-${ZEPPELIN_VER}-bin-all.tgz && \
	tar -zxvf /tmp/zeppelin-${ZEPPELIN_VER}-bin-all.tgz && \
	rm -rf /tmp/zeppelin-${ZEPPELIN_VER}-bin-all.tgz && \
	mv /zeppelin-${ZEPPELIN_VER}-bin-all ${ZEPPELIN_HOME}

EXPOSE 8080 8443

# Install GDAL utilities
RUN apt-get install -y gdal-bin

VOLUME ${ZEPPELIN_HOME}/logs \
       ${ZEPPELIN_HOME}/notebook

WORKDIR ${ZEPPELIN_HOME}
CMD ./bin/zeppelin.sh run

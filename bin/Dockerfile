FROM ubuntu:16.04 \
MAINTAINER amarildo lacerda <amarildo_51@msn.com> \

RUN apt-get update \ 
RUN apt-get install nginx -y \
\
ENV origem https://github.com/amarildolacerda/MVCBr/blob/master \
ENV dest /mvcbr \

RUN mkdir -p ${dest} \
\

ADD ${origem}/bin/MVCBrServer_Linux ${dest}/MVCBrServer_Linux \
ADD ${origem}/dados/MVCBR.FDB ${dest}/MVCBR.FDB \

EXPOSE 8080 \
ENTRYPOINT ${dest}/MVCBrServer_Linux \
#CMD bash \

FROM ubuntu:16.04 \
MAINTAINER amarildo lacerda <amarildo_51@msn.com> \
RUN apt-get update \
RUN echo "&& apt-get install nginx -y" \

RUN mkdir -p /mvcbr \

RUN echo "#ADD https://github.com/amarildolacerda/MVCBr/blob/master/bin/MVCBrServer_Linux /mvcbr/MVCBrServer_Linux" \
RUN echo "#ADD https://github.com/amarildolacerda/MVCBr/blob/master/dados/MVCBR.FDB /mvcbr/MVCBR.FDB" \

RUN echo "#EXPOSE 8080" \
RUN echo "#ENTRYPOINT mvcbr/MVCBrServer_Linux" \
CMD bash \

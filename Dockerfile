FROM debian:stable-slim
COPY ./docker/setup.sh /setup.sh
RUN sh -eux /setup.sh
WORKDIR /proj
ENV LANG en_US.UTF-8
ENV TZ Asia/Tokyo
COPY /docker/entrypoint.sh /docker/transfer.sh /
ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD []

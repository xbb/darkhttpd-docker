FROM alpine:3.16 AS build-stage

ARG VERSION=v1.14

RUN apk add --no-cache gcc make musl-dev && \
    wget -O darkhttpd.zip https://github.com/emikulic/darkhttpd/archive/"${VERSION}".zip \
    && unzip darkhttpd.zip \
    && rm darkhttpd.zip \
    && cd darkhttpd-* \
    && make CFLAGS=-static  \
    && mkdir /html \
    && echo "darkhttpd" > /html/index.html

FROM scratch

COPY --from=build-stage /darkhttpd-*/darkhttpd /darkhttpd
COPY --from=build-stage /html /html

ENTRYPOINT ["/darkhttpd"]

EXPOSE 8080

CMD ["/html", "--port", "8080"]

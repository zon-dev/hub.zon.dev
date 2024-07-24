FROM alpine:edge
RUN apk add zig

RUN mkdir -p /opt/app
WORKDIR /opt/app

RUN zig version

COPY . .
RUN zig build

# CMD [ "" ]
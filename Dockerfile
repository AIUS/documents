FROM alpine:3.8 AS builder
WORKDIR /doc
ADD https://github.com/jgm/pandoc/releases/download/2.4/pandoc-2.4-linux.tar.gz .
RUN tar -xzvf pandoc-2.4-linux.tar.gz -C /usr/local --strip-components 1
RUN apk add --no-cache moonscript lua lua-argparse lua-json4 lua-lyaml texlive-xetex texmf-dist-latexextra
COPY . /doc/
RUN ./helper build
RUN ./helper index

FROM nginx:alpine
COPY --from=builder /doc/ /usr/share/nginx/html

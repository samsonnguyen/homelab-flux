FROM devodev/inotify:latest

RUN apk add openssh-client-default openssh-client-common
COPY send.sh /send.sh
RUN chmod +x /send.sh
ENV INOTIFY_SCRIPT="/send.sh"

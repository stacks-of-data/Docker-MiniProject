FROM debian:latest

RUN apt-get update && apt-get install -y \
    chromium \
    ca-certificates
  
RUN adduser --system --group --no-create-home chromium \
    && mkdir -p /home/chromium \
    && chown -R chromium:chromium /home/chromium

COPY --chmod=0777 entrypoint.sh /entrypoint.sh
USER chromium
ENV HOME /home/chromium

ENTRYPOINT [ "/entrypoint.sh" ]
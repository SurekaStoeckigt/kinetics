FROM pandoc/core:3.1
WORKDIR /work
COPY scripts/convert.sh /usr/local/bin/convert.sh
RUN chmod +x /usr/local/bin/convert.sh
ENTRYPOINT ["/usr/local/bin/convert.sh"]

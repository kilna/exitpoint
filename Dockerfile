ARG base_image=busybox:latest

FROM ${base_image}

COPY exitpoint.sh /

COPY exitpoint-entrypoint.sh /

RUN chmod +x /exitpoint*.sh

# Set to another path if you want a different exitpoint location
ENV EXITPOINT=/exitpoint.sh

# Set to a value if you want to run your own entrypoint in a derived container
ENV ENTRYPOINT=''

ENTRYPOINT /exitpoint-entrypoint.sh

CMD []


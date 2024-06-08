ARG base_image=busybox:latest

FROM ${base_image}

COPY exitpoint.sh /

COPY exitpoint-entrypoint.sh /

RUN chmod +x /exitpoint*.sh

ENTRYPOINT [ "/exitpoint-entrypoint.sh" ]

# Set to a valid script if you want to run your own entrypoint in a
# derived container; /exitpoint-entrypoint.sh will in turn call this entrypoint
ENV ENTRYPOINT=''

# Set to another path if you want a different exitpoint location in your
# derived container
ENV EXITPOINT=/exitpoint.sh

# Default of no initial command to run; only the exitpoint will be executed
# Set CMD in your derived container (with optional --wait or --background
# prefix) in order to run a command at start of the container too.
CMD []


FROM kilna/exitpoint

COPY /*.sh /

RUN chmod +x /*.sh

ENV ENTRYPOINT=/entrypoint.sh

CMD [ "tail", "-f", "/dev/null" ]


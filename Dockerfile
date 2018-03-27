FROM scratch

ENV SERVICE_PORT 8080

EXPOSE $SERVICE_PORT

COPY opv-workshop /

CMD ["/opv-workshop"]
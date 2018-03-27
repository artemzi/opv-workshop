FROM scratch

ENV SERVICE_PORT 8080

EXPOSE $SERVICE_PORT

COPY opv_workshop /

CMD ["/opv_workshop"]
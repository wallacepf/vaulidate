FROM golang:1.16-alpine

RUN apk update && apk add --no-cache curl

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /goprintenv

ARG var_username
ARG var_password
ENV USERNAME=${var_username}
ENV PASSWORD=${var_password}

EXPOSE 8080

CMD [ "/goprintenv" ]
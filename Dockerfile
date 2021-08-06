FROM golang:1.16-buster AS builder
WORKDIR /demo-app
COPY go.mod .
COPY go.sum .
COPY ./apps ./
RUN go mod download
RUN go build -o /app ./*.go

FROM debian
RUN apt-get update && apt-get install -y ca-certificates && update-ca-certificates
COPY --from=builder /app .
CMD exec ./app

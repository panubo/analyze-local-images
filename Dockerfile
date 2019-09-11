FROM golang:1.12-alpine as builder

RUN apk --no-cache add git glide
RUN cd /go/src && mkdir -p github.com/coreos/analyze-local-images
ADD . /go/src/github.com/coreos/analyze-local-images
RUN cd /go/src/github.com/coreos/analyze-local-images && glide install
RUN cd /go && go install github.com/coreos/analyze-local-images
## To build MacOS
#RUN cd /go && GOOS=darwin GOARCH=amd64 go install github.com/coreos/analyze-local-images

FROM alpine:3.8
RUN apk --no-cache add docker
COPY --from=builder /go/bin/analyze-local-images /analyze-local-images
ENTRYPOINT ["/analyze-local-images"]
EXPOSE 9279

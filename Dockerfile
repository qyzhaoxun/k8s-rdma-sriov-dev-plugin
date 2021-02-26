FROM golang:1.14-alpine as builder

ARG GIT_COMMIT=$(git rev-list -1 HEAD)

ENV GO111MODULE=on
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

# config
WORKDIR /go/src/k8s-rdma-sriov-dev-plugin
COPY go.mod .
COPY go.sum .
RUN GO111MODULE=on go mod download
COPY . .
RUN go install -ldflags "-s -w -X main.GitCommitId=$GIT_COMMIT" ./

# runtime image
FROM gcr.io/google_containers/ubuntu-slim:0.14
COPY --from=builder /go/bin/ /bin/k8s-rdma-sriov-dp
ENTRYPOINT ["/bin/k8s-rdma-sriov-dp"]
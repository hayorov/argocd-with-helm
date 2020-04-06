
FROM alpine:latest  
RUN apk --no-cache add ca-certificates
WORKDIR /root/


ARG HELM3_VER=3.1.2
ARG HELM2_VER=2.16.5

RUN mkdir /custom-tools \
    && wget -qO- https://get.helm.sh/helm-v${HELM3_VER}-linux-amd64.tar.gz | tar -xvzf - \
    && mv linux-amd64/helm /custom-tools/helm-v3 \
    && wget -qO- https://storage.googleapis.com/kubernetes-helm/helm-v${HELM2_VER}-linux-amd64.tar.gz | tar -xvzf - \
    && mv linux-amd64/helm /custom-tools/helm-v2 \
    && wget -qO- https://raw.githubusercontent.com/hayorov/argo-cd-helmfile/master/src/helm-wrapper.sh > /custom-tools/helm \
    && chmod +x /custom-tools/helm


FROM argoproj/argocd:v1.4.2
COPY --from=0 /custom-tools /usr/local/bin

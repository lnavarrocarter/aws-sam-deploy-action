FROM alpine:3.14

LABEL version="1.0.0"

LABEL com.github.actions.name="SAM Deploy Action"
LABEL com.github.actions.description="Deploy AWS SAM Stack"
LABEL com.github.actions.icon="upload-cloud"
LABEL com.github.actions.color="purple"

LABEL repository="https://github.com/lnavarrocarter/aws-sam-deploy-action"
LABEL homepage="https://github.com/lnavarrocarter/aws-sam-deploy-action"
LABEL maintainer="Nacho Navarro <lnavarro.carter@gmail.com>"

ENV GLIBC_VER=2.31-r0

# install glibc compatibility for alpine
RUN apk --no-cache add \
        bash \
        binutils \
        curl \
    && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
    && apk add --no-cache \
        glibc-${GLIBC_VER}.apk \
        glibc-bin-${GLIBC_VER}.apk \
    && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/*/dist/aws_completer \
        /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/*/dist/awscli/examples \
    && apk --no-cache del \
        binutils \
        curl \
    && rm glibc-${GLIBC_VER}.apk \
    && rm glibc-bin-${GLIBC_VER}.apk \
    && rm -rf /var/cache/apk/*

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

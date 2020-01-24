FROM docker.io/alpine:3.11 as base

WORKDIR /aports

RUN apk update

RUN apk add abuild \
            alpine-conf \
            alpine-sdk \
            apk-tools \
            build-base \
            busybox \
            dosfstools \
            fakeroot \
            grub-efi \
            mtools \
            openssh \
            squashfs-tools \
            syslinux \
            xorriso

RUN adduser root abuild

# RUN echo "ALL            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

# USER build

RUN abuild-keygen -i -a -n

RUN mkdir /tmp/cache/ /tmp/iso/

ADD https://gitlab.alpinelinux.org/alpine/aports/-/archive/3.11-stable/aports-3.11-stable.tar.gz /tmp/
RUN tar -zxvf /tmp/aports-3.11-stable.tar.gz --strip-components=1
RUN ls -lah

COPY ./ scripts/

ENV PROFILE=alpineusb \
    TAG=v1

RUN scripts/mkimage.sh \
      --repository http://dl-cdn.alpinelinux.org/alpine/v3.11/main \
      --workdir /tmp/cache/ \
      --outdir /tmp/iso/ \
      --tag ${TAG} \
      --yaml \
      --profile ${PROFILE}

FROM base

COPY --from=base /tmp/iso/alpine-${PROFILE}-${TAG}-x86_64.iso /

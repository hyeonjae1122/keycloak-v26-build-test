FROM registry.access.redhat.com/ubi9 AS ubi-micro-build

RUN mkdir -p /mnt/rootfs
RUN dnf install --installroot /mnt/rootfs vi curl java-21-openjdk-devel \
    --releasever 9 --setopt install_weak_deps=false --nodocs -y && \
    dnf --installroot /mnt/rootfs clean all && \
    rpm --root /mnt/rootfs -e --nodeps setup

FROM quay.io/keycloak/keycloak:26.0.0

COPY --from=ubi-micro-build /mnt/rootfs /


RUN /opt/keycloak/bin/kc.sh build

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
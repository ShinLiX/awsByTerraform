#!/bin/bash
set -eux

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y \
  docker.io \
  docker-compose \
  curl \
  git \
  unzip \
  net-tools \
  ca-certificates

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

cat >/home/ubuntu/bootstrap-check.sh <<'EOF'
#!/bin/bash
set -e
echo "=== Docker version ==="
docker --version || true
echo "=== Docker Compose version ==="
docker-compose --version || true
EOF

chmod +x /home/ubuntu/bootstrap-check.sh
chown ubuntu:ubuntu /home/ubuntu/bootstrap-check.sh

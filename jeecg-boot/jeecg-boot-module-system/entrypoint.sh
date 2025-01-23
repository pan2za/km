#!/bin/sh

# 设置最大尝试次数和等待时间（秒）
MAX_RETRIES=30
WAIT_TIME=5

echo "Checking if kykms-ES is reachable..."

for i in $(seq 1 $MAX_RETRIES); do
  # 尝试 ping kykms-ES
  if ping -c 1 kykms-ES &> /dev/null; then
    echo "kykms-ES is up!"
    break
  else
    echo "Attempt $i: kykms-ES not reachable yet. Retrying in $WAIT_TIME seconds..."
    sleep $WAIT_TIME
  fi
done

if [ $i -gt $MAX_RETRIES ]; then
  echo "Failed to reach kykms-ES after $MAX_RETRIES attempts. Exiting."
  exit 1
fi

# 启动 Java 应用程序
exec java -jar jeecg-system-start-3.7.1.jar "$@"

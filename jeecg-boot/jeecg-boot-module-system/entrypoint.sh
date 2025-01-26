#!/bin/sh

# 设置最大尝试次数和等待时间（秒）
MAX_RETRIES=30
WAIT_TIME=5
PASSWORD=${OPENSEARCH_INITIAL_ADMIN_PASSWORD}

echo "Checking if kykms-ES is reachable..."

# 定义其他变量
USERNAME="admin"
HOST="http://kykms-ES:9200"
ENDPOINT="/_index_template/km_doc"

# 使用curl进行HEAD请求并捕获状态码
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -u "${USERNAME}:${PASSWORD}" -I "${HOST}${ENDPOINT}")

for i in $(seq 1 $MAX_RETRIES); do
  # 尝试 ping kykms-ES
  if [ "$STATUS_CODE" -eq 200 ]; then
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

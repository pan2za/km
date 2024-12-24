#!/bin/bash

# 检查是否提供了备份文件路径作为参数
if [ $# -eq 0 ]; then
    echo "Usage: $0 <path_to_tar_gz_file>"
    exit 1
fi

BACKUP_FILE=$1

# 解压备份文件到临时目录
TEMP_DIR=$(mktemp -d)
echo "Extracting to temporary directory $TEMP_DIR"
tar -xzvf "$BACKUP_FILE" -C "$TEMP_DIR"

# 加载每个镜像 tar 文件
for TAR_FILE in "$TEMP_DIR"/*.tar; do
    if [ -f "$TAR_FILE" ]; then
        IMAGE_NAME=$(basename "$TAR_FILE" .tar)
        echo "Loading image $IMAGE_NAME from $TAR_FILE..."
        docker load -i "$TAR_FILE"
    fi
done

# 清理临时文件
rm -rf "$TEMP_DIR"
echo "All images have been loaded."

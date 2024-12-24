#!/bin/bash

# 定义要导出的镜像列表
IMAGES=("kykms" "kykms-ui" "jeecg-boot-kykms-es" "redis:5.0" "jeecg-boot-kykms-mysql")

# 创建一个临时目录来存放各个镜像的 tar 文件
TEMP_DIR=$(mktemp -d)
echo "Temporary directory created at $TEMP_DIR"

# 保存每个镜像为 .tar 文件
for IMAGE in "${IMAGES[@]}"; do
    echo "Saving image $IMAGE..."
    docker save -o "$TEMP_DIR/$IMAGE.tar" "$IMAGE"
done

# 将所有镜像 tar 文件打包成一个大 tar 文件
OUTPUT_TAR="images_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
tar -czvf "$OUTPUT_TAR" -C "$TEMP_DIR" .

# 清理临时文件
rm -rf "$TEMP_DIR"
echo "All images have been saved into $OUTPUT_TAR"

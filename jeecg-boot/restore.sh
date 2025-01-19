#!/bin/bash

# 镜像保存目录
save_dir="/mnt/sdb1/release"

# 检查保存目录是否存在
if [ ! -d "$save_dir" ]; then
    echo "Error: Directory $save_dir does not exist."
    exit 1
fi

# 定义需要恢复的 9 个镜像文件名
images=(
    "kykms-ui.tar"
    "kykms.tar"
)

# 遍历所有镜像文件并加载
for image_file in "${images[@]}"; do
    file_path="$save_dir/$image_file"
    if [ -f "$file_path" ]; then
        echo "Loading image from $file_path..."
        docker load -i "$file_path"
    else
        echo "Error: File $file_path does not exist. Skipping..."
    fi
done

echo "All specified images have been loaded from $save_dir."

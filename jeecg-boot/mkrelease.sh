#!/bin/bash

# 镜像保存目录
save_dir="/mnt/sdb1/release"

# 创建保存目录（如果不存在）
mkdir -p "$save_dir"

images=(
    "kykms-ui"
    "kykms"
)

# 遍历所有镜像并保存
for image in "${images[@]}"; do
    # 检查镜像是否存在
    if docker image inspect "$image" > /dev/null 2>&1; then
        # 替换镜像名称中的斜杠为下划线（避免文件名问题）
        file_name=$(echo "$image" | tr '/' '_' | tr ':' '_').tar
        file_path="$save_dir/$file_name"

        echo "Saving image $image to $file_path..."
        docker save -o "$file_path" "$image"
    else
        echo "Error: Image $image does not exist. Skipping..."
    fi
done

echo "All specified images have been saved to $save_dir."

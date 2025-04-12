#!/usr/bin/env python3
import os
import sys
from PIL import Image

# 定义目标尺寸
TARGET_SIZES = {
    "characters": (512, 512),       # 角色肖像
    "ui": (128, 128),               # UI图标
    "backgrounds": (1280, 720),     # 背景图像
    "background": (1280, 720)       # 备用背景目录名
}

def resize_image(image_path, target_size):
    """调整图像尺寸并保留透明通道"""
    try:
        # 打开图像
        img = Image.open(image_path)
        original_size = img.size
        
        # 检查是否需要调整大小
        if original_size == target_size:
            print(f"✓ {os.path.basename(image_path)} 已经是正确尺寸 {target_size}")
            return True
            
        # 获取图像模式
        mode = img.mode
        
        # 调整图像大小 (使用LANCZOS算法获得更好的质量)
        resized_img = img.resize(target_size, Image.LANCZOS)
        
        # 保存调整后的图像，确保保留透明通道
        resized_img.save(image_path, format=img.format, quality=95)
        print(f"✓ 已调整 {os.path.basename(image_path)} 从 {original_size} 到 {target_size}")
        return True
        
    except Exception as e:
        print(f"✗ 处理 {image_path} 时出错: {str(e)}")
        return False

def process_directory(directory):
    """处理指定目录中的所有图像"""
    # 确定目标尺寸
    dir_name = os.path.basename(directory)
    if dir_name in TARGET_SIZES:
        target_size = TARGET_SIZES[dir_name]
    else:
        # 对于未知目录，我们不处理
        print(f"? 跳过未知目录 {dir_name} (没有定义目标尺寸)")
        return
    
    print(f"\n处理目录: {directory} (目标尺寸: {target_size})")
    
    # 获取目录中的所有PNG文件
    if not os.path.exists(directory):
        print(f"! 目录 {directory} 不存在")
        return
        
    image_files = [f for f in os.listdir(directory) if f.lower().endswith(('.png', '.jpg', '.jpeg'))]
    
    if not image_files:
        print(f"! 目录 {directory} 中没有找到图像文件")
        return
    
    success_count = 0
    for filename in image_files:
        image_path = os.path.join(directory, filename)
        if resize_image(image_path, target_size):
            success_count += 1
    
    print(f"共处理了 {len(image_files)} 个文件，成功调整 {success_count} 个")

def main():
    # 获取项目根目录
    project_dir = "/Users/ghy/Desktop/game_test/x2_project"
    assets_dir = os.path.join(project_dir, "assets")
    
    # 检查assets目录是否存在
    if not os.path.exists(assets_dir):
        print(f"错误: assets目录不存在: {assets_dir}")
        return
    
    # 处理每个资源目录
    asset_subdirs = [
        os.path.join(assets_dir, "characters"),
        os.path.join(assets_dir, "ui"),
        os.path.join(assets_dir, "backgrounds"),
        os.path.join(assets_dir, "background")  # 添加备用背景目录
    ]
    
    for directory in asset_subdirs:
        process_directory(directory)
    
    print("\n所有图像处理完成!")

if __name__ == "__main__":
    main() 
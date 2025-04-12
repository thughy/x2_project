#!/usr/bin/env python3
import os
import sys
import shutil
from PIL import Image

# 定义角色和他们需要的情绪表情
CHARACTER_EMOTIONS = {
    "isa": [
        "neutral", "curious", "happy", "sad", "confused", 
        "surprised", "warm", "awe", "hopeful", "reflective"
    ],
    "erika": [
        "neutral", "curious", "friendly", "concerned", "professional",
        "enthusiastic", "impressed", "warm", "excited"
    ],
    "neil": [
        "neutral", "fascinated", "tired", "surprised", "awe",
        "determined", "passionate", "focused", "analytical", 
        "excited", "philosophical", "profound"
    ],
    "kai": [
        "neutral", "analytical", "precise", "contemplative",
        "angry", "curious", "confused"
    ]
}

def duplicate_base_image(base_path, character, emotions):
    """从基础图像创建多个情绪变体"""
    if not os.path.exists(base_path):
        print(f"错误: 基础图像不存在: {base_path}")
        return False
    
    characters_dir = os.path.dirname(base_path)
    
    # 获取基础图像信息
    try:
        img = Image.open(base_path)
        print(f"处理角色: {character} (原始图像大小: {img.size})")
    except Exception as e:
        print(f"打开图像 {base_path} 时出错: {str(e)}")
        return False
    
    # 为每个情绪创建副本
    for emotion in emotions:
        emotion_path = os.path.join(characters_dir, f"{character}_{emotion}.png")
        
        # 如果情绪变体已存在，则跳过
        if os.path.exists(emotion_path) and emotion != "neutral":
            print(f"✓ {character}_{emotion}.png 已存在，跳过")
            continue
        
        # 使用基础图像创建情绪变体
        shutil.copy2(base_path, emotion_path)
        print(f"✓ 已创建 {character}_{emotion}.png")
    
    return True

def main():
    # 获取项目根目录
    project_dir = "/Users/ghy/Desktop/game_test/x2_project"
    characters_dir = os.path.join(project_dir, "assets", "characters")
    
    # 检查characters目录是否存在
    if not os.path.exists(characters_dir):
        print(f"错误: characters目录不存在: {characters_dir}")
        return
    
    # 处理每个角色
    for character, emotions in CHARACTER_EMOTIONS.items():
        # 基础图像路径
        base_path = os.path.join(characters_dir, f"{character}.png")
        
        # 如果基础图像不存在，尝试使用neutral变体
        if not os.path.exists(base_path):
            base_path = os.path.join(characters_dir, f"{character}_neutral.png")
            if not os.path.exists(base_path):
                print(f"错误: 角色 {character} 的基础图像和neutral变体都不存在")
                continue
        
        # 创建情绪变体
        duplicate_base_image(base_path, character, emotions)
    
    print("\n所有角色情绪变体创建完成!")

if __name__ == "__main__":
    main() 
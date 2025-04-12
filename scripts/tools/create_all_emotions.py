#!/usr/bin/env python3
import os
import sys
import shutil
from PIL import Image

# 所有情绪列表 - 包含了所有可能需要的情绪
ALL_EMOTIONS = [
    "neutral", "curious", "happy", "sad", "confused", 
    "surprised", "warm", "awe", "hopeful", "reflective",
    "friendly", "concerned", "professional", "enthusiastic", 
    "impressed", "excited", "fascinated", "tired", "determined", 
    "passionate", "focused", "analytical", "philosophical", 
    "profound", "precise", "contemplative", "angry"
]

def create_all_emotions_for_character(character_path, character):
    """为角色创建所有情绪变体"""
    if not os.path.exists(character_path):
        print(f"错误: 角色图像不存在: {character_path}")
        return False
    
    print(f"为角色 {character} 创建所有情绪变体")
    
    characters_dir = os.path.dirname(character_path)
    success_count = 0
    
    # 为每个情绪创建副本
    for emotion in ALL_EMOTIONS:
        emotion_path = os.path.join(characters_dir, f"{character}_{emotion}.png")
        
        try:
            # 复制基础图像
            shutil.copy2(character_path, emotion_path)
            print(f"✓ 已创建 {character}_{emotion}.png")
            success_count += 1
        except Exception as e:
            print(f"✗ 创建 {character}_{emotion}.png 失败: {str(e)}")
    
    print(f"角色 {character} 处理完成: 创建了 {success_count} 个情绪变体")
    return True

def create_default_portrait(characters_dir):
    """创建默认肖像"""
    neutral_path = os.path.join(characters_dir, "_neutral.png")
    
    # 如果已存在则跳过
    if os.path.exists(neutral_path):
        print(f"默认肖像已存在: {neutral_path}")
        return
    
    try:
        # 创建一个简单的灰色图像
        img = Image.new('RGBA', (512, 512), (128, 128, 128, 255))
        img.save(neutral_path, format="PNG")
        print(f"✓ 已创建默认肖像: {neutral_path}")
    except Exception as e:
        print(f"✗ 创建默认肖像失败: {str(e)}")

def create_system_icons(ui_dir):
    """创建系统图标"""
    narrator_path = os.path.join(ui_dir, "narrator_icon.png")
    system_path = os.path.join(ui_dir, "system_icon.png")
    
    try:
        # 创建叙述者图标 (蓝色圆圈)
        if not os.path.exists(narrator_path):
            img = Image.new('RGBA', (128, 128), (0, 0, 0, 0))
            for x in range(128):
                for y in range(128):
                    # 创建蓝色圆圈
                    dx, dy = x - 64, y - 64
                    dist = (dx*dx + dy*dy) ** 0.5
                    if dist < 50:
                        img.putpixel((x, y), (50, 100, 200, 255))
            img.save(narrator_path, format="PNG")
            print(f"✓ 已创建叙述者图标: {narrator_path}")
        
        # 创建系统图标 (红色三角形)
        if not os.path.exists(system_path):
            img = Image.new('RGBA', (128, 128), (0, 0, 0, 0))
            for x in range(128):
                for y in range(128):
                    # 创建红色三角形
                    if y > 30 and y < 100 and x > 30 and x < 100 and x + y > 128:
                        img.putpixel((x, y), (200, 50, 50, 255))
            img.save(system_path, format="PNG")
            print(f"✓ 已创建系统图标: {system_path}")
    except Exception as e:
        print(f"✗ 创建系统图标失败: {str(e)}")

def main():
    # 项目根目录
    project_dir = "/Users/ghy/Desktop/game_test/x2_project"
    characters_dir = os.path.join(project_dir, "assets", "characters")
    ui_dir = os.path.join(project_dir, "assets", "ui")
    
    # 确保目录存在
    if not os.path.exists(characters_dir):
        os.makedirs(characters_dir)
        print(f"创建目录: {characters_dir}")
    
    if not os.path.exists(ui_dir):
        os.makedirs(ui_dir)
        print(f"创建目录: {ui_dir}")
    
    # 创建默认肖像
    create_default_portrait(characters_dir)
    
    # 创建系统图标
    create_system_icons(ui_dir)
    
    # 处理每个角色
    characters = ["isa", "erika", "neil", "kai"]
    
    for character in characters:
        character_path = os.path.join(characters_dir, f"{character}.png")
        create_all_emotions_for_character(character_path, character)
    
    print("\n所有角色情绪变体创建完成!")

if __name__ == "__main__":
    main() 
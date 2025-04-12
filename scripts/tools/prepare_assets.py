#!/usr/bin/env python3
import os
import sys
import subprocess
import importlib.util

def import_script(script_path):
    """动态导入Python脚本"""
    try:
        spec = importlib.util.spec_from_file_location("module.name", script_path)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        return module
    except Exception as e:
        print(f"导入脚本 {script_path} 时出错: {str(e)}")
        return None

def run_script(script_path):
    """运行指定脚本"""
    print(f"\n{'=' * 60}")
    print(f"执行脚本: {os.path.basename(script_path)}")
    print(f"{'=' * 60}\n")
    
    # 检查脚本是否存在
    if not os.path.exists(script_path):
        print(f"错误: 脚本不存在: {script_path}")
        return False
    
    # 尝试导入并执行脚本的main函数
    try:
        module = import_script(script_path)
        if module and hasattr(module, 'main'):
            module.main()
            return True
        else:
            print(f"错误: 脚本 {script_path} 中没有找到main函数")
            return False
    except Exception as e:
        print(f"执行脚本 {script_path} 时出错: {str(e)}")
        return False

def check_required_assets():
    """检查游戏所需的所有资源是否存在"""
    project_dir = "/Users/ghy/Desktop/game_test/x2_project"
    assets_dir = os.path.join(project_dir, "assets")
    
    # 定义需要检查的资源文件
    required_assets = {
        "UI图标": [
            os.path.join(assets_dir, "ui", "narrator_icon.png"),
            os.path.join(assets_dir, "ui", "system_icon.png")
        ],
        "默认肖像": [
            os.path.join(assets_dir, "characters", "_neutral.png")
        ],
        "角色肖像": []
    }
    
    # 添加所有角色情绪变体
    characters = ["isa", "erika", "neil", "kai"]
    emotions = [
        "neutral", "curious", "happy", "sad", "confused", "surprised", 
        "warm", "awe", "hopeful", "reflective", "friendly", "concerned", 
        "professional", "enthusiastic", "impressed", "excited", 
        "fascinated", "tired", "determined", "passionate", "focused", 
        "analytical", "philosophical", "profound", "precise", 
        "contemplative", "angry"
    ]
    
    for character in characters:
        for emotion in emotions:
            asset_path = os.path.join(assets_dir, "characters", f"{character}_{emotion}.png")
            required_assets["角色肖像"].append(asset_path)
    
    # 添加背景图像
    background_types = [
        "research", "private", "public", "boundary", "crisis"
    ]
    
    for bg_type in background_types:
        asset_path = os.path.join(assets_dir, "background", f"background_{bg_type}.png")
        required_assets.setdefault("背景图像", []).append(asset_path)
    
    # 检查所有资源
    print("\n检查游戏资源:\n")
    
    missing_count = 0
    for category, paths in required_assets.items():
        missing_in_category = 0
        
        for path in paths:
            if not os.path.exists(path):
                if missing_in_category == 0:
                    print(f"-- {category} --")
                
                print(f"✗ 缺少: {os.path.basename(path)}")
                missing_in_category += 1
                missing_count += 1
        
        if missing_in_category == 0:
            print(f"✓ {category}: 全部文件存在")
    
    if missing_count > 0:
        print(f"\n警告: 共发现 {missing_count} 个缺失资源")
    else:
        print("\n✓ 所有必需的游戏资源已准备就绪!")
    
    return missing_count == 0

def main():
    # 项目根目录
    project_dir = "/Users/ghy/Desktop/game_test/x2_project"
    tools_dir = os.path.join(project_dir, "scripts", "tools")
    
    # 要执行的脚本列表
    scripts = [
        os.path.join(tools_dir, "create_emotion_variants.py"),  # 第1步: 创建角色情绪变体
        os.path.join(tools_dir, "fix_background_paths.py"),    # 第2步: 修复背景图像路径
        os.path.join(tools_dir, "resize_assets.py"),           # 第3步: 调整所有素材尺寸
    ]
    
    # 按顺序执行所有脚本
    for script_path in scripts:
        if not run_script(script_path):
            print(f"警告: 脚本 {os.path.basename(script_path)} 可能未成功执行")
    
    # 最后检查游戏资源
    all_assets_ready = check_required_assets()
    
    if all_assets_ready:
        print("\n所有游戏资源已准备就绪，可以开始游戏测试!")
    else:
        print("\n警告: 一些游戏资源仍然缺失，游戏可能无法正常运行")

if __name__ == "__main__":
    main() 
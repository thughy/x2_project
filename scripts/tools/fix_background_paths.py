#!/usr/bin/env python3
import os
import sys
import shutil

def fix_background_paths():
    """将背景图像从backgrounds目录移动到background目录"""
    project_dir = "/Users/ghy/Desktop/game_test/x2_project"
    source_dir = os.path.join(project_dir, "assets", "backgrounds")
    target_dir = os.path.join(project_dir, "assets", "background")
    
    # 检查源目录是否存在
    if not os.path.exists(source_dir):
        print(f"错误: 源目录不存在: {source_dir}")
        return
    
    # 创建目标目录(如果不存在)
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)
        print(f"已创建目标目录: {target_dir}")
    
    # 获取源目录中的所有背景图像
    background_files = [f for f in os.listdir(source_dir) if f.startswith("background_") and f.lower().endswith(".png")]
    
    if not background_files:
        print(f"警告: 在 {source_dir} 中没有找到背景图像文件")
        return
    
    # 移动所有背景图像
    for filename in background_files:
        source_path = os.path.join(source_dir, filename)
        target_path = os.path.join(target_dir, filename)
        
        # 如果目标文件已存在，先删除它
        if os.path.exists(target_path):
            os.remove(target_path)
            print(f"已删除已存在的目标文件: {target_path}")
        
        # 移动文件
        shutil.copy2(source_path, target_path)
        print(f"已复制: {filename} -> {target_dir}")
    
    print(f"\n已成功将 {len(background_files)} 个背景图像从 {source_dir} 复制到 {target_dir}")

def check_background_references():
    """检查代码中的背景引用"""
    project_dir = "/Users/ghy/Desktop/game_test/x2_project"
    expected_path = "res://assets/background/"
    
    # 可能包含背景引用的脚本目录
    script_dirs = [
        os.path.join(project_dir, "scripts"),
        os.path.join(project_dir, "scenes")
    ]
    
    references_found = False
    
    for script_dir in script_dirs:
        if not os.path.exists(script_dir):
            continue
            
        # 遍历所有脚本文件
        for root, dirs, files in os.walk(script_dir):
            for file in files:
                if file.endswith((".gd", ".tscn")):
                    file_path = os.path.join(root, file)
                    
                    # 读取文件内容
                    try:
                        with open(file_path, 'r') as f:
                            content = f.read()
                            
                            # 检查背景引用
                            if "res://assets/backgrounds/" in content:
                                references_found = True
                                print(f"在 {file_path} 中找到了错误的背景路径引用")
                    except Exception as e:
                        print(f"读取文件 {file_path} 时出错: {str(e)}")
    
    if not references_found:
        print("未发现代码中有错误的背景路径引用")
    else:
        print("警告: 发现可能需要修正的背景路径引用！")

def main():
    # 修复背景路径
    fix_background_paths()
    
    # 检查代码中的背景引用
    check_background_references()

if __name__ == "__main__":
    main() 
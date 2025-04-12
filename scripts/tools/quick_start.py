#!/usr/bin/env python3
import os
import sys
import subprocess
import time

def print_header(text):
    """打印带格式的标题"""
    line = "=" * 70
    print(f"\n{line}")
    print(f"  {text}")
    print(f"{line}\n")

def run_script(script_path):
    """运行指定的Python脚本"""
    if not os.path.exists(script_path):
        print(f"错误: 脚本不存在: {script_path}")
        return False
    
    try:
        result = subprocess.run([sys.executable, script_path], check=True)
        return result.returncode == 0
    except subprocess.CalledProcessError:
        return False
    except Exception as e:
        print(f"运行脚本 {script_path} 时出错: {str(e)}")
        return False

def main():
    print_header("X² PROJECT - 快速启动工具")
    
    # 项目根目录
    project_dir = "/Users/ghy/Desktop/game_test/x2_project"
    tools_dir = os.path.join(project_dir, "scripts", "tools")
    
    # 步骤1: 处理素材
    print_header("步骤1: 处理游戏素材")
    prepare_script = os.path.join(tools_dir, "prepare_assets.py")
    
    print("正在运行资源处理脚本...\n")
    success = run_script(prepare_script)
    
    if not success:
        response = input("\n资源处理出现问题。是否仍要继续? (y/n): ")
        if response.lower() != 'y':
            print("操作已取消。")
            return
    
    # 等待1秒，确保文件写入完成
    time.sleep(1)
    
    # 步骤2: 启动游戏
    print_header("步骤2: 启动游戏")
    
    game_script = os.path.join(tools_dir, "run_game_with_checks.py")
    run_script(game_script)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n操作已取消。")
    except Exception as e:
        print(f"\n发生错误: {str(e)}")
        sys.exit(1) 
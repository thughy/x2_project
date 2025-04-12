#!/usr/bin/env python3
import os
import sys
import subprocess
import platform

def check_godot_executable():
    """检查Godot可执行文件是否存在"""
    # 根据操作系统确定可能的Godot可执行文件路径
    godot_paths = []
    
    if platform.system() == "Darwin":  # macOS
        godot_paths = [
            "/Applications/Godot.app/Contents/MacOS/Godot",
            os.path.expanduser("~/Applications/Godot.app/Contents/MacOS/Godot"),
            "/Applications/Godot_4.app/Contents/MacOS/Godot",
            os.path.expanduser("~/Applications/Godot_4.app/Contents/MacOS/Godot")
        ]
    elif platform.system() == "Windows":
        godot_paths = [
            "C:/Program Files/Godot/Godot.exe",
            "C:/Program Files (x86)/Godot/Godot.exe",
            os.path.expanduser("~/AppData/Local/Programs/Godot/Godot.exe")
        ]
    else:  # Linux and others
        godot_paths = [
            "/usr/bin/godot",
            "/usr/local/bin/godot",
            os.path.expanduser("~/godot/bin/godot")
        ]
    
    # 添加当前目录和环境变量中的Godot
    godot_paths.append("godot")  # If in PATH
    
    # 检查每个可能的路径
    for godot_path in godot_paths:
        try:
            # 尝试运行Godot版本命令
            result = subprocess.run([godot_path, "--version"], 
                                   stdout=subprocess.PIPE, 
                                   stderr=subprocess.PIPE,
                                   text=True,
                                   check=False)
            
            if result.returncode == 0:
                print(f"找到Godot: {godot_path} (版本: {result.stdout.strip()})")
                return godot_path
        except FileNotFoundError:
            continue
        except Exception as e:
            print(f"检查 {godot_path} 时出错: {str(e)}")
    
    return None

def run_asset_check():
    """运行资源检查脚本"""
    project_dir = "/Users/ghy/Desktop/game_test/x2_project"
    asset_check_script = os.path.join(project_dir, "scripts", "tools", "prepare_assets.py")
    
    if not os.path.exists(asset_check_script):
        print(f"错误: 资源检查脚本不存在: {asset_check_script}")
        return False
    
    try:
        # 运行资源检查脚本
        result = subprocess.run([sys.executable, asset_check_script], 
                               check=True)
        return result.returncode == 0
    except subprocess.CalledProcessError:
        return False
    except Exception as e:
        print(f"运行资源检查脚本时出错: {str(e)}")
        return False

def run_game():
    """运行Godot游戏"""
    project_dir = "/Users/ghy/Desktop/game_test/x2_project"
    
    # 检查Godot可执行文件
    godot_path = check_godot_executable()
    if not godot_path:
        print("错误: 找不到Godot可执行文件")
        print("请确保Godot已安装并在PATH中，或者手动启动游戏")
        return False
    
    # 命令参数
    godot_args = [
        godot_path,
        "--path", project_dir,
        "--debug"  # 使用调试模式启动
    ]
    
    try:
        print(f"\n启动游戏...\n命令: {' '.join(godot_args)}\n")
        
        # 启动游戏
        process = subprocess.Popen(godot_args)
        
        print("游戏已启动! 请查看Godot窗口。")
        print("(此脚本将保持运行，按Ctrl+C结束)")
        
        # 等待游戏运行
        process.wait()
        
        return True
    except Exception as e:
        print(f"启动游戏时出错: {str(e)}")
        return False

def main():
    print("X² PROJECT - 游戏启动与资源检查工具\n")
    
    # 首先运行资源检查
    print("第1步: 检查游戏资源...")
    if not run_asset_check():
        response = input("\n资源检查发现问题。是否仍要尝试启动游戏? (y/n): ")
        if response.lower() != 'y':
            print("游戏启动已取消。请修复资源问题后再试。")
            return
    
    # 运行游戏
    print("\n第2步: 启动游戏...")
    if not run_game():
        print("\n游戏启动失败。请检查Godot是否已正确安装。")
        print("您也可以手动启动Godot并打开项目。")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n操作已取消。")
    except Exception as e:
        print(f"\n发生错误: {str(e)}")
        sys.exit(1) 
# Bug修复日志

## UI交互 (UI Interaction)

### BUG-UI-001：对话UI无交互反应
**日期**：2023-11-28

**优先级**：高 - 游戏核心功能阻断性问题

**问题描述**：
用户无法通过点击或空格键前进对话，选择项无法显示和选择，导致游戏核心交互功能完全无法使用。

**复现步骤**：
1. 启动游戏
2. 进入游戏场景
3. 尝试通过点击或按空格键前进对话 - 无响应
4. 对话中应出现选择项时无法显示选择面板

**问题根源分析**：
1. **选择面板显示问题**：
   - `ChoicesPanel`在UI设计时默认设置为`visible = false`
   - 在`display_choices`函数中创建选择按钮后，没有将`ChoicesPanel`设为可见
   - 同样，`clear_choices`函数清除选择后没有隐藏面板

2. **输入处理问题**：
   - 对话UI的`_input`函数条件判断过于严格，只有同时满足多个条件才会响应输入
   - 缺少调试输出，难以确认输入是否被正确捕获

3. **对话控制器问题**：
   - `dialogue_scene_controller.gd`中`update_dialogue_ui`函数在没有选择项时不会清除之前的选择面板

4. **输入映射设置问题**：
   - 缺少验证输入映射是否正确初始化的机制

**修复方案**：
1. **选择面板显示修复**：
   ```gdscript
   # 在display_choices函数末尾添加
   $ChoicesPanel.visible = true
   
   # 在clear_choices函数末尾添加
   $ChoicesPanel.visible = false
   ```

2. **输入处理优化**：
   ```gdscript
   # 重构_input函数，添加调试输出
   func _input(event):
       # 如果对话UI可见，且没有选择项显示，则允许通过点击或空格键前进对话
       if visible and choices_container.get_child_count() == 0:
           if event.is_action_pressed("ui_continue"):
               emit_signal("dialogue_advanced")
               
       # 调试信息
       if event.is_action_pressed("ui_continue"):
           print("UI continue action pressed. UI visible: ", visible, ", Choices count: ", choices_container.get_child_count())
   ```

3. **对话控制器修复**：
   ```gdscript
   # 在update_dialogue_ui函数中添加对无选择情况的处理
   if choices.size() > 0:
       dialogue_ui.display_choices(choices)
   else:
       # 确保清除之前的选择
       dialogue_ui.clear_choices()
   ```

4. **输入映射设置增强**：
   ```gdscript
   # 在input_map_setup.gd中添加调试输出
   print("Setting up input mappings...")
   # 各种初始化代码
   print("Input mapping setup complete")
   print("ui_continue actions:", InputMap.action_get_events("ui_continue").size())
   ```

5. **初始化修复**：
   ```gdscript
   # 在_ready函数中确保所有UI元素都正确初始化
   func _ready():
       # 其他初始化代码
       hide()
       $ChoicesPanel.visible = false
       $EmotionPanel.visible = false
       $RelationshipPanel.visible = false
   ```

**验证方法**：
通过运行游戏并启用详细日志，确认：
1. 输入映射正确初始化（"ui_continue actions: 2"）
2. 输入事件被正确捕获（"UI continue action pressed..."）
3. 选择面板能正确显示选择项数量（"Choices count: 3"）
4. 对话能够正常进行，并且场景转换正常

**相关文件**：
- `scripts/ui/dialogue_ui.gd` - 主要修改点
- `scripts/dialogue/dialogue_scene_controller.gd` - 次要修改点
- `scripts/core/input_map_setup.gd` - 添加调试输出

**教训与最佳实践**：
1. UI元素显示/隐藏状态应在对应的功能函数中明确控制
2. 关键用户输入应添加调试日志，便于排查问题
3. 初始化函数应明确设置所有UI元素的初始状态
4. 复杂条件判断应简化，并添加适当的注释说明判断逻辑
5. 对话系统的进展与选择处理应有清晰的日志记录

**修复影响**：
解决了游戏核心交互功能无法使用的阻断性问题，恢复了对话系统的正常功能，包括对话前进和选择处理。

---

## 系统分类编号规则

**BUG-UI-xxx**: UI相关问题
**BUG-DLG-xxx**: 对话系统问题
**BUG-GAME-xxx**: 游戏逻辑问题
**BUG-SYS-xxx**: 系统/引擎问题
**BUG-ART-xxx**: 美术资源问题
**BUG-SND-xxx**: 音效/音乐问题
**BUG-PERF-xxx**: 性能问题 

---

## 资源加载 (Resource Loading)

### BUG-ART-001：角色肖像和背景图像无法加载
**日期**：2025-04-12

**优先级**：高 - 游戏视觉呈现阻断性问题

**问题描述**：
游戏无法正确加载角色肖像和背景图像，导致显示占位符图像而非实际美术资源。这影响了游戏的视觉呈现和玩家体验。

**复现步骤**：
1. 启动游戏
2. 进入游戏场景
3. 观察角色肖像显示为彩色占位符
4. 观察背景显示为纯色占位符

**问题根源分析**：
1. **资源导入问题**：
   - Godot需要将原始资源文件(.png, .jpg等)导入为引擎可用的格式(.import)
   - 资源文件存在但未被Godot引擎正确导入
   - 缺少命令行导入资源的步骤

2. **错误处理问题**：
   - 代码中使用了Python风格的`try-except`错误处理，而非GDScript的条件检查
   - 资源加载失败时缺乏详细的错误日志

3. **路径不一致问题**：
   - 背景图像路径存在不一致：有些代码使用`assets/background/`，有些使用`assets/backgrounds/`
   - 缺少统一的资源路径管理

**修复方案**：
1. **资源导入修复**：
   ```bash
   # 使用Godot命令行工具导入项目资源
   godot --headless --editor --quit --path /path/to/project
   ```

2. **GDScript错误处理修正**：
   ```gdscript
   # 从
   try:
       texture = load(bg_path)
   except:
       print("无法加载背景")
       
   # 修改为
   if ResourceLoader.exists(bg_path):
       texture = load(bg_path)
   else:
       print("背景资源不存在:" + bg_path)
   ```

3. **路径一致性修复**：
   ```gdscript
   # 统一使用一个背景路径
   var bg_path = "res://assets/background/" + background_name + ".png"
   
   # 删除多余的backgrounds目录(带s)
   ```

4. **详细日志记录**：
   ```gdscript
   # 添加资源加载详细日志
   print("尝试加载背景:" + bg_path)
   if ResourceLoader.exists(bg_path):
       print("背景资源存在，尝试加载")
       texture = load(bg_path)
       print("成功加载背景")
   else:
       print("背景资源不存在:" + bg_path)
   ```

**验证方法**：
1. 使用命令行导入资源：`godot --headless --editor --quit --path /Users/ghy/Desktop/game_test/x2_project`
2. 检查`.godot/imported/`目录中是否生成了导入文件
3. 运行游戏，观察资源是否正确加载
4. 检查日志输出，确认资源加载过程

## 对话系统 (Dialogue System)

### BUG-DIALOGUE-001：对话被旁白(narrator)主导而非角色主导
**日期**：2025-04-12

**优先级**：中 - 影响游戏体验和角色沉浸感

**问题描述**：
游戏对话系统中，即使玩家选择了特定角色，对话仍然由旁白(narrator)主导，而不是由所选角色主导，降低了角色视角的沉浸感。

**复现步骤**：
1. 启动游戏
2. 选择任意角色（如Erika）
3. 进入游戏场景
4. 观察对话 - 大部分对话由narrator说出，而非所选角色

**问题根源分析**：
1. **角色特定对话文件中的说话者设置问题**：
   - 在角色特定对话文件（如`chapter1_erika.gd`）中，许多对话节点的speaker仍设置为"narrator"而非相应角色ID
   - 对话UI在处理narrator说话者时没有正确替换为玩家角色

2. **对话加载机制问题**：
   - 对话管理器在加载角色特定对话时，没有正确优先使用角色特定对话

**修复方案**：

1. **修改角色特定对话文件**：
   ```gdscript
   # 将角色特定对话文件中的narrator改为相应角色ID
   # 从
   "speaker": "narrator",
   
   # 修改为
   "speaker": "erika", # 或其他相应角色ID
   ```

2. **改进对话UI处理逻辑**：
   ```gdscript
   # 在dialogue_ui.gd中添加处理逻辑
   # 处理narrator或system（强制替换为玩家角色）
   elif speaker_id == "narrator" or speaker_id == "system":
       print("[对话 UI] 检测到旁白，将其替换为玩家角色:", player_char_id)
       final_speaker_id = player_char_id
       final_speaker_name = player_name
       is_player_speaking = true
       
       # 如果旁白没有指定情绪，设置一个默认情绪
       if emotion == "neutral":
           final_emotion = "thoughtful"
       
       # 修改文本，使其更适合主角发言
       text = convert_narrator_text_to_first_person(text)
   ```

3. **添加文本转换函数**：
   ```gdscript
   # 将旁白文本转换为第一人称
   func convert_narrator_text_to_first_person(text):
       # 替换常见的第三人称描述为第一人称
       var converted_text = text
       
       # 替换一些常见的第三人称表述
       converted_text = converted_text.replace("研究团队", "我们团队")
       converted_text = converted_text.replace("他们", "我们")
       
       # 处理特定角色的第三人称描述
       var player_char_id = game_state.get_player_character()
       if player_char_id == "erika":
           converted_text = converted_text.replace("艾丽卡博士", "我")
           converted_text = converted_text.replace("艾丽卡", "我")
           converted_text = converted_text.replace("她的", "我的")
       
       return converted_text
   ```

4. **添加详细调试日志**：
   ```gdscript
   # 添加详细日志，帮助理解对话处理流程
   print("[对话 UI] 最终处理结果: 说话者=", final_speaker_id, ", 显示名称=", final_speaker_name)
   print("[对话 UI] 最终对话内容: \"", text, "\"")
   ```

**验证方法**：
1. 启动游戏并选择不同角色
2. 观察对话是否由所选角色主导而非旁白
3. 检查对话文本是否正确使用第一人称
4. 检查日志输出，确认对话处理流程

### BUG-DIALOGUE-002：对话系统跳过初始对话
**日期**：2025-04-12

**优先级**：高 - 影响游戏核心叙事体验

**问题描述**：
游戏在选择角色后会自动跳过初始对话（intro_01到intro_08），直接进入选择部分，导致玩家无法体验完整的故事情节。

**复现步骤**：
1. 启动游戏
2. 选择任意角色
3. 进入游戏场景
4. 观察对话 - 初始对话（intro_01到intro_08）被跳过

**问题根源分析**：
1. **对话管理器中的自动进度机制**：
   - 当对话节点没有选择项且有下一个节点时，会自动跳到下一个节点，导致intro对话被快速跳过
   - 没有机制来确保用户能够查看每个对话节点的内容

**修复方案**：

1. **修改对话管理器中的自动进度机制**：
   ```gdscript
   # 从
   # If no choices, and there's a next node, automatically progress
   if active_choices.size() == 0 and "next" in node_data:
       current_node = node_data["next"]
       return process_current_node()
   
   # 修改为
   # If no choices, and there's a next node, check if we should automatically progress
   if active_choices.size() == 0 and "next" in node_data:
       # 检查是否是intro对话节点
       var is_intro_node = current_node.begins_with("intro_")
       # 检查是否有auto_advance标志
       var auto_advance = node_data.get("auto_advance", false)
       
       # 如果是intro节点或没有auto_advance标志，不自动前进，等待用户交互
       if is_intro_node and not auto_advance:
           # 发出信号，表示需要用户交互才能继续
           emit_signal("dialogue_waiting_for_advance")
           return true
       else:
           # 对于非intro节点或有auto_advance标志的节点，自动前进
           current_node = node_data["next"]
           return process_current_node()
   ```

2. **添加新的信号和处理方法**：
   ```gdscript
   # 在对话管理器中添加新信号
   signal dialogue_waiting_for_advance
   
   # 添加手动前进对话的方法
   func advance_dialogue():
       print("[对话管理器] 用户请求前进对话")
       
       if current_dialogue == null or current_node == null:
           print("[对话管理器] 无法前进对话，当前没有活动对话")
           return false
       
       # 获取当前节点数据
       var node_data = dialogue_library[current_dialogue]["nodes"][current_node]
       
       # 检查是否有下一个节点
       if "next" in node_data:
           # 移动到下一个节点
           current_node = node_data["next"]
           # 处理新节点
           return process_current_node()
       else:
           # 对话结束
           emit_signal("dialogue_ended", current_dialogue)
           current_dialogue = null
           current_node = null
           return false
   ```

3. **在对话场景控制器中处理等待信号**：
   ```gdscript
   # 处理对话等待用户交互的信号
   func _on_dialogue_waiting_for_advance():
       print("[对话控制器] 对话等待用户交互")
       
       # 获取当前对话节点信息
       var current_node_data = dialogue_manager.get_current_node()
       if current_node_data == null:
           print("[对话控制器] 警告: 无法获取当前对话节点数据")
           return
       
       # 更新对话UI，显示对话内容并等待用户点击继续
       if dialogue_ui != null:
           # 设置UI为等待用户交互模式
           dialogue_ui.show_dialogue(
               current_node_data.get("speaker", ""),
               current_node_data.get("text", ""),
               current_node_data.get("emotion", "neutral"),
               [] # 没有选择项
           )
           
           # 显示继续按钮或提示
           dialogue_ui.show_continue_prompt()
   ```

4. **修改对话前进方法**：
   ```gdscript
   # 从
   func _on_dialogue_advanced():
       print("对话前进")
       
       # Process flags before advancing to check for scene transitions
       if check_scene_transition():
           return
       
       # Clear choices just in case
       dialogue_ui.clear_choices()
       
       # Advance to the next node
       print("处理当前对话节点")
       dialogue_manager.process_current_node()
       
       # Update the UI
       update_dialogue_ui()
   
   # 修改为
   func _on_dialogue_advanced():
       print("[对话控制器] 用户请求前进对话")
       
       # 先检查是否有场景转换
       if check_scene_transition():
           return
       
       # 清除选项
       dialogue_ui.clear_choices()
       
       # 使用新的advance_dialogue方法前进对话
       print("[对话控制器] 调用对话管理器的advance_dialogue方法")
       dialogue_manager.advance_dialogue()
       
       # 更新UI
       update_dialogue_ui()
   ```

**验证方法**：
1. 启动游戏并选择不同角色
2. 观察是否能够看到所有初始对话（intro_01到intro_08）
3. 确认每个对话节点都需要用户交互才会前进
4. 检查日志输出，确认对话处理流程

**相关文件**：
- `scripts/game_scene.gd` - 背景加载
- `scripts/ui/dialogue_ui.gd` - 角色肖像加载
- `scripts/ui/character_select.gd` - 角色选择界面肖像加载
- `scripts/dialogue/dialogue_manager.gd` - 对话资源加载
- `scripts/core/background_manager.gd` - 背景管理

**教训与最佳实践**：
1. 使用GDScript的条件检查而非Python风格的try-except进行错误处理
2. 保持资源路径的一致性，避免使用多个不同的路径指向同一类资源
3. 在资源加载过程中添加详细的日志记录，便于排查问题
4. 使用命令行工具导入资源，避免依赖Godot编辑器界面
5. 实现资源加载的优雅降级，当资源不可用时提供合适的占位符

**修复影响**：
解决了游戏视觉呈现的关键问题，使玩家能够看到正确的角色肖像和背景图像，大幅提升了游戏体验。同时，改进了代码质量和错误处理机制，使未来的资源加载更加健壮。

### BUG-SYS-001：GDScript语法错误导致功能失效
**日期**：2025-04-12

**优先级**：高 - 代码执行阻断性问题

**问题描述**：
多个脚本文件中使用了Python风格的`try-except`错误处理语法，而GDScript不支持这种语法，导致相关功能无法正常执行。

**复现步骤**：
1. 查看控制台错误日志
2. 观察多个"Parse Error"错误，指向try-except语句

**问题根源分析**：
1. **语法不兼容**：
   - GDScript基于Python但不完全兼容Python语法
   - GDScript不支持try-except错误处理机制
   - 开发者可能混淆了Python和GDScript的语法差异

2. **缺少代码审查**：
   - 代码中的语法错误未在提交前被发现
   - 缺少自动化测试和语法检查

**修复方案**：
1. **替换错误处理语法**：
   ```gdscript
   # 从
   try:
       var resource = load(path)
       return resource
   except:
       print("Error loading resource")
       return null
       
   # 修改为
   if ResourceLoader.exists(path):
       var resource = load(path)
       return resource
   else:
       print("Error loading resource")
       return null
   ```

2. **添加资源存在性检查**：
   ```gdscript
   # 创建通用的资源加载函数
   func load_if_exists(path):
       if ResourceLoader.exists(path):
           return load(path)
       else:
           print("Resource does not exist: " + path)
           return null
   ```

**验证方法**：
1. 修改所有包含try-except的脚本文件
2. 运行游戏，确认控制台中不再出现语法错误
3. 测试资源加载功能，确认能够正确处理资源不存在的情况

**相关文件**：
- `scripts/game_scene.gd`
- `scripts/ui/dialogue_ui.gd`
- `scripts/ui/character_select.gd`
- `scripts/dialogue/dialogue_manager.gd`
- `scripts/core/background_manager.gd`

**教训与最佳实践**：
1. 熟悉目标语言的语法特性，避免混用不同语言的语法
2. 实现代码审查流程，确保提交前发现语法错误
3. 使用统一的错误处理模式，提高代码一致性
4. 为常用功能创建辅助函数，避免重复代码
5. 添加详细的错误日志，便于排查问题

**修复影响**：
解决了由于语法错误导致的功能失效问题，使游戏能够正确加载资源并处理错误情况。同时，提高了代码质量和可维护性，为未来的开发奠定了更好的基础。
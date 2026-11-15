# 动作示意素材

这些素材由同一工作区的 `bynd-app/src/animacoes/anatomia` 模型及绘制引擎生成，动作 ID 与原型目录一致。`*-still.webp` 是 200 像素的列表静态姿势；`*-still-hd.webp` 是 600 像素的详情静态姿势；`*-motion-hd.webp` 是按原型周期采样 24 帧的 600 像素循环动画。原型没有人体模型的动作保留通用图标回退。三个素材逐字节一致的动作通过别名共享文件，动作名称和图例仍各自保留。

素材用于界面演示，不代表用户动作捕捉或训练数据。更新原型模型后，应重新生成素材并检查 `exercise_anatomy_assets.dart` 的 ID 和图例。


重新生成时，需要 Node.js、`sharp` 以及启用了 WebP 的 Python Pillow。编码器会拒绝非空输出目录，请先使用空的临时目录生成和检查结果，再替换本目录与 `lib/features/activity/presentation/models/exercise_anatomy_assets.dart`：

```powershell
node tool/export_anatomy_frames.mjs <bynd-app目录> <临时帧目录> <sharp模块目录>
python tool/encode_exercise_anatomy.py <临时帧目录> <临时素材目录>
```

编码步骤会在指定输出目录删除本次生成且三种素材均一致的重复文件，不会删除其他文件；更新模型后应运行动作目录和多帧解码测试。

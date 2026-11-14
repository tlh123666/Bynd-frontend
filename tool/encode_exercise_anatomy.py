"""将原型人体帧编码为 Flutter 动作素材；需要支持 WebP 的 Pillow。"""
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import argparse
import hashlib
import json
import re

from PIL import Image


def encode(item, frames_dir, output_dir):
    """编码一项动作，保留原型默认姿势和 24 帧运动周期。"""
    exercise_id = item['id']
    with Image.open(frames_dir / f'{exercise_id}-0.png') as original:
        original.save(output_dir / f'{exercise_id}-still-hd.webp', 'WEBP', quality=95, method=4)
        thumbnail = original.copy()
        thumbnail.thumbnail((200, 1000), Image.Resampling.LANCZOS)
        thumbnail.save(output_dir / f'{exercise_id}-still.webp', 'WEBP', quality=86, method=4)
        thumbnail.close()
    frames = []
    try:
        for index in range(1, 25):
            with Image.open(frames_dir / f'{exercise_id}-{index}.png') as frame:
                frames.append(frame.convert('RGBA').copy())
        frames[0].save(
            output_dir / f'{exercise_id}-motion-hd.webp', 'WEBP',
            save_all=True, append_images=frames[1:],
            duration=max(20, round(item['duration'] * 1000 / 24)),
            loop=0, quality=95, method=4,
        )
    finally:
        for frame in frames:
            frame.close()
    for suffix in ('still-hd', 'motion-hd'):
        with Image.open(output_dir / f'{exercise_id}-{suffix}.webp') as result:
            if result.width != 600 or (suffix == 'motion-hd' and result.n_frames < 2):
                raise ValueError(f'动作素材无效：{exercise_id}-{suffix}')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('frames', type=Path, help='export_anatomy_frames.mjs 输出目录')
    parser.add_argument('output', type=Path, help='素材输出目录；建议使用空临时目录')
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    # 拒绝非空目录，避免覆盖已有文件或误删不属于本次生成的素材。
    if any(args.output.iterdir()):
        raise FileExistsError(f'输出目录必须为空：{args.output}')
    items = json.loads((args.frames / 'manifest.json').read_text(encoding='utf-8'))
    if not items:
        raise ValueError('动作清单为空')
    # 只允许原型的安全文件名，避免清单意外写出目标目录。
    if any(not re.fullmatch(r'[a-z0-9-]+', item['id']) for item in items):
        raise ValueError('动作清单含非法 ID')
    with ThreadPoolExecutor(max_workers=2) as pool:
        list(pool.map(lambda item: encode(item, args.frames, args.output), items))
    # 三种用途的文件均完全相同时才复用；保留每个动作自己的图例。
    groups = {}
    suffixes = ('still', 'still-hd', 'motion-hd')
    for item in items:
        signature = tuple(
            hashlib.sha256((args.output / f"{item['id']}-{suffix}.webp").read_bytes()).digest()
            for suffix in suffixes
        )
        groups.setdefault(signature, []).append(item['id'])
    aliases = {}
    for group in groups.values():
        canonical = min(group, key=lambda value: (len(value), value))
        for exercise_id in group:
            if exercise_id == canonical:
                continue
            aliases[exercise_id] = canonical
            for suffix in suffixes:
                duplicate = args.output / f'{exercise_id}-{suffix}.webp'
                original = args.output / f'{canonical}-{suffix}.webp'
                if duplicate.read_bytes() != original.read_bytes():
                    raise ValueError(f'动作素材不一致：{exercise_id}-{suffix}')
                duplicate.unlink()
    lines = ['// 由 bynd-app 的人体模型导出；未列出的动作使用原型默认回退图标。', 'const exerciseAnatomyLegends = <String, String>{']
    for item in items:
        name = json.dumps(item['id'], ensure_ascii=False).replace('$', r'\$')
        legend = json.dumps(item['legend'], ensure_ascii=False).replace('$', r'\$')
        lines.append(f'  {name}: {legend},')
    lines.extend(['};', '', '/// 原型中画面逐字节相同的动作，共用同一组资源；动作名称与图例仍独立。', 'const exerciseAnatomyAssetAliases = <String, String>{'])
    for exercise_id, canonical in sorted(aliases.items()):
        lines.append(f'  {json.dumps(exercise_id)}: {json.dumps(canonical)},')
    lines.extend(['};', '', '/// 通过稳定 ID 找到可复用的动画资源。', 'String exerciseAnatomyAssetId(String id) => exerciseAnatomyAssetAliases[id] ?? id;'])
    (args.output / 'exercise_anatomy_assets.dart').write_text('\n'.join(lines) + '\n', encoding='utf-8')
    print(f'已编码并校验 {len(items)} 个动作。')

"""Chapter 4 architecture diagrams."""
import os, sys
sys.path.insert(0, os.path.dirname(__file__))
from svgkit import *
OUT = os.path.join(os.path.dirname(__file__), "../../template/fig/")

# ---------------------------------------------------------------- ladder
W, H = 860, 640
s = [header(W, H)]
s.append(dot(26, 28))
for x in (250, 500, 750):
    s.append(tick(x, 16))

s.append(band3(20, 44, 820, "01", "训练族内的十二偏移增强", [
    ("整曲平移", "p ← p+k，k∈[−5,6]\n结构与时值不变"),
    ("去重审计", "425,304 次呈现\n232,278 个唯一事件"),
    ("增强池", "35,442 条记录\n78,028,625 个目标")]
))
s.append(band3(20, 230, 820, "02", "六档非嵌入参数梯队", [
    ("Nano / Mini / Base", "0.20M · 1.19M\n14.20M"),
    ("Medium / Large", "25.22M\n85.06M"),
    ("XL", "302.31M\n整档留出")]
))
s.append(band(20, 416, 400, 190, "03", "训练与恢复"))
s.append(band(440, 416, 400, 190, "04", "预测与条件干预"))
for i, (t, sub) in enumerate([("原生 FP32 训练", "16N 字节静态显存"),
                              ("完整状态持久化", "权重＋动量＋RNG")]):
    s.append(card(40, 478 + i * 60, 360, 52, t, sub, size=14.5, sub_size=11.8))
for i, (t, sub) in enumerate([("容量留出预测", "参数＋目标联合拟合"),
                              ("前缀配对与 SSM", "同提示两条件")]):
    s.append(card(460, 478 + i * 60, 360, 52, t, sub, size=14.5, sub_size=11.8))
s.append(elbow(430, 214, 430, 226, mid=220))
s.append(elbow(430, 400, 220, 412, mid=406))
s.append(elbow(430, 400, 640, 412, mid=406))
s.append(footer())
open(OUT + "arch-ch4-ladder.svg", "w").write("".join(s))

# ---------------------------------------------------------------- transpose
W, H = 860, 470
s = [header(W, H)]
s.append(label(430, 30, "十二平均律平移：音级循环、音程守恒", size=16, fill=INK, weight="700"))

notes = [0, 2, 4, 5, 7, 4, 2, 0]
rows = [(150, 0, "原始旋律", LINE), (300, 5, "整体 +5 半音", ACCENT)]
for y0, shift, title, colour in rows:
    s.append(label(52, y0 - 46, title, size=13, fill=INK, anchor="start", weight="600"))
    for i, p in enumerate(notes):
        x = 130 + i * 92
        yy = y0 - (p + shift) * 2.6 + 30
        s.append(f'<rect x="{x-17}" y="{yy-18}" width="34" height="36" rx="3" '
                 f'fill="white" stroke="{colour}" stroke-width="1.7"/>')
        s.append(label(x, yy + 6, str(p + shift), size=13, fill=INK if shift else MUTED))
    for i in range(len(notes) - 1):
        x1, x2, yb = 130 + i * 92, 130 + (i + 1) * 92, y0 + 46
        s.append(f'<line x1="{x1}" y1="{yb}" x2="{x2}" y2="{yb}" stroke="{ARROW}" stroke-width="0.9"/>')
        s.append(f'<line x1="{x1}" y1="{yb-4}" x2="{x1}" y2="{yb+4}" stroke="{ARROW}" stroke-width="0.9"/>')
        s.append(f'<line x1="{x2}" y1="{yb-4}" x2="{x2}" y2="{yb+4}" stroke="{ARROW}" stroke-width="0.9"/>')
        s.append(label((x1 + x2) / 2, yb + 16, f"+{notes[i+1]-notes[i]}", size=11))
for i in (0, 3, 7):
    x = 130 + i * 92
    s.append(f'<line x1="{x}" y1="196" x2="{x}" y2="272" stroke="{ACCENT}" stroke-width="1.1" '
             f'stroke-dasharray="5 5" marker-end="url(#ah)"/>')
s.append(label(430, 418, "Δp 逐项相同，旋律轮廓与调式关系不变；时值由独立的 d 承载，每小节严格守恒", size=12.5, fill=ACCENT))
s.append(label(430, 446, "逐音八度折叠会破坏等距性，因此采用整曲平移", size=11.5))
s.append(footer())
open(OUT + "arch-ch4-transpose.svg", "w").write("".join(s))

# ---------------------------------------------------------------- prefix
W, H = 860, 300
s = [header(W, H)]
s.append(label(430, 32, "前缀条件生成的配对协议", size=16, fill=INK, weight="700"))
s.append(card(30, 66, 210, 74, "自由条件", "仅元数据", size=14.5, sub_size=12))
s.append(card(30, 168, 210, 74, "前缀条件", "真实前四小节", size=14.5, sub_size=12))
s.append(card(300, 116, 210, 74, "生成八小节", "种子 42 检查点", size=14.5, sub_size=12))
s.append(card(570, 116, 260, 74, "只评分后四小节", "音级 / 起音相似度", size=14.5, sub_size=12))
s.append(arrow(242, 103, 296, 140))
s.append(arrow(242, 205, 296, 168))
s.append(arrow(512, 153, 566, 153))
s.append(label(430, 262, "族内配对重采样 10,000 次，排除提示本身", size=12))
s.append(footer())
open(OUT + "arch-ch4-prefix.svg", "w").write("".join(s))
print("ch4 diagrams")

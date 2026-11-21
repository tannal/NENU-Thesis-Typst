"""Chapter 2 concept diagrams."""
import os, sys
sys.path.insert(0, os.path.dirname(__file__))
from svgkit import *
OUT = os.path.join(os.path.dirname(__file__), "../../template/fig/")

# ---------------------------------------------------------------- ABC anatomy
W, H = 860, 400
s = [header(W, H)]
s.append(label(430, 30, "ABC 记谱法的四层语义结构", size=16, fill=INK, weight="700"))

# header block
s.append(f'<rect x="30" y="56" width="300" height="176" rx="4" fill="white" stroke="{LINE}"/>')
s.append(label(48, 82, "谱头元数据", size=13, fill=INK, anchor="start", weight="600"))
for i, (k, v, note) in enumerate([("X:", "1", "曲目索引"), ("T:", "The Maid", "标题"),
                                  ("M:", "6/8", "拍号"), ("L:", "1/8", "单位时值"), ("K:", "G", "调号")]):
    y = 110 + i * 24
    s.append(label(56, y, k, size=12.5, fill=ACCENT, anchor="start", weight="700"))
    s.append(label(80, y, v, size=12.5, fill=INK, anchor="start"))
    s.append(label(310, y, note, size=11, fill=MUTED, anchor="end"))

# body
s.append(f'<rect x="360" y="56" width="470" height="176" rx="4" fill="white" stroke="{LINE}"/>')
s.append(label(378, 82, "乐谱正文", size=13, fill=INK, anchor="start", weight="600"))
tokens = [("G2", "音名＋时值"), ("A", "音名"), ("^c", "升号＋音名"), ("B", "音名"),
          ("|", "小节线"), (":|", "反复记号")]
for i, (t, note) in enumerate(tokens):
    x = 390 + i * 72
    s.append(f'<rect x="{x}" y="100" width="56" height="34" rx="3" fill="white" stroke="{ACCENT}"/>')
    s.append(label(x + 28, 122, t, size=13, fill=ACCENT, weight="600"))
    s.append(label(x + 28, 152, note, size=9.5))
s.append(label(378, 186, "音高轴：A–G ＋ 八度撇逗 ＋ 升降号", size=11, fill=MUTED, anchor="start"))
s.append(label(378, 206, "时间轴：时值后缀（2, /2）与 M/L 联合决定小节容量", size=11, fill=MUTED, anchor="start"))

# four layers
layers = [("元数据层", "调式 / 拍号 / 速度"), ("音高轴", "半音离散标量"),
          ("时间轴", "有理数时值"), ("结构层", "小节线 / 反复")]
bw = 190
for i, (t, sub) in enumerate(layers):
    x = 30 + i * (bw + 20)
    s.append(card(x, 270, bw, 70, t, sub, size=13.5, sub_size=11))
s.append(label(430, 372, "四层同时约束生成：文本合法不等于时值合法", size=12))
s.append(footer())
open(OUT + "fig-abc-structure.svg", "w").write("".join(s))

# ---------------------------------------------------------------- RNN unrolled
W, H = 860, 330
s = [header(W, H)]
s.append(label(430, 30, "循环网络的展开与梯度连乘", size=16, fill=INK, weight="700"))
xs = [110, 330, 550]
for i, x in enumerate(xs):
    s.append(card(x, 70, 100, 58, f"h_{i+1}", f"时刻 {i+1}", size=14, sub_size=11))
if True:
    s.append(card(xs[0]-92, 70, 76, 58, "x", "输入", size=13, sub_size=10.5))
for i in range(2):
    s.append(arrow(xs[i] + 102, 99, xs[i+1] - 4, 99))

s.append(label(430, 160, "跨距 Δt 的状态雅可比连乘：", size=12.5, fill=INK))

# decay curve
import math
pts = []
for i in range(0, 61):
    t = i / 60
    v = 0.5 + 0.5 * math.exp(-3.2 * t)
    pts.append(f"{60 + t*700:.1f},{300 - v*60:.1f}")
s.append(f'<polyline points="{" ".join(pts)}" fill="none" stroke="{ACCENT}" stroke-width="2"/>')
s.append(f'<line x1="60" y1="300" x2="770" y2="300" stroke="{LINE}" stroke-width="1"/>')
s.append(f'<line x1="60" y1="300" x2="60" y2="222" stroke="{LINE}" stroke-width="1"/>')
s.append(label(70, 222, "‖∂h_t/∂h_k‖", size=11, fill=MUTED, anchor="start"))
s.append(label(760, 322, "时序跨度", size=11, fill=MUTED, anchor="end"))
s.append(label(430, 250, "谱半径 < 1 时梯度上界随跨度衰减", size=12, fill=ACCENT))
s.append(footer())
open(OUT + "fig-rnn-unrolled.svg", "w").write("".join(s))

# ---------------------------------------------------------------- LSTM cell
W, H = 860, 320
s = [header(W, H)]
s.append(label(430, 30, "LSTM 的门控与加性细胞状态", size=16, fill=INK, weight="700"))
s.append(f'<rect x="210" y="66" width="440" height="170" rx="8" fill="white" stroke="{LINE}" stroke-width="1.6"/>')
s.append(label(430, 92, "细胞状态 c_t", size=13, fill=ACCENT, weight="600"))
s.append(card(232, 108, 96, 44, "遗忘门 f", "σ", size=12.5, sub_size=11))
s.append(card(340, 108, 96, 44, "输入门 i", "σ", size=12.5, sub_size=11))
s.append(card(448, 108, 96, 44, "候选 g", "tanh", size=12.5, sub_size=11))
s.append(card(556, 108, 72, 44, "输出门 o", "σ", size=12, sub_size=10.5))
s.append(card(300, 176, 260, 44, "c ← f ⊙ c + i ⊙ g", "加性更新", size=13, sub_size=11))
s.append(arrow(430, 152, 430, 172))
s.append(arrow(100, 151, 208, 151))
s.append(label(104, 143, "x_t", size=12, fill=MUTED, anchor="start"))
s.append(arrow(652, 151, 760, 151))
s.append(label(766, 155, "h_t", size=12, fill=MUTED, anchor="start"))
s.append(label(430, 272, "遗忘门偏置 +1：直接通路的局部导数为 diag(f_t)，接近 1 时衰减最小", size=12))
s.append(footer())
open(OUT + "fig-lstm-gate.svg", "w").write("".join(s))

# ---------------------------------------------------------------- causal mask
W, H = 860, 330
s = [header(W, H)]
s.append(label(430, 30, "因果自注意力的可见性结构", size=16, fill=INK, weight="700"))
x0, y0, cell = 250, 66, 26
for i in range(8):
    for j in range(8):
        visible = j <= i
        fill = ACCENT if visible else "white"
        op = "0.85" if visible else "1"
        s.append(f'<rect x="{x0+j*cell}" y="{y0+i*cell}" width="{cell-1.5}" height="{cell-1.5}" '
                 f'fill="{fill}" fill-opacity="{op}" stroke="{LINE}" stroke-width="0.5"/>')
s.append(label(x0 + 4*cell, y0 - 10, "键（历史位置）", size=11.5))
s.append(f'<text x="{x0-14}" y="{y0+4*cell}" font-size="11.5" fill="{MUTED}" text-anchor="middle" transform="rotate(-90 {x0-14} {y0+4*cell})">查询</text>')
s.append(label(620, 118, "可见区", size=12, fill=ACCENT, anchor="start", weight="600"))
s.append(label(620, 140, "j ≤ i：前缀可读", size=11, fill=MUTED, anchor="start"))
s.append(label(620, 170, "掩码区", size=12, fill=INK, anchor="start", weight="600"))
s.append(label(620, 192, "j > i：禁止访问", size=11, fill=MUTED, anchor="start"))
s.append(label(430, 306, "softmax 只在合法前缀上归一化；图路径长度不随距离增长", size=12))
s.append(footer())
open(OUT + "fig-attention-mask.svg", "w").write("".join(s))

# ---------------------------------------------------------------- LoRA
W, H = 860, 300
s = [header(W, H)]
s.append(label(430, 30, "LoRA 的低秩旁路", size=16, fill=INK, weight="700"))
s.append(card(80, 76, 220, 66, "冻结权重 W", "d × d，不更新", size=14, sub_size=11.5))
s.append(card(430, 60, 190, 50, "A：d × r", "可训练", size=13, sub_size=11))
s.append(card(430, 122, 190, 50, "B：r × d", "可训练，零初始化", size=13, sub_size=11))
s.append(card(690, 90, 140, 66, "相加", "W x + BAx", size=13, sub_size=11))
s.append(arrow(302, 109, 426, 85))
s.append(arrow(302, 109, 426, 147))
s.append(arrow(622, 85, 686, 108))
s.append(arrow(622, 147, 686, 124))
s.append(label(430, 214, "r ≪ d：可训练参数由 d² 降至 2dr", size=13, fill=ACCENT, weight="600"))
s.append(label(430, 240, "d = 4096、r = 16 时由 1.68×10⁷ 降至 1.31×10⁵，压缩约 128 倍", size=12))
s.append(footer())
open(OUT + "fig-lora.svg", "w").write("".join(s))
print("ch2 diagrams")

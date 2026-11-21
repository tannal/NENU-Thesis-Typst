"""Chapter 3 architecture diagrams."""
import os, sys
sys.path.insert(0, os.path.dirname(__file__))
from svgkit import *
OUT = os.path.join(os.path.dirname(__file__), "../../template/fig/")

# ---------------------------------------------------------------- system
W, H = 860, 640
s = [header(W, H)]
s.append(dot(26, 28))
for x in (250, 500, 750):
    s.append(tick(x, 16))

s.append(band3(20, 44, 820, "01", "数据划分与词表学习", [
    ("事件级去重", "45,850 → 44,304\n拒绝原因留档"),
    ("旋律族隔离", "22,011 族，8:1:1\n族间无交集"),
    ("训练族内建词表", "Char 43 · BPE 256\nMusical 118")]
))
s.append(band3(20, 230, 820, "02", "同构解码器训练", [
    ("四种拓扑", "RNN · LSTM\nPost-LN · GPT2ABC"),
    ("原生 CUDA 引擎", "cuBLAS GEMM\n融合 Softmax"),
    ("50 轮完整遍历", "种子 42/43/44\n验证选模")]
))
# bottom: two half-width bands
def half(y, x, num, title, items):
    out = [band(x, y, 400, 190, num, title)]
    for i, (t, sub) in enumerate(items):
        out.append(card(x + 20, y + 62 + i * 60, 360, 52, t, sub, size=14.5, sub_size=11.8))
    return "".join(out)
s.append(half(416, 20, "03", "预测性能", [
    ("测试集 NLL / PPL", "验证最优检查点，三种子"),
    ("Top-1 / Top-5 准确率", "805,328 个有效目标")]))
s.append(half(416, 440, "04", "生成与资源", [
    ("无修复采样", "τ=0.85，Top-p=0.95，3,000 次"),
    ("九维特征 · 显存 · 延迟", "条件于八小节可用窗口")]))
s.append(elbow(430, 214, 430, 226, mid=220))
s.append(elbow(430, 400, 220, 412, mid=406))
s.append(elbow(430, 400, 640, 412, mid=406))
s.append(footer())
open(OUT + "arch-ch3-system.svg", "w").write("".join(s))

# ---------------------------------------------------------------- decoder block
W, H = 860, 300
s = [header(W, H)]
s.append(label(430, 34, "GPT2ABC 解码块（重复 12 层，d=256，h=8，9,573,376 参数）", size=15, fill=INK, weight="700"))
blocks = [("词元嵌入", "＋位置嵌入"), ("Pre-LN → MHA", "＋残差"), ("Pre-LN → FFN", "＋残差"),
          ("LayerNorm", "共享分类头"), ("Softmax", "118 类")]
cw, gap = 148, 18
x0 = (W - (cw * 5 + gap * 4)) / 2
for i, (t, sub) in enumerate(blocks):
    x = x0 + i * (cw + gap)
    s.append(card(x, 150, cw, 76, t, sub, size=14, sub_size=11.5))
    if i:
        s.append(arrow(x - gap + 1, 188, x - 3, 188))
s.append(f'<path d="M {x0+74} 150 C {x0+74} 96, {x0+4*(cw+gap)+74} 96, {x0+4*(cw+gap)+74} 148" '
         f'fill="none" stroke="{ACCENT}" stroke-width="1.5" stroke-dasharray="6 4" marker-end="url(#ah)"/>')
s.append(label(430, 104, "残差与恒等路径", size=12, fill=ACCENT))
s.append(label(430, 264, "训练目标：掩码交叉熵，屏蔽 PAD 与重叠前缀，保留 EOS", size=12))
s.append(footer())
open(OUT + "arch-ch3-decoder.svg", "w").write("".join(s))

# ---------------------------------------------------------------- tokenizer
W, H = 860, 340
s = [header(W, H)]
s.append(label(430, 32, "字符边界与音乐事实边界的错位", size=16, fill=INK, weight="700"))
s.append(card(30, 62, 380, 96, "字符级切分", "^  ,  g  2  |  :\n单音符被拆成 4–6 个孤立字符", size=14.5, sub_size=12))
s.append(card(450, 62, 380, 96, "ABCTokenizer", "^g2    |:    :|\n修饰音级与复合节拍成为原子词元", size=14.5, sub_size=12))

y = 218
for i, c in enumerate(["^", "g", "2", "|", ":"]):
    x = 60 + i * 62
    s.append(f'<rect x="{x}" y="{y}" width="50" height="42" rx="3" fill="white" stroke="{LINE}"/>')
    s.append(label(x + 25, y + 28, c, size=17, fill=INK, weight="600"))
s.append(label(230, 296, "字符级：5 个词元", size=12))

for i, c in enumerate(["^g2", "|:"]):
    x = 520 + i * 110
    s.append(f'<rect x="{x}" y="{y}" width="98" height="42" rx="3" fill="white" stroke="{ACCENT}" stroke-width="1.8"/>')
    s.append(label(x + 49, y + 28, c, size=17, fill=ACCENT, weight="600"))
s.append(label(660, 296, "乐理词法：2 个词元", size=12))
s.append(footer())
open(OUT + "arch-ch3-tokenizer.svg", "w").write("".join(s))
print("ch3 diagrams")

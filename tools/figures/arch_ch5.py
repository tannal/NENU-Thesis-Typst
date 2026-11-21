"""Chapter 5 outlook diagram."""
import os, sys
sys.path.insert(0, os.path.dirname(__file__))
from svgkit import *
OUT = os.path.join(os.path.dirname(__file__), "../../template/fig/")

W, H = 860, 480
s = [header(W, H)]
s.append(label(430, 30, "从当前基座到后续研究的四条路径", size=16, fill=INK, weight="700"))

# central base
s.append(card(300, 56, 260, 62, "本章基座", "9.57M GPT2ABC · 六档梯队", size=14.5, sub_size=11.5))

paths = [
    (40, 176, "容量前沿", "固定计算预算\n搜索 N 与 D 的最优配比", ACCENT),
    (245, 176, "表示与时间", "相对音程 / 均匀时间步\n匹配音乐时间跨度", LINE),
    (450, 176, "条件与结构", "远距前缀扰动\n宏观曲式规划", LINE),
    (655, 176, "人耳与场景", "盲测听评 · 跨域迁移\n边缘部署", LINE),
]
for x, y, t, sub, col in paths:
    s.append(card(x, y, 170, 96, t, sub, size=13.5, sub_size=11))
    s.append(f'<path d="M 430 120 L {x+85} 120 L {x+85} 172" fill="none" stroke="{ARROW}" '
             f'stroke-width="1.3" marker-end="url(#ah)"/>')
s.append(f'<line x1="122" y1="120" x2="742" y2="120" stroke="{ARROW}" stroke-width="1.3"/>')

for i, (t, sub) in enumerate([("固定预算实验", "同计算量下比较容量"),
                              ("匹配时间表示", "按小节而非词元对齐"),
                              ("可证伪的结构", "顺序扰动与主题保持"),
                              ("可复现的听评", "受试者 · 盲测 · 统计")]):
    s.append(card(40 + i * 205, 320, 180, 84, t, sub, size=13, sub_size=10.8))
    s.append(f'<line x1="{40 + i*205 + 90}" y1="276" x2="{40 + i*205 + 90}" y2="316" '
             f'stroke="{ARROW}" stroke-width="1.2" stroke-dasharray="4 4" marker-end="url(#ah)"/>')
s.append(label(430, 448, "四条路径共享同一评价口径：可复查的协议、原始输出与分层不确定性", size=12))
s.append(footer())
open(OUT + "fig-outlook.svg", "w").write("".join(s))
print("ch5 diagram")

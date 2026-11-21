"""Wide diagrams tailored to 16:9 slides."""
import os, sys
sys.path.insert(0, os.path.dirname(__file__))
from svgkit import *
OUT = os.path.join(os.path.dirname(__file__), "../../slides/figures/")

# wide 3-step flow
W, H = 1200, 300
s = [header(W, H)]
steps = [("事件去重", "45,850 → 44,304\n拒绝原因逐条留档"),
         ("旋律族隔离", "22,011 族，8:1:1\n族间交集为零"),
         ("训练族内建词表", "Char 43 · BPE 256\nMusical 118")]
bw, gap = 340, 60
x0 = (W - bw * 3 - gap * 2) / 2
for i, (t, sub) in enumerate(steps):
    x = x0 + i * (bw + gap)
    s.append(card(x, 70, bw, 110, t, sub, size=21, sub_size=16))
    if i:
        s.append(arrow(x - gap + 6, 125, x - 6, 125))
s.append(label(600, 232, "词表只学训练族；验证集选模；测试集只报告一次", size=17, fill=MUTED))
s.append(footer())
open(OUT + "slide-flow.svg", "w").write("".join(s))

# wide tokenizer contrast
W, H = 1200, 300
s = [header(W, H)]
s.append(card(50, 60, 480, 120, "字符级切分", "^  ,  g  2  |  :   →  5 个词元\n语义密度低，序列被拉长", size=20, sub_size=15))
s.append(card(670, 60, 480, 120, "ABCTokenizer", "^g2   |:   :|   →  2 个词元\n边界完整，逐字可逆", size=20, sub_size=15))
s.append(label(600, 232, "K = 4 贪婪最长匹配 + 字符回退，O(C)", size=17, fill=ACCENT, weight="600"))
s.append(footer())
open(OUT + "slide-tokenizer.svg", "w").write("".join(s))

# wide ladder
W, H = 1200, 280
s = [header(W, H)]
tiers = [("Nano", "0.20M"), ("Mini", "1.19M"), ("Base", "14.20M"),
         ("Medium", "25.22M"), ("Large", "85.06M"), ("XL", "302.31M")]
bw, gap = 150, 36
x0 = (W - bw * 6 - gap * 5) / 2
for i, (t, p) in enumerate(tiers):
    x = x0 + i * (bw + gap)
    col = ACCENT if i == 5 else LINE
    s.append(card(x, 100, bw, 84, t, p + " 参数", size=20, sub_size=15))
    if i:
        s.append(arrow(x - gap + 4, 142, x - 4, 142))
s.append(label(600, 62, "非嵌入参数横跨近三个数量级，统一 Pre-LN 与 T = 256", size=17, fill=INK))
s.append(label(600, 226, "XL 整档留出：不参与拟合，只用于检验预测", size=16, fill=MUTED))
s.append(footer())
open(OUT + "slide-ladder.svg", "w").write("".join(s))
print("slide diagrams")

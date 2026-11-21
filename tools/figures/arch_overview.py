"""Fig 1.1 — overall research roadmap (SVG, hand-laid out)."""
import os, sys
sys.path.insert(0, os.path.dirname(__file__))
from svgkit import *
OUT = os.path.join(os.path.dirname(__file__), "../../template/fig/")

W, H = 860, 790
s = [header(W, H)]
s.append(dot(26, 28))
for x in (250, 500, 750):
    s.append(tick(x, 16))

s.append(band3(20, 44, 820, "01", "数据构建与规范化", [
    ("公开语料", "folk-rnn v3\n45,850 条"),
    ("语义去重", "绝对事件去重\n44,304 条"),
    ("旋律族隔离", "轮廓键聚类\n22,011 族")]
))
s.append(band3(20, 230, 820, "02", "乐理分词与可逆编码", [
    ("字符级 / BPE-256", "词表 43 / 256\n通用合并基线"),
    ("ABCTokenizer", "最长匹配 K=4\n词表 118"),
    ("逐字可逆校验", "往返恒等\nOOV = 0")]
))
s.append(band3(20, 416, 820, "03", "自回归建模与规模扩展", [
    ("四种基准架构", "RNN · LSTM\nPost-LN · GPT2ABC"),
    ("六档容量梯队", "0.20M → 302M\n非嵌入参数"),
    ("十二半音增强", "整曲平移\n音程与时值守恒")]
))
s.append(band3(20, 602, 820, "04", "多维评价与条件生成", [
    ("统计学习层", "NLL · PPL · BPC\nTop-k 准确率"),
    ("音乐事件层", "覆盖率 · 九维特征"),
    ("条件与资源", "前缀配对 · 显存延迟")]
))
s.append(elbow(430, 214, 430, 226, mid=220))
s.append(elbow(430, 400, 430, 412, mid=406))
s.append(elbow(430, 586, 430, 598, mid=592))
s.append(footer())
open(OUT + "arch-overview.svg", "w").write("".join(s))
print("overview")

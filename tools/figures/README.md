# 图表生成

本目录包含论文与幻灯片的全部图件源码。约定如下：

- **架构图**：手绘 SVG，由 `svgkit.py` 提供的图元（编号色带、卡片、箭头）拼装，
  坐标显式给出，不依赖数据。对应脚本 `arch_overview.py`、`arch_ch2.py`、
  `arch_ch3.py`、`arch_ch4.py`、`arch_ch5.py`、`arch_slides.py`。
- **数据图表**：matplotlib 绘制，读取 `abc_ai_paper_writing` 数据包中的 CSV/JSON，
  统一配色与字号见 `chartstyle.py`。对应脚本 `charts_ch3.py`、`charts_ch4.py`。

## 重新生成

```bash
python3 tools/figures/arch_overview.py     # 第 1 章路线图
python3 tools/figures/arch_ch2.py          # 第 2 章概念图
python3 tools/figures/arch_ch3.py          # 第 3 章系统/解码块/分词
python3 tools/figures/arch_ch4.py          # 第 4 章梯队/平移/前缀
python3 tools/figures/arch_ch5.py          # 第 5 章展望
python3 tools/figures/arch_slides.py       # 幻灯片宽版

python3 -m venv .venv && .venv/bin/pip install matplotlib numpy
.venv/bin/python tools/figures/charts_ch3.py
.venv/bin/python tools/figures/charts_ch4.py
```

数据路径在 `charts_ch*.py` 顶部的 `D` 常量中，指向写作资料包的 `data/` 目录。

## 设计约定

| 元素 | 取值 |
|---|---|
| 主色（强调） | `#0f766e` |
| 正文墨色 | `#1f2933` |
| 次要文字 | `#6b7a8f` |
| 网格 | `#e8eef5`，20pt 间隔 |
| 卡片描边 | `#3c4a5a`，1.1pt |
| 色板 | teal / amber / purple / slate / gray / red |

画布宽度控制在 860 左右，使正文 14–16cm 宽度下字号约为 7–9pt。

#import "@preview/touying:0.5.3": *
#import themes.university: *
#import "@preview/lilaq:0.2.0" as lq

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [基于自回归架构的 ABC 音乐生成],
    subtitle: [表示效率 · 架构基准 · 规模规律 · 条件可控],
    author: [谭盟　指导教师：杨贵福 教授],
    date: [东北师范大学　2026 年 11 月],
  ),
)

#set text(font: ("Noto Sans CJK SC", "Liberation Sans"), lang: "zh")
#show raw: set text(font: ("DejaVu Sans Mono", "Liberation Mono"), size: .8em)

#let accent = rgb("#0f766e")
#let muted = rgb("#6b7a8f")

#let kpi(value, label) = block(inset: (x: 8pt, y: 4pt), radius: 4pt, fill: rgb("#f4f8f7"))[
  #text(size: 1.55em, weight: "bold", fill: accent)[#value] \
  #text(size: .72em, fill: muted)[#label]
]

#let note(body) = block(below: 0pt, inset: (x: 6pt, y: 4pt), radius: 3pt,
  stroke: (left: 2.2pt + accent), fill: rgb("#f7fafa"))[
  #text(size: .8em)[#body]
]

#title-slide()

== 一页看懂全文

#grid(columns: (1.02fr, 1fr), column-gutter: 1.4em,
  [
    #set text(size: .92em)
    *问题*：在数万首民谣、百余个离散原语的条件下，音乐生成能否做到可复查、可外推、可解释？

    #v(.7em)
    *做法*：事件级语料 → 乐理分词 → 四架构基准 → 六档容量 → 移调增强 → 前缀条件

    #v(.7em)
    #note[每一层结论都绑定到可重新执行的过程：划分、词表、检查点、采样、区间。]
  ],
  [
    #grid(columns: (1fr, 1fr), gutter: .8em,
      kpi[44,304][去重后记录],
      kpi[22,011][保守旋律族],
      kpi[118][乐理词表],
      kpi[9.57M][GPT2ABC 参数],
      kpi[302M][XL 容量上限],
      kpi[0.8571][最优测试 NLL],
    )
  ]
)

== 数据与表示

#image("figures/slide-flow.svg", width: 94%)

#v(.4em)
#grid(columns: (1fr, 1fr), column-gutter: 2em,
  [
    #set text(size: .78em)
    - 以绝对音高与时值事件去重，避免移调副本跨集泄露
    - 轮廓键把记录聚为 22,011 族，8:1:1 划分
  ],
  [
    #set text(size: .78em)
    - 词表只在训练族内建立
    - 族交集为零，是全部结论的共同前提
  ]
)

== 乐理分词：为什么不直接用 BPE

#image("figures/slide-tokenizer.svg", width: 94%)

#v(.4em)
#set text(size: .78em)
- `^g2`、`|:` 这类复合符号是乐理的最小语义单元，BPE 按字频合并会跨越小节线
- ABCTokenizer 以 K=4 的最长匹配保留词法边界，逐字可逆，OOV 为 0

== 分词效率：压缩与编码是两个方向

#image("figures/chart-ch3-tokenizer-tradeoff.svg", width: 84%)

#note[BPE 压缩比最高（2.79 字符/词元），但每字符编码成本也最高（0.7531 bpc）；乐理词法以 1.77 的压缩比取得 0.7037 bpc 的最优值。]

== 四类架构的独立测试

#grid(columns: (1.12fr, 1fr), column-gutter: 1.1em,
  [
    #image("figures/chart-ch3-arch-learning.svg", width: 100%)
  ],
  [
    #set text(size: .82em)
    #table(
      columns: 3, stroke: none, inset: 5pt,
      table.hline(stroke: 1.4pt),
      [*模型*], [*NLL*], [*PPL*],
      table.hline(stroke: .8pt),
      [RNN], [1.3722], [3.9439],
      [LSTM], [1.1609], [3.1930],
      [Post-LN], [0.8955], [2.4486],
      [*GPT2ABC*], [*0.8571*], [*2.3562*],
      table.hline(stroke: 1.4pt),
    )
    #v(.5em)
    验证最优检查点；GPT2ABC 为 Pre-LN + 权重绑定。
  ]
)

== 过拟合：末轮权重会骗人

#grid(columns: (1fr, 1fr), column-gutter: 1.1em,
  [
    #set text(size: .84em)
    #table(
      columns: 3, stroke: none, inset: 4.5pt,
      table.hline(stroke: 1.4pt),
      [*模型*], [*Best*], [*Final*],
      table.hline(stroke: .8pt),
      [RNN], [1.3722], [1.3728],
      [LSTM], [1.1609], [1.3029],
      [Post-LN], [0.8955], [3.4649],
      [GPT2ABC], [0.8571], [3.1314],
      table.hline(stroke: 1.4pt),
    )
  ],
  [
    #set text(size: .84em)
    - 最优检查点分别出现在第 49、16、12、8 轮
    - 继续训练使训练族 NLL 下降，测试 NLL 却大幅回升
    - 结论：以独立验证集保存最优检查点
  ]
)

== 生成可靠性

#image("figures/chart-ch3-coverage.svg", width: 84%)
#v(-.2em)
#align(center)[#text(size: .74em, fill: muted)[无修复、不拒绝重采样；差异主要出现在八小节覆盖率与小节时值一致性上]]

== 转向规模：六档梯队

#image("figures/slide-ladder.svg", width: 94%)

#v(.4em)
#grid(columns: (1fr, 1fr), column-gutter: 2em,
  [
    #set text(size: .78em)
    - 统一 Pre-LN、权重共享、$T = 256$，三种子训练
    - 增强池：35,442 条 → 425,304 次呈现
  ],
  [
    #set text(size: .78em)
    - 78.0M 评分目标；45.4% 的呈现与既有事件序列重复
    - XL 整档留出，只用于检验预测
  ]
)

== 容量实验

#v(-.2em)
#image("figures/chart-ch4-capacity.svg", width: 68%)
#v(.2em)
#grid(columns: (1fr, 1fr), column-gutter: 2em,
  [
    #set text(size: .76em)
    - 测试 NLL：1.7166 → 0.8567
    - Medium 0.8871 优于 Large 0.9217
  ],
  [
    #set text(size: .76em)
    - 共同目标数 15/20/25M 对齐后，容量效应清晰分层
    - XL 在 25M 目标处取得最小 0.9651
  ]
)

== XL 整档留出：容量信息有用吗？

#v(-.2em)
#image("figures/chart-ch4-forecast.svg", width: 86%)
#v(.2em)
#grid(columns: (1fr, 1fr), column-gutter: 2em,
  [
    #set text(size: .76em)
    - 拟合范围内 RMSE 降低 39.4%
    - 全部留出点降低 8.0%
  ],
  [
    #set text(size: .76em)
    - 标度指数 α = 0.248（自然语言约 0.076）
    - 渐近截距 0.380；85M 之后收益快速衰减
  ]
)

== 移调增强：代数证明 + 代价

#v(-.2em)
#image("figures/chart-ch4-augmentation.svg", width: 86%)
#v(.2em)
#grid(columns: (1fr, 1fr), column-gutter: 2em,
  [
    #set text(size: .76em)
    - 整体平移：音程逐项相等，小节时值严格守恒
    - 逐音八度折叠破坏等距性，因此不采用
  ],
  [
    #set text(size: .76em)
    - 域内 NLL 上升 0.1120
    - +5 半音压力 NLL 下降 0.1038
  ]
)

== 双轨评价：似然与音乐不同步

#image("figures/chart-ch4-music.svg", width: 70%)
#v(-.2em)
#align(center)[#text(size: .74em, fill: muted)[XL 的独特音级 6.41 逼近参照 6.74，音域 14.27 半音低于参照 15.51]]

== 前缀条件生成

#grid(columns: (1.02fr, 1fr), column-gutter: 1.1em,
  [
    #image("figures/arch-ch4-prefix.svg", width: 100%)
    #image("figures/chart-ch4-prefix.svg", width: 100%)
  ],
  [
    #set text(size: .84em)
    - 同提示配对：自由 vs 前缀，只评分后四小节
    - 音级相似度 0.440 → 0.935（GPT2ABC）
    - 族 bootstrap 95% 区间 [0.4355, 0.5533]，远离零
    - 三个模型方向一致，音级响应约为起音的三倍
  ]
)

== 续写内部有什么结构

#image("figures/chart-ch4-ssm.svg", width: 62%)
#v(-.2em)
#align(center)[#text(size: .74em, fill: muted)[同一提示，仅取生成后八小节；前缀条件下出现更清晰的对角带状结构]]

== 结论

#set text(size: .92em)

- *表示*：乐理分词在固定路径 BPC 上最优（0.7037），但不保证小节时值合法
- *架构*：GPT2ABC 取得最低测试 NLL（0.8571），增益属于 Pre-LN 与权重绑定的组合配置
- *规模*：联合模型可预测未见容量，$alpha = 0.248$；85M 之后边际收益快速衰减
- *数据*：移调增强改善压力测试，代价是域内拟合
- *条件*：前缀显著约束续写的音级与节奏特征
- *边界*：单一民谣来源、256 词元上下文、三个训练种子

#v(.1em)
#align(center)[#text(size: 1.2em, weight: "bold", fill: accent)[谢谢]]

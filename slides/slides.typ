#import "@preview/touying:0.5.3": *
#import themes.university: *
#import "@preview/lilaq:0.2.0" as lq

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [基于自回归架构的 ABC 音乐生成],
    subtitle: [从架构基准到扩展定律与受控前缀],
    author: [谭盟],
    date: [2026 年 11 月],
  ),
)

#set text(font: ("Noto Sans CJK SC", "Liberation Sans"), lang: "zh")
#show raw: set text(font: ("DejaVu Sans Mono", "Liberation Mono"), size: .8em)

#title-slide()

== 研究问题

- *表示效率*：乐理规则分词能否降低每字符编码成本，同时保持语法合法性？
- *架构差异*：RNN、LSTM、Post-LN 与 GPT2ABC 在预测、过拟合与结构保持上如何分化？
- *规模与条件*：扩大容量能否带来可预测收益？移调增强与前缀输入如何改变生成？

#v(1em)
#block(fill: luma(242), inset: 1em, radius: .3em)[
  *本文贡献*：可逆乐理分词器 · 旋律族隔离基准 · 多维评价体系 · 六档扩展实验 · 前缀配对干预
]

== 数据与隔离

#grid(columns: (1.05fr, 1fr), column-gutter: 1.2em,
  [
    #image("figures/ch3_01_system.svg", width: 100%)
  ],
  [
    #text(size: .82em)[
    - 原始记录 45,850 条，事件去重后 44,304 条
    - 移调不变轮廓键聚为 22,011 个旋律族
    - 训练 / 验证 / 测试 = 35,442 / 4,425 / 4,437
    - 族间交集为零，词表只在训练族内学习
    ]
    #v(.6em)
    #text(size: .78em, fill: luma(90))[跨集重叠为 0：移调副本不能跨划分泄露]
  ]
)

== 乐理分词器 ABCTokenizer

#grid(columns: (1fr, 1fr), column-gutter: 1.2em,
  [
    #text(size: .85em)[
    - 最长匹配（K=4）+ 字符回退，词表 118
    - 覆盖 `^` `_` `=` 升降号、八度记号与小节线
    - 编码像空间内逐字可逆，OOV = 0.00%
    ]
    #v(.8em)
    #table(
      columns: 3, stroke: none, inset: 5pt,
      table.hline(stroke: 1.2pt),
      [*方案*], [*压缩比*], [*BPC*],
      table.hline(stroke: .6pt),
      [Char], [1.0000], [0.7360],
      [BPE-256], [2.7933], [0.7531],
      [*Musical*], [*1.7703*], [*0.7037*],
      table.hline(stroke: 1.2pt),
    )
  ],
  [
    #image("figures/ch3_03_tokenizer_tradeoff.svg", width: 100%)
  ]
)

== 四种架构的独立测试

#grid(columns: (1.15fr, 1fr), column-gutter: 1em,
  [
    #image("figures/ch3_04_architecture_learning.svg", width: 100%)
  ],
  [
    #text(size: .9em)[
    #table(
      columns: 3, stroke: none, inset: 4pt,
      table.hline(stroke: 1.2pt),
      [*模型*], [*NLL*], [*PPL*],
      table.hline(stroke: .6pt),
      [RNN], [1.3722], [3.9439],
      [LSTM], [1.1609], [3.1930],
      [Post-LN], [0.8955], [2.4486],
      [*GPT2ABC*], [*0.8571*], [*2.3562*],
      table.hline(stroke: 1.2pt),
    )
    #v(.6em)
    所有模型从随机权重训练；GPT2ABC 为 Pre-LN + 权重绑定。
    ]
  ]
)

== 生成可靠性与音乐特征

#grid(columns: (1fr, 1fr), column-gutter: 1em,
  [
    #image("figures/ch3_06_generation_reliability.svg", width: 100%)
    #text(size: .72em)[每配置 3,000 次无修复采样]
  ],
  [
    #image("figures/ch3_07_music_distributions.svg", width: 100%)
    #text(size: .72em)[九维特征：低 NLL 伴随音域与熵的收缩]
  ]
)

== 从基准到规模

#grid(columns: (1.1fr, 1fr), column-gutter: 1.2em,
  [
    #lq.diagram(
      width: 10cm, height: 7cm,
      xlabel: [N / 百万（对数轴）],
      ylabel: [测试 NLL],
      xscale: "log",
      lq.plot(
        (0.200, 1.190, 14.196, 25.220, 85.056, 302.311),
        (1.7166, 1.2727, 0.9387, 0.8871, 0.9217, 0.8567),
      ),
    )
  ],
  [
    #text(size: .86em)[
    - 六档：Nano 0.20M → XL 302M 非嵌入参数
    - 测试 NLL 由 1.7166 降至 0.8567
    - *并非严格单调*：Large（0.9217）高于 Medium（0.8871）
    - 共同累计目标数下比较，避免只比预算终点
    ]
  ]
)

== 容量实验：轨迹而非末点

#image("figures/ch4_02_capacity.svg", width: 78%)
#text(size: .76em, fill: luma(90))[
  六档模型的验证轨迹与独立测试；阴影为三种子 ±1 SD。不同档位的训练预算并不相同，因此不把末点当作充分收敛包络。
]

== 十二半音移调增强

#image("figures/ch4_05_augmentation.svg", width: 82%)
#text(size: .78em)[
  Mini 配对对照：域内 NLL 上升约 0.112，固定 +5 半音压力测试下降约 0.104。
]

== 前缀条件生成

#image("figures/ch4_07_prefix_effect.svg", width: 84%)
#text(size: .78em)[
  同一提示配对：GPT2ABC 音级相似度 0.440 → 0.935；族 bootstrap 区间排除零。
]

== 结构性案例：自相似矩阵

#image("figures/ch4_08_shared_ssm.svg", width: 86%)
#text(size: .76em, fill: luma(90))[只含生成后的八小节，给定前缀完全移出图像；用于结构可视化，不当作动机理解的真值。]

== 结论

- *表示*：乐理分词在固定路径 BPC 上优于字符级与 BPE，但不保证小节时值合法。
- *架构*：GPT2ABC 取得最低测试 NLL；优势属于 Pre-LN 与权重绑定的组合配置。
- *规模*：容量与累计目标的联合模型可预测未见 XL 容量，但收益并非单调。
- *条件*：移调增强改善压力测试、牺牲域内拟合；前缀显著改变续写特征。
- *边界*：单一民谣来源、256 词元上下文、三个训练种子。

#v(.6em)
#align(center)[#text(size: 1.1em, weight: "bold")[谢谢！]]

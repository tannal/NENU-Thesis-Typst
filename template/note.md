#let status_tag(content, color) = box(
  inset: (x: 4pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
  fill: color.lighten(80%),
  stroke: color.lighten(30%),
  text(size: 8pt, weight: "bold", fill: color.darken(20%), content),
)

#let todo = status_tag("TODO", orange)
#let wip = status_tag("WIP", blue)
#let done = status_tag("DONE", green)

#let report(
  title: "",
  author: "",
  date: datetime.today(),
  body,
) = {
  set page(
    paper: "a4",
    margin: (x: 2cm, y: 2.5cm),
    header: align(right, text(8pt, gray)[#title | #date.display("[year]-[month]-[day]")]),
    numbering: "1",
  )

  set text(font: ("Times New Roman", "Source Han Serif SC", "SimSun"), size: 10.5pt, lang: "zh")
  show raw: set text(font: "Cascadia Code", size: 8.5pt)

  set heading(numbering: "1.1.", outlined: true)

  show heading.where(level: 1): it => {
    v(1.2em)
    block(
      fill: luma(245),
      inset: 8pt,
      radius: 4pt,
      width: 100%,
      it,
    )
    v(0.6em)
  }

  pad(bottom: 1.5em, {
    align(center)[
      #text(20pt, weight: "bold")[#title]
      #v(0.5em)
      #grid(
        columns: (1fr, 1fr),
        align(right)[*作者：* #author #h(1em)], align(left)[*更新日期：* #date.display("[year]年[month]月[day]日")],
      )
    ]
    line(length: 100%, stroke: 0.5pt + gray)
  })

  show outline.entry.where(level: 1): it => {
    v(10pt, weak: true)
    strong(it)
  }
  outline(title: "目录", indent: auto)
  pagebreak()

  body
}

#show: report.with(
  title: "进度报告",
  author: "谭盟",
)

#set math.equation(numbering: "(1)")

= 计划

完成第三章核心科研任务与工程实现。使用 C/CUDA 实现了统一张量流架构与领域专有分词器 ABCTokenizer 摆脱了庞大通用语言模型的算力束缚，以 0.90M 参数量和超过 13.7 万 tokens/s 的高吞吐量实现了对传统民谣旋律规律的高效建模。

#quote(block: true)[
  调式 和 调性  和  和弦，在领域中，可能是从 音高 中独立出来的。请考虑和参考其他文献。
]

ABC记谱法的header里面有调式信息，训练的时候全部数据都移动到了C调，音高是MIDI的局限性，ABC记谱法可以处理调式调性和和弦。
需要研究Muspy是否是基于绝对音高了，如果是的话需要适配。

我们观察到了RNN的梯度消失问题。

设计第四章内容与实验

客观评测证实了自注意力机制在调式调性空间具备自组织收敛能力。生成旋律在音级种类上精准收敛于七声音阶理论值 7.00，调式一致性达到 0.9917，彻底解决了传统循环神经网络严重的半音阶随机漂移问题。

第四章可能做流行音乐与民谣互通的动机重复与受控变奏机制，并引入文法约束解码，系统解决自回归生成在长程曲式中面临的动机漂移与机械死循环两极分化痛点。

= 正在进行的线索

== 第三章

把之前用Python编写的模型训练和推理过程用原生cuda实现了一遍，以下是训练数据

#table(
  columns: (1.2fr, 0.9fr, 1.1fr, 1.1fr, 1.1fr, 1.2fr, 1.8fr),
  inset: 6.5pt,
  align: horizon + center,
  stroke: 0.5pt + gray,
  fill: (x, y) => if y == 0 { rgb(230, 235, 245) } else if calc.even(y) { white } else { rgb(245, 248, 252) },

  // 表头
  [*模型架构*], [*参数量*], [*权重大小*], [*验证损失*], [*验证 PPL*], [*调式一致性*], [*梯度传播机制与长程依赖特性*],

  // Vanilla RNN
  [Vanilla RNN],
  [0.24M],
  [952 KB],
  [1.8756],
  [6.52],
  [0.7774],
  [一阶递归乘积；时间步长累乘导致梯度指数级消失（$gamma^T arrow 0$）],

  // Standard LSTM
  [Standard LSTM],
  [0.64M],
  [2.5 MB],
  [1.7287],
  [5.63],
  [0.9978],
  [遗忘门控线性维持梯度通路],

  // GPT-2
  [*GPT-2 (Domain)*],
  [*0.90M*],
  [*3.5 MB*],
  [*1.6937*],
  [*5.44*],
  [*0.9917*],
  [*$O(1)$ 因果多头自注意力；残差与 Pre-LN 保证全序列梯度无损直达*],
)


Pre-LN GPT-2 指的是将*层归一化（Layer Normalization）*的位置从残差块的“输出后”调整到“输入前”的 GPT-2 变体模型。
在标准的 GPT-2 中，虽然 OpenAI 宣称对初始化和 LayerNorm 位置做了微调，但社区中通常将 Transformer 架构细分为 Post-LN 和 Pre-LN 两类。两者的核心区别在于数据流经层归一化和残差连接的顺序

#align(center)[
  #block(width: 100%)[
    #align(left)[*核心区别对照*]
    #v(0.6em)
    #table(
      columns: (1.2fr, 1.8fr, 2.5fr),
      align: (left + horizon, left + horizon, left + horizon),
      stroke: none,
      table.hline(stroke: 1pt),
      table.header(
        [*架构类型*], [*结构公式*], [*特点*]
      ),
      table.hline(stroke: 0.5pt),

      [Post-LN（标准 Transformer）],
      [$x_(l+1) = "LN"(x_l + "SubLayer"(x_l))$],
      [容易在深层产生梯度消失或梯度爆炸，通常需要配合严格的 *Warmup*（预热）学习率策略。],

      table.hline(stroke: 0.3pt),

      [Pre-LN（GPT-2 实际采用的变体）],
      [$x_(l+1) = x_l + "SubLayer"("LN"(x_l))$],
      [梯度在残差通道中流动更顺畅，*训练更稳定*，通常不需要 Warmup 即可直接用大学习率训练。],

      table.hline(stroke: 1pt)
    )
  ]
]

=== ABCTokenizer #done

针对字符级和通用 BPE 破坏音乐音高与时值原子性的缺陷，设计了基于确定性有限状态自动机的专用分词器。该算法将音名、变音记号、八度标识以及相对时值倍率实现原子级绑定与解耦，将全曲词表严格压缩为 91 个 Token。单曲序列长度由 482 步大幅缩减至 187 步，文本压缩比达到 2.58 倍，语法切分碎片率降为零。

=== CUDA 训练/推理引擎 #done

使用Cuda通过单一物理张量排布统一管理 Vanilla RNN、双门控 LSTM 与因果多头自注意力 GPT-2 的连续显存拓扑。

底层引擎集成了分层梯度范数追踪、全局梯度裁剪、余弦退火学习率调度与早停保护机制。在单张 RTX 4090 显卡上，GPT-2 训练吞吐稳定在 137,066.8 tokens/s，3000 步训练收敛仅需数分钟。

=== Muspy重写 #done

重构实现了Muspy，从真实语料、循环网络及 GPT-2 中提取 9 维客观乐理特征。量化实验结果如表 1 所示。

#figure(
  table(
    columns: (auto, auto, 1fr, 1fr, 1fr),
    inset: 6pt,
    align: horizon + center,
    stroke: 0.5pt + gray,
    fill: (x, y) => if y == 0 { rgb(230, 235, 245) } else if calc.even(y) { white } else { rgb(245, 248, 252) },

    [*评估指标 (Metric)*], [*统计量*], [*真实数据集 (Folk-v1)*], [*循环模型 (Vanilla RNN)*], [*本文模型 (GPT-2)*],

    table.cell(rowspan: 2)[*音高跨度 (Pitch Range)*], [均值], [18.1658], [42.0000], [*19.2000*],
    [标准差], [3.8006], [11.1803], [*2.8636*],

    table.cell(rowspan: 2)[*独特音高数 (N Pitches)*], [均值], [11.3005], [26.8000], [*11.4000*],
    [标准差], [2.4889], [8.7006], [*2.3022*],

    table.cell(rowspan: 2)[*独特音级数 (N Pitch Classes)*], [均值], [7.1732], [12.0000], [*7.0000*],
    [标准差], [0.9674], [0.0000], [*0.0000*],

    table.cell(rowspan: 2)[*调式一致性 (Scale Consistency)*], [均值], [0.9922], [0.7774], [*0.9917*],
    [标准差], [0.0183], [0.0601], [*0.0084*],

    table.cell(rowspan: 2)[*音高熵 (Pitch Entropy)*], [均值], [3.1190], [4.2982], [*3.1645*],
    [标准差], [0.2958], [0.3812], [*0.2810*],

    table.cell(rowspan: 2)[*音级熵 (Pitch Class Entropy)*], [均值], [2.6061], [3.4475], [*2.6103*],
    [标准差], [0.1623], [0.2104], [*0.1245*],

    table.cell(rowspan: 2)[*律动一致性 (Groove Consistency)*], [均值], [0.9843], [0.9215], [*0.9832*],
    [标准差], [0.0245], [0.0450], [*0.0221*],
  ),
  caption: [真实民谣数据集与不同生成模型在 9 维计算音乐学指标上的量化实测对比],
)

AI 生成的一首曲子里，刚好不多不少就围绕着这 7 个核心音符转，没有出现游离在调外的杂音。

=== 自回归推理加固与声学合成 #done

推理引擎全面部署了防幻觉机制。调号守卫在首个合法调号生成后主动封锁头部 Token 采样，消除多调号冲突。自适应重复惩罚有效抑制了小节末端死循环，Prompt 归一化管线确保了输入字符与词表符号的严格对齐。

同时简单模拟了大钢琴琴槌瞬态与双弦微失谐共鸣，支持标准 MIDI 音色切换程序，支持从MIDI到ABC和从ABC到MIDI，以及转化采样为wav。

音源合成是一个已经成熟的领域，著名的纯物理建模音源 Modartt Pianoteq（目前已更新到 Pianoteq 8/9）内部对琴槌、琴弦、音板相互作用的傅里叶构造和偏微分方程求解核心算法，属于该公司的核心商业机密并申请了发明专利。

将POP909数据集转化为了ABC记谱法，可以上传一个wav或者ABC记谱采样。

== 第四章

目前仍需设计第四章的内容和实验（如果需要）

可能采用第三章的模型来验证符号音乐领域存不存在Scaling Law，也可能做流行音乐生成（POP909）数据集，五声音阶，结构性重复等等。

我们现有的民谣语料库约 8.2M tokens。如果直接拿 8.2M tokens 猛训 852M 的巨大网络，模型仅需百步就会彻底记忆全部训练集，导致验证集迅速严重过拟合。

我们需要更多的数据来支持Scale模型的参数量，算力是足够的。

为了在论文中系统性地拟合出符号音乐模型的扩展定律幂律曲线，我们估算了一份参数空间梯队，详细列出了各体量的超参数配置、参数量统计、显存开销及训练吞吐预算。

#table(
  columns: 11,
  align: center + horizon,
  stroke: none,
  table.hline(stroke: 1.5pt),
  table.header(
    [梯队型号], [层数 $L$], [隐层 $d$], [头数 $h$], [上下文 $T$], [参数量 $N$],
    [静态显存], [训练显存 ($B=16$)], [吞吐量 (tok/s)], [总算力 $C$ (FLOPs)], [4090 可行性]
  ),
  table.hline(stroke: 1pt),
  [Nano-ABC],   [2],  [128],  [4],  [512], [0.24 M],  [3.8 MB],  [0.8 GB],  [42,000], [$1.18 times 10^(16)$], [完全轻松],
  [Mini-ABC],   [4],  [256],  [4],  [512], [0.85 M],  [13.6 MB], [1.4 GB],  [35,000], [$4.18 times 10^(16)$], [完全轻松],
  [Base-ABC],   [12], [256],  [8],  [512], [2.52 M],  [40.3 MB], [2.6 GB],  [28,000], [$1.24 times 10^(17)$], [当前配置],
  [Medium-ABC], [8],  [512],  [8],  [512], [10.6 M],  [169 MB],  [4.5 GB],  [19,000], [$5.21 times 10^(17)$], [完全推荐],
  [Large-ABC],  [12], [768],  [12], [512], [35.8 M],  [572 MB],  [7.8 GB],  [11,000], [$1.76 times 10^(18)$], [黄金基准],
  [Pro-ABC],    [16], [1024], [16], [512], [128.2 M], [2.05 GB], [13.2 GB], [5,200],  [$6.30 times 10^(18)$], [高算力推荐],
  [Ultra-ABC],  [24], [1536], [16], [512], [345.6 M], [5.53 GB], [18.6 GB], [2,100],  [$1.70 times 10^(19)$], [需FlashAttn],
  [Limit-ABC],  [32], [2048], [16], [512], [852.1 M], [13.6 GB], [22.4 GB], [850],    [$4.19 times 10^(19)$], [需激活重算],
  table.hline(stroke: 1.5pt),
)

= 已完成

模型训练和推理代码cuda重写，0.9M 模型训练大约2分钟，加速训练过程。

编写论文第三章内容，同步进行实验，重复了5月份的实验结果

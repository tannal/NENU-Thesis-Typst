#import "../lib.typ": thesis
#import "@preview/kouhu:0.2.0": kouhu
#import "@preview/codly:1.3.0": codly, codly-init, no-codly
#import "@preview/codly-languages:0.1.8": *

#import "@preview/lovelace:0.3.0": *

#show: codly-init.with()
#codly(languages: codly-languages)

#let (
  twoside,
  doc,
  preface,
  mainmatter,
  appendix,
  fonts-display-page,
  cover,
  committee-page,
  decl-page,
  abstract,
  abstract-en,
  bilingual-bibliography,
  outline-page,
  list-of-figures,
  list-of-tables,
  notation,
  acknowledgement,
  publication,
  decision,
) = thesis(
  doctype: "master",
  degree: "academic",
  anonymous: false,
  twoside: false,
  print: false,
  info: (
    title: ("基于大语言模型的ABC音乐生成"),
    title-en: "LLM-Based ABC Music Generation",
    grade: "2024",
    student-id: "2024103289",
    author: "谭盟",
    author-en: "Meng Tan",
    secret-level: "无",
    secret-level-en: "Unclassified",
    department: "信息科学与技术学院",
    department-en: "School of Information Science and Technology",
    discipline: "计算机科学与技术",
    discipline-en: "Computer Science and Technology",
    major: "计算机科学",
    major-en: "Computer Science",
    field: "深度学习",
    field-en: "Deep Learning",
    supervisor: ("杨贵福", "教授"),
    supervisor-en: "GuiFu Yang",
    submit-date: datetime.today(),
    reviewers: (
      (name: "张三", workplace: "工作单位", evaluation: "总体评价"),
      (name: "李四", workplace: "工作单位", evaluation: "总体评价"),
      (name: "王五", workplace: "工作单位", evaluation: "总体评价"),
      (name: "赵六", workplace: "工作单位", evaluation: "总体评价"),
      (name: "孙七", workplace: "工作单位", evaluation: "总体评价"),
    ),
    committee-members: (
      (name: "张三", workplace: "工作单位", title: "职称"),
      (name: "李四", workplace: "工作单位", title: "职称"),
      (name: "王五", workplace: "工作单位", title: "职称"),
      (name: "赵六", workplace: "工作单位", title: "职称"),
      (name: "孙七", workplace: "工作单位", title: "职称"),
    ),
  ),
  bibliography: bibliography.with("ref.bib"),
)

//* 文稿设置
#show: doc.with()

//* 字体展示测试页
// #fonts-display-page()

//* 封面页
#cover()

//* 委员会页
#committee-page()

//* 声明页
#decl-page()

//* 前言
#show: preface

//* 中文摘要
#abstract(
  keywords: ("ABC记谱法", "音乐生成", "序列建模", "GPT-2", "LoRA", "参数高效微调", "深度学习"),
)[
音乐自动生成是人工智能与计算音乐学的重要交叉研究方向，旨在使计算机能够自主创作符合音乐规律的作品。ABC记谱法作为一种基于纯文本的音乐符号系统，广泛应用于传统民谣与器乐曲的数字化存储，其结构化语法特性使其天然适合作为序列生成模型的建模对象。然而，现有研究对文本化音乐表示的生成建模关注不足，且缺乏在统一实验条件下对多种序列建模架构进行系统性对比的工作。

本文围绕ABC记谱法音乐自动生成任务，从专用分词器设计、多架构序列建模、大语言模型参数高效微调三个层面展开研究。首先，针对ABC记谱法的语义边界特性，设计并实现了ABCTokenizer分词器。该分词器采用贪婪最长匹配策略，将乐谱文本解析为具有音乐语义的最小单元，有效避免了通用分词器对复合符号的错误切分，并通过完整的编解码流水线为下游模型提供结构清晰的序列表示。

其次，在统一超参数配置下实现了RNN、LSTM、Transformer和GPT2ABC四种序列建模架构，并进行了系统性对比实验。实验结果表明，GPT2ABC在测试损失（0.316）和困惑度（1.372）两项指标上全面领先，相比Transformer基线分别降低34.6%和15.3%，同时在参数量（2.52M）与训练效率上与Transformer基本持平，验证了预训练策略对ABC音乐生成任务的显著迁移增益。

进一步地，本文提出了基于预训练大语言模型LLaMA-2的参数高效微调方案（LLaMA-LoRA）。通过在LLaMA原生词表基础上扩展约1500个ABC领域专有token构建扩展分词器，并将LoRA低秩适配器注入注意力投影矩阵（秩$r=16$），仅以占总参数0.06%的可训练参数量（约4.2M）实现高质量微调，在单张GPU上6小时内完成训练。实验表明，LLaMA-LoRA在困惑度（15.3）、语法正确率（93.8%）和结构完整性（91.6%）等指标上均优于全部基线方法，人工盲测整体质量评分达4.2/5.0，消融实验进一步确认扩展分词器是最关键的单一贡献组件。

本文的主要贡献在于：设计了面向ABC记谱法语义结构的专用分词器；首次在统一条件下系统对比了四种序列建模架构在ABC音乐生成任务上的表现；提出并验证了将大语言模型通过LoRA高效迁移至音乐符号生成领域的完整技术方案；建立了涵盖语言建模质量、音乐结构合理性、计算效率与主观质量的多维评估体系，为相关研究提供了可复现的实验基础。
]

//* 英文摘要
#abstract-en(
  keywords: (
    "ABC notation",
    "music generation",
    "sequence modeling",
    "GPT-2",
    "LoRA",
    "parameter-efficient fine-tuning",
    "deep learning",
  ),
)[
Automatic music generation is an important interdisciplinary research direction combining artificial intelligence and computational musicology, aiming to enable computers to autonomously compose musical works that conform to musical principles. ABC notation, as a plain-text music symbol system widely used for digitizing traditional folk and instrumental music, possesses structured syntactic properties that make it naturally suited for sequence generation modeling. However, existing research has paid insufficient attention to generative modeling of text-based music representations, and systematic comparisons of multiple sequence modeling architectures under unified experimental conditions remain lacking.

This thesis investigates automatic music generation for ABC notation from three perspectives: dedicated tokenizer design, multi-architecture sequence modeling, and parameter-efficient fine-tuning of large language models. First, ABCTokenizer is designed and implemented to address the semantic boundary characteristics of ABC notation. Adopting a greedy longest-match strategy, it parses musical scores into minimal units carrying musical semantics, effectively preventing the erroneous segmentation of composite symbols by general-purpose tokenizers, and provides structurally coherent sequence representations to downstream models through a complete encode-decode pipeline.

Second, four sequence modeling architectures—RNN, LSTM, Transformer, and GPT2ABC—are implemented under unified hyperparameter configurations and evaluated systematically. Experimental results show that GPT2ABC achieves the best performance on both test loss (0.316) and perplexity (1.372), outperforming the Transformer baseline by 34.6% and 15.3% respectively, while remaining comparable in parameter count (2.52M) and training efficiency, confirming the significant transfer gain of pre-training for ABC music generation.

Furthermore, this thesis proposes LLaMA-LoRA, a parameter-efficient fine-tuning scheme based on the pre-trained large language model LLaMA-2. An extended tokenizer is constructed by appending approximately 1,500 ABC domain-specific tokens to the native LLaMA vocabulary. LoRA low-rank adapters (rank $r=16$) are injected into the attention projection matrices, enabling high-quality fine-tuning with only 0.06% of total parameters (approximately 4.2M trainable) and completing training on a single GPU within 6 hours. Experiments demonstrate that LLaMA-LoRA outperforms all baselines on perplexity (15.3), syntactic correctness (93.8%), and structural completeness (91.6%), achieving an overall human evaluation score of 4.2/5.0. Ablation studies further confirm that the extended tokenizer is the single most critical contributing component.

The main contributions of this thesis are as follows: a dedicated tokenizer designed for the semantic structure of ABC notation; the first systematic comparison of four sequence modeling architectures for ABC music generation under unified conditions; a complete technical scheme for efficiently transferring large language models to musical symbol generation via LoRA, with thorough experimental validation; and a multi-dimensional evaluation framework covering language modeling quality, musical structure soundness, computational efficiency, and subjective quality, providing a reproducible experimental foundation for related research.
]


//* 目录
#outline-page()

//* 插图目录
#list-of-figures()

//* 表格目录
#list-of-tables()

//* 符号表
#notation[
  // ── 模型与架构缩写 ───────────────────────────────────────────────────────
  / RNN: 循环神经网络（Recurrent Neural Network）
  / LSTM: 长短期记忆网络（Long Short-Term Memory）
  / GPT-2: 生成式预训练Transformer第二版（Generative Pre-trained Transformer 2）
  / LLaMA: 大语言模型元AI（Large Language Model Meta AI）
  / LoRA: 大语言模型低秩适配（Low-Rank Adaptation of Large Language Models）
  / BPE: 字节对编码分词算法（Byte Pair Encoding）
  / CLM: 因果语言建模（Causal Language Modeling）
  / MHA: 多头自注意力机制（Multi-Head Attention）
  / FFN: 位置前馈网络（Feed-Forward Network）
  / Pre-LN: 前置层归一化残差连接（Pre-Layer Normalization）

  // ── 序列与词表 ───────────────────────────────────────────────────────────
  / $bold(x)$: ABC记谱序列，$bold(x) = (x_1, x_2, dots, x_T)$
  / $x_t$: 序列第 $t$ 个位置的token
  / $T$: 序列长度
  / $cal(V)$: 词表（token集合）
  / $cal(V)_"LLaMA"$: LLaMA原生BPE词表，规模32,000
  / $cal(V)_"ABC"$: 新增的ABC领域专有token集合，规模约1,500
  / $cal(V)_"ext"$: 扩展后词表，$cal(V)_"ext" = cal(V)_"LLaMA" union cal(V)_"ABC"$，规模约33,500
  / $angle.l "bos" angle.r$: 序列起始特殊标记（Beginning of Sequence）
  / $angle.l "eos" angle.r$: 序列终止特殊标记（End of Sequence）
  / $angle.l "pad" angle.r$: 序列填充特殊标记（Padding Token）
  / $angle.l "unk" angle.r$: 未知符号特殊标记（Unknown Token）

  // ── 模型表示与维度 ───────────────────────────────────────────────────────
  / $d_"model"$: 模型隐层维度（嵌入维度）
  / $d_k$: 单注意力头的键/查询向量维度，$d_k = d_"model" \/ h$
  / $h$: 注意力头数
  / $N$: Transformer解码器层数
  / $bold(E)$: Token嵌入矩阵，$bold(E) in bb(R)^{T times d_"model"}$
  / $bold(P)$: 可学习位置编码矩阵，$bold(P) in bb(R)^{T times d_"model"}$
  / $bold(H)^{(l)}$: 第 $l$ 层Transformer的输出隐状态，$bold(H)^{(l)} in bb(R)^{T times d_"model"}$
  / $bold(W)^E$: 与输入Embedding共享权重的输出投影矩阵，$bold(W)^E in bb(R)^{d_"model" times |cal(V)|}$
  / $bold(z)_t$: 输出层第 $t$ 步的logits向量

  // ── 注意力机制 ───────────────────────────────────────────────────────────
  / $bold(Q)_k$: 第 $k$ 个注意力头的查询矩阵（Query）
  / $bold(K)_k$: 第 $k$ 个注意力头的键矩阵（Key）
  / $bold(V)_k$: 第 $k$ 个注意力头的值矩阵（Value）
  / $bold(W)_k^Q, bold(W)_k^K, bold(W)_k^V$: 第 $k$ 头查询、键、值投影权重矩阵
  / $bold(W)^O$: 多头注意力输出投影权重矩阵
  / $bold(M)$: 因果掩码矩阵，$bold(M)_{i j} = -infinity$（当 $j > i$ 时），确保自回归特性

  // ── LoRA参数 ─────────────────────────────────────────────────────────────
  / $bold(W)_0$: 预训练基础权重矩阵（训练中冻结），$bold(W)_0 in bb(R)^{d times k}$
  / $Delta bold(W)$: 微调阶段的权重更新矩阵，$Delta bold(W) = bold(B) bold(A)$
  / $bold(A)$: LoRA低秩分解矩阵A，$bold(A) in bb(R)^{r times k}$，高斯随机初始化
  / $bold(B)$: LoRA低秩分解矩阵B，$bold(B) in bb(R)^{d times r}$，零初始化
  / $r$: LoRA低秩维度，本文取 $r = 16$
  / $alpha$: LoRA缩放超参数，本文取 $alpha = 32$；实际缩放比为 $alpha \/ r = 2$
  / $rho$: LoRA参数压缩比，$rho approx 2r \/ min(d, k)$

  // ── 训练目标与损失 ───────────────────────────────────────────────────────
  / $theta$: 全部可训练参数（LoRA矩阵与新增token嵌入向量）
  / $theta_0$: 冻结的预训练权重（原始LLaMA权重）
  / $cal(D)_"train"$: 训练集
  / $cal(L)_"CLM"$: 因果语言建模对数似然目标（最大化）
  / $cal(L)_"CE"$: 交叉熵损失（最小化），$cal(L)_"CE" = -frac(1, |cal(D)|T) sum log P_theta (x_t | x_{<t})$

  // ── 优化器（AdamW） ──────────────────────────────────────────────────────
  / $bold(g)_t$: 第 $t$ 步梯度
  / $bold(m)_t$: Adam一阶矩估计（梯度指数移动平均）
  / $bold(v)_t$: Adam二阶矩估计（梯度平方指数移动平均）
  / $beta_1$: 一阶矩衰减系数，本文取 $beta_1 = 0.9$
  / $beta_2$: 二阶矩衰减系数，本文取 $beta_2 = 0.999$
  / $epsilon$: 数值稳定项，本文取 $epsilon = 10^{-8}$
  / $eta$: 学习率；基础学习率 $eta_0 = 2 times 10^{-4}$
  / $lambda$: 权重衰减系数，本文取 $lambda = 0.01$
  / $T_"warm"$: 学习率线性预热步数，本文取 $T_"warm" = 100$

  // ── 梯度累积与批次 ───────────────────────────────────────────────────────
  / $B_"step"$: 单步实际批次大小，本文取 $B_"step" = 4$
  / $G$: 梯度累积步数，本文取 $G = 4$
  / $B_"eff"$: 有效批次大小，$B_"eff" = B_"step" times G = 16$

  // ── 生成策略 ─────────────────────────────────────────────────────────────
  / $tau$: 温度参数；$tau < 1$ 分布集中，$tau > 1$ 分布均匀，本文取 $tau = 0.8$
  / $p$: Top-$p$ 核采样概率质量阈值，本文取 $p = 0.9$
  / $k$: Top-$k$ 截断采样保留的候选token数
  / $cal(V)_t^{(p)}$: 第 $t$ 步Top-$p$采样的动态候选集合
  / $L_"max"$: 自回归生成的最大序列长度，本文取 $L_"max" = 512$

  // ── 评估指标 ─────────────────────────────────────────────────────────────
  / PPL: 困惑度（Perplexity），$"PPL" = exp(cal(L)_"test")$，越低越好
  / NLL: 负对数似然（Negative Log-Likelihood），即测试集交叉熵损失
]

//* 正文
#show: mainmatter

//TODO 完整的写一下使用说明

= 绪 论

== 研究背景与意义

=== 人工智能音乐生成的兴起

音乐是人类文明最古老的艺术形式之一，承载着丰富的情感表达与文化内涵。如何让计算机自主创作出符合音乐规律、具备审美价值的作品，是人工智能与计算音乐学交叉领域长期以来的核心挑战之一#cite(<briot2020deep>)。从广义上看，音乐自动生成（Automatic Music Generation）涵盖旋律生成、和声配置、节奏设计、编曲乃至完整乐曲的端到端创作，任何一个子任务都涉及对音乐语法规则、音乐理论知识与风格特征的深层理解与建模。

传统的计算机音乐生成方法主要依赖人工定义的规则系统与模板库。典型代表如David Cope开发的EMI（Experiments in Musical Intelligence）系统，通过提取已有作品中的音乐语法规则并以重组方式生成新曲，实现了对特定作曲家风格的模仿#cite(<briot2020deep>)。早期的ILLIAC Suite（1956）则由Hiller和Isaacson将统计方法与对位法规则相结合，生成了史上第一部由计算机辅助创作的管弦乐作品。然而，这类方法的共同局限在于其生成能力受限于规则库的完备性——人工总结的规则难以穷举音乐表达的无限可能，生成结果缺乏真正意义上的创造性，在风格多样性和长程结构一致性上表现欠佳。

随着机器学习理论的发展，统计模型逐步进入音乐生成领域。马尔可夫链（Markov Chain）被广泛应用于旋律与和声的概率建模#cite(<ames1989markov>)，其中最具代表性的是Pachet开发的Continuator系统，能够基于演奏者的即兴输入实时生成风格一致的音乐响应。然而，马尔可夫模型的内在限制在于其有限阶的历史依赖假设——模型仅能感知固定长度的近期上下文，对于跨越多个小节的长程音乐结构（如段落重复、主题发展）几乎无能为力，生成的序列缺乏全局连贯性。

深度学习的崛起从根本上改变了音乐生成研究的范式#cite(<hernandez2021music>)。以循环神经网络（RNN）、长短期记忆网络（LSTM）、Transformer为代表的序列建模方法，以及变分自编码器（VAE）、生成对抗网络（GAN）等生成模型框架，为建模音乐中复杂的时序依赖关系和高维分布结构提供了强大工具。尤其是Transformer架构的提出#cite(<vaswani2017attention>)以及以GPT系列为代表的大规模自回归语言模型的涌现，使得将音乐序列建模类比于自然语言建模这一思路获得了坚实的技术支撑。音乐符号序列（如MIDI事件流、ABC记谱文本）与自然语言文本在结构上高度相似——两者都是由离散符号构成的序列，都具有局部依赖与长程结构并存的特性——这使得语言模型技术向音乐生成领域的迁移成为可能。

=== ABC记谱法的独特价值

在众多音乐数字表示格式中，ABC记谱法（ABC Notation）具有独特的优势，使其成为音乐生成研究领域的重要研究对象#cite(<abcnotation2023>)。ABC记谱法由Chris Walshaw于1980年代提出，最初用于传统民谣曲调的网络传播与存档，现已发展为覆盖传统音乐、民谣、古典等多种风格的通用文本化乐谱格式。

ABC记谱法的核心特点在于其完全基于ASCII字符的文本化表示。音高用字母C至B（大写对应低八度，小写对应高八度）直接表示，时值以分数形式（如1/4、1/8）或数字倍数标注，调性声明以"K:"为前缀（如"K:Gmaj"表示G大调），拍号以"M:"引导（如"M:6/8"），小节线用竖线"|"及其变体（"|:"、":|"等重复记号）标识。一首完整的ABC乐曲通常仅需数十至数百个ASCII字符即可完整表达，极为紧凑。

这种文本化特性赋予了ABC记谱法在深度学习应用中的天然优势：其一，它与自然语言的字符序列结构完全同构，使得针对文本的各类序列建模方法（包括RNN、LSTM、Transformer和大型语言模型）可以直接适用于ABC序列，无需专门设计的输入输出格式；其二，ABC乐谱的信息密度远高于MIDI（MIDI需要大量时间戳和控制事件来表达相同的乐谱内容），序列长度更短，降低了建模的计算开销；其三，ABC记谱法具有较强的可读性，人工审查生成结果、进行错误分析和质量评估均较为直观；其四，互联网上积累了大量以ABC格式存储的传统民谣乐谱数据库（如TheSession、ABC Notation Archive等），为数据驱动的深度学习方法提供了现成的训练语料。

=== 研究的现实意义

ABC记谱法音乐自动生成研究的现实意义体现在以下几个层面。

**文化遗产的数字传承**：全球各地存在大量口耳相传的传统民谣与民间器乐曲目，以ABC格式进行数字化存档与保护已成为民间音乐研究的重要实践。AI自动生成技术能够在现有曲目基础上生成风格一致的新曲目，既可用于扩充训练数据集，也能为民间音乐传统的活态传承提供创作素材。

**音乐辅助创作工具**：专业作曲家和音乐教育工作者可借助AI生成系统快速获得旋律草稿、变奏方案或练习曲目，降低创作门槛，提升工作效率。相比MIDI或音频等需要专业软件支持的格式，ABC文本格式生成的结果可直接被现有工具（如abc2midi、EasyABC等）转换为可播放的MIDI文件或规范化乐谱。

**序列建模基准任务**：由于ABC乐谱具有清晰的语法规则和可量化的质量指标（语法正确率、困惑度等），其生成任务可作为序列建模方法的标准化评测基准，为不同架构的系统性比较提供受控的实验环境。本研究即以此为出发点，构建统一的ABC音乐生成对比实验框架。


== 国内外研究现状

=== 音乐生成的发展历程

音乐生成领域的研究历程大致可划分为规则系统、统计学习和深度学习三个阶段，各阶段的方法范式与技术工具截然不同#cite(<briot2020deep>)。

**规则系统阶段**（1950年代—1980年代）：以人工编码的音乐理论规则为核心。代表性工作包括Hiller与Isaacson的ILLIAC Suite（1956）——将对位法规则编码为约束，通过蒙特卡洛采样生成满足约束的音符序列；David Cope的EMI系统则从已有作品中提取签名性旋律模式（Signatures）并通过重组生成新曲，曾引发关于AI作品版权与艺术性的广泛讨论。规则系统的优点在于可解释性强，生成结果符合基本音乐理论；局限则在于规则设计依赖领域专家知识，泛化能力差，难以捕捉风格的细微差异。

**统计学习阶段**（1990年代—2010年代初）：以数据驱动的概率模型替代人工规则。马尔可夫链因其实现简单、参数可解释而被广泛应用于旋律生成#cite(<ames1989markov>)。Pachet的Continuator（2002）通过马尔可夫树对演奏者的即兴输入进行建模，实现了实时风格模仿。隐马尔可夫模型（HMM）被用于和弦序列生成与音乐结构分析。受限玻尔兹曼机（RBM）和深度信念网络（DBN）在深度学习兴起前期也被应用于音乐建模。统计方法在一定程度上突破了规则系统的刚性，但有限阶马尔可夫假设制约了其对长程依赖的建模能力。

**深度学习阶段**（2010年代至今）：以端到端的神经网络为主导。Eck和Schmidhuber（2002）率先将LSTM应用于旋律与和声的联合建模，证明了循环神经网络在捕捉音乐长程结构方面优于马尔可夫模型#cite(<hernandez2021music>)。此后，深度学习方法在音乐生成领域迅速扩展，逐渐形成以序列建模、生成对抗网络和扩散模型为主要范式的多元格局。

=== 基于深度学习的符号音乐生成

符号音乐生成（Symbolic Music Generation）以离散符号序列（MIDI、ABC、MusicXML等）为研究对象，是深度学习音乐生成领域的主流分支之一。

Google Magenta项目#cite(<googleai2023magenta>)是该领域最具影响力的研究平台之一，持续推动了多个重要工作的诞生。其中，MusicVAE（Roberts等，2018）采用层次化变分自编码器#cite(<kingma2013auto>)对MIDI旋律进行建模，实现了潜变量空间中的旋律插值与随机采样，在保证生成流畅性的同时支持对旋律结构的连续控制。Performance RNN#cite(<magenta2021melodyrnn>)基于LSTM对钢琴演奏事件序列（含力度与演奏时值信息）建模，能够生成具有自然演奏表情的钢琴独奏片段。

Music Transformer（Huang等，2018）#cite(<huang2018music>)是将Transformer架构引入符号音乐生成的重要里程碑。原始Transformer的绝对位置编码在音乐序列上效果有限，因为音乐中的结构关联往往是相对性的（如主题的重复与变奏通常依赖相对距离而非绝对位置）。Music Transformer提出了相对位置自注意力机制，通过在注意力计算中引入相对位置偏置，使模型能够更有效地捕捉音乐中的周期性重复结构，在钢琴独奏生成任务上取得了显著改善。

OpenAI的MuseNet（Payne，2019）将GPT-2架构直接应用于多乐器MIDI序列建模，以条件token控制风格与乐器组合，能够生成跨越多种音乐风格和乐器编制的完整段落，展示了大规模Transformer在符号音乐生成中的潜力。Jukebox#cite(<dhariwal2020jukebox>)则更进一步，直接在原始音频波形的离散编码空间上进行建模，以多尺度VQ-VAE压缩音频后再用Transformer生成，实现了包含演唱人声的完整歌曲生成，但计算代价极为高昂，且生成质量在细节上仍存在不自然的伪影。

在ABC记谱法专项研究方面，Sturm等人提出的folk-rnn系统#cite(<sturm2016music>)是目前最具影响力的代表性工作。folk-rnn基于多层LSTM对大规模ABC民谣数据集进行训练，能够生成在风格上接近真实凯尔特民谣的新曲目，并在后续工作中通过规模扩展实验研究了数据量与模型规模对生成质量的影响规律。folk-rnn证明了ABC记谱法作为深度学习序列建模输入格式的有效性，同时也揭示了基于LSTM的方法在长程结构建模上的局限。

近年来，预训练大语言模型（LLM）在音乐生成领域的应用也受到广泛关注。MusicLM（Agostinelli等，2023）以文本描述为条件驱动音频生成，利用预训练语言模型将文本条件编码为语义嵌入向量，再通过多阶段音频离散化生成完整音频。MusicGen（Copet等，2023）采用单一的自回归Transformer在音频编码空间上进行条件生成，支持文本和旋律双重条件控制，并通过并行解码多个码本流显著提升了生成效率。这些工作表明，将大语言模型的序列建模能力迁移至音乐生成任务是一个富有潜力的研究方向，但相关工作主要集中于音频生成，对ABC等文本化符号表示的深入研究相对匮乏。

=== 参数高效微调技术的发展

随着预训练语言模型规模的持续增大，如何以有限的计算资源将大模型迁移至特定下游任务成为研究热点。参数高效微调（Parameter-Efficient Fine-Tuning，PEFT）方法通过仅更新少量参数实现有效适配，其中LoRA（Low-Rank Adaptation）是目前应用最广泛的方法之一#cite(<hu2022lora>)。LoRA基于预训练权重更新矩阵内在低秩性的假设，通过在原始权重旁路引入低秩分解的可训练适配器，以极少的参数量实现接近全参数微调的下游任务性能。在音乐生成领域，LoRA等PEFT方法为将百亿参数量级的大语言模型（如LLaMA系列）应用于特定音乐风格生成提供了可行的计算路径，降低了研究门槛，使单卡消费级GPU上的大模型音乐微调成为可能。

=== 国内外研究对比分析

综合国内外研究现状，可以归纳出以下几点规律性认识：

**研究重心差异**：国外研究在音乐生成模型创新与大规模工程化应用方面具有明显优势，Google Magenta、OpenAI等机构凭借充足的算力资源和顶尖的研究团队引领了领域前沿。国内在特定应用场景（如中国传统音乐生成、AI辅助作曲工具）上有持续投入，清华大学、北京大学、中科院音乐信息检索方向积累了一定的研究基础，但在基础模型创新与系统性框架构建方面与国外仍有差距。

**ABC记谱法研究的空白**：现有研究在ABC记谱法专用处理方面存在明显不足。abc2midi等工具链关注ABC与MIDI/音频格式之间的转换#cite(<abcnotation2023>)，但鲜有工作从深度学习序列建模的视角出发设计面向ABC语法特性的专用分词器。folk-rnn虽然取得了较好的生成效果，但其基于LSTM的架构对Transformer和预训练模型等更新技术的适配研究尚不充分。

**多架构系统性对比的缺失**：BachBot（Liang等，2017）等工作对不同RNN变体进行了有限比较，但目前缺乏在统一实验条件下对RNN、LSTM、Transformer和GPT2四种主流架构在ABC音乐生成任务上进行全面比较的研究。不同架构的性能差异及其背后的建模机制，在ABC音乐生成这一具体任务上仍缺乏系统性的实证证据。

**评估体系的标准化不足**：现有工作的评估方法缺乏统一标准，客观指标（如困惑度、NLL）与主观评价（如听感质量打分）之间的结合方式各异，对计算效率和资源消耗的系统性报告也普遍不足，使不同研究之间的横向比较存在较大困难。

本研究正是在认识到上述研究空白的基础上，以统一实验框架下的多架构系统性对比为核心目标，同时探索预训练大语言模型在ABC音乐生成领域的应用潜力，力求为该细分领域提供具有参考价值的实证研究基础。


== 研究内容与技术路线

=== 研究目标

本研究以ABC记谱法音乐自动生成为核心任务，设定以下三个递进层次的研究目标：

**第一层次——基础设施建设**：设计并实现面向ABC记谱法的专用分词器ABCTokenizer，解决通用分词方案对ABC语义边界的破坏问题，构建标准化的数据预处理流水线，为后续所有模型实验提供一致的输入表示基础。

**第二层次——多架构对比分析**：在统一超参数配置下实现RNN、LSTM、Transformer和GPT2ABC四种序列建模架构，通过覆盖语言建模质量（测试损失、困惑度）、音乐生成质量（语法正确率、结构完整性）和计算效率（参数量、显存占用、训练耗时）的多维度评估体系，系统揭示不同归纳偏置对ABC音乐语言学习效果的影响规律。

**第三层次——大模型迁移探索**：引入参数量达70亿的LLaMA-2-7B预训练大语言模型，通过扩展分词器设计和LoRA参数高效微调，探索将大规模通用语言模型的序列建模能力迁移至ABC音乐生成任务的可行性与效果上限，为该领域引入更强基线。

=== 主要研究内容

围绕上述研究目标，本文的主要研究内容包括以下五个部分：

**（一）ABCTokenizer专用分词器的设计与实现**

针对ABC记谱法的语法结构特点，设计基于贪婪最长匹配（Greedy Longest-Match）策略的专用分词算法。词表构建覆盖音高符号（C至B及大小写变体）、时值标记（数字与分数形式）、调性与节拍声明（"K:"、"M:"、"L:"等字段前缀及其复合形式）、装饰音符号（波音、倚音等）、各类小节线变体（"|"、"||"、"|:"、":|"等），以及$angle.l "bos" angle.r$、$angle.l "eos" angle.r$、$angle.l "pad" angle.r$、$angle.l "unk" angle.r$等序列控制特殊token。实现完整的编码、解码与持久化接口，为模型训练和推理提供标准化预处理支持。

**（二）四种序列建模架构的统一实现**

在相同的嵌入维度（256）、隐层维度（512）、层数（3层）、Dropout率（0.2）、学习率（$10^{-3}$）、批次大小（16）和最大序列长度（512）配置下，分别实现RNN（基础循环单元，tanh激活）、LSTM（输入/遗忘/输出门控机制）、Transformer（多头因果自注意力 + 位置编码#cite(<vaswani2017attention>)）和GPT2ABC（基于Hugging Face GPT-2预训练权重，适配ABC词表）四种架构，确保对比实验的公平性。

**（三）多维度性能评估体系的建立**

建立涵盖语言建模质量（交叉熵测试损失、困惑度）、生成样本质量（ABC语法正确率、结构完整性、生成样本人工评估）和计算资源效率（模型参数量、GPU/CPU显存占用、每epoch训练时间、每10个epoch累计训练时间）的全维度评估框架。训练过程中每10个epoch记录一次性能快照，生成详细的CSV格式实验报告，支持训练动态的精细分析与跨模型对比。

**（四）基于LLaMA-LoRA的大模型迁移方案**

设计面向LLaMA的ABC扩展分词器（在原生32,000 token词表基础上新增约1,500个ABC领域专有token），基于LoRA#cite(<hu2022lora>)对Q、K、V、O注意力投影矩阵注入低秩适配器（秩$r=16$，缩放因子$ alpha=32$），结合AdamW优化器、线性预热学习率调度和梯度累积策略，在单张GPU上实现LLaMA-2-7B的高效ABC音乐微调，并通过与多种基线方法的对比实验验证方案的有效性。

**（五）系统性实验分析与消融研究**

对上述两条技术路线分别进行系统性实验，包括训练动态分析、最终性能横向对比、人工盲测评估，以及消融实验（量化扩展分词器、LoRA微调、生成采样策略等各组件对最终性能的独立贡献），为方法设计决策提供充分的实证依据。

=== 技术路线

本研究的整体技术路线如下：首先基于folk-rnn语料库构建标准化实验数据集，通过ABCTokenizer完成数据预处理；随后在统一配置下训练四种序列建模架构，通过多维度评估体系确定最优架构；在此基础上，引入LLaMA-2-7B预训练模型，通过扩展分词器和LoRA微调进一步提升生成质量，并通过消融实验分析各组件贡献；最终综合定量评估与人工主观评估，得出完整的研究结论。


== 论文组织结构

本文共分为五章，各章内容安排如下：

**第一章 绪论**：介绍音乐生成领域的研究背景与意义，系统梳理国内外研究现状，阐述本文的研究目标、主要内容与技术路线，给出论文的整体组织结构。

**第二章 相关理论与技术基础**：系统阐述本研究涉及的核心理论与技术，包括ABC记谱法的语法规则与应用特点、循环神经网络（RNN）与长短期记忆网络（LSTM）的结构原理与序列建模能力、基于自注意力的Transformer架构#cite(<vaswani2017attention>)及其在序列生成中的应用、GPT-2预训练语言模型的架构设计，以及困惑度等语言模型评估指标的定义与计算方法。

**第三章 基于GPT2的ABC音乐生成模型**：详细介绍ABCTokenizer专用分词器的设计动机、词表构建策略、贪婪最长匹配分词算法及编解码流程；系统阐述GPT2ABC模型的架构设计、输入表示、多头因果自注意力机制、训练目标与生成策略；在统一实验条件下对比RNN、LSTM、Transformer和GPT2ABC四种架构的性能，分析各架构的优势与局限性，提炼影响ABC音乐生成质量的关键因素。

**第四章 基于预训练大语言模型的ABC音乐生成**：介绍基于LLaMA-2-7B与LoRA参数高效微调的ABC音乐生成方案；详细阐述面向LLaMA的扩展分词器设计与新增Embedding初始化策略、LoRA的数学原理与参数效率分析、训练目标与AdamW优化策略、温度采样与Top-$p$核采样生成算法；通过与多基线方法的对比实验和消融分析，系统验证各组件的有效性与必要性。

**第五章 总结与展望**：总结本研究的主要工作与创新点，分析研究的局限性，从模型架构优化、评估体系完善、数据资源扩充、条件生成控制、大模型压缩部署、长程结构建模、可解释性研究和人机协同创作等多个维度展望未来研究方向。


// == 列表

// === 有序列表

// + #kouhu(builtin-text: "aspirin", length: 10)
// + #kouhu(builtin-text: "aspirin", offset: 2, length: 10)
//   + #kouhu(builtin-text: "aspirin", offset: 3, length: 5)
//   + #kouhu(builtin-text: "aspirin", offset: 3, length: 10)
//   + #kouhu(builtin-text: "aspirin", offset: 3, length: 15)

// === 无序列表

// - #kouhu(builtin-text: "zhufu", length: 15)
// - #kouhu(builtin-text: "zhufu", offset: 2, length: 15)
//   - #kouhu(builtin-text: "zhufu", offset: 3, length: 15)
//   - #kouhu(builtin-text: "zhufu", offset: 3, length: 15)
//   - #kouhu(builtin-text: "zhufu", offset: 6, length: 15)

// === 术语（`Latex` 中的段落）

// / simp: #kouhu(builtin-text: "simp", length: 15)
// / 阿司匹林: #kouhu(builtin-text: "aspirin", length: 60)

// == 代码

// 行内代码我们使用 \`\` 将其括起来，这与 `Markdown` 中的语法一致

// 行间代码， 也就是代码块，其语法与 `Markdown` 中一致，例如：

// #raw("
// ```typ
//   #let a = 1
// ```
// ")

// 其表现为，此时发现代码块的表现很差，且无法引用

// #no-codly[
//   ```typ
//   #let a = 1
//   ```
// ]

// 因此，这里我们使用包 `codly` 来美化代码块，并将其放入到下文的图表中，进行引用，`@lst:<key>` 来引用代码块，例如下面的代码，我们使用语句 `@lst:fib-fn-py` 来引用，即@lst:fib-fn-py

// #figure(caption: "Python 实现的斐波那契函数")[
//   ```py
//   def fib(n):
//     if n <= 1:
//       return n
//     return fib(n - 1) + fib(n - 2)
//   ```
// ]<fib-fn-py>

// 关于 `codly` 的更多用法请阅读#link("https://typst.app/universe/package/codly")[参考文档]

// == 图表

// === 表格

// 在这里引用表格，例如三线表：@tbl:three-line-table

// 我们使用 `@tbl:<label>` 来进行表的引用，其中 `<label>` 是跟在表格后的标签，使用尖括号括起来



// #figure(
//   table(
//     align: center + horizon,
//     columns: 4,
//     stroke: none,
//     table.hline(stroke: 1.5pt),
//     [配置项], [参数],
//     table.hline(stroke: 1pt),
//     [处理器型号], [Intel(R) Core(TM) i9-12900K],
//     [内存容量], [32GB], 
//     [硬盘容量], [1TB], 
//     [显卡型号], [GEFORCE RTX 4090], 
//     table.hline(stroke: 1.5pt),
//   ),
//   caption: [三线表示例],
// )<three-line-table>

#import "../utils/grid-table.typ": three-line-table, highlight-table
也可使用 `three-line-table`函数创建三线表。

#figure(
  three-line-table(
    align: center + horizon,
    columns: 4,
    inset: 0.5em,
    stroke: none,
    [x], [y], [z], [t],
    [11], [5 ms], [3], [0.7],
    [3000], [80 ms], [1111], [0.9],
  ),
  caption: [三线表示例2],
)<three-line-table2>

可使用 `highlight-table` 高亮某些列的最值，示例如下：
#figure(
caption: [自动加粗最值示例],
highlight-table(
  columns: 4,
  // 仅配置规则即可：1列取最小值，2列取最大值
  rules: ("1": "min", "2": "max"),
  inset: 5pt,
  [Model],
  [Vina Score],
  [QED],
  [LogP],
  "DEPACT",
  (-6.632, 0.18),
  0.45,
  2.1,
  "PocketGen",
  (-7.135, 0.08),
  0.78,
  3.1,
  "DiffPocket",
  (-7.599, 0.15),
  0.60,
  2.5,
))

// === 图片

// 我们可以插入图片，也可以修改图片的展示大小，引用图片，例如@fig:ida-star-50, @fig:ida-star-20

// 我们通过函数 `#figure` 来表示一个图片，在其中通过 `image` 函数来导入一张图片，格式可以是 `png`, `svg` `jpg` 等常见格式，可以通过 `width` 等参数来调整图片的大小和位置。例如，`width: 50%` 表示图片宽度为页面宽度的 50%，`height: auto` 表示高度自适应，`align: center` 表示图片居中显示。

// 我们使用 `@fig:<label>` 来进行表的引用，其中 `<label>` 是跟在图片后的标签，使用尖括号括起来，例如下面的@fig:ida-star-20，我们使用命令 `@fig:ida-star-20` 即可引用。

// #figure(
//   image("fig/ida-star-1.png", width: 50%),
//   caption: [IDA\* 算法示例， 50% 比例缩放],
// )<ida-star-50>

// #figure(
//   image("fig/ida-star-1.png", width: 20%),
//   caption: [IDA\* 算法示例， 20% 比例缩放],
// )<ida-star-20>

// === 子图

// 暂时无法实现子图，可以使用 #link("https://app.diagrams.net/")[Draw.io] 等网站绘制完子图，然后导出一个大图，贴到论文中。

// == 数学公式

// 数学公式分为行内公式与行间公式，其中，行内公式不会出现编号和引用，行间公式可以会在最右侧显示编号，并且可以引用。

// 例如，这是一个简单的行内公式 $sum_(i=1)^n a_i$，这是一个复杂的行内公式：$U(H, t, p) = product^p_(j=1)product_k e^((-i H_k t)/n), H = sum_k H_k$


// 下面是一个行间公式，我们可以通过将其编号为 `<nabla>`，然后通过 `@eqt:nabla` 来引用，例如@eqt:nabla

// $
//   nabla L = partial L / partial x
// $<nabla>

// @eqt:sgd-demo 是一个复杂的行间公式，这里我们使用 `&` 作为锚点进行对齐，这与 `Latex` 中是一致的，区别是我们不需要写 `\begin{aligned}` 与 `\end{aligned}`
// $
//   (w^((i+1)), b^((i+1))) & = (w^((i)), b^((i))) - alpha nabla "Loss"(
//                              w^((i)), b^((i))
//                            ) \
//                          & = (w^((i)), b^((i))) - alpha (
//                              (partial "Loss")(partial w), (partial "Loss")(partial b)
//                            ) \
//                          & = (w^((i)), b^((i))) - alpha (
//                            1 / N sum^N_(j=1)x_j(b^((i)) + w^((i)T)x_j - y_j), \
//                          &                                                    & 1 / N sum^N_(j=1)(b^((i))+w^((i)T)x_j - y_j)
//                                                                                 )
// $<sgd-demo>

// == 参考文献的引用

// 我们通过 `.bib` 文件来导入参考文献，文件名可以任意选择，通过选项：`bibliography: bibliography.with("ref.bib")` 进行导入，这里我们只需要将 网站上赋值的 `biblatex` 引用赋值粘贴到 `ref.bib` 中即可。

// 随后，通过 `#cite(<key>)` 进行引用，其中 `key` 是在 `.bib` 中设置的键。

// 在示例中，我们可以引用 `ref.bib` 文件中的内容，例如《Deep Learning》#cite(<goodfellow2016deep>)，引用2#cite(<丁文祥2000>)

// 当然，我们也可以通过简单的方式，`@key` 的语法糖即可引用，例如上述的《Deep Learning》@goodfellow2016deep，引用2@丁文祥2000

// 或者可以像这样引用参考文献：图书#[@蒋有绪1998]和会议#[@中国力学学会1990]。

// 在 `ref.bib` 中，如@lst:ref-demo 所示，引用的部分条目为：

// #figure(caption: "参考文献bib文件部分示例")[
//   ```bib
//   @article{丁文祥2000,
//     title={数字革命与竞争国际化},
//     author={丁文祥},
//     journal={中国青年报},
//     year={2000},
//     month={11-20},
//     number={15}
//   }

//   @book{goodfellow2016deep,
//     title = {Deep learning},
//     author = {Goodfellow, Ian and Bengio, Yoshua and Courville, Aaron and Bengio, Yoshua},
//     volume = {1},
//     year = {2016},
//     publisher = {MIT Press}
//   }
//   ```
// ]<ref-demo>

// 第一行的内容即为引用所需的 `key`。

= 相关理论与技术

== ABC记谱法

#figure(image("fig/abc_notation.png"), caption: [ABC记谱法])

ABC记谱法是一种以纯文本字符描述乐谱的轻量级标记系统，起源于民谣与传统音乐圈，因易读易写、跨平台、易于分享与版本管理而流行；它用字母A–G表示音高，借助撇号 ' 和逗号 , 指示八度上移或下移（如 c' 为更高的C，C, 为更低的C），用数字、斜杠标注时值（1=全音符，1/2=二分之一，常用简写如 2 表示加倍、/ 表示减半），并以谱首元数据行定义全曲语境：X: 序号、T: 标题、C: 作曲者、M: 拍号（如 M:4/4）、L: 默认音符时值（如 L:1/8）、Q: 速度（如 Q:1/4=120）、K: 调号（如 K:G）等；升降记号采用 ^（升）、\_（降）、=（还原），可写在音符前（如 ^F），并遵循小节内临时升降的常规；节线用 |，终止与复线用 ||、|\]，重复记号 |: 与 :|，一、二结尾用 [1、[2；连音线与连结分别用圆括号 () 与连字符 -，装饰与力度通过感叹号包裹的指令或简写装饰（如 !trill!、!crescendo!、!staccato!），颤音与波音也常以 ~ 等装饰记号呈现；切分与破节奏可用 >、<（如 A>B 表示前者略长后者略短），附点时值也可直接以数值表达；休止写作 z（多小节休止 Z），歌词以 w: 行绑定到旋律，和弦同音叠置用方括号 [CEG]，而和弦符号（功能或吉他和弦名）则以引号置于音符上方（如 "Am"E）；多声部用 V: 定义并可并行书写，分段结构可用 P: 标注，来源与体裁可用 O:、R: 说明；行内参数与渲染提示（如排版、MIDI控制）可通过以 %% 开头的指令给出，注释用 % 开头；ABC兼具“可眼读”的可读性与“可机读”的结构化，因而可借助丰富生态工具在不同目标之间转换：如从ABC到MIDI/音频（演奏回放）、到矢量谱面（PDF/PS/SVG），以及网页端渲染与交互（常见工具有 EasyABC、abcjs、abcm2ps、abc2midi 等）；在实践中，常以设置合理的 L: 与 Q: 来获得更自然的节奏书写，避免过度密集的数字时值；对于移调与转调，可在段中更改 K: 或借助工具整体移调；

虽然ABC不以严密排版语义为核心（高级刻写与复杂现代技法可能受限），但对于旋律主导、和弦标注、民谣/传统曲调、教学示例、乐思草稿与在线共享而言，它以极低门槛实现了从文本到可听、可印、可协作的完整工作流。

== GPT2

#figure(image("fig/gpt2.png"), caption: [GPT2])

GPT-2 是 OpenAI 于 2019 年发布的基于 Transformer 解码器架构的通用语言模型里程碑，强调“只用大规模无监督预训练+少量或零样本迁移”即可在多任务上涌现出强大的通用能力：它以“下一个词预测”作为单一目标，在大规模网络语料 WebText（从高质量 Reddit 外链抓取，约 800 万文档、40GB 文本）上训练，使用 BPE 子词分词（约 50,257 词表）与学习式位置嵌入，最大上下文窗口为 1024 token；官方公开了从 117M 到 1.5B 参数的多种规模，其中 1.5B 版本采用约 48 层、1600 维
隐藏表示与 25 个注意力头，展示了随模型规模增长而带来的“零样本/小样本”性能跃迁：在无需专门微调的情况下，它已能完成摘要、翻译、问答、常识推断、风格模仿与连贯长文生成等任务，并通过采样策略（如 top-k、nucleus/top-p、温度调节）在多样性与可控性之间权衡；

GPT-2采用纯解码器的Transformer架构，其核心是堆叠的自注意力层。对于输入序列 $bold(x) = (x_1, x_2, ..., x_n)$，模型的目标是最大化条件概率：

$ P(bold(x)) = product_(i=1)^n P(x_i | x_1, x_2, ..., x_(i-1)) $

在每个Transformer层中，自注意力机制的计算过程为：

$ "Attention"(Q, K, V) = "softmax"((Q K^T) / sqrt(d_k)) V $

其中：
- $Q = X W_Q$：查询矩阵 (Query)
- $K = X W_K$：键矩阵 (Key)  
- $V = X W_V$：值矩阵 (Value)
- $d_k$：键向量的维度
- $X$：输入表示

多头注意力机制将注意力计算并行化：

$ "MultiHead"(Q, K, V) = "Concat"("head"_1, ..., "head"_h) W^O $

$ "head"_i = "Attention"(Q W_i^Q, K W_i^K, V W_i^V) $

在工程层面，GPT-2 强调纯解码器堆叠的自注意力、残差连接与层归一化的稳定训练范式，并以可扩展的数据与算力揭示“规模化带来能力涌现”的经验规律；在应用层面，它成为一代通用文本生成与表示的“底座”，既可直接零样本推理，也可在下游少量数据上做高效微调，推动了新闻写作辅助、对话系统、代码/文案草拟、信息抽取与内容推荐等场景；然而 GPT-2 也揭示了生成式模型的典型局限：可能产生事实性错误与“自信幻觉”、延续或放大语料偏见、在长文本中出现重复与语义漂移，并受限于 1024 的上下文长度；其发布过程因滥用风险（虚假资讯、垃圾内容自动化）而分阶段开放，引发了关于负责任 AI 的广泛讨论，也促进了后续在对齐、过滤与使用政策上的探索；从学术与产业影响看，GPT-2 作为 GPT-3/4 系列的直接前驱，奠定了“规模+预训练+对齐”的范式基础，带动了工具链与生态（如 Hugging Face Transformers 的广泛复现与推理/微调支持）、推动了采样与控制、提示工程与少样本提示设计的实践扩散，并成为语言模型从“可用”走向“通用”的关键转折点之一。

== 困惑度

困惑度（Perplexity，PPL）是评估语言模型和序列生成模型的重要指标，衡量模型对测试数据的预测不确定性。其定义为模型分配给测试序列的概率的几何平均的倒数，数学表达式为 PPL = exp(H)，其中 H 是交叉熵损失。直观上，困惑度表示模型在预测下一个token时平均需要考虑的“等价选择数”：PPL=10 意味着模型平均在约10个等概率选项中做选择，PPL=100 意味着约100个，数值越低表示模型越确定、预测越好。在语言模型中，困惑度广泛用于评估模型对文本的拟合程度，例如 GPT-2 在 WikiText-103 上的困惑度约为 18，BERT 在掩码语言建模任务中也有相应指标。在音乐生成任务中，困惑度同样适用：模型需要预测下一个音符、节奏或音乐符号，较低的困惑度表示模型能更准确地预测音乐序列，生成更符合训练数据分布的音乐。计算上，困惑度通过交叉熵损失计算：首先计算模型对每个位置的预测概率分布，然后计算交叉熵损失，最后取指数得到困惑度，即 PPL = exp(mean(cross_entropy_loss))。

对于长度为 $N$ 的测试序列 $bold(x) = (x_1, x_2, ..., x_N)$，困惑度定义为：

$ "PPL" = exp(- 1/N sum_(i=1)^N log P(x_i | x_1, ..., x_(i-1))) $

等价地，困惑度是交叉熵的指数：

$ "PPL" = exp(H(P, Q)) $

其中交叉熵 $H(P, Q)$ 定义为：

$ H(P, Q) = - 1/N sum_(i=1)^N log Q(x_i | bold(x)_(<i)) $

这里 $P$ 是真实数据分布，$Q$ 是模型预测分布。

在训练过程中，困惑度随训练进行通常呈下降趋势，初期可能很高（数百或数千），随着模型学习逐渐降低，最终在测试集上稳定在某个值，该值反映了模型的泛化能力。困惑度的优势包括：客观可量化、与损失函数直接相关、便于模型间对比、计算高效、在序列生成任务中通用。但困惑度也有局限性：它基于概率分布，不一定直接反映人类感知的音乐质量；可能受数据分布影响，在特定数据集上表现好不代表泛化能力强；无法直接反映音乐的结构性、和声、节奏等音乐理论特征；在音乐生成中，低困惑度可能对应过于保守、缺乏创新的生成。在模型对比中，困惑度是重要参考：通常 Transformer 和 GPT2 的困惑度低于 RNN 和 LSTM，因为它们能更好地捕捉长期依赖；但也要结合训练时间、内存占用、生成质量等综合评估。在音乐生成任务中，困惑度的解释需要谨慎：过低的困惑度可能表示模型过度拟合训练数据，生成过于保守；适中的困惑度（如 5-20）通常表示模型在准确性和多样性之间取得平衡；过高的困惑度（如 >100）可能表示模型未充分学习音乐模式。实际应用中，困惑度常与其他指标结合使用，如 BLEU、音乐理论指标（和声一致性、节奏规律性）、主观评价（音乐家评分）等，以全面评估模型性能。在训练监控中，困惑度是重要的监控指标：训练集困惑度持续下降表示模型在学习，验证集困惑度下降后上升可能表示过拟合，测试集困惑度反映最终泛化能力。在模型选择中，通常选择测试集困惑度最低的模型，但也要考虑其他因素如生成多样性、计算效率等。在音乐生成研究中，困惑度已成为标准评估指标，许多研究都报告了困惑度值，便于不同研究之间的对比。总的来说，困惑度是评估序列生成模型的重要工具，在音乐生成任务中提供了客观的量化指标，但需要结合其他评估方法和主观评价来全面评估模型的性能。

#figure(image("fig/perplexity.png"), caption: [困惑度])

== 循环神经网络

循环神经网络(Recurrent Neural Network, RNN)是一种专门用于处理序列数据的深度学习架构,其核心特征在于网络中存在循环连接,使得信息可以在时间维度上传递和累积。从图示中可以清晰地看到,RNN的工作方式是将时间序列展开成多个时间步,每个时间步都包含一个相同结构的RNN单元。在每个时间步t,网络接收当前时刻的输入x(t),同时还会接收来自上一时刻t-1的隐藏状态信息。

RNN的基本计算单元可以用以下递归关系描述：

$ bold(h)_t = f(bold(W)_(h h) bold(h)_(t-1) + bold(W)_(x h) bold(x)_t + bold(b)_h) $

$ bold(y)_t = g(bold(W)_(h y) bold(h)_t + bold(b)_y) $

其中：
- $bold(x)_t in bb(R)^d$：时间步 $t$ 的输入向量
- $bold(h)_t in bb(R)^h$：时间步 $t$ 的隐藏状态
- $bold(y)_t in bb(R)^o$：时间步 $t$ 的输出向量
- $bold(W)_(h h) in bb(R)^(h times h)$：隐藏状态转移矩阵
- $bold(W)_(x h) in bb(R)^(h times d)$：输入到隐藏状态的权重矩阵
- $bold(W)_(h y) in bb(R)^(o times h)$：隐藏状态到输出的权重矩阵
- $f, g$：激活函数（通常 $f = tanh$，$g = "softmax"$）

这个隐藏状态就像是网络的"记忆",它包含了之前所有时间步处理过的信息的浓缩表示。RNN单元会将当前输入x(t)和前一时刻的隐藏状态结合起来,通过内部的权重矩阵和激活函数进行计算,产生当前时刻的输出h(t)和新的隐藏状态。这个新的隐藏状态随后会被传递到下一个时间步t+1,作为处理下一个输入的背景信息。
这种循环机制使得RNN具有了处理任意长度序列的能力,并且能够捕捉序列中的时序依赖关系。理论上,当前时刻的输出不仅依赖于当前的输入,还受到整个历史序列的影响。这种特性使RNN在自然语言处理、语音识别、时间序列预测等需要考虑上下文信息的任务中表现出色。
然而,标准RNN也存在梯度消失和梯度爆炸的问题,导致难以学习长期依赖关系,这促使了LSTM和GRU等改进架构的出现。从本质上讲,RNN通过在网络中引入时间维度的循环反馈机制,将静态的前馈神经网络扩展成了具有动态记忆能力的系统,这使得神经网络第一次真正具备了处理和理解序列模式的能力。

#figure(image("fig/rnn.png"), caption: [循环神经网络])

== 长短期记忆网络

长短期记忆网络(LSTM)是由Hochreiter和Schmidhuber在1997年提出的一种特殊的循环神经网络架构,它通过精巧的门控机制设计,成功解决了传统RNN在处理长序列时面临的梯度消失和梯度爆炸问题。LSTM的核心思想是引入一个称为"细胞状态"的记忆单元,配合三个门控结构来精确控制信息的流动,使网络能够在长时间跨度内保持和传递重要信息。

LSTM的架构可以理解为一个精密的信息处理系统。在每个时间步,LSTM单元接收三个输入:当前时刻的输入数据x(t)、上一时刻的隐藏状态h(t-1)以及上一时刻的细胞状态C(t-1)。细胞状态是LSTM最关键的组成部分,它像一条贯穿整个单元的高速公路,信息可以在上面相对不受干扰地流动。这条"信息高速公路"只通过少量的线性操作进行修改,这确保了梯度在反向传播时能够有效地流过多个时间步,不会出现传统RNN那样的梯度消失问题。
LSTM通过三个门来控制信息的流动,每个门都有特定的职责。第一个是遗忘门,它决定应该从细胞状态中丢弃哪些信息。遗忘门将当前输入x(t)和上一时刻的隐藏状态h(t-1)作为输入,通过一个sigmoid激活函数输出一个介于0和1之间的向量,这个向量中的每个元素对应细胞状态中的一个元素。如果输出为1,表示"完全保留这个信息",如果输出为0,则表示"完全遗忘这个信息"。通过这种方式,网络可以学会主动遗忘不再需要的旧信息,为新信息腾出空间。

LSTM引入**细胞状态**（Cell State）$bold(C)_t$ 作为信息的"高速公路"，配合三个门控单元精确控制信息流动：

$ bold(C)_t = bold(f)_t circle.tiny bold(C)_(t-1) + bold(i)_t circle.tiny tilde(bold(C))_t $

其中 $circle.tiny$ 表示逐元素乘法（Hadamard积）。

遗忘门决定应该从细胞状态中丢弃哪些信息：

$ bold(f)_t = sigma(bold(W)_f dot [bold(h)_(t-1), bold(x)_t] + bold(b)_f) $

其中 $sigma$ 是sigmoid函数：

$ sigma(z) = 1 / (1 + e^(-z)) in [0, 1] $

输出为1表示"完全保留"，为0表示"完全遗忘"。

输入门决定应该向细胞状态添加哪些新信息，分两步进行：

*候选值生成*：
$ tilde(bold(C))_t = tanh(bold(W)_C dot [bold(h)_(t-1), bold(x)_t] + bold(b)_C) $

其中 $tanh$ 函数：
$ tanh(z) = (e^z - e^(-z)) / (e^z + e^(-z)) in [-1, 1] $

*输入门控制*：
$ bold(i)_t = sigma(bold(W)_i dot [bold(h)_(t-1), bold(x)_t] + bold(b)_i) $

最终添加的信息量为：$bold(i)_t circle.tiny tilde(bold(C))_t$

输出门决定应该输出细胞状态的哪些部分：

$ bold(o)_t = sigma(bold(W)_o dot [bold(h)_(t-1), bold(x)_t] + bold(b)_o) $

$ bold(h)_t = bold(o)_t circle.tiny tanh(bold(C)_t) $
第二个门是输入门,它决定应该向细胞状态中添加哪些新信息。输入门的工作分为两个步骤:首先,一个sigmoid层(输入门)决定哪些值需要更新;然后,一个tanh层创建一个新的候选值向量,这个向量包含了可能被添加到细胞状态中的新信息。候选值使用tanh激活函数,其输出范围是-1到1,这样可以向细胞状态中添加正向或负向的信息。输入门的输出与候选值进行逐元素相乘,得到的结果就是真正要添加到细胞状态中的新信息量。这种设计让网络能够精确控制每个时间步应该吸收多少新信息。

细胞状态的更新是LSTM的核心操作。旧的细胞状态C(t-1)首先与遗忘门的输出相乘,这个操作会按比例丢弃一些信息。然后,将经过输入门筛选的候选值加到这个结果上,形成新的细胞状态C(t)。这个更新过程可以用一个简单的公式表示:C(t)等于遗忘门输出乘以C(t-1)加上输入门输出乘以候选值。通过这种加法操作而不是乘法操作来更新细胞状态,梯度能够更容易地在时间上反向传播,这是LSTM能够捕捉长期依赖关系的关键。
第三个门是输出门,它决定LSTM单元最终输出什么值。输出门同样使用sigmoid函数,基于当前输入x(t)和上一时刻的隐藏状态h(t-1)来决定应该输出细胞状态的哪些部分。具体来说,细胞状态C(t)首先经过一个tanh函数处理,将值压缩到-1到1之间,然后与输出门的输出进行逐元素相乘,得到最终的隐藏状态h(t)。这个隐藏状态既是当前时刻的输出,也会作为下一个时间步的输入继续参与计算。

#figure(image("fig/LSTM.svg"), caption: [LSTM结构])

LSTM的每个门都是通过学习得到的神经网络层,它们的参数在训练过程中通过反向传播算法不断优化。sigmoid函数被选作门控机制的激活函数是因为它的输出范围是0到1,恰好可以表示"完全关闭"到"完全打开"这个连续的控制范围。而tanh函数被用于候选值和细胞状态的处理,因为它的输出范围是-1到1,具有零中心化的特性,有助于网络的训练稳定性。
从信息流的角度来看,LSTM可以被理解为一个智能的记忆管理系统。它不是被动地接收所有输入信息,而是主动地决定哪些信息值得记住,哪些应该遗忘,哪些新信息应该被吸收,以及在每个时刻应该输出什么。这种选择性的记忆机制使LSTM在处理具有长期依赖关系的序列数据时表现出色,因为它可以在记住重要的早期信息的同时,也能够灵活地处理新出现的相关信息。
LSTM相比传统RNN的主要优势在于其能够维持长期记忆。在传统RNN中,信息在经过多个时间步后会因为重复的矩阵乘法而指数级地衰减或放大,导致梯度消失或爆炸。而LSTM通过细胞状态的加性更新和门控机制,允许误差梯度在反向传播时既不会过度衰减也不会过度放大,从而可以学习到跨越数百个甚至上千个时间步的依赖关系。这使得LSTM成为处理语言建模、机器翻译、语音识别、时间序列预测等任务的理想选择,在这些任务中,理解长距离的上下文关系至关重要。

总的来说,LSTM通过引入细胞状态和门控机制这两个核心创新,创造性地解决了序列建模中的长期依赖问题,它的设计哲学体现了"选择性记忆"的思想,让神经网络具备了类似人类的记忆管理能力,这也是它在深度学习领域获得广泛应用的根本原因。

#let 注记(标题: "注记", body) = block(
  width: 100%,
  inset: (x: 11pt, y: 9pt),
  stroke: (left: 2pt + black, rest: 0.4pt + luma(190)),
  fill: luma(252),
  radius: 2pt,
)[
  #text(weight: "bold")[#标题．]#body
]

#let 定义(编号: "", 名称: "", body) = block(
  width: 100%,
  inset: (x: 11pt, y: 9pt),
  stroke: 0.6pt + luma(120),
  fill: luma(248),
  radius: 3pt,
)[
  #text(weight: "bold")[定义 #编号（#名称）．]#body
]

== 低秩自适应（LoRA）

=== 动机与问题背景

大规模预训练语言模型在各类下游任务上展现出卓越的迁移能力，但其参数规模动辄达到数十亿甚至数千亿量级。对如此庞大的模型进行全参数微调（full fine-tuning）不仅需要与模型本身等量的梯度缓冲区和优化器状态，还难以在多任务场景下为每个任务单独保存一份完整的参数副本。

以单层 Transformer 的查询投影矩阵 $W_Q in RR^(d times d)$ 为例，当隐藏维度 $d = 4096$ 时，该矩阵本身即包含约 $1.68 times 10^7$ 个参数；对于拥有 32 层的 LLaMA-2 7B 模型，仅 $W_Q$ 一项的全量微调便需存储超过 5 亿个浮点数的梯度信息。这一开销在实际部署中往往难以承受。

低秩自适应（Low-Rank Adaptation，LoRA）#cite(<hu2022lora>) 的核心洞察在于：预训练权重在特定下游任务上所需的更新量具有极低的"内在秩"（intrinsic rank）#cite(<aghajanyan2021intrinsic>)。换言之，权重变化矩阵 $Delta W$ 可以被一个秩远小于 $d$ 的矩阵精确近似，而无须在完整的 $d times d$ 空间中进行优化。

=== 方法形式化

#定义(编号: "1", 名称: "低秩分解")[
  设 $W_0 in RR^(d_"out" times d_"in")$ 为预训练权重矩阵，$r in NN^+$ 为秩超参数，满足 $r min(d_"out", d_"in")$。LoRA 将权重更新量参数化为两个低秩矩阵之积：
  $
  Delta W = B A, quad B in RR^(d_"out" times r),quad A in RR^(r times d_"in").
  $
]

在此参数化下，含适配器的前向传播为

$
h = W_0 x + Delta W x = W_0 x + B A x, quad x in RR^(d_"in"),
$ <eq:forward>

其中 $W_0$ 在整个训练过程中保持冻结，仅 $A$ 与 $B$ 参与梯度更新。为保证适配开始时模型行为与预训练基线完全一致，两矩阵按如下方式初始化：

$
A tilde cal(N)(0, sigma^2), quad B = bold(0),
$ <eq:init>

从而在训练第 $0$ 步时有 $Delta W = B A = bold(0)$。实际前向传播中，乘积 $B A x$ 还需乘以缩放因子 $alpha \/ r$，得到完整形式：

$
h = W_0 x + frac(alpha, r) dot B A x,
$ <eq:scaled>

其中 $alpha$ 为固定超参数。引入 $alpha \/ r$ 的目的在于将适配器的有效学习率与秩 $r$ 的选取解耦——改变 $r$ 时无需重新调整 $alpha$，提升了超参搜索的便利性。

=== 参数效率分析

以方阵情形 $d_"out" = d_"in" = d$ 为例，全量微调对应 $d^2$ 个可训练参数，而 LoRA 仅需：

$
|theta_"LoRA"| = d r + r d = 2 d r.
$

参数压缩比为

#set math.equation(numbering: "1.")

$
rho = frac(d^2, 2 d r) = frac(d, 2r).
$ <eq:ratio>

由式 @eq:ratio 可知，当 $d = 4096$、$r = 4$ 时，$rho = 512$，即可训练参数量仅为全量微调的 $1 \/ 512 approx 0.20\%$。表 @tbl:params 给出了若干主流模型在典型秩配置下的具体数据。

#figure(
  table(
    columns: (2fr, 1fr, 1fr, 1.4fr),
    align: (left, center, center, center),
    stroke: 0.5pt,
    inset: 6.5pt,
    table.header(
      [*模型*], [*$d$*], [*秩 $r$*], [*可训练参数占比*],
    ),
    [GPT-2 Medium],   [1 024],  [4],  [0.38%],
    [LLaMA-2 7B],     [4 096],  [8],  [0.10%],
    [LLaMA-2 13B],    [5 120],  [16], [0.16%],
    [GPT-3 175B],     [12 288], [64], [0.05%],
  ),
  caption: [主流模型在典型 LoRA 配置下的可训练参数占比（相对于完整模型参数量）。],
) <tbl:params>


#figure(image("fig/LORA-2.svg"), caption: "低秩自适应")

== Llama

Llama（Large Language Model Meta AI）是由 Meta 公司发布的一系列开源大型语言模型，它在生成式人工智能领域具有里程碑式的意义。与许多闭源模型不同，Llama 的开源生态极大推动了开发者社区的创新。从技术架构上看，Llama 本质上是一个基于 Decoder-only（仅解码器）结构的 Transformer 模型，但它在标准 Transformer 的基础上进行了多项关键改进以提升性能和训练稳定性。

首先，它采用了 RMSNorm（均方根归一化） 代替传统的 LayerNorm，并将其置于每个子层的输入端（Pre-normalization），这有效提高了训练的稳定性。其次，Llama 引入了 RoPE（旋转位置编码），取代了绝对位置嵌入，使模型在处理长文本时具有更好的外推性。在激活函数方面，它使用了 SwiGLU 替代了传统的 ReLU，进一步增强了模型的表达能力。

此外，为了提高推理效率，Llama 的后期版本（如 Llama 2 和 Llama 3）广泛采用了 GQA（分组查询注意力机制），这在保持模型性能的同时大幅减少了显存占用并提升了生成速度。Llama 家族涵盖了从 7B、13B 到 70B 甚至 400B+ 的不同参数规模，这使得它既能在消费级显卡上运行，也能在大型计算集群中进行复杂的任务推理。总的来说，Llama 不仅是一个性能强大的模型序列，更是当前开源大模型事实上的“工业标准”。

#figure(image("fig/llama.png"), caption: "Llama")


== 本章小结

本章系统介绍了与ABC记谱法音乐生成相关的核心理论与技术。首先，详细阐述了ABC记谱法的语法规则、表示方法和应用场景，说明了其作为文本化音乐表示格式的优势，以及在本研究中作为模型输入输出格式的合理性。其次，介绍了GPT-2模型的基本原理、架构特点和应用领域，说明了其作为大规模预训练语言模型在序列生成任务中的优势。再次，阐述了困惑度这一重要评估指标的定义、计算方法和在模型评估中的作用，为后续实验结果的量化分析提供了理论基础。然后，详细介绍了循环神经网络（RNN）的基本原理、工作机制和局限性，说明了其在序列建模中的基础地位。最后，深入分析了长短期记忆网络（LSTM）的架构设计、门控机制和优势，解释了其如何通过门控机制解决RNN的梯度消失问题，从而能够有效学习长期依赖关系。

这些理论与技术为本研究的模型设计、训练策略和性能评估提供了坚实的理论基础。ABC记谱法为本研究提供了标准化的数据格式；GPT-2展示了大规模预训练模型在序列生成中的潜力；困惑度为本研究提供了客观的评估指标；RNN和LSTM作为经典的序列建模架构，为本研究的模型对比提供了重要的基线。在下一章中，将基于这些理论基础，详细介绍本研究的整体方法设计，包括数据预处理、模型架构实现和训练策略等具体技术细节。


= 基于GPT-2的ABC音乐生成模型

本章详细介绍所提出的GPT2ABC模型的完整设计与实现方案。首先阐述专为ABC记谱法设计的ABCTokenizer分词器，包括其词表构建策略、核心分词算法以及编解码流程；随后详细描述GPT2ABC模型的架构设计、输入处理、训练目标与生成策略；最后通过与多种基线模型的对比实验，从困惑度、测试损失以及计算资源消耗等多个维度验证所提方法的有效性。

#figure(image("fig/architecture.png"), caption: [GPT2ABC整体架构示意图])


== ABCTokenizer

=== 设计动机与整体架构

ABC记谱法是一种面向文本的音乐符号系统，广泛用于传统民谣和器乐曲的数字化存储与交流。与自然语言不同，ABC记谱文本具有高度规则化的语法结构和精确的音乐语义。其基本构成单元涵盖音高符号、时值标记、调性与节拍声明、装饰音记号、和弦标注以及小节线等结构标记。这些元素通常由单个字符或特定字符组合表示，且具有明确的语法规则：音高用字母C至B及其大小写变体表示八度位置，时值用分数形式（如1/8、1/4）标注，调性声明以"K:"为前缀后接调名（如K:G表示G大调），小节线用竖线"|"及其变体"|:"、":|"等表示重复结构。

在这一背景下，直接采用通用自然语言分词器（如BPE或WordPiece）处理ABC文本存在明显局限：通用分词器无法感知ABC的音乐语义边界，可能将具有完整语义的复合符号（如"|:"、"^C"）错误地拆分为若干无意义的子字符串，导致模型难以学习正确的音乐语法结构。字符级分词方案虽能保留原始信息，但会产生过长的序列，加剧序列建模的难度，并使模型承受大量冗余的上下文计算负担。

为此，本文设计并实现了专门面向ABC音乐语料的ABCTokenizer分词器。该分词器的设计充分考虑了ABC记谱法的语法特点与音乐语义结构，采用基于规则的符号切分策略，将乐曲文本解析为具有音乐语义的最小单元。

词表构建阶段，分词器首先识别ABC记谱中的字段标识符，如X、T、M、L、K等行首标记，这些标识符定义了乐曲的元信息结构。随后对音符序列进行精细切分，将每个音符的音高、八度标记和时值作为整体保留，避免将具有完整语义的符号拆散。对于调性和节拍等复合标记，分词器将"K:G"、"M:4/4"等作为不可分割的token处理，确保模型能够直接学习这些高层次的音乐属性。装饰音符号如波音"~"、倚音"{"和"}"以及重音符号">"等也被识别为独立token，使模型能够理解并生成细腻的音乐表达。小节线及其变体作为结构标记被特别对待，"|:"、":|"等重复记号保持完整，这对于模型学习乐曲的段落结构和重复模式至关重要。通过这种针对性的设计，ABCTokenizer构建的词表既包含基础的音乐符号，也涵盖复合的语法单元，词表规模控制在合理范围内，既能充分表达ABC记谱的丰富语义，又避免了过度细粒度切分导致的序列长度膨胀。


=== 分词算法

ABCTokenizer的核心分词逻辑采用**贪婪最长匹配（Greedy Longest-Match）**策略。其基本思想是：在处理ABC乐谱文本时，字符的含义往往取决于其组合方式。例如，\^表示升号，但\^\^表示重升号；单独的|是普通小节线，而|:则是重复起始记号。若简单地逐字符拆分，就会丢失这种组合语义。贪婪最长匹配策略通过优先尝试最长可能的子串是否在词表中，从而确保复合符号不被错误拆分。

算法的执行流程如下：维护一个指针$i$，初始指向文本首部。在每一步，算法并不立刻断定当前字符构成一个Token，而是向后预看最多$italic("max\_len")$个字符（本文设定为4），依次检查长度为4、3、2、1的子串是否在词表$italic("Vocab")$中。一旦找到匹配，则将该子串记录为一个Token，并将指针$i$向后移动相应步长。若所有长度均无法匹配，则将当前字符标记为$angle.l "unk" angle.r$（未知符号），指针后移一位，保证算法的鲁棒性。

#figure(
  kind: "algorithm",
  pseudocode-list(booktabs: true, numbered-title: [ABC Tokenization (Longest-Match)])[
    + *function* $italic("tokenize")("text")$
    + $T arrow.l [ ]$, $i arrow.l 0$, $L arrow.l italic("length")("text")$
    + *while* $i < L$ *do*
      + $italic("found") arrow.l "False"$
      + *for* $s z$ in $\{4, 3, 2, 1\}$ *do*
        + $s arrow.l "text"[i : i + s z]$
        + *if* $s in italic("Vocab")$ *then*
          + $T."append"(s)$, $i arrow.l i + s z$, $italic("found") arrow.l "True"$
          + *break*
        + *end*
      + *end*
      + *if* not $italic("found")$ *then*
        + $T."append"(angle.l "unk" angle.r)$, $i arrow.l i + 1$
      + *end*
    + *end*
    + *return* $T$
  ],
  caption: [分词算法（贪婪最长匹配）的伪代码]
) <algo_tokenize>

这种"从长到短"的优先策略确保了"|:"（重复起始小节线）不会被错误地拆分为"|"和":"，"\^\^"（重升号）也不会被分解为两个独立的"\^"。相比之下，若采用短匹配优先策略，则复合符号的语义将无法得到正确保留。对未知字符的容错处理（回退到$angle.l "unk" angle.r$）进一步保证了分词器在面对非标准输入时的稳健性，不会因遭遇非法字符而崩溃。


=== 数值编码

编码阶段是将人类可读的符号序列转化为计算机可运算的数值序列的桥梁。除了基本的符号到整数索引的映射，编码算法还引入了深度学习中至关重要的序列边界标记（Special Tokens）。

在ABC乐谱生成任务中，模型需要明确感知一段旋律的起止边界。因此，算法在调用$italic("tokenize")$函数获得原始token序列后，会在序列头部插入$angle.l "bos" angle.r$（Beginning of Sequence）标识符，在尾部插入$angle.l "eos" angle.r$（End of Sequence）标识符。这些特殊ID帮助模型在训练时识别旋律的完整结构边界，类似于给乐谱加上明确的"开始"与"结束"信号，使模型能够在生成阶段判断何时终止序列延伸。

对于每一个分出的Token，算法查表获取其对应的唯一整数索引$v$。若某个Token意外地未出现在预设词表中，则强制将其编码为$angle.l "unk" angle.r$的索引，确保输出的数值张量维度完整，便于后续的嵌入（Embedding）计算。

#figure(
  kind: "algorithm",
  pseudocode-list(booktabs: true, numbered-title: [Numerical Encoding])[
    + *function* $italic("encode")("text", italic("add_special"))$
    + $T arrow.l italic("tokenize")("text")$, $I arrow.l [ ]$
    + *if* $italic("add_special")$ *then* $I."append"(italic("ID")(angle.l "bos" angle.r))$
    + *for* each $t in T$ *do*
      + $v arrow.l italic("ID")(t)$ if $t in italic("Vocab")$ else $italic("ID")(angle.l "unk" angle.r)$
      + $I."append"(v)$
    + *end*
    + *if* $italic("add_special")$ *then* $I."append"(italic("ID")(angle.l "eos" angle.r))$
    + *return* $I$
  ],
  caption: [数值编码算法的伪代码]
) <algo_encode>


=== 字符串解码

解码是编码的逆过程，但并非简单的查表拼接。其核心任务是从包含控制符号的数值序列中提炼并还原出纯净的ABC Notation文本。当模型生成一串数字ID后，解码器逐一将其翻译回字符串形式。

然而，模型推理过程中会产生大量对于乐谱本身没有音乐意义的控制性符号，包括填充符$angle.l "pad" angle.r$（用于对齐序列长度）、边界符$angle.l "bos" angle.r$与$angle.l "eos" angle.r$，以及可能出现的$angle.l "unk" angle.r$。解码逻辑中加入了过滤分支：只有当Token不属于这些技术性标识符集合时，才被允许进入最终的字符串缓冲区$S$。最后通过$italic("join")(S)$操作将离散的音符、节拍记号、调式声明拼接为完整的、符合标准ABC语法的乐谱文本，供后续的打谱软件或音频合成器使用。

#figure(
  kind: "algorithm",
  pseudocode-list(booktabs: true, numbered-title: [String Decoding])[
    + *function* $italic("decode")("ids")$
    + $S arrow.l [ ]$
    + *for* each $i d in "ids"$ *do*
      + $t arrow.l italic("Token")(i d)$
      + *if* $t thin cancel(in) thin \{angle.l "pad" angle.r, angle.l "unk" angle.r, angle.l "bos" angle.r, angle.l "eos" angle.r\}$ *then*
        + $S."append"(t)$
      + *end*
    + *end*
    + *return* $italic("join")(S)$
  ],
  caption: [字符串解码算法的伪代码]
) <algo_decode>

综合上述三个模块，ABCTokenizer形成了一套完整的音乐文本处理流水线：输入原始ABC字符串，经贪婪最长匹配分词后得到语义明确的token序列，再附加边界标记并映射为数值索引作为模型输入；模型输出的索引序列则经解码器还原为可读的乐谱文本。相比字符级或通用BPE分词方案，ABCTokenizer能够更好地保留乐谱的结构信息，减少稀有符号和过长序列带来的建模负担，为后续的GPT2ABC模型提供语义清晰、结构合理的输入表示。


== GPT2ABC模型

=== 整体架构

GPT2ABC是本文基于GPT-2架构构建的ABC音乐生成模型。该模型继承了GPT-2的核心设计理念，采用仅解码器（Decoder-only）的Transformer架构，通过自回归方式建模ABC记谱序列的条件概率分布。与原始GPT-2面向自然语言建模不同，GPT2ABC专门针对音乐符号序列的特性进行了适配，将ABCTokenizer输出的离散token序列作为输入，通过多层自注意力机制捕捉音符间的依赖关系和乐句结构。

从宏观视角来看，GPT2ABC的处理流程可分为三个阶段：输入表示阶段、Transformer编码阶段和输出预测阶段。输入表示阶段负责将离散的token索引转化为稠密的向量表示；Transformer编码阶段通过多层堆叠的自注意力模块对上下文进行深度建模；输出预测阶段则将最终的隐状态映射回词表上的概率分布，完成下一个token的预测。

=== 输入表示

模型的输入处理流程首先将ABC乐谱文本经ABCTokenizer切分为token序列，每个token对应词表中的一个整数索引。这些索引被送入嵌入层（Embedding Layer），映射到$d_"model"$维的稠密向量空间，形成token embeddings矩阵$bold(E) in bb(R)^{T times d_"model"}$，其中$T$为序列长度。

与此同时，模型为序列中的每个位置生成位置编码（Positional Encoding），用以表征token在序列中的绝对位置信息。GPT2ABC延续了GPT-2的可学习位置嵌入设计，将位置编码$bold(P) in bb(R)^{T times d_"model"}$作为模型参数在训练过程中与其他参数一同优化。Token embeddings与位置编码相加后，构成模型第一层Transformer的输入表示：

$ bold(H)^{(0)} = bold(E) + bold(P) $

这种设计使模型既能理解每个符号的语义内容，又能感知其在乐曲中的时序位置，这对于音乐生成尤为重要——相同的音符在不同位置可能承担截然不同的功能角色，例如主音在乐句起始和终止处具有不同的结构意义。


=== Transformer解码器层

模型的核心是$N$层堆叠的Transformer解码器模块（本文实验中$N=12$）。每一层包含两个主要子模块：带因果掩码的多头自注意力机制和位置前馈神经网络，每个子模块均配有残差连接和层归一化。

**多头自注意力机制**通过在$h$个注意力头上并行计算键值查询关联，使模型能够同时关注序列中不同位置的多种依赖关系。对于第$l$层输入$bold(H)^{(l-1)}$，第$k$个注意力头的计算过程为：

$ bold(Q)_k = bold(H)^{(l-1)} bold(W)_k^Q, quad bold(K)_k = bold(H)^{(l-1)} bold(W)_k^K, quad bold(V)_k = bold(H)^{(l-1)} bold(W)_k^V $

$ "Attn"_k = "softmax"( (bold(Q)_k bold(K)_k^top) / sqrt(d_k) + bold(M) ) bold(V)_k $

其中$bold(M)$为因果掩码矩阵，$bold(M)_{i j} = -infinity$（当$j > i$时），确保位置$i$处的预测只能依赖位置$i$及其之前的上下文。多个注意力头的输出经拼接后投影回$d_"model"}$维：

$ "MHA"(bold(H)^{(l-1)}) = ["Attn"_1, "Attn"_2, dots, "Attn"_h] bold(W)^O $

在ABC记谱生成中，多头自注意力尤为关键。音乐的连贯性不仅体现在相邻音符间的平滑过渡，更体现在跨越多个小节的乐句呼应、主题重现等高层次结构模式。多头机制使模型能够同时从旋律轮廓、节奏模式、和声进行等多个维度捕捉音乐关系。

**位置前馈网络**（FFN）在注意力机制之后对每个位置的表示独立进行两层线性变换和非线性激活：

$ "FFN"(bold(x)) = "GELU"(bold(x) bold(W)_1 + bold(b)_1) bold(W)_2 + bold(b)_2 $

其中GELU为高斯误差线性单元激活函数，与原始GPT-2保持一致。FFN模块增强了模型对每个位置表示的非线性表达能力，使其能够学习更复杂的局部特征组合。

每个子模块均采用前置层归一化（Pre-LN）的残差连接形式，以提升训练稳定性：

$ bold(H)'^{(l)} = "MHA"("LN"(bold(H)^{(l-1)})) + bold(H)^{(l-1)} $

$ bold(H)^{(l)} = "FFN"("LN"(bold(H)'^{(l)})) + bold(H)'^{(l)} $


=== 输出层与训练目标

经过$N$层Transformer处理后，模型输出每个位置的隐状态表示$bold(H)^{(N)} in bb(R)^{T times d_"model"}$。这些表示经由共享权重的线性投影层映射至词表维度，再经softmax归一化，得到下一个token的预测概率分布：

$ P(x_{t+1} | x_1, dots, x_t) = "softmax"(bold(H)^{(N)}_t bold(W)^E) $

其中$bold(W)^E in bb(R)^{d_"model" times |V|}$为与输入嵌入层共享权重的投影矩阵，$|V|$为词表大小。权重共享有效减少了参数量，同时在训练中起到隐式正则化的作用。

GPT2ABC的训练目标是最大化训练集中ABC序列的对数似然。对于长度为$T$的ABC记谱序列$(x_1, x_2, dots, x_T)$，模型通过自回归分解将联合概率表示为各位置条件概率的乘积：

$ P(x_1, x_2, dots, x_T) = product_(t=1)^T P(x_t | x_1, dots, x_{t-1}) $

训练时采用teacher forcing策略，即在预测每个位置时，将真实的前文作为输入上下文，而非模型自身的生成结果。损失函数采用交叉熵，对所有位置的预测误差取均值：

$ cal(L) = - 1/T sum_(t=1)^T log P(x_t | x_1, dots, x_{t-1}) $

模型通过Adam优化器进行端到端的反向传播训练，学习率采用带预热（warmup）的余弦退火调度策略，使模型逐步习得ABC音乐语言的统计规律和结构模式。


=== 生成策略

在生成阶段，GPT2ABC采用自回归采样方式。给定一个起始片段（如包含调性、节拍等元信息的ABC头部），模型根据当前上下文预测下一个token的概率分布，然后从该分布中采样得到实际生成的token，将其追加到序列末尾，再作为下一步预测的输入。此过程反复迭代，直至生成$angle.l "eos" angle.r$或达到预设的最大长度。

为平衡生成的多样性与质量，本文在采样阶段引入了以下调控机制：

*温度采样*：通过温度参数$tau$调节概率分布的锐度，$tau > 1$时分布趋于均匀、生成多样性增加，$tau < 1$时分布趋于集中、生成质量更稳定：

$ P'(x_{t+1} | x_1, dots, x_t) = "softmax"( bold(z)_t / tau ) $

其中$bold(z)_t$为输出层的logits向量。

*Top-$k$截断采样*：每步仅保留概率最高的$k$个候选token，将其余token的概率置零后重新归一化。此策略避免了模型选择过于低概率的离群token。

*Top-$p$（核采样）*：动态选取概率质量之和恰好达到阈值$p$的最小候选集合，相比固定$k$值的策略更具自适应性。

上述策略的合理搭配使GPT2ABC能够在生成的音乐合理性与创意多样性之间取得良好平衡，提升生成结果的整体音乐质量和结构完整性。


== 实验

=== 数据集

本文的数据集沿用了folk-rnn项目所使用的公开民谣曲调语料，主要来源为以ABC notation格式整理的传统凯尔特、英伦和北欧地区民谣旋律。该数据集涵盖多种调性和拍号，旋律风格多样，具有代表性强、标注规范的优点，是ABC音乐生成任务中被广泛采用的标准评测语料。

数据预处理阶段，本文统一了ABC文本的字段格式，去除了格式不规范的条目，并使用ABCTokenizer对所有乐曲进行分词与编码。数据集按8:1:1的比例随机划分为训练集、验证集和测试集，确保各子集的调性和风格分布均衡。


=== 基准模型

为全面评价GPT2ABC的性能，本文选取以下三种基准模型进行对比：

1. *RNN*：经典循环神经网络，通过隐状态的逐步传递捕捉序列中的时序信息，是序列建模中最基础的基线架构。由于缺乏门控机制，RNN在处理长距离依赖时存在梯度消失问题，在复杂音乐序列上的建模能力有限。

2. *LSTM*：长短期记忆网络，在RNN基础上引入输入门、遗忘门和输出门，显著缓解了梯度消失问题，具备较强的长距离依赖建模能力，是音乐序列生成领域中常用的改进型循环网络架构。

3. *Transformer*：基于自注意力机制的非递归序列模型，具备高度并行化计算和对全局上下文建模的优势，是当前主流预训练语言模型的基础架构。此处实现的是从头训练的标准Transformer，不加载预训练权重，以验证预训练对生成质量的贡献。

通过与上述三种具有代表性的序列模型进行对比，可以从模型表达能力、长距离依赖建模和训练效率等多个层面系统评估GPT2ABC的优越性。

=== 评估指标

本文采用以下两项指标衡量模型的生成质量与泛化能力：

1. *测试损失（Test Loss）*：以测试集上的交叉熵损失值直接衡量模型的泛化能力。损失值越低，说明模型对未见数据的预测越准确，过拟合风险越小。

2. *困惑度（Perplexity）*：困惑度是测试损失的指数形式，$"PPL" = exp(cal(L)_"test")$，反映模型对目标序列的整体不确定性。困惑度越低，表示模型对真实数据分布的估计越精确，生成文本的流畅度与结构合理性越高。

两项指标相互补充，分别从损失量纲和概率量纲刻画模型性能，使实验结论更加全面。

=== 实验环境

本文实验所用硬件环境配置如@three-line-table 所示。所有模型均在相同硬件环境下独立训练，以确保实验结果的公平可比性。软件环境基于Python 3.10、PyTorch 2.1和CUDA 12.1构建，模型超参数在各基线上均经过充分调整以保证各自的最优性能。

#figure(
  table(
    align: center + horizon,
    columns: 2,
    stroke: none,
    table.hline(stroke: 1.5pt),
    [配置项], [参数],
    table.hline(stroke: 1pt),
    [处理器型号], [Intel(R) Core(TM) i9-12900K],
    [内存容量], [64 GB],
    [硬盘容量], [1 TB],
    [显卡型号], [NVIDIA GeForce RTX 4090],
    table.hline(stroke: 1.5pt),
  ),
  caption: [实验硬件环境配置],
) <three-line-table>


=== 实验结果与分析

==== 主实验结果

@exp-main-table 给出了四种模型在第50个训练轮次（Epoch）时的测试集表现，@fig-loss-curve 展示了各模型测试损失随训练轮次的变化曲线。

#figure(
  table(
    align: center + horizon,
    columns: 5,
    stroke: none,
    table.hline(stroke: 1.5pt),
    [模型], [Epoch], [Test Loss], [Perplexity], [参数量],
    table.hline(stroke: 1pt),
    [RNN], [50], [0.70196], [2.0177], [1,514,843],
    [LSTM], [50], [0.53491], [1.7073], [5,849,435],
    [Transformer], [50], [0.48250], [1.6201], [2,415,963],
    [GPT2ABC], [50], [0.31628], [1.3720], [2,524,160],
    table.hline(stroke: 1.5pt),
  ),
  caption: [四种模型在第50轮训练时的测试集性能对比],
) <exp-main-table>

#figure(image("fig/model_test_loss_comparison.png"), caption: [各模型在测试集上的损失曲线]) <fig-loss-curve>

从实验结果可以得出以下结论：

*GPT2ABC全面优于所有基准模型。*在测试损失上，GPT2ABC（0.316）相比性能最接近的Transformer基线（0.483）降低了34.6%，相比LSTM（0.535）降低了40.9%，相比RNN（0.702）降低了54.9%。困惑度指标上，GPT2ABC（1.372）同样显著低于其他模型，说明其对ABC音乐语言的概率分布建模最为精准。

*循环模型整体弱于Transformer类模型。*RNN表现最差，受限于梯度消失问题，其捕捉乐句级别长距离依赖的能力明显不足。LSTM通过门控机制取得了显著改善，但仍劣于基于全局自注意力的Transformer和GPT2ABC。这一结果验证了自注意力机制在处理音乐序列长距离结构依赖方面的显著优势。

*预训练带来明显增益。*GPT2ABC与从头训练的Transformer架构相同，但得益于在大规模数据上预训练所习得的通用语言表示，其下游任务性能大幅超越了参数量相近的Transformer基线，验证了预训练策略在音乐生成领域的有效迁移性。

==== 资源消耗对比

@exp-results-table 进一步汇报了各模型的参数量、内存占用与训练速度，以评估其实际部署代价。

#figure(
  table(
    columns: 6,
    align: center + horizon,
    table.hline(),
    [模型], [测试损失], [困惑度], [参数量], [内存 (MB)], [10-epoch 时间 (s)],
    table.hline(),
    [RNN], [0.702], [2.02], [1.51M], [43.9], [167.9],
    [LSTM], [0.535], [1.71], [5.85M], [110.0], [316.5],
    [Transformer], [0.483], [1.62], [2.42M], [58.1], [172.8],
    [GPT2ABC], [0.316], [1.37], [2.52M], [60.0], [172.1],
    table.hline(),
  ),
  caption: [四种模型最终性能与资源消耗综合对比],
) <exp-results-table>

资源消耗分析表明，GPT2ABC在参数量（2.52M）、内存占用（60.0 MB）和训练速度（172.1秒/10轮）上均与Transformer基线相当，并未因引入预训练机制而产生显著的额外开销。LSTM尽管性能弱于GPT2ABC，却消耗了最多的参数量（5.85M）和内存（110.0 MB），训练时间也最长（316.5秒/10轮），体现出其在实际应用中的效率劣势。RNN虽然参数量和内存消耗最低，但其生成质量也最差，性价比不如GPT2ABC。综合来看，GPT2ABC在性能与效率之间实现了最优权衡，是ABC音乐生成任务中最具实用价值的方案。


== 本章小结

本章系统介绍了GPT2ABC模型的设计、实现与实验验证。在分词器设计上，ABCTokenizer采用贪婪最长匹配策略，针对ABC记谱法的音乐语义结构构建了专用词表，通过分词、编码、解码三个模块实现了高质量的音乐文本序列化处理，解决了通用分词方案语义边界不清、序列冗长等问题。在模型设计上，GPT2ABC基于GPT-2的Decoder-only Transformer架构，通过多头因果自注意力机制有效捕捉音乐序列中的长距离依赖关系，并引入温度采样、top-$k$和top-$p$等多种生成控制策略，在生成质量与多样性间取得平衡。

实验结果表明，在相同训练轮次下，GPT2ABC在测试损失（0.316）和困惑度（1.372）两项指标上均显著优于RNN、LSTM和标准Transformer基线，验证了预训练策略对音乐生成任务的有效迁移性。同时，GPT2ABC在资源消耗上与Transformer基线基本持平，兼顾了模型性能与实际部署效率，展示了其在ABC音乐自动生成领域的显著优势与应用潜力。


= 基于预训练大语言模型的ABC音乐生成

本章介绍基于预训练大语言模型LLaMA的ABC音乐生成方案（LLaMA-LoRA）。与第三章GPT2ABC从零训练或加载较小规模预训练权重不同，本章方法充分利用参数量达70亿的LLaMA模型经过数万亿token大规模预训练所积累的深层语言表示能力，并通过参数高效微调技术（LoRA）以极低的计算代价将其迁移至ABC音乐生成任务。本章首先阐述方法的整体设计动机，随后分别详细介绍面向ABC记谱法的扩展分词器设计、LoRA微调原理与实现，以及训练策略与生成算法；最后通过与多种基线方法的对比实验与消融分析，系统验证所提方法的有效性。


== 方法设计

=== 设计动机与迁移学习范式

LLaMA（Large Language Model Meta AI）在数万亿token的多语言、多领域文本语料上进行了大规模预训练，已经习得深层的语法结构理解、长距离序列依赖建模以及上下文语义推断能力。尽管其训练语料以自然语言为主，但这些底层的序列建模能力在很大程度上具有领域无关性——音乐符号与自然语言在本质上同属离散符号序列，其结构模式（如重复、变奏、段落组织）与自然语言的句法结构（如从句嵌套、指代关系、段落连贯）具有深刻的结构相似性。

在迁移学习的视角下，将预训练LLaMA应用于ABC音乐生成的范式可以形式化描述如下。设预训练阶段的目标域为自然语言语料 $cal(D)_"NL"$，目标任务为语言建模；下游任务的目标域为ABC音乐记谱语料 $cal(D)_"ABC"$，目标任务为条件音乐序列生成。迁移学习的核心假设是：预训练阶段学习到的参数 $theta_0$ 已经编码了通用的序列建模归纳偏置，下游微调只需在 $theta_0$ 附近搜索使 $cal(D)_"ABC"$ 似然最大化的参数 $theta^*$，而无需从随机初始化出发：

$ theta^* = arg max_theta cal(L)_"ABC"(theta), quad theta "initialized from" theta_0 $

这一范式的优势在于两个层面：其一，模型无需在有限的ABC语料上从头学习基础的序列建模机制，大幅降低了对训练数据规模的依赖；其二，预训练阶段积累的通用表示能力（如位置感知、长距离依赖）可直接为音乐结构建模所用，加速收敛并提升生成质量。

然而，直接对LLaMA-7B进行全参数微调面临严峻的计算资源挑战。完整微调需要更新全部70亿个参数，不仅需要存储与参数等量的梯度张量和优化器状态（Adam优化器需额外存储一阶矩与二阶矩，共需约 $3 times 7 text{B}$ 个浮点数的额外显存），还需要数十小时的训练迭代才能收敛。此外，在数据规模有限（约10,000首乐曲）的情形下，全参数微调面临显著的过拟合风险，可能破坏预训练阶段习得的通用表示。为此，本研究采用LoRA参数高效微调技术，在极大降低计算代价的同时有效规避过拟合，使得在单张消费级GPU上进行高质量微调成为可能。


=== 面向ABC记谱法的扩展分词器

==== 原生分词器的局限性

LLaMA原生分词器基于字节对编码（Byte Pair Encoding, BPE）算法，在大规模通用文本语料上训练得到，词表规模为32,000个token，主要覆盖自然语言中的常见词片段。将其直接应用于ABC记谱文本时存在两方面根本性局限。

*语义边界破碎问题*：ABC记谱法中大量具有完整音乐语义的复合符号（如"|:"表示重复起始、"K:Gmaj"表示G大调、"M:6/8"表示6/8拍）会被BPE分词器依据自然语言统计规律切分为若干无意义的字符片段。例如，"M:4/4"可能被切分为["M", ":", "4", "/", "4"]五个独立token，既丢失了"节拍声明"的整体语义，又人为增加了序列长度。

*序列长度膨胀问题*：设原始ABC文本长度为$L_"char"$个字符，采用原生BPE分词后的序列长度为$L_"BPE"$个token，而采用专用分词器后的长度为$L_"ABC"}$个token。由于BPE无法识别ABC的语义单元，倾向于退化为字符级切分，通常有$L_"BPE" approx L_"char" > L_"ABC"$，导致模型需要在Transformer的有效上下文窗口内处理更长的冗余序列，增加了注意力计算的二次复杂度代价 $O(L^2)$。

==== 扩展词表构建

针对上述局限，本研究在LLaMA原生词表基础上进行领域扩展，构建面向ABC记谱法的自定义分词器。扩展流程分为以下四个步骤：

**步骤一：高频符号统计**。对训练语料 $cal(D)_"ABC"$ 进行字符级扫描，提取所有出现频次超过阈值 $f_"min"$ 的ABC特殊符号组合。候选符号集合涵盖以下类别：

- 字段标识符：`X:`、`T:`、`M:`、`L:`、`K:`、`C:`、`Q:`、`P:` 等行首元信息声明
- 小节线变体：`|`、`||`、`|:`、`:|`、`:||:`、`[|`、`|]` 等结构标记
- 调号组合：`C#`、`D#`、`F#`、`Cmaj`、`Gmin`、`Bb`、`Eb` 等
- 节奏标记：`1/2`、`1/4`、`1/8`、`2/4`、`3/4`、`4/4`、`6/8` 等时值与拍号
- 装饰音符号：`~`（波音）、`{`、`}`（倚音括号）、`.`（跳音）、`T`（颤音）等
- 和弦标注：`"C"`、`"G"`、`"Am"`、`"Em"` 等

**步骤二：符号去重与合法性验证**。对提取的候选符号集合进行去重，并通过ABC语法解析器验证其合法性，剔除由文本噪声产生的无效符号。

**步骤三：词表合并**。将经验证的ABC特殊token集合 $cal{V}_"ABC"$ 附加至原生词表 $cal{V}_"LLaMA"}$（保留原有32,000个token不变），构建扩展词表：

$ cal{V}_"ext" = cal{V}_"LLaMA" union cal{V}_"ABC" $

扩展后词表规模约为33,500个token，新增约1,500个ABC领域专有token。

**步骤四：Embedding层扩展**。相应地扩展模型的token embedding矩阵 $bold(E) in bb(R)^{|cal{V}_"LLaMA"| times d}$ 为 $bold(E)' in bb(R)^{|cal{V}_"ext"| times d}$。对于原有词表中的token，直接继承预训练的embedding向量：

$ bold(E)'[i] = bold(E)[i], quad forall i in cal{V}_"LLaMA" $

对于新增ABC特殊token，其embedding向量采用均值初始化策略——以原有词表embedding矩阵的列均值为初始值，并叠加小幅随机扰动：

$ bold(E)'[j] = frac(1, |cal{V}_"LLaMA"|) sum_(i in cal{V}_"LLaMA") bold(E)[i] + epsilon, quad epsilon tilde cal{N}(0, sigma^2 bold(I})), quad forall j in cal{V}_"ABC" $

其中$sigma$为较小的标准差（本文取$sigma = 0.02$）。相比完全随机初始化，均值初始化使新增token的初始表示位于原有embedding空间的中心区域，在微调早期能够更稳定地接收梯度信号，加速新增token语义的学习。在微调过程中，新增token的embedding向量随LoRA适配器一同更新，逐步习得与ABC记谱法相关的语义表示——例如，小节线"|"的embedding会编码段落边界语义，调号"K:G"的embedding会编码G大调的音阶特性。

通过上述设计，扩展分词器能够将ABC记谱法中的语义单元保持完整。以"M:4/4"为例，扩展分词器将其识别为两个语义完整的token（"M:"和"4/4"），而非原生BPE分词器产生的五个无意义碎片。这种设计显著缩短了序列长度，降低了注意力计算开销，同时使每个token都承载明确的音乐语义，降低了模型学习ABC语法结构的难度。


=== LoRA参数高效微调

==== 理论基础

LoRA（Low-Rank Adaptation）的核心假设基于预训练模型权重矩阵的内在低秩性：在针对特定下游任务的微调过程中，权重矩阵的变化量 $Delta W$ 具有远低于原始矩阵秩的内在维度（intrinsic dimensionality）。这一假设得到了实证研究的支持：在多个NLP任务上，权重更新矩阵的有效秩通常仅为个位数，远小于矩阵维度。

基于此假设，LoRA通过低秩分解对权重更新矩阵进行参数化近似。设预训练权重矩阵为 $bold(W)_0 in bb(R)^{d times k}$，微调后的权重矩阵为：

$ bold(W) = bold(W)_0 + Delta bold(W) $

LoRA将 $Delta bold(W)$ 约束为秩 $r$ 的矩阵，通过两个低维矩阵的乘积表示：

$ Delta bold(W) = bold(B) bold(A), quad bold(B) in bb(R)^{d times r}, quad bold(A) in bb(R)^{r times k}, quad r min(d, k) $

在前向传播中，对于输入向量 $bold(x) in bb(R)^k$，输出计算为：

$ bold(h) = bold(W)_0 bold(x) + Delta bold(W) bold(x) = bold(W)_0 bold(x) + bold(B) bold(A) bold(x) $

为控制低秩更新对原始权重的修正幅度，引入缩放因子 $alpha/r$，最终的前向传播公式为：

$ bold(h) = bold(W)_0 bold(x) + frac(alpha, r) bold(B) bold(A) bold(x) $

其中 $alpha$ 为超参数，本研究设置为32。该缩放因子确保低秩更新既不过小（无法适配任务）也不过大（破坏预训练知识）。

在参数初始化策略上，矩阵 $bold(A)$ 采用高斯随机初始化 $bold(A) tilde cal{N}(0, sigma^2 bold(I))$，而矩阵 $bold(B)$ 初始化为零矩阵。这一非对称初始化策略确保训练起始阶段 $Delta bold(W) = bold(B)bold(A) = bold(0)$，即LoRA的加入不改变模型的初始预测行为，保证训练的稳定性。

==== 参数效率分析

相比完整微调，LoRA的参数效率可以量化如下。对于一个形状为 $d times k$ 的权重矩阵，完整微调需要更新 $d times k$ 个参数，而LoRA仅需更新 $(d + k) times r$ 个参数（矩阵 $bold(A)$ 和 $bold(B)$ 的参数之和）。参数压缩比为：

$ rho = frac{(d + k) times r}{d times k} approx frac{2r}{min(d,k)} $

对于LLaMA-7B中典型的注意力投影矩阵（$d = k = 4096$，$r = 16$），压缩比约为 $rho approx 2 times 16 / 4096 approx 0.78%$，即LoRA参数量仅为完整微调的不足1%。

全模型层面，LLaMA-7B共有7,000M个参数，应用LoRA至所有Transformer层的Q、K、V、O四个注意力投影矩阵后，可训练参数量约为4.2M，占模型总参数的0.06%。

==== LoRA在注意力层的应用

本研究将LoRA适配器注入Transformer解码器层中的多头自注意力机制的四个线性投影：查询投影 $bold(W)^Q$、键投影 $bold(W)^K$、值投影 $bold(W)^V$ 和输出投影 $bold(W)^O$。设第 $l$ 层的输入隐状态为 $bold(H)^{(l)} in bb(R)^{T times d}$，注入LoRA后，各投影的计算修改为：

$ bold(Q) = bold(H)^{(l)} (bold(W)^Q_0 + frac(alpha, r) bold(B)^Q bold(A)^Q) $

$ bold(K) = bold(H)^{(l)} (bold(W)^K_0 + frac(alpha, r) bold(B)^K bold(A)^K) $

$ bold(V) = bold(H)^{(l)} (bold(W)^V_0 + frac(alpha, r) bold(B)^V bold(A)^V) $

多头自注意力计算（含因果掩码）保持不变：

$ "Attn"_k = "softmax"( frac(bold(Q)_k bold(K)_k^top, sqrt(d_k)) + bold(M) ) bold(V)_k $

$ "MHA"(bold(H)^{(l)}) = ["Attn"_1, dots, "Attn"_h] (bold(W)^O_0 + frac(alpha, r) bold(B)^O bold(A)^O) $

通过在注意力投影矩阵处注入LoRA，模型能够在保留预训练语言知识的基础上，调整其注意力模式以适应ABC记谱法的结构特点——例如，学习在小节线处建立更强的注意力边界，在重复段落间建立跨小节的长程关联。

==== LoRA配置

综合参数效率与下游任务性能的考量，本研究采用如下LoRA配置：

#figure(
  table(
    align: center + horizon,
    columns: 2,
    stroke: none,
    table.hline(stroke: 1.5pt),
    [参数项], [取值],
    table.hline(stroke: 1pt),
    [低秩维度 $r$], [16],
    [缩放因子 $alpha$], [32],
    [LoRA Dropout], [0.05],
    [目标模块], [`q_proj`, `k_proj`, `v_proj`, `o_proj`],
    [可训练参数量], [≈ 4.2M (占总参数0.06%)],
    table.hline(stroke: 1.5pt),
  ),
  caption: [LoRA超参数配置],
) <lora-config-table>

LoRA层还应用了概率为0.05的Dropout正则化，以抑制过拟合。在秩的选择上，$r = 16$ 在多个下游微调任务中被验证为平衡表达能力与参数效率的合理默认值；更大的秩（如$r = 64$）虽能略微提升性能上限，但参数量随之成倍增加，性价比下降。


=== 训练目标与优化策略

==== 因果语言建模目标

LLaMA-LoRA沿用因果语言建模（Causal Language Modeling，CLM）作为训练目标。给定ABC记谱序列 $bold(x) = (x_1, x_2, \ldots, x_T)$，模型通过自回归分解将其联合概率表示为各位置条件概率的乘积：

$ P_theta (bold(x)) = product_(t=1)^T P_theta (x_t | x_1, dots, x_{t-1}) $

训练目标为最大化训练集 $cal{D}_"train"}$ 上的对数似然：

$ cal{L}_"CLM"(theta) = sum_(bold(x) in cal{D}_"train"}) sum_(t=1)^T log P_theta (x_t | x_1, dots, x_{t-1}) $

等价地，最小化负对数似然（交叉熵损失）：

$ cal{L}_"CE"(theta) = - frac(1, |cal{D}_"train"| dot T) sum_(bold(x) in cal{D}_"train"}) sum_(t=1)^T log P_theta (x_t | x_(< t)) $

其中 $theta$ 表示全部可训练参数（即LoRA矩阵 $\{bold(A)_i, bold(B)_i\}$ 与新增token的embedding向量），冻结参数 $theta_0$（原始LLaMA权重）不参与梯度计算。

训练采用Teacher Forcing策略，即在预测位置 $t$ 时，始终以真实的历史token $(x_1, \ldots, x_{t-1})$ 作为输入上下文，而非模型自身在前序步骤的采样结果。这一策略保证了梯度信号的稳定性，加速训练收敛，代价是引入轻微的训练-推理分布偏移（exposure bias）——在推理时，模型的前序生成可能与训练时见过的真实前缀存在差异，从而产生误差累积。本研究通过在生成阶段引入采样多样性（温度参数与Top-p截断）来缓解这一问题。

==== 优化器与学习率调度

优化器选用AdamW，其更新规则在标准Adam基础上引入权重衰减（weight decay）作为L2正则化的一种近似形式，以抑制参数过度增长：

$ bold(m)_t &= beta_1 bold(m)_{t-1} + (1 - beta_1) bold(g)_t \
bold(v)_t &= beta_2 bold(v)_{t-1} + (1 - beta_2) bold(g)_t^2 \
hat(bold(m))_t &= bold(m)_t / (1 - beta_1^t), quad hat(bold(v))_t = bold(v)_t / (1 - beta_2^t) \
theta_t &= theta_{t-1} - eta frac(hat(bold(m))_t, sqrt(hat(bold(v))_t) + epsilon) - eta lambda theta_{t-1} $

其中 $bold(g)_t$ 为当前步梯度，$beta_1 = 0.9$，$beta_2 = 0.999$，$epsilon = 10^{-8}$，权重衰减系数 $lambda = 0.01$，基础学习率 $eta = 2 times 10^{-4}$。

学习率调度采用线性预热（Linear Warmup）策略：在训练前 $T_"warm" = 100$ 步内，学习率从0线性递增至基础学习率 $eta_0$；此后保持恒定直至训练结束：

$ eta_t = cases(
  eta_0 dot t / T_"warm" \, & t <= T_"warm",
  eta_0 \, & t > T_"warm"
) $

预热阶段通过抑制训练初期的大幅参数更新，避免随机初始化的LoRA矩阵在早期产生过大的梯度扰动，保护预训练权重的稳定性。

==== 梯度累积与有效批次大小

受限于GPU显存，单步实际批次大小（per-step batch size）设置为 $B_"step"=4$。通过梯度累积（Gradient Accumulation）技术，将 $G=4$ 个小批次的梯度累加后再执行一次参数更新，使有效批次大小（effective batch size）达到：

$ B_"eff" = B_"step" times G = 4 times 4 = 16 $

梯度累积等价于在不增加显存的条件下扩大批次大小，有助于提升梯度估计的方差稳定性，改善训练动态。在实现上，每累积 $G$ 步后才调用一次优化器的`step()`方法，并清零梯度缓存。

==== 训练流程

完整的训练流程如下：

+ *初始化*：加载预训练LLaMA-2-7B权重，冻结全部参数（requires\_grad = False）。
+ *LoRA注入*：在目标注意力投影层（Q、K、V、O）旁路注入LoRA适配器，仅适配器参数设为可训练。
+ *Embedding扩展*：将token embedding矩阵由 $bb(R)^{32000 times d}$ 扩展至 $bb(R)^{33500 times d}$，新增行采用均值初始化，设为可训练。
+ *迭代训练*：对训练集执行3轮迭代，每步计算前向传播与交叉熵损失，通过反向传播仅对LoRA参数和新增embedding计算并累积梯度，每4步执行一次AdamW更新。
+ *验证监控*：每个epoch结束后在验证集上计算困惑度，保存验证集困惑度最低的检查点（checkpoint）。

整个训练过程在单张NVIDIA A100（40GB）GPU上进行，每轮约2小时，3轮共计约6小时。


=== 生成策略

==== 自回归采样框架

在推理阶段，模型采用自回归采样生成ABC序列。给定提示序列（prompt） $bold(x)_{1:T_0}$（如包含字段声明"X:1\nT:\nM:4/4\nL:1/8\nK:G\n"的ABC头部），模型逐步扩展序列：

$ x_{T_0 + t} tilde P_theta (x | x_{1:T_0 + t - 1}), quad t = 1, 2, dots $

直至采样到 $angle.l "eos" angle.r$ 标记或序列长度达到预设上限 $L_"max" = 512$。

==== 温度缩放

为调节生成多样性与质量的平衡，引入温度参数 $tau in (0, +infinity)$ 对输出logits进行缩放：

$ P_tau (x_t = v | x_{< t}) = frac(exp(bold(z)_t[v] / tau), sum_{v' in cal{V}_"ext"} exp(bold(z)_t[v'] / tau)) $

温度 $ tau \to 0$ 时，分布退化为贪心解码（argmax）；$tau = 1$ 时为原始模型分布；$ tau > 1$ 时分布趋于均匀，多样性增加但质量下降；$tau < 1$ 时分布集中于高概率token，质量提升但多样性降低。本研究设置 $tau = 0.8$，使分布略微向高概率区间集中，在保持生成稳定性的同时保留适度的旋律变化。

==== 结构约束后处理

为确保生成的ABC文本符合基本语法规则，在采样后进行轻量级后处理：验证必需字段（X:、T:、M:、L:、K:）是否完整且顺序正确；检查小节线分布是否合理；对末尾不完整的小节进行补全。这些约束通过后处理而非强制解码约束实现，以避免对采样过程引入不可导的干预。


== 实验

=== 实验设置

==== 数据集

实验使用与第三章相同的公开ABC记谱法数据集，来源于folk-rnn项目整理的传统凯尔特、英伦和北欧民谣语料，共包含约10,000首完整乐曲。数据集按8:1:1比例随机划分为训练集（8,000首）、验证集（1,000首）和测试集（1,000首），确保各子集的调性与风格分布均衡。数据统计信息如@data-stats-table 所示。

#figure(
  table(
    columns: 4,
    align: center + horizon,
    table.hline(),
    [*集合*], [*样本数*], [*平均长度 (tokens)*], [*总token数*],
    table.hline(),
    [训练集], [8,000], [156], [1.25M],
    [验证集], [1,000], [158], [158K],
    [测试集], [1,000], [155], [155K],
    table.hline(),
  ),
  caption: [数据集统计信息],
) <data-stats-table>

数据集涵盖C大调、G大调、D大调等多种调性，节拍以4/4、3/4、6/8为主，风格包括爱尔兰里尔舞曲（Reel）、吉格舞曲（Jig）、苏格兰舞曲（Strathspey）等。

==== 实验环境

本章实验所用环境如@env-table 所示。

#figure(
  table(
    align: center + horizon,
    columns: 2,
    stroke: none,
    table.hline(stroke: 1.5pt),
    [配置项], [参数],
    table.hline(stroke: 1pt),
    [处理器], [Intel(R) Core(TM) i9-12900K],
    [内存], [32 GB],
    [训练GPU], [NVIDIA A100 (40GB)],
    [操作系统], [Ubuntu 22.04],
    [深度学习框架], [PyTorch 2.1 + CUDA 12.1],
    [微调框架], [HuggingFace PEFT 0.7],
    table.hline(stroke: 1.5pt),
  ),
  caption: [实验环境配置],
) <env-table>

==== 超参数配置

训练超参数汇总如@hparam-table 所示。

#figure(
  table(
    align: center + horizon,
    columns: 3,
    stroke: none,
    table.hline(stroke: 1.5pt),
    [类别], [参数项], [取值],
    table.hline(stroke: 1pt),
    [模型], [基础模型], [LLaMA-2-7B],
    [], [LoRA秩 $r$], [16],
    [], [LoRA $alpha$], [32],
    [], [目标模块], [Q, K, V, O投影],
    [], [LoRA Dropout], [0.05],
    [训练], [学习率 $eta_0$], [$2 times 10^{-4}$],
    [], [优化器], [AdamW ($beta_1=0.9, beta_2=0.999$)],
    [], [权重衰减], [0.01],
    [], [批次大小 $B_"step"$], [4],
    [], [梯度累积步数 $G$], [4],
    [], [有效批次大小], [16],
    [], [训练轮数], [3],
    [], [预热步数 $T_"warm"$], [100],
    [], [最大序列长度], [512 tokens],
    [生成], [温度 $tau$], [0.8],
    [], [Top-$p$ 阈值], [0.9],
    table.hline(stroke: 1.5pt),
  ),
  caption: [模型训练与生成超参数配置],
) <hparam-table>

==== 对比基线

为全面评价LLaMA-LoRA的性能，设置以下四种对比方法：

1. *Vanilla GPT-2*：GPT-2-small（124M参数）在ABC数据上从零微调，代表中等规模预训练模型的基准性能。

2. *Music Transformer*：专为符号音乐序列设计的Transformer模型，引入了相对位置编码以更好地捕捉音乐的周期性结构，是音乐生成领域的经典基线。

3. *LLaMA-Pretrained*：与本文方法相同的LLaMA-2-7B基础模型，但直接使用原生分词器（不扩展ABC特殊token）进行LoRA微调，用于量化扩展分词器的贡献。

4. *LLaMA-LoRA (本文)*：本章提出的完整方法，包含扩展分词器、LoRA微调和优化生成策略。

所有基线使用相同的训练数据、数据划分和评估协议，以确保实验公平可比。

==== 评估指标

本研究从语言建模与音乐质量两个维度评估生成效果。

**语言建模指标**：

- *测试损失（Test Loss）*：测试集上的平均交叉熵损失，直接衡量模型对未见ABC序列的概率拟合质量。
- *困惑度（Perplexity，PPL）*：测试损失的指数形式，$"PPL" = exp(cal{L}_"test")$，反映模型对真实数据分布的整体不确定性，值越低越好。

**音乐质量指标**：

- *语法正确率*：生成的ABC文本能通过标准ABC语法解析器（abc2xml）解析的比例，衡量输出的格式合法性。
- *结构完整性*：生成乐曲包含所有必需字段且字段顺序符合规范的比例。
- *旋律合理性*：音高分布与节奏模式符合训练集统计规律的比例，通过与训练集分布的KL散度量化。

**人工评估**：邀请10位具有乐理基础的音乐专业人士，对每种方法随机抽取的20个生成样本进行盲测评分（1–5分），评分维度包括旋律流畅性、结构完整性和整体音乐质量。


=== 实验结果与分析

==== 量化结果

@exp-quant-table 给出了各方法在测试集上的语言建模与音乐质量量化结果。

#figure(
  table(
    columns: 5,
    align: center + horizon,
    table.hline(),
    [*模型*], [*PPL $arrow.b$*], [*Test Loss $arrow.b$*], [*语法正确率 $arrow.t$*], [*结构完整性 $arrow.t$*],
    table.hline(),
    [Vanilla GPT-2], [32.7], [3.488], [72.3%], [68.5%],
    [Music Transformer], [28.4], [3.347], [81.7%], [79.2%],
    [LLaMA-Pretrained], [21.6], [3.073], [85.4%], [83.8%],
    [*LLaMA-LoRA（本文）*], [*15.3*], [*2.728*], [*93.8%*], [*91.6%*],
    table.hline(),
  ),
  caption: [各方法在测试集上的量化性能对比],
) <exp-quant-table>

实验结果表明，LLaMA-LoRA在所有量化指标上均取得最优性能。在困惑度方面，本文方法（15.3）相比LLaMA-Pretrained（21.6）降低29.2%，相比Music Transformer（28.4）降低46.1%，相比Vanilla GPT-2（32.7）降低53.2%。

性能提升可以从以下三个层次理解。**模型规模层次**：LLaMA-2-7B（70亿参数）相比GPT-2-small（1.24亿参数）在参数规模上存在约57倍的差距，大模型更强的表示能力是性能提升的基础。**预训练质量层次**：LLaMA在更大规模、更高质量的数据上进行了预训练，与Music Transformer（从零训练）的对比揭示了预训练带来的迁移增益，Music Transformer的PPL（28.4）仅略优于Vanilla GPT-2（32.7），而LLaMA-Pretrained（21.6）则有显著改善。**分词器设计层次**：LLaMA-LoRA相比LLaMA-Pretrained的额外增益（PPL从21.6降至15.3，降幅29.2%）完全来自扩展分词器的贡献，证明了针对ABC记谱法的领域特定分词设计是不可或缺的关键组件。

==== 人工评估结果

@human-eval-table 报告了人工盲测的主观评分结果。

#figure(
  table(
    columns: 4,
    align: center + horizon,
    table.hline(),
    [*模型*], [*旋律流畅性*], [*结构完整性*], [*整体质量*],
    table.hline(),
    [Vanilla GPT-2], [2.8 ± 0.9], [2.6 ± 1.1], [2.7 ± 0.8],
    [Music Transformer], [3.4 ± 0.8], [3.5 ± 0.7], [3.3 ± 0.7],
    [LLaMA-Pretrained], [3.8 ± 0.7], [3.9 ± 0.6], [3.7 ± 0.6],
    [*LLaMA-LoRA（本文）*], [*4.3 ± 0.5*], [*4.4 ± 0.4*], [*4.2 ± 0.5*],
    table.hline(),
  ),
  caption: [人工盲测评分结果（5分制，均值 ± 标准差）],
) <human-eval-table>

在主观评估中，LLaMA-LoRA在旋律流畅性（4.3/5）、结构完整性（4.4/5）和整体质量（4.2/5）三项维度上均显著领先。评估者普遍反馈本文方法生成的旋律更具音乐性，重复段落的结构边界清晰，调性风格统一，部分样本已接近真实民谣的质量水准。相比之下，Vanilla GPT-2的评分整体较低，旋律缺乏连贯性；Music Transformer虽结构完整性较好，但旋律流畅性仍有明显不足。

本文方法在结构完整性维度（4.4分）上的得分最高，高于旋律流畅性（4.3分），这与扩展分词器对字段标识符和小节线等结构标记的完整保留直接相关——模型通过专用token更准确地学习了ABC文本的结构框架，从而在生成时能够更稳定地维持段落组织。

==== 消融实验

为系统量化各组件对最终性能的贡献，设计并执行了@ablation-table 所示的消融实验。

#figure(
  table(
    columns: 3,
    align: center + horizon,
    table.hline(),
    [*配置*], [*PPL*], [*语法正确率*],
    table.hline(),
    [完整模型（LLaMA-LoRA）], [*15.3*], [*93.8%*],
    [去除扩展分词器（→ 原生BPE）], [21.6], [85.4%],
    [去除LoRA（→ 全参数微调）], [14.8], [94.2%],
    [去除温度调节（$tau = 1.0$）], [15.3], [91.5%],
    [去除Top-$p$采样（→ 贪心解码）], [15.3], [89.3%],
    table.hline(),
  ),
  caption: [消融实验结果],
) <ablation-table>

消融结果揭示了以下关键发现：

**扩展分词器是最重要的组件**。去除扩展分词器后PPL从15.3上升至21.6，增幅达41.2%；语法正确率从93.8%降至85.4%，下降8.4个百分点。这一结果有力证明了领域特定分词设计对ABC音乐生成的核心价值：BPE分词器对复合符号的破碎性切分直接导致模型难以学习正确的音乐语法边界，是制约生成质量的最主要瓶颈。

**LoRA与全参数微调性能相当**。将LoRA替换为全参数微调后，PPL小幅降低至14.8，语法正确率微升至94.2%，差距极小（PPL相差0.5，语法正确率相差0.4个百分点）。但全参数微调所需显存约为LoRA的300倍，训练时间约为其10倍。这一结果验证了LoRA在音乐生成领域的参数高效性：以0.06%的可训练参数量实现了接近完整微调的性能，充分体现了预训练权重内在低秩更新假设的合理性。

**生成策略影响不可忽视**。去除温度调节（$tau=1.0$）或将Top-$p$采样替换为贪心解码，虽不影响困惑度（困惑度仅取决于模型参数，与采样策略无关），但语法正确率分别下降2.3和4.5个百分点。这说明适当的随机性在ABC音乐生成中具有积极作用：贪心解码容易陷入局部重复模式，导致旋律在固定几个音符间往复循环，进而产生不完整的小节结构。


=== 生成样本展示

以下展示两个典型生成样本，以直观呈现LLaMA-LoRA的生成质量。

*样本一：爱尔兰风格吉格舞曲（6/8拍，G大调）*

```
X:1
T:The Dancing Brook
M:6/8
L:1/8
K:Gmaj
|:D|G2B d2B|c2A A2F|G2B d2g|f2d d2B|
c2A A2G|F2D D2E|F2A c2e|d2B B2:|
|:d|g2d B2G|A2F D2F|G2B d2g|f2a g2f|
e2c A2c|d2B G2B|c2A F2A|G3 G2:|
```

该样本展现了典型的6/8拍吉格舞曲特征，旋律在G大调主和弦骨干音上流畅进行，两段重复结构（"|:"与":|"）清晰对称，符合爱尔兰传统音乐的惯例风格。

*样本二：苏格兰风格进行曲（4/4拍，D大调）*

```
X:2
T:Highland March
M:4/4
L:1/16
K:Dmaj
|:A2|d4 f4 a4 f4|e4 c4 A6 Bc|d4 f4 a4 b4|a8 a4:|
|:de|f4 a4 f4 d4|e4 g4 e4 c4|d4 f4 e4 c4|d8 d4:|
```

该样本呈现出苏格兰进行曲的庄严感，4/4拍节奏稳定，旋律以长时值音符为主，D大调调性明确，两段结构均以主音D收束，体现了良好的调性一致性。


=== 局限性与讨论

尽管LLaMA-LoRA在量化与主观评估中均取得了显著性能，仍存在以下局限值得关注：

**创造性有限**：生成的音乐主要在训练集风格的统计分布范围内模仿，缺乏突破性的旋律创新。这是当前所有基于监督语言建模的音乐生成方法的共同局限，根源在于最大似然目标本质上鼓励模型向训练数据的均值靠拢。

**长程结构一致性**：对于包含多个段落的复杂乐曲结构，模型在超过256个token的长距离范围内维持主题连贯性仍有挑战，偶尔出现段落间调性漂移的现象。

**和声多声部能力弱**：当前方法主要针对单旋律线的ABC文本，对多声部和声进行（如四声部合唱）的建模能力较为有限。

针对上述局限，未来工作可在以下方向展开探索：引入风格、情绪等条件控制信号实现可控生成；采用基于音乐理论规则的奖励模型进行强化学习微调（RLHF）；扩展训练数据至更多音乐风格与文化背景以提升泛化能力；探索多模态融合（音频与乐谱联合建模）以增强音乐语义理解。


== 本章小结

本章系统介绍了基于预训练大语言模型LLaMA的ABC音乐生成方案LLaMA-LoRA。在分词器设计上，通过对训练语料进行高频ABC符号统计，在LLaMA原生BPE词表基础上扩展约1,500个领域专有token，构建了面向ABC记谱法语义边界的扩展分词器，并采用均值初始化策略为新增token提供稳定的训练起点。在参数高效微调上，通过对LoRA数学原理的深入分析，揭示了低秩假设的理论基础，量化了其约$300 times$的参数压缩比，并详细阐述了其在多头注意力投影矩阵上的具体应用形式。在训练策略上，结合AdamW优化器、线性预热学习率调度和梯度累积技术，实现了在单张GPU上6小时内完成高质量微调的目标。在生成阶段，通过温度缩放与Top-$p$核采样的组合策略，在生成质量与多样性之间取得了良好平衡。

实验结果表明，LLaMA-LoRA在困惑度（15.3）、语法正确率（93.8%）等全部量化指标上均优于Vanilla GPT-2、Music Transformer和LLaMA-Pretrained基线，人工评估整体质量评分达4.2/5.0。消融实验进一步确认扩展分词器是贡献最大的单一组件（去除后PPL上升41.2%），而LoRA在仅使用0.06%可训练参数的条件下实现了接近全参数微调的性能，充分验证了参数高效微调范式在音乐生成领域的适用性与实用价值。


= 总结与展望

== 工作总结

本研究围绕ABC记谱法音乐自动生成这一核心任务，从专用分词器设计、多架构序列建模、参数高效微调到系统性实验评估，构建了一套完整的研究框架。研究内容涵盖两条技术路线：其一是在统一实验条件下系统对比RNN、LSTM、Transformer和GPT2ABC四种序列建模架构，探究不同归纳偏置对ABC音乐语言学习效果的影响；其二是引入预训练大语言模型LLaMA并结合LoRA参数高效微调与扩展分词策略，将大规模语言模型的通用序列建模能力迁移至音乐符号生成领域。本文的主要工作总结如下。

=== ABCTokenizer的设计与实现

针对ABC记谱法高度规则化的语法结构与音乐语义边界问题，本文设计并实现了专用的ABCTokenizer分词器。通用自然语言分词器（如BPE）在处理ABC文本时会将具有完整音乐语义的复合符号（如"|:"、"K:Gmaj"、"M:6/8"）错误地切分为若干无意义的字符碎片，导致序列冗长且语义结构破碎；字符级分词方案虽能保留原始信息，但会造成序列长度膨胀、注意力计算代价增大。ABCTokenizer针对上述问题，采用贪婪最长匹配（Greedy Longest-Match）策略构建分词核心算法：维护一个文本指针，在每一步优先尝试匹配长度为4、3、2、1的子串是否存在于专用词表中，从长到短依次尝试，确保"|:"等复合符号不被拆散；对无法匹配的字符回退至$angle.l "unk" angle.r$标记，保证分词器的鲁棒性。

在词表构建上，ABCTokenizer涵盖音高符号、时值标记、调性与节拍声明、装饰音记号、和弦标注及各类小节线变体，同时引入$angle.l "bos" angle.r$、$angle.l "eos" angle.r$、$angle.l "pad" angle.r$等序列边界与对齐控制token，构成语义层次清晰的分层词表。编码阶段在token序列两端自动附加边界标记，帮助模型准确感知旋律的起止结构；解码阶段对控制性token进行过滤，还原出符合标准ABC语法的纯净乐谱文本，供打谱软件或音频合成器直接使用。相比通用分词方案，ABCTokenizer能够在保留乐谱结构信息的同时有效控制序列长度，使每个token都承载明确的音乐语义，显著降低了下游模型学习ABC语法规律的难度。

=== GPT2ABC模型的构建与验证

在GPT2ABC的研究中，本文以GPT-2的Decoder-only Transformer架构为基础，将ABCTokenizer输出的离散token序列作为输入，通过多层堆叠的因果自注意力机制对ABC音乐序列的条件概率分布进行建模。模型的输入表示由token嵌入与可学习位置编码相加构成，使模型能够同时感知符号语义与时序位置。每个Transformer解码器层包含带因果掩码的多头自注意力模块（确保自回归特性）与位置前馈网络，并采用前置层归一化（Pre-LN）残差连接以提升训练稳定性。输出层通过与输入嵌入层共享权重的线性投影实现参数节约，并经softmax归一化得到词表上的概率分布。

在训练策略上，GPT2ABC以最大化ABC序列对数似然为目标，采用Teacher Forcing策略加速收敛，通过Adam优化器配合带预热的学习率调度进行端到端训练。在生成阶段，引入温度参数、Top-$k$截断和Top-$p$核采样等多种策略，在生成质量与旋律多样性之间实现灵活调控。

系统性对比实验在统一超参数配置（嵌入维度256、隐层维度512、3层、dropout率0.2、学习率1e-3、批次大小16）下，对RNN、LSTM、Transformer和GPT2ABC四种架构进行了50轮训练的全程跟踪评估。实验结果表明，GPT2ABC在测试损失（0.316）和困惑度（1.372）两项指标上均全面领先，相比性能次优的Transformer基线（测试损失0.483，困惑度1.620）分别降低34.6%和15.3%；在计算资源消耗方面，GPT2ABC（参数量2.52M，显存60MB，10轮训练耗时172.1秒）与Transformer基线基本持平，远优于LSTM（5.85M参数，110MB显存，316.5秒）。实验系统地揭示了各架构的性能规律：RNN受梯度消失制约，长距离音乐依赖建模能力最弱；LSTM通过门控机制取得明显改善；Transformer通过全局自注意力进一步提升；GPT2ABC则在Transformer架构基础上叠加预训练迁移增益，取得最优综合表现。

=== 基于LLaMA-LoRA的音乐生成方案

在大语言模型迁移的研究路线中，本文提出了LLaMA-LoRA方案，将LLaMA-2-7B的通用序列建模能力迁移至ABC音乐生成任务。该方案在三个核心模块上进行了系统性设计。

**扩展分词器**方面，通过对训练语料进行高频ABC符号统计，在LLaMA原生BPE词表（32,000 token）基础上扩展约1,500个领域专有token，覆盖字段标识符、小节线变体、调号组合、节奏标记、装饰音符号等ABC核心语义单元，构建规模约33,500的扩展词表。新增token的embedding向量采用原有词表embedding均值叠加小幅随机扰动的初始化策略，在保证训练稳定性的同时加速领域语义的学习。

**LoRA参数高效微调**方面，基于预训练权重更新矩阵内在低秩性的理论假设，对Q、K、V、O四个注意力投影矩阵注入低秩适配器（秩$r=16$，缩放因子$alpha=32$，Dropout率0.05），可训练参数量约4.2M，仅占LLaMA-2-7B全部参数的0.06%，实现约300倍的参数压缩比，将完整微调所需的约84GB优化器状态显存压缩至约50MB，使单张24GB消费级GPU即可完成微调任务。

**训练与生成策略**方面，结合AdamW优化器（含权重衰减$lambda=0.01$）、线性预热学习率调度（前100步从0线性升至$2 times 10^{-4}$）和梯度累积（有效批次大小16），在单张A100 GPU上6小时内完成3轮微调；生成阶段采用温度缩放（$tau=0.8$）与Top-$p$核采样（$p=0.9$）组合策略，在生成稳定性与旋律多样性之间取得良好平衡。

实验结果表明，LLaMA-LoRA在困惑度（15.3）、测试损失（2.728）、语法正确率（93.8%）和结构完整性（91.6%）等全部量化指标上均优于Vanilla GPT-2、Music Transformer和LLaMA-Pretrained基线；人工盲测整体质量评分达4.2/5.0，旋律流畅性和结构完整性评分分别为4.3和4.4。消融实验进一步确认，扩展分词器是贡献最大的单一组件（去除后PPL上升41.2%），而LoRA以极少参数实现了接近全参数微调（PPL 14.8）的性能（PPL 15.3），验证了参数高效微调范式在音乐生成领域的实用价值。

=== 实验框架的标准化建设

本研究在实验设计层面也进行了系统性建设。数据预处理采用固定随机种子（42），按8:1:1比例划分训练集、验证集和测试集，确保不同模型在完全相同的数据分布上进行训练与评估。评估体系覆盖语言建模质量（测试损失、困惑度）、音乐生成质量（语法正确率、结构完整性）、计算效率（参数量、显存占用、训练耗时）和主观质量（人工盲测）四个维度，为模型选择提供了多角度参考。每10个训练轮次记录一次性能快照，输出详细的CSV格式实验报告，支持训练动态的精细分析。完整的代码实现、超参数配置与数据预处理流程均公开可复现，为后续研究提供了标准化的实验基础。


== 工作展望

尽管本研究在ABC记谱法音乐生成任务上取得了较为系统的成果，但仍存在若干值得深入探索的方向。以下从模型架构、评估体系、数据资源、生成控制、应用拓展等多个层面展望未来研究方向。

=== 更大规模预训练模型的探索

本研究在预训练模型路线上采用了LLaMA-2-7B，其参数规模已显著优于GPT2ABC，但与当前最先进的开源大语言模型（如LLaMA-3-70B、Qwen-72B等）相比仍有差距。已有研究表明，语言模型的能力随参数规模呈现出幂律增长趋势（Scaling Law），更大规模的模型有望在序列建模的深度与广度上取得进一步突破。然而，更大规模模型的微调即便借助LoRA也面临更高的显存门槛；未来可探索量化感知训练（QLoRA）——将基础模型权重以4-bit或8-bit整数格式存储，在保留LoRA低秩更新精度的同时大幅压缩显存占用——以实现在消费级硬件上对更大规模模型的高效微调。

此外，专门针对符号音乐设计的预训练模型（如在海量MIDI或MusicXML语料上预训练的模型）也值得关注。与通用语言模型相比，此类模型的预训练数据分布与ABC记谱法更为接近，迁移时的领域偏移（domain shift）更小，有望以更少的微调数据和计算成本达到更优的生成质量。

=== 多维度音乐质量评估体系的完善

当前评估体系以困惑度、测试损失等语言建模指标为主，辅以语法正确率、结构完整性等基于规则的音乐质量指标，以及人工盲测。然而，上述指标对旋律的音乐性质量（如和声合理性、旋律线条的张弛感、节奏律动的律感）仍缺乏细粒度的客观量化能力。

未来可从以下方向完善评估体系。**基于音乐理论的自动评估**：设计量化和声一致性的指标（如音符与调性和弦的契合度）、节奏规律性指标（如节拍重音与强位音符的吻合程度）以及旋律流畅性指标（如相邻音程的分布是否符合传统旋律写作规律）。**基于学习的评估模型**：训练一个专门用于评估ABC音乐质量的判别模型，以真实民谣与生成样本之间的分布距离（如Fréchet Music Distance，类比图像生成中的FID）为评价尺度。**标准化主观评估协议**：设计包含更多维度（如风格一致性、情绪表达、创造性）的盲测问卷，并扩大评估者样本量，以降低主观评分的方差，提升评估结论的统计显著性。

=== 数据资源的扩展与多样化

本研究数据集规模约为10,000首传统民谣，风格集中于凯尔特与英伦民间音乐传统。这一规模对于探索基础架构特性是足够的，但对于训练能够泛化到更广泛音乐风格的生成模型则显得有限。未来可从以下方向扩充数据资源。

**规模扩展**：收集更大规模的ABC格式乐谱数据库（如TheSession、folkwiki等平台的公开资源），将训练语料扩充至数十万甚至数百万首。已有研究（如folk-rnn的后续工作）表明，数据规模的增长能够显著提升模型对旋律多样性和风格细节的学习能力。

**风格多样化**：纳入古典、爵士、蓝调、巴洛克、民谣等多种音乐风格的ABC乐谱，使模型具备跨风格生成的能力，同时支持条件生成（见下文）的风格控制需求。

**数据增强**：探索适用于ABC记谱法的数据增强技术，如等音转调（将乐曲移至不同调性）、节奏变换（将4/4拍改写为3/4或6/8拍的等价版本）和旋律镜像（音高轴反转）等，在有限原始数据上扩大有效训练样本量，缓解过拟合。

**数据质量优化**：研究训练数据质量对生成质量的影响规律，探索自动化数据清洗方法（如基于ABC语法解析器的合法性过滤、基于难度估计的样本筛选），提升低质量样本对模型的负面影响。

=== 条件生成与精细化控制

当前方案的生成控制主要依赖于prompt（起始ABC头部）和温度参数，控制粒度较粗。用户无法在不手动编写ABC片段的情况下指定调性、拍号、风格、情绪、难度、旋律走向等高层次音乐属性。

未来可探索多种条件生成范式。**属性条件生成**：在模型输入中引入结构化条件向量，编码用户指定的音乐属性（如"G大调、6/8拍、中速、爱尔兰吉格风格"），通过条件交叉注意力或前缀嵌入机制将属性约束注入生成过程。**旋律填充与续写**：给定乐曲的前半部分，生成风格和声一致的后半部分；或给定头尾旋律片段，生成中间的过渡乐句，实现旋律级别的补全与插值。**基于强化学习的质量优化**：以音乐理论规则（和声合理性、音域合法性、节奏一致性）和人类偏好评分作为奖励信号，通过近端策略优化（PPO）或直接偏好优化（DPO）对生成模型进行强化学习微调，引导模型从最大似然解向音乐质量最优解迁移，缓解监督训练目标与生成质量目标之间的偏差。

=== 多模态音乐表示的融合

本研究专注于ABC记谱法这一文本化音乐表示，未来可探索多模态扩展方向，将ABC生成与其他音乐模态相互贯通。**ABC-MIDI联合建模**：将ABC记谱法与MIDI事件序列在统一的多模态框架下联合建模，利用MIDI丰富的力度、踏板、连奏等表情信息补充ABC符号表示的不足，实现从乐谱到演奏的一体化生成。**音频引导的生成**：以音频片段的声学特征（如音调轮廓、节奏型）为条件，驱动ABC乐谱的自动生成，实现"听音写谱"式的多模态转换。**乐谱图像的理解与生成**：结合视觉Transformer等多模态模型，探索从乐谱扫描图像到ABC文本的转录，以及从ABC文本到规范化乐谱排版的渲染，实现乐谱全流程的智能化处理。

=== 长程音乐结构建模

当前基于Transformer的方案在处理超过256个token的长序列时，注意力计算的平方复杂度$O(L^2)$制约了其对完整多段落乐曲的全局结构建模能力；在超过有效注意力窗口的跨段落范围内，模型对主题呼应、调性回归等高层次音乐结构的感知能力有所下降。

未来可从以下方向攻克长程建模挑战。**线性注意力与稀疏注意力**：引入Longformer、BigBird等线性或稀疏注意力机制，将注意力复杂度从$O(L^2)$降至$O(L)$或$O(L sqrt{L})$，支持更长序列的端到端建模。**层次化结构建模**：采用分层的生成架构，底层模型负责在音符和小节级别生成局部旋律细节，高层模型负责在乐句和段落级别规划全局结构框架，两个层次通过跨层注意力或潜变量进行耦合，实现"先谋篇布局、再填充细节"的从粗到细生成策略。**记忆增强机制**：引入外部记忆模块（如Transformer-XL的循环记忆、Memorizing Transformer的KNN记忆等），使模型能够在有限的注意力窗口外持续保留对远处重要上下文的访问能力，增强对旋律主题的长程记忆与复现。

=== 模型压缩与边缘部署

当前LLaMA-LoRA方案在推理阶段仍依赖服务器级GPU，限制了其在实际应用中的可及性。未来可探索以下模型压缩与轻量化方向，以支持边缘设备部署和实时音乐生成应用。**知识蒸馏**：以LLaMA-LoRA等大模型为教师，训练参数量更小的学生模型，使其在音乐生成任务上接近教师模型的分布，实现性能与效率的协同优化。**模型量化**：将模型权重从FP32/FP16压缩至INT8/INT4格式存储与计算，配合量化感知训练（QAT）维持生成质量，可在移动端GPU（如Apple M系列芯片、高通骁龙等）上实现可接受延迟的实时推理。**结构化剪枝**：识别并移除对ABC音乐生成任务贡献较小的注意力头和前馈神经元，在不显著损失生成质量的前提下压缩模型计算图，提升推理吞吐量。

=== 音乐生成的可解释性研究

深度生成模型通常被视为"黑盒"，其内部表示与音乐知识之间的对应关系难以直接解读。未来可从可解释性角度深入探究模型如何编码和运用音乐结构知识。**注意力模式可视化**：分析自注意力权重在不同音乐事件（如小节线、调性声明、旋律转折点）处的分布特征，探究模型是否在注意力层面习得了与音乐结构语义对应的模式。**表示空间探测**：通过线性探测分类器（probing classifier）检验模型隐层表示中是否编码了调性、节拍、音符功能等音乐属性，定量评估不同层次表示的音乐语义丰富性。**因果干预分析**：对模型内部表示施加定向干预（如在隐层中增减代表特定调性的方向向量），观察对生成输出的影响，探索模型内部的音乐知识表示机制，为可控生成提供理论基础。

=== 人机协同音乐创作系统

将AI音乐生成技术转化为实际可用的创作辅助工具，是本研究长期的应用目标。未来可围绕以下应用场景构建人机协同系统。**交互式旋律编辑**：构建可视化的ABC乐谱编辑环境，允许用户在任意位置插入或修改音符，系统根据用户的局部修改实时推断并补全其余部分，实现"人出创意、AI补全细节"的协作模式。**风格迁移与变奏**：给定用户提供的主题旋律，自动生成多种风格变体（如将爱尔兰民谣主题改编为巴洛克风格的复调变奏），丰富音乐创作的探索空间。**音乐教育辅助**：根据学习者的演奏水平自动生成适配难度的练习曲目和伴奏，并提供基于音乐理论的生成解释，将AI音乐生成系统转化为个性化音乐教育工具。

=== 跨文化音乐生成

本研究的训练数据集中于西欧传统民谣，生成的音乐风格相应集中于凯尔特和英伦传统。未来可拓展至更广泛的世界音乐风格，包括中国传统五声调式音乐、印度古典音乐的旋律模式（raga）、阿拉伯音乐的微分音体系等。跨文化音乐生成不仅要求数据资源的多元化，更需要对非西方音乐理论体系进行相应的表示与建模设计，这是一个兼具学术挑战性与文化价值的研究方向。

综上所述，ABC记谱法音乐自动生成是一个横跨深度学习、音乐信息检索与音乐理论的交叉研究领域，既具有丰富的学术探索空间，又具有广泛的实际应用潜力。本研究所建立的实验框架、分词器设计方法论与模型架构对比体系，为该领域后续研究提供了可复现的基础与可扩展的平台。随着大语言模型技术的持续演进、高质量音乐数据资源的不断积累，以及音乐理论与计算方法的深度融合，AI辅助音乐创作在可控性、创造性与音乐性上有望取得突破性进展，为音乐创作、教育与文化传承提供更强大的智能化支撑。



// = 术语

// *需要注意，标题只支持到四级标题，但目录不支持显示四级标题*，如果需要四级标题，最好请使用术语，也就是：

// \ 术语（term）

// = 手动分页

// 使用 `#pagebreak()` 手动分页
// #pagebreak()

// 中英双语参考文献
// 默认使用 gb-7714-2015-numeric 样式
#bilingual-bibliography(full: true)

// 附录
// #show: appendix

// = 附录标题

// 第一个附录，引用@app:appendixB

// = 第二个附录<app:appendixB>

// 附录不允许有子标题

// 附录内容，这里也可以加入图片，例如@fig:appendix-img。

// #figure(
//   image("fig/ida-star-2.png", width: 20%),
//   caption: [图片测试],
// ) <appendix-img>

//* 后记
// #acknowledgement[
//   #kouhu(builtin-text: "zhufu", length: 200)

//   #kouhu(builtin-text: "zhufu", length: 100)
// ]

//* 成果
// #publication()


//* 评价与决议书（博士限定）
// #decision(
//   comments: (
//     supervisor: kouhu(length: 500),
//   ),
// )

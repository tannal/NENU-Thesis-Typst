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
    title: "基于大语言模型的ABC音乐生成",
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

#set math.equation(numbering: (..nums) => {
  let count = nums.pos()
  "(" + count.map(str).join(".") + ")"
})

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
  keywords: ("符号音乐生成", "ABC记谱法", "GPT-2", "扩展定律", "计算音乐学", "自注意力机制"),
)[
符号音乐作为人类高度抽象的离散艺术语言，在序列维度上受到严格的物理声学调式排他律、小节时值代数守恒律以及跨越数十至数百步的长程动机呼应约束。然而，传统生成模型多局限于循环神经网络（RNN/LSTM）等浅层时序拓扑，不仅受制于循环状态迭代的梯度弥散与长程记忆瓶颈，且在纯文本记谱建模中缺乏乐理原子感知的专业分词系统；同时，符号音乐在大模型扩展定律（Scaling Laws）与计算音乐学双轨量化评估领域的系统性研究长期处于空白。

针对上述挑战，本文设计并实现了基于自回归因果 Transformer 解码器架构的符号音乐生成系统 GPT2ABC。首先，针对 ABC 记谱法的双重文本-音乐语义特性，推导并构建了面向 ABC 语法的专用分词系统 ABCTokenizer。该系统基于前缀树 Trie 的贪婪最长匹配策略，在构建仅包含 91 个紧凑 Token 的词表下，完整固化了调号、音高八度、时值分母与小节线等乐理边界。消融实验表明，ABCTokenizer 将等效字符信息熵压缩率降至 0.4604 bpc（相比字符级分词的 0.7820 bpc 提升了 41.1% 的表达效率），并将生成小节的时值代数守恒通过率提升至 96.8%。

其次，在动力学方程与梯度流动层面，本文系统剖析了 Vanilla RNN、LSTM、标准 Transformer 与 GPT2ABC 的归纳偏置差异。在经过十二半音循环群 $bb(Z)_(12)$ 离散数据增强构建的 550,200 首曲目（约 1 亿 Token）高保真数据集上开展受控实验。评测结果表明：GPT2ABC 在验证集上取得了 0.9055 的测试损失与 2.4732 的困惑度（PPL），相比 LSTM 基线（损失 1.5230，PPL 4.59）实现了 40.54% 的测试损失显著降幅，并实现了 38.8% 的端到端训练收敛加速，有力证实了 Pre-LN 结构与多头因果自注意力在多时间尺度动机建模上的架构优越性。

再次，本文在国际上首次推导并验证了符号音乐生成领域的参数扩展定律。通过在非嵌入参数量 $0.12 "M"$ 至 $12.4 "M"$ 范围内建立参数幂律拟合，得出关系式 $cal(L)(N) = (3.12 times 10^3 / N)^(0.142) + 0.725$（判定系数 $R^2 = 0.9951$）。音乐生成的参数扩展指数 $alpha_N = 0.142$ 约为自然语言处理领域的 1.87 倍，揭示了符号音乐高度确定的局部语法约束带来了更显著的早期缩放边际收益。

最后，本文构建了涵盖 9 维计算音乐学指标的评估体系。GPT2ABC 生成样本在音阶一致性（0.9928 vs 真实数据集 0.9922）与音符类多样性（7.08 vs 7.17）上高度拟合人类真实分布。同时，本文客观揭示了当前自回归模型的局限性：休止符生成的保守坍缩导致空拍率仅为 0.0000，且仍存在 3.2% 的小节时值语法残差，为未来引入代数符号硬约束与强化学习对齐提供了明确的研究方向。
]

#abstract-en(
  keywords: ("Symbolic Music Generation", "ABC Notation", "GPT-2", "Scaling Laws", "Computational Musicology", "Self-Attention"),
)[
Symbolic music, as a highly structured and discrete human cognitive representation, is governed by rigorous physical-acoustic modal exclusivity, algebraic bar duration conservation, and long-range motif recurrence spanning dozens of measures. However, traditional symbolic generation approaches predominantly rely on shallow recurrent topologies such as RNNs and LSTMs, which suffer from severe gradient dissipation, finite hidden-state information bottlenecks, and the absence of specialized tokenization capable of preserving musical atomic boundaries. Furthermore, empirical investigations concerning power-law scaling laws and multidimensional computational musicological evaluations in symbolic music remain largely unexplored.

To address these challenges, this thesis presents GPT2ABC, an end-to-end symbolic music generation framework based on the Pre-LN causal Transformer decoder architecture. First, tailored to the dual text-music semantic nature of ABC notation, we derive ABCTokenizer based on a trie-based greedy longest-matching scheme. Operating with a compact vocabulary of only 91 tokens, it preserves critical musical boundaries including key signatures, octave registers, note duration modifiers, and bar lines. Cross-tokenizer ablation demonstrates that ABCTokenizer achieves an equivalent character information compression of 0.4604 bits-per-character (bpc), yielding a 41.1% compression gain over character-level tokenization (0.7820 bpc) while boosting bar metric validity to 96.8%.

Second, from the perspectives of dynamical equations and gradient flow mechanics, we systematically analyze the inductive biases of Vanilla RNN, LSTM, standard Post-LN Transformer, and GPT2ABC. Controlled benchmarks conducted on a high-fidelity folk corpus augmented via the twelve-semitone cyclic group $bb(Z)_(12)$ (550,200 tunes, ~100M tokens) show that GPT2ABC achieves a test loss of 0.9055 and a perplexity of 2.4732. This represents a 40.54% loss reduction over the LSTM baseline (loss 1.5230, PPL 4.59) and a 38.8% training convergence speedup, empirically verifying the superiority of Pre-LN causal self-attention in capturing multi-scale hierarchical motifs.

Third, this work establishes the first parameter scaling law for symbolic music. Across model capacities ranging from 0.12M to 12.4M non-embedding parameters, the empirical loss follows a strict power-law scaling trajectory: $cal(L)(N) = (3.12 times 10^3 / N)^(0.142) + 0.725$ with a goodness-of-fit $R^2 = 0.9951$. The scaling exponent $alpha_N = 0.142$ is approximately 1.87 times that observed in natural language modeling, proving that the deterministic syntactic and harmonic constraints of music enable significantly faster marginal returns during early capacity scaling.

Finally, a dual-track evaluation framework integrating 9-dimensional MusPy statistical metrics is established. Generated pieces closely match the ground-truth human distribution in scale consistency (0.9928 vs 0.9922) and unique pitch classes (7.08 vs 7.17). Meanwhile, we honestly identify critical limitations: a collapsed empty beat rate of 0.0000 reveals conservative rest suppression, and a 3.2% bar syntax residual error highlights the necessity of neuro-symbolic algebraic constraints in future research.
]


//* 目录
#outline-page()

//* 插图目录
#list-of-figures()

//* 表格目录
#list-of-tables()

//* 符号表
#notation[
  // ── 模型、架构与系统缩写 ─────────────────────────────────────────────────
  / RNN: 循环神经网络（Recurrent Neural Network）
  / LSTM: 长短期记忆网络（Long Short-Term Memory）
  / GPT-2: 生成式预训练 Transformer 第二版（Generative Pre-trained Transformer 2）
  / GPT2ABC: 本文提出的面向 ABC 记谱法的因果解码自注意力音乐生成模型
  / BPTT: 沿时间反向传播算法（Backpropagation Through Time）
  / MHA: 多头因果自注意力机制（Multi-Head Attention）
  / MLP: 多层感知机前馈网络（Multi-Layer Perceptron / FFN）
  / Pre-LN: 前置层归一化残差拓扑结构（Pre-Layer Normalization）
  / SSM: 自身相似度矩阵（Self-Similarity Matrix）
  / GEMM: 通用稠密矩阵乘法（General Matrix Multiply）
  / CEC: 恒定误差轮联机制（Constant Error Carousel）

  // ── 序列表示与词表空间 ───────────────────────────────────────────────────
  / $bold(x)$: ABC 记谱离散符号序列，$bold(x) = (x_1, x_2, dots, x_T)$
  / $x_t$: 序列第 $t$ 个离散时间步的 Token
  / $T$: 输入序列长度（本文模型上下文窗口统一取 $T = 256$）
  / $cal(V)$: 离散音乐词表（Token 集合）
  / $|cal(V)|$: 词表规模，本文 ABCTokenizer 精简词表 $|cal(V)| = 91$
  / $K_"max"$: 分词贪婪最长匹配的最大窗口长度，本文取 $K_"max" = 4$
  / $⟨"bos"⟩$: 序列起始特殊标记（Beginning of Sequence）
  / $⟨"eos"⟩$: 序列终止特殊标记（End of Sequence）
  / $⟨"pad"⟩$: 序列填充对齐标记（Padding Token）
  / $⟨"unk"⟩$: 未登录/未知符号标记（Unknown Token）

  // ── 网络维度与张量表示 ───────────────────────────────────────────────────
  / $L$: Transformer 解码器堆叠层数
  / $d$: 模型隐层特征维度（$d_"model"$）
  / $h$: 多头注意力头数
  / $d_k$: 单注意力头的键/查询子空间维度，$d_k = d \/ h$
  / $bold(E)$: 词嵌入矩阵（Token Embedding），$bold(E) in bb(R)^{T times d}$
  / $bold(P)$: 可学习位置编码矩阵（Position Embedding），$bold(P) in bb(R)^{T times d}$
  / $bold(H)^{(l)}$: 第 $l$ 层 Transformer 解码块输出特征张量
  / $bold(W)_E$: 词嵌入权重矩阵（输入与输出分类头权重绑定），$bold(W)_E in bb(R)^{|cal(V)| times d}$
  / $bold(z)_t$: 输出层第 $t$ 步未经归一化的分类对数几率向量（Logits）

  // ── 注意力投影与因果掩码 ─────────────────────────────────────────────────
  / $bold(Q)_m, bold(K)_m, bold(V)_m$: 第 $m$ 个注意力头的查询、键、值张量
  / $bold(W)_(Q,m), bold(W)_(K,m), bold(W)_(V,m)$: 第 $m$ 个注意力头的线性投影权重矩阵
  / $bold(W)_O$: 多头注意力拼接输出投影矩阵，$bold(W)_O in bb(R)^(d times d)$
  / $bold(M)$: 因果下三角掩码矩阵（Causal Mask），$bold(M)_(i j) = 0$（$i >= j$）或 $-infinity$（$i < j$）

  // ── 代数对称性与数据增强 ─────────────────────────────────────────────────
  / $bb(G)_"Pitch"$: 十二平均律半音阶代数循环群，$bb(G)_"Pitch" = (bb(Z)_(12), +)$
  / $p$: 绝对半音阶整数音高值（MIDI Pitch，$p in [0, 127]$）
  / $cal(T)_k$: 十二平均律无损音高移调算子，$cal(T)_k (p) = (p + k) mod 12$
  / $Delta bold(P)$: 相邻旋律音程相对阶差向量，$Delta p_i = p_(i+1) - p_i$
  / $cal(M)_k$: 复合音乐三元组全变换算子，$cal(M)_k (n_i) = (cal(T)_k (p_i), d_i, t_i)$

  // ── 神经扩展定律（Scaling Laws）参数 ─────────────────────────────────────
  / $N$: 模型非嵌入参数量（Non-Embedding Parameters），$N = L dot (12 d^2 + 13 d)$
  / $D$: 训练集有效数据规模（总 Token 数量）
  / $C$: 自回归语言模型训练浮点运算总开销（FLOPs），$C approx 6 N D$
  / $cal(L)(N)$: 模型在非嵌入参数量为 $N$ 时的测试/验证交叉熵损失
  / $alpha_N$: 参数规模标度指数（Scaling Exponent），本文实测拟合值 $alpha_N = 0.138$
  / $N_c$: 特征尺度常数，本文拟合值 $N_c = 1.84 times 10^4$
  / $cal(L)_oo$: 理论渐近不可约信息熵下界（Irreducible Loss），本文拟合值 $cal(L)_oo = 0.825 " nats"$
  / $R^2$: 经验幂律回归方程的判定系数（拟合优度），本文实测 $R^2 = 0.9942$
  / $delta cal(L)$: 泛化差距 / 经验过拟合损失增量，$delta cal(L) = cal(L)_"val" - cal(L)_"train"$

  // ── 硬件显存预算对账（RTX 4090 单卡物理约束） ─────────────────────────────
  / $M_"param"$: 浮点权重参数常驻显存，$M_"param" = 4N " 字节"$
  / $M_"grad"$: 参数反向梯度张量显存，$M_"grad" = 4N " 字节"$
  / $M_"opt"$: AdamW 一阶动量与二阶动量状态显存，$M_"opt" = 8N " 字节"$
  / $M_"static"$: 单精度训练总静态显存，$M_"static" = 16N " 字节"$
  / $M_"total"$: 单步训练总物理显存占用（静态显存 + 动态前向激活显存缓冲区）

  // ── 采样控制与计算音乐学评估指标 ─────────────────────────────────────────
  / $tau$: 采样温度系数（Temperature），$tau < 1$ 趋于保守，$tau > 1$ 增强多样性
  / $p$: Top-$p$ 动态核采样概率质量阈值（Nucleus Sampling）
  / $"PPL"$: 困惑度（Perplexity），$"PPL" = exp(cal(L)_"test")$
  / $bold(S)$: 自身相似度矩阵（Self-Similarity Matrix），$bold(S) in bb(R)^(T times T)$
  / $bold(v)_t$: 时间步 $t$ 处的 12 维色度音级特征向量（Chroma Vector）
]


//* 正文
#show: mainmatter

//TODO 完整的写一下使用说明

#include "chapter1.typ"

#include "chapter2.typ"

#include "chapter3.typ"

#include "chapter4.typ"

#include "chapter5.typ"

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

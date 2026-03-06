#import "../lib.typ": thesis
#import "@preview/kouhu:0.2.0": kouhu
#import "@preview/codly:1.3.0": codly, codly-init, no-codly
#import "@preview/codly-languages:0.1.8": *

#import "@preview/embiggen:0.0.1": *
#import "@preview/lovelace:0.3.0": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#import "my_pkg_typ/utils/highlight-table.typ": highlight-table
#import "my_pkg_typ/utils/model_graph.typ": (
  edge_args, enclose_node_args, ffn_node_args, function_node_args, io_node_args, mha_node_args, module_node_args,
  operator_node_args, residual_edge_args,
)

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
  info: (
    title: ("毕业论文中文题目", "基于扩散与流匹配的蛋白质口袋设计方法研究"),
    title-en: "Research on Protein Pocket Design Methods Based on Diffusion and Flow Matching",
    grade: "2024",
    student-id: "2024103293",
    author: "曾令树",
    author-en: "Lingshu Zeng",
    secret-level: "无",
    secret-level-en: "Unclassified",
    department: "信息科学与技术学院",
    department-en: "School of Information Science and Technology",
    discipline: "计算机科学与技术",
    discipline-en: "Computer Science and Technology",
    major: "计算机科学",
    major-en: "Computer Science",
    field: "深度学习理论与应用",
    field-en: "Deep Learning Theory and Applications",
    supervisor: ("付治国", "教授"),
    supervisor-en: "Zhiguo Fu",
    submit-date: datetime.today(),
    reviewers: (
      (name: "", workplace: "", evaluation: ""),
      (name: "", workplace: "", evaluation: ""),
      (name: "", workplace: "", evaluation: ""),
      (name: "", workplace: "", evaluation: ""),
      (name: "", workplace: "", evaluation: ""),
    ),
    committee-members: (
      (name: "", workplace: "", title: ""),
      (name: "", workplace: "", title: ""),
      (name: "", workplace: "", title: ""),
      (name: "", workplace: "", title: ""),
      (name: "", workplace: "", title: ""),
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

//*中文摘要
#abstract(
  keywords: ("蛋白质口袋设计", "扩散模型", "流匹配", "SE3不变与等变", "图神经网络"),
)[
  蛋白质口袋是指与配体距离在指定范围内的所有残基的集合。蛋白质口袋设计旨在生成能够与特定配体高效结合的蛋白质。蛋白质口袋设计是实现蛋白–配体相互作用精准调控、提升药物研发效率，并推动理性药物设计与功能蛋白工程发展的关键基础。现有蛋白质口袋生成方法仍有很多问题，如生成质量不高、可控性差和计算效率低。

  本文针对生成质量不高、可控性差问题提出基于扩散模型的 DiffPocket，DiffPocket 采用 DDPM 作为生成框架，对蛋白质的$C alpha$原子坐标进行扩散，将配体、口袋掩码和非口袋区域作为条件输入，用于指导口袋的生成过程。采样完成后，使用ProteinMPNN对生成的口袋结构进行序列设计。实验结果表明，在CrossDocked数据集上，DiffPocket在Vina Score（-7.599）和Uni-GBSA（-55.585）等结合亲和力指标上表现优异，在pLDDT（86.422）和AAR（53.75%）方面也取得了良好的性能，提高了生成质量和生成的可控性。

  针对计算效率低的问题，本文提出了基于最优传输流匹配的 FlowPocket ，FlowPocket在较低采样步数下能够取得与扩散模型相当的生成质量，实验结果表明在CrossDocked数据集上， FlowPocket 在Vina Score 与 Uni-GBSA 上与DiffPocket表现相当，且优于传统的口袋生成方法，在保持生成质量的同时显著提升了采样效率，验证了流匹配方法在蛋白质口袋设计任务中的有效性和高效性。

  综上所述，本文聚焦于蛋白质口袋生成任务，针对现有方法生成质量不高、可控性差、计算效率低的问题，提出了两个针对性的模型，并在公开数据集上的进行了测试，验证了方法的可行性与有效性。上述研究为高质量、高可控且高效率的蛋白质口袋设计提供了新的思路，也为后续基于生成模型的结构生物学与药物设计研究奠定了基础。
]

//* 英文摘要
#abstract-en(
  keywords: (
    "Protein Pocket Design",
    "Diffusion Models",
    "Flow Matching",
    "SE(3) Invariance and Equivariance",
    "Graph Neural Networks",
  ),
)[
  A protein pocket refers to the set of all residues within a specified distance from a ligand. Protein pocket design aims to generate proteins that can efficiently bind to specific ligands. Protein pocket design is a crucial foundation for achieving precise regulation of protein-ligand interactions, improving drug discovery efficiency, and promoting rational drug design and functional protein engineering. Existing protein pocket generation methods still have many problems, such as low generation quality, poor controllability, and low computational efficiency.

  This paper proposes DiffPocket, a diffusion model-based method addressing the issues of low generation quality and poor controllability. DiffPocket uses DDPM as the generation framework, diffusing the $C alpha$ atom coordinates of the protein, and using the ligand, pocket mask, and non-pocket regions as conditional inputs to guide the pocket generation process. After sampling, ProteinMPNN is used for sequence design of the generated pocket structure. Experimental results show that on the CrossDocked dataset, DiffPocket performs excellently in binding affinity metrics such as Vina Score (-7.599) and Uni-GBSA (-55.585), and also achieves good performance in pLDDT (86.422) and AAR (53.75%), improving generation quality and controllability.

  To address the problem of low computational efficiency, this paper proposes FlowPocket, based on optimal transport flow matching. FlowPocket can achieve comparable generation quality to diffusion models with fewer sampling steps. Experimental results show that on the CrossDocked dataset, FlowPocket performs comparably to DiffPocket in Vina Score and Uni-GBSA, and outperforms traditional pocket generation methods. While maintaining generation quality, it significantly improves sampling efficiency, validating the effectiveness and efficiency of the flow matching method in protein pocket design tasks.

  In summary, this paper focuses on the protein pocket generation task, addressing the problems of low generation quality, poor controllability, and low computational efficiency of existing methods. Two targeted models are proposed and tested on public datasets, verifying the feasibility and effectiveness of the methods. The above research provides new ideas for high-quality, highly controllable, and highly efficient protein pocket design, and lays the foundation for subsequent research on structure biology and drug design based on generative models.
]

//* 目录
#outline-page()

//* 插图目录
#list-of-figures()

//* 表格目录
#list-of-tables()

//* 符号表
#notation[
  / $and$: 表示逻辑与（Logical AND）
  / $or$: 表示逻辑或（Logical OR）
  / $NN$: 自然数（natural number）
  / $NN^+$: ${n in NN and n eq.not 0}$
  / $RR$: 实数域（Real Number Field）
  / $bold(x)$: 向量$x$（Vector）
  / $X$: 矩阵$X$（Matrix）
  / $I$: 单位矩阵$I$（Identity Matrix）
  / $e$: 自然常数，$e=sum_(n=0)^(infinity) 1/(n!)$
  / $(Omega,cal(F),P)$: 概率空间（Probability Space）,其中$Omega$为样本空间，$cal(F)$为$Omega$的$sigma$代数，$P$为$cal(F)$上的概率测度。
  / $phi_(\#) P$: 表示概率测度$P$在可测映射$phi$下的像测度（image measure）, 也被称作推前测度（push-forward measure）.
  / ln: 自然对数（Natural Logarithm）
  / $cal(N)(bold(x);bold(a),Sigma)$: 表示均值为$bold(a)$,协方差矩阵为$Sigma$的高斯分布（Gaussian Distribution）
  / $cal(U)(a,b)$: 表示区间$[a,b]$上的均匀分布（Uniform Distribution）
  / $EE$: 数学期望（Expectation）
  / $nabla_(bold(x))f(bold(x))$: $f$对向量$bold(x)$的梯度（Gradient）
  / div或$nabla dot f$: 表示向量场的散度算子（divergence operator）
  / $Delta_(x) f(x)$: 拉普拉斯算子（Laplace operator）
  / $O_m$: $m$阶正交矩阵群 (Orthogonal matrix group)
  / $"SO"(3)$: 三维旋转群 (3D rotation group)
  / $"SE"(3)$: 三维空间中的欧几里得群 (Euclidean group)
]

//* 正文
#show: mainmatter

//TODO 完整的写一下使用说明

= 绪 论

随着人工智能技术的迅猛发展，深度学习已成为推动社会进步与产业升级的核心动力。作为人工智能的关键支撑，深度学习在社会生产与日常生活中得到广泛应用。在制造业中，CNN @li2021survey 用产品缺陷检测 @wang2018fast，LSTM @hochreiter1997long 网络分析设备传感器数据，预测故障发生时间。在医疗业中，U-Net @ronneberger2015u 被应用用于CT和图像分割，GAN @goodfellow2020generative 用于生成新分子结构，加速药物发现。在生活领域，以Transformer @vaswani2017attention 为基础的大语言模型被广泛应用于自然语言处理、机器翻译、智能问答等领域。

在深度学习的快速发展过程中，生成式模型#cite(<lai2025deep>) 的突破成为研究热点。其中，扩散模型（Diffusion Models）#cite(<yang2023diffusion>) 近年来凭借其强大的生成能力和建模优势，受到学术界与工业界的广泛关注。DDPM（Denoising Diffusion Probabilistic Models）@ho2020denoising 通过逐步向数据添加噪声并学习逆过程还原的方式，能够生成高质量、细节丰富且多样化的样本，相比早期生成模型（如GAN、VAE @kingma2022autoencodingvariationalbayes）更稳定、训练更容易收敛，并在图像生成任务中实现了接近甚至超越GAN的效果，成为扩散模型快速发展的重要里程碑。特别是在条件生成任务中，扩散模型通过引入条件信息 $y$ 可以学习条件分数函数 $nabla_x ln p_t (x|y)$ 实现精确的条件控制生成。

扩散模型在生命科学中的应用展现出巨大的潜力。
近年来，研究者开始将扩散模型引入蛋白质口袋生成（Protein Pocket Generation）#cite(<wu2024protein>) 任务中，通过对蛋白质三维结构的高精度建模与生成，能够高效预测潜在结合口袋。这一方法不仅有助于揭示蛋白质与小分子之间的相互作用机制，还为新药研发提供了更加智能化和高效的工具，有望显著加速药物筛选与设计的进程。
通过在蛋白质结构去噪任务上微调 RoseTTAFold @baek2021accurate 结构预测网络，研究者获得了一个蛋白质骨架的生成模型RFDiffsuion @watson2023novo ，该模型在无条件和拓扑约束的蛋白质单体设计方面取得了优异的性能.
AlphaFold #cite(<AlphaFold2021>) 是 DeepMind 开发的基于深度学习的蛋白质结构预测模型，它能够从氨基酸序列准确预测蛋白质的三维结构。传统实验方法（如 X 射线晶体学、冷冻电镜）耗时且昂贵，而 AlphaFold 通过引入注意力机制和进化信息，大幅提升了预测精度，在国际结构预测竞赛 CASP 中达到了接近实验分辨率的水平，被认为是生命科学领域的重大突破，并已广泛应用于药物研发、疾病机理研究和新型蛋白设计。

蛋白质口袋设计的核心在于模拟蛋白质与小分子配体之间的相互作用。这类相互作用在酶催化、信号转导和细胞调控等关键生物过程中发挥着决定性作用。当小分子结合到特定蛋白质位点时，往往会诱导蛋白质构象发生变化，从而调控其生物学功能，甚至产生新的功能特性。这使得蛋白质口袋设计在多个领域具有广泛的应用前景，例如构建能够在缺乏天然催化剂条件下完成化学反应的工程化酶，或开发用于检测环境污染物和生物标志物的高灵敏度生物传感器。

然而，由于配体–蛋白质相互作用的复杂性、配体与氨基酸侧链的高度柔性以及蛋白质序列与三维结构之间高度复杂的非线性依赖关系，在计算层面上生成具备高结合有效性与特异性的蛋白质口袋仍然面临重大挑战。具体来说，蛋白质–配体结合不仅受到静电作用、疏水作用、氢键、范德华力等多种非共价相互作用的共同影响，还受到溶剂效应、离子环境以及蛋白质构象动态变化的调控。这使得单一的静态结构往往无法全面反映结合位点的真实状态，而动态模拟又面临计算资源消耗巨大、采样效率低下等问题。此外，蛋白质口袋的设计还需要考虑选择性与亲和力的平衡，即如何在增强目标配体结合力的同时，避免非特异性结合造成副作用或失效，这进一步增加了设计难度。在算法层面，尽管深度学习与分子模拟技术的发展为蛋白质口袋预测和设计提供了新工具，但当前模型仍难以捕捉蛋白质序列到三维结构再到功能活性之间的全局复杂关系，尤其在稀有结构类型、柔性环区及非典型口袋中，预测准确性显著下降。因此，实现能够在计算上高效、准确、可控地生成具有高特异性与高结合活性的蛋白质口袋，仍然是结构生物学、药物设计及计算生物学领域亟待突破的核心问题。

蛋白质口袋与配体的相互作用是一个高度动态的过程，其中分子动力学信息在决定相互作用的稳定性、选择性和功能性方面起着核心作用。然而，现有的口袋生成模型大多基于静态结构，忽视了蛋白质与配体复合物在真实生理条件下的构象变化和动态行为，从而限制了其在功能设计中的精度和适用性。

= 研究背景

== 扩散模型

扩散模型是一类生成模型，它通过逐步“加噪”和“去噪”的过程来学习数据的分布。其核心思想是：先将真实数据不断加入随机噪声，直到接近完全随机的某种先验噪声（通常为高斯噪声）；然后训练一个神经网络，学习如何逆转这个加噪过程，从噪声中一步步恢复出原始数据。通过这种方式，模型能够在推理时从纯噪声中生成逼真的样本。

设$(Omega, cal(F), P_0)$为概率空间, 其中$Omega=RR^d$为样本空间, $cal(F)$为$Omega$上的$sigma$代数（即Borel $sigma$代数$cal(B)(RR^d)$），$P_0$为$Omega$上的概率测度。设$bold(x)_0 in Omega$为原始数据，扩散模型通过不断地向$bold(x)_0$加入随机噪声，得到一族概率测度${P_t, t in [0,T]}$ (离散情况下为${P_t, t in {0,1,2,...,T}}$), 其中$P_t$为$t$时刻被加噪后的数据的概率测度。$t in [0,T]$称为时间参数，$T$为最大时间。$P_0$为初始时刻的原始数据分布。假设$P_t$的概率密度函数（PDF）存在，记作$p_t (bold(x))$。


最先被广泛应用的扩散模型为DDPM#cite(<ho2020denoising>)，DDPM将原始数据$bold(x)_0 in RR^d, d in NN^+$通过如下方式逐步加噪得到$bold(x)_T tilde p_T (bold(x)) approx cal(N)(bold(0),I)$

$
  q(bold(x)_t|bold(x)_(t-1)) = cal("N") (bold(x)_t; sqrt(1 - beta_t) dot bold(x)_(t-1), beta_t dot I)
$
DDPM 的加噪过程可被重参数化为：
$
  bold(x)_t = sqrt(1 - beta_t) bold(x)_(t-1) + sqrt(beta_t) bold(epsilon), bold(epsilon) tilde cal("N") (0, I)
$

其中$bold(x)_t in RR^d$表示$t$时刻的加噪数据，$I in RR^(d times d)$表示单位矩阵，$beta_t in RR$为加噪系数，$bold(x)_0$为原始干净数据。$bold(x)_T$为完全加噪后的数据，$p_t$ 为$t$时刻被加噪后的数据的概率密度函数，$p_T$近似于标准高斯分布的概率密度函数。

#figure(caption: "DDPM扩散模型")[
  #diagram(
    node-stroke: 0.1em,
    node-fill: gradient.radial(
      blue.lighten(80%),
      blue,
      center: (30%, 20%),
      radius: 80%,
    ),
    spacing: 4em,
    node((0, 0), [$x_0$], radius: 1.5em),
    edge("-|>", [$q(x_1|x_0)$]),
    node((1, 0), [$x_1$], radius: 1.5em),
    edge("--|>"),
    node((2, 0), [$x_(t-1)$], radius: 1.5em),
    edge("-|>", [$q(x_(t)|x_(t-1))$]),
    node((3, 0), [$x_t$], radius: 1.5em),
    edge("--|>"),
    node((4, 0), [$x_T$], radius: 1.5em),
    edge((3, 0), (2, 0), "-|>", [$p_(theta)(x_(t-1)|x_t)$], bend: 30deg),
  )
]

$alpha_t := 1 - beta_t$，$overline(alpha)_t := product_(i=1)^(t)(alpha_i)$

通过重参数化，可以将多步加噪等价合并为一步加噪：

$
  q(bold(x)_t|bold(x)_(0)) = cal("N") (bold(x)_t; sqrt(overline(alpha)_t) dot bold(x)_(0), (1-overline(alpha)_t) dot I)
$

重参数化后的加噪过程为：
$
  bold(x)_t = sqrt(overline(alpha)_t) bold(x)_(0) + sqrt(1-overline(alpha)_t) bold(epsilon), bold(epsilon) tilde cal("N") (0, I)
$

DDPM采样过程可视化如 @fig:ddpm_sampling 所示。

#figure(caption: "DDPM采样可视化")[
  #image("images/ddpm.png")
]<ddpm_sampling>

研究 #cite(<song2020score>) 表明，所有的扩散过程都可用随机微分方程（SDE）来描述。

- 正向过程(加噪)：
$
  "d" bold(x) = f(bold(x), t) "d" t + g(bold(x),t) "d" w
$

其中$f(bold(x),t):RR^d times RR arrow.r RR^d$被称作漂移系数，描述系统在没有随机扰动情况下的确定性变化率。$g(bold(x),t): RR^d times RR arrow.r RR^(d times d)$被称作扩散系数，描述系统受到随机扰动的强度。$"d" w$表示$d$维标准布朗运动（Wiener过程）的增量。

特殊地，DDPM前向过程的SDE形式为：
$
  "d" bold(x) = (- beta_(t) / 2 dot bold(x)) "d" t + sqrt(beta_(t)) "d" w
$


- 逆向过程(去噪)：
$
  "d" bold(x) &= stretch(brace.l, size: #200%) f(bold(x), t) - nabla dot [g(bold(x),t)g(bold(x),t)^T] - g(bold(x),t) g(bold(x),t)^T nabla_(bold(x)) ln p_t (bold(x))stretch(brace.r, size: #200%) "d" t\
  &+ g(bold(x),t) "d" w
$
$
  "d" bold(x) &= bigg(brace.l) f(bold(x), t) - nabla dot [g(bold(x),t)g(bold(x),t)^T] - g(bold(x),t) g(bold(x),t)^T nabla_(bold(x)) ln p_t (bold(x)) bigg(brace.r) "d" t\
  &+ g(bold(x),t) "d" w
$
其中$nabla dot$表示散度算子，作用到方阵上表示逐行求散度，结果为一个向量。实际应用中，当$g(bold(x),t) = g(t) I$（即扩散系数为标量函数乘以单位矩阵）时，有$nabla dot [g(bold(x),t) g(bold(x),t)^T] = nabla dot [g^2(t) I] = 0$，因为常数矩阵的散度为零。此时逆向过程可以被简化为：
$
  "d" bold(x) &= stretch(brace.l, size: #200%) f(bold(x), t) - g^2 (bold(x),t) nabla_(bold(x)) ln p_t (bold(x))stretch(brace.r, size: #200%) "d" t
  &+ g(bold(x),t) "d" w
$
特殊地，DDPM逆向过程的SDE形式为：
$
  "d" bold(x) = (- beta_(t) / 2 dot bold(x) - beta_(t) nabla_(bold(x)) ln p_t (bold(x)))"d" t + sqrt(beta_(t)) "d" w
$

- 条件$bold(y) in RR^k$下的扩散模型的逆向过程为：
$
  "d" bold(x) & = stretch(brace.l, size: #200%)
                f(bold(x),t) - nabla dot [g(bold(x),t)g(bold(x),t)^T] - g(bold(x),t)g(bold(x),t)^T (nabla_(bold(x)) ln p_t (bold(x)|bold(y)))
                stretch(brace.r, size: #200%) "d" t \
              & + g(bold(x),t) "d" w \
              & = stretch(brace.l, size: #200%)
                f(bold(x),t) - nabla dot [g(bold(x),t)g(bold(x),t)^T] - g(bold(x),t)g(bold(x),t)^T (nabla_(bold(x)) ln p_t (bold(y)|bold(x)) + nabla_(bold(x)) ln p_t (bold(x)))
                stretch(brace.r, size: #200%) "d" t \
              & + g(bold(x),t) "d" w
$

$nabla_(bold(x)) ln p_t (bold(y)|bold(x))$被称作条件分数 ，$nabla_(bold(x)) ln p_t (bold(x))$被称作无条件分数。实际应用中，可以训练一个神经网络来学习 $nabla_(bold(x)) ln p_t (bold(y)|bold(x))$，也可以使用某些先验知识直接确定 $nabla_(bold(x)) ln p_t (bold(y)|bold(x))$。扩散模型的较为完备的随机微分方程理论为扩散模型的研究打下了坚实的基础。

扩散模型的 ODE 流（Probability Flow ODE）是一种与传统反向 SDE 等价的确定性生成方法，它将原本带噪声的反向扩散过程转换为一个无随机项的常微分方程，轨迹由初值和时间唯一确定，同时保证在任意时刻的边际分布与原 SDE 完全一致。通过这个 ODE，可以用数值积分沿平滑确定的路径将简单先验（如高斯噪声）映射到目标数据分布，相比 SDE 采样不需要在每一步引入噪声，因此通常可以用更少的积分步生成高质量样本，显著提升采样效率。扩散逆过程的ODE流为：
$
  "d" bold(x) &= stretch(\(, size: #200%) f(bold(x), t) - 1/2 dot nabla dot [g(bold(x),t)g(bold(x),t)^T] - 1/2 dot g(bold(x),t) g(bold(x),t)^T nabla_(bold(x)) ln p_t (bold(x))stretch(\), size: #200%) "d" t
$

== 线性SDE <linear_sde>
线性SDE：
$ "d" bold(x) = (a(t) bold(x) + c(t)) "d" t + (b(t)bold(x) + d(t)) "d" w \
a(t), b(t), c(t), d(t) in RR ,bold(x) in RR^d $的前向过程有显式解：
$
  bold(x)_t = Phi_(t,t_0) (bold(x)_t_0 + integral_(t_0)^t Phi^(-1)_(s, t_0) bigg(\()c(s)-b(s)d(s)bigg(\)) "d" s + integral_(t_0)^t Phi^(-1)_(s, t_0) d(s) "d" w_s) \
  Phi_(t,t_0) := exp(integral_(t_0)^t a(s) - 1/2 b^2(s) "d" s + integral_(t_0)^t b(s) "d" w_s)
$
若$c(t)eq.triple b(t) eq.triple 0$, 则
$
  bold(x)_t = exp(integral_(t_0)^t a(s) "d" s) bold(x)_t_0 + exp(integral_(t_0)^t a(s) "d" s) integral_(t_0)^t Phi^(-1)_(s, t_0) d(s) "d" w_s
$
令$u(t):=exp(integral_(t_0)^t a(s) "d" s), v(t):=exp(integral_(t_0)^t a(s) "d" s) sqrt(integral_(t_0)^t (Phi^(-1)_(s, t_0) d(s))^2 "d" s)$，则
$
  bold(x)_t = u(t) bold(x)_t_0 + v(t) epsilon, quad epsilon tilde cal(N)(0, I)
$

== 无条件扩散

之后若无特别说明，则默认扩散过程的SDE的扩散项$g(bold(x),t)$为只与$t$有关的标量值函数，即可简写为$g(t)$。

训练一个时间依赖的神经网络$s_theta (bold(x),t)$来近似无条件分数$nabla_(bold(x)) ln p_t (bold(x))$，训练目标为最小化：
$
  EE_(t tilde U(0, T)) stretch(\[, size: #300%) lambda(t) EE_(bold(x) tilde p_t) [bar.v.double s_theta (bold(x),t) - nabla_(bold(x)) ln p_t (bold(x)) bar.v.double^2_2 ] stretch(\], size: #300%)
$<learn_score>
其中$lambda:[0,T] arrow.r RR^+$是一个权重函数，给予不同时间$t$不同的权重；$t$从均匀分布$cal(U)(0, T]$中采样。
由于真实的分数函数$nabla_(bold(x)) ln p_t (bold(x))$通常难以直接计算，文献 #cite(<vincent2011connection>) 提出的去噪分数匹配（Denoising Score Matching, DSM）为扩散模型的训练提供了一种等价且可操作的训练方法。
$
  EE_(t tilde U(0, T)) stretch(\[, size: #300%) lambda(t) EE_(bold(x)_0 tilde p_0) stretch(\[, size: #150%) EE_(bold(x) tilde p_(0t)) [bar.v.double s_theta (bold(x),t) - nabla_(bold(x)) ln p_(0t) (bold(x)|bold(x)_0) bar.v.double^2_2] stretch(\], size: #150%) stretch(\], size: #300%)
$<DSM>
其中$p_(0t)(bold(x)|bold(x)_0)$为从$0$时刻的$bold(x)_0$加噪到$t$时刻得到$bold(x)$的转移概率密度。
这两个目标函数在梯度下降优化中的等价性证明见 @DSM_equivalence 。

因此，使用梯度下降优化目标函数#ref(<eqt:learn_score>)等价于优化#ref(<eqt:DSM>)，因为两者的梯度仅相差一个与参数$theta$无关的常数项。


由于扩散过程可以表示为随机微分方程，我们可以使用标准的数值方法进行采样。最常用的数值方法是Euler-Maruyama方法。设时间区间$[0,T]$被等间隔划分为${t_0=0 < t_1 < t_2 < ... < t_N=T}$，其中$Delta t = t_(i-1) - t_i = -T/N$（注意这里是逆向时间）。对于逆向扩散过程
$"d" bold(x) = a(bold(x), t) "d" t + b(bold(x), t) "d" w$
其中$a:RR^d times RR arrow.r RR^d$为漂移项，$b:RR^d times RR arrow.r RR^(d times d)$为扩散项，有Euler-Maruyama离散化：

$
  bold(x)_(t_(i-1)) = bold(x)_(t_i) + a(bold(x)_(t_i), t_i) Delta t + b(bold(x)_(t_i), t_i) Delta w
$
其中$Delta w tilde cal(N)(bold(0), |Delta t| I)$为布朗运动增量。

#figure(
  kind: "algorithm",
  //

  pseudocode-list(booktabs: true, numbered-title: [无条件扩散模型的训练])[
    + 将时间区间$[0,T]$等间隔划分：${t_0=0 < t_1 < t_2 < ... < t_N=T}$
    + 从真实分布中采样一个样本 $bold(x)_0 tilde P_0$
    + *while* not converge
      + 采样一个$i$，$i in {1, 2, ..., N}$
      + 根据$"d" bold(x) = f(bold(x), t) "d" t + g(bold(x),t) "d" w$得到$bold(x)_(t_i)$
      + $"loss" = bar.v.double s_theta (bold(x)_(t_i),t_i) - nabla_(bold(x)) ln p_(0t) (bold(x)|bold(x)_0)|_(bold(x)=bold(x)_(t_i)) bar.v.double^2_2$
      + 反向传播，并更新神经网络参数
    + *end*
  ],
) <unconditional_diffusion_training>

#figure(
  kind: "algorithm",


  pseudocode-list(booktabs: true, numbered-title: [无条件扩散模型的采样])[
    + 将时间区间$[0,T]$等间隔划分：${t_0=0 < t_1 < t_2 < ... < t_N=T}$
    + 从先验分布采样初始噪声：$bold(x)_(t_N) tilde cal(N)(bold(0), I)$
    + *for* $i$ in ${N, N-1, ..., 1}$
      + 使用训练好的分数网络$s_theta$计算逆向SDE的数值解：
      + $bold(x)_(t_(i-1)) = bold(x)_(t_i) + stretch(paren.l, size: #200%)f(bold(x)_(t_i), t_i) - g^2 (t_i) s_theta (bold(x)_(t_i), t_i) stretch(paren.r, size: #200%) Delta t + g(t_i) Delta w$
      + 其中$Delta w tilde cal(N)(bold(0), |Delta t| I)$，$Delta t = t_(i-1) - t_i$
    + *end*
    + *return* $bold(x)_(t_0)$
  ],
) <unconditional_diffusion_sampling>

== Denoising Score Matching 训练的等价性 <DSM_equivalence>
Score Based Diffusion 的原始的训练目标为：
$
  EE_(t tilde U(0, T)) stretch(\[, size: #300%) lambda(t) EE_(bold(x) tilde p_t) [bar.v.double s_theta (bold(x),t) - nabla_(bold(x)) ln p_t (bold(x)) bar.v.double^2_2 ] stretch(\], size: #300%)
$<original_score_based_diffusion>
去噪分数匹配（DSM）的训练目标为：
$
  EE_(t tilde U(0, T)) stretch(\[, size: #300%) lambda(t) EE_(bold(x)_0 tilde p_0) stretch(\[, size: #150%) EE_(bold(x) tilde p_(0t)) [bar.v.double s_theta (bold(x),t) - nabla_(bold(x)) ln p_(0t) (bold(x)|bold(x)_0) bar.v.double^2_2] stretch(\], size: #150%) stretch(\], size: #300%)
$<DSM_score_based_diffusion>
要证明两者训练的等价性，只需要证明对最内层的期望的导数相等即可。设$p_t$为$t$时刻的概率密度函数，$s_theta (bold(x),t)$为分数函数，则有：

$
  EE_(bold(x) tilde p_t) stretch(bracket, size: #200%) 1/2 bar.v.double s_theta (bold(x),t) - nabla_(bold(x)) ln p_t (bold(x)) bar.v.double^2_2 stretch(bracket.r, size: #200%) \
  = EE_(bold(x) tilde p_t) stretch(bracket, size: #200%)1/2 bar.v.double s_theta (bold(x),t) bar.v.double^2_2 stretch(bracket.r, size: #200%) \
  + EE_(bold(x) tilde p_t) stretch(bracket, size: #200%)1/2 bar.v.double nabla_(bold(x)) ln p_t (bold(x)) bar.v.double^2_2 stretch(bracket.r, size: #200%) \
  - EE_(bold(x) tilde p_t) stretch(bracket, size: #200%) < s_theta (bold(x),t), nabla_(bold(x)) ln p_t (bold(x)) > stretch(bracket.r, size: #200%)
$<1>

$
  EE_(bold(x) tilde p_t) stretch(bracket, size: #200%) < s_theta (bold(x),t), nabla_(bold(x)) ln p_t (bold(x)) > stretch(bracket.r, size: #200%) &= integral< s_theta (bold(x),t), nabla_(bold(x)) ln p_t (bold(x)) > p_t (bold(x)) "d" bold(x) \
  &= integral< s_theta (bold(x),t), (nabla_(bold(x)) p_t (bold(x)))/(p_t (bold(x))) > p_t (bold(x)) "d" bold(x) \
  &= integral< s_theta (bold(x),t), nabla_(bold(x)) p_t (bold(x)) > "d" bold(x) \
  &= integral< s_theta (bold(x),t), nabla_(bold(x)) integral p_(0t) (bold(x)|bold(x)_0)p_0 (bold(x)_0) "d" bold(x)_0 > "d" bold(x) \
  &= integral< s_theta (bold(x),t), integral nabla_(bold(x)) p_(0t) (bold(x)|bold(x)_0)p_0 (bold(x)_0) "d" bold(x)_0 > "d" bold(x) \
  &= integral integral <s_theta (bold(x),t), nabla_(bold(x)) p_(0t) (bold(x)|bold(x)_0)p_0 (bold(x)_0) > "d" bold(x)_0 "d" bold(x) \
  &= integral integral p_0 (bold(x)_0) <s_theta (bold(x),t), nabla_(bold(x)) p_(0t) (bold(x)|bold(x)_0)> "d" bold(x)_0 "d" bold(x) \
  &= integral integral p_0 (bold(x)_0) <s_theta (bold(x),t), p_(0t) (bold(x)|bold(x)_0) nabla_(bold(x)) ln p_(0t) (bold(x)|bold(x)_0)> "d" bold(x)_0 "d" bold(x) \
  &= integral integral p_(0t) (bold(x)|bold(x)_0) p_0 (bold(x)_0) <s_theta (bold(x),t), nabla_(bold(x)) ln p_(0t) (bold(x)|bold(x)_0)> "d" bold(x)_0 "d" bold(x) \
  &= EE_(bold(x)_0 tilde p_0, bold(x) tilde p_(0t) (bold(x)|bold(x)_0)) stretch(bracket.l, size: #200%)<s_theta (bold(x),t), nabla_(bold(x)) ln p_(0t) (bold(x)|bold(x)_0)> stretch(bracket.r, size: #200%)
$

$
  EE_(bold(x)_0 tilde p_0, bold(x) tilde p_(0t) (bold(x)|bold(x)_0)) stretch(bracket, size: #200%) 1/2 bar.v.double s_theta (bold(x),t) - nabla_(bold(x)) ln p_(0t) (bold(x)|bold(x)_0) bar.v.double^2_2 stretch(bracket.r, size: #200%) \
  = EE_(bold(x)_0 tilde p_0, bold(x) tilde p_(0t) (bold(x)|bold(x)_0)) stretch(bracket, size: #200%)1/2 bar.v.double s_theta (bold(x),t) bar.v.double^2_2 stretch(bracket.r, size: #200%)\
  + EE_(bold(x)_0 tilde p_0, bold(x) tilde p_(0t) (bold(x)|bold(x)_0)) stretch(bracket, size: #200%)1/2 bar.v.double nabla_(bold(x)) ln p_(0t) (bold(x)|bold(x)_0) bar.v.double^2_2 stretch(bracket.r, size: #200%) \
  - EE_(bold(x)_0 tilde p_0, bold(x) tilde p_(0t) (bold(x)|bold(x)_0)) stretch(bracket, size: #200%) < s_theta (bold(x),t), nabla_(bold(x)) ln p_(0t) (bold(x)|bold(x)_0) > stretch(bracket.r, size: #200%)
$<2>

因此，使用梯度下降优化目标函数#ref(<eqt:1>)等价于优化#ref(<eqt:2>)，因为两者的梯度仅相差一个与参数$theta$无关的常数项。

== 条件扩散

条件扩散模型可以分为以下几种类型：
#figure(caption: [条件扩散类型], kind: table)[
  #grid(
    columns: (1fr,) * 3,
    rows: (auto,) * 3,
    // stroke: 0.1em,
    inset: 0.5em,
    align: center,
    grid.hline(),
    [方法名], [是否需要额外的神经网络（分类头）], [是否需要额外的训练],
    grid.hline(),
    [classifier-guidance diffusion], [是], [是],
    [classifier-free diffusion], [否], [是],
    [loss-guidance diffusion], [否], [否],
    [model-guidance diffusion], [是], [否],
    grid.hline(),
  )
]


=== 分类器指导的扩散
Classifier-Guidance Diffusion 使用参数化的分类器神经网络$c_(theta) (bold(x),t, bold(y))$来学习条件概率$p_t (bold(y)|bold(x))$。分类器$c_(theta)$的输入为$t$时刻的含噪声数据$bold(x)_t$和时间$t$，输出为在给定$bold(x)_t$条件下标签为$bold(y)$的概率。条件分数通过分类器的梯度近似：$nabla_(bold(x)) ln p_t (bold(y)|bold(x)) approx nabla_(bold(x)) ln c_(theta) (bold(x),t,bold(y))|_(bold(x)=bold(x)_t)$。

=== 无分类器指导的扩散
Classifier-Free Diffusion 是一种无需额外分类器的条件生成方法，它使用神经网络$s_theta (bold(x),t,bold(y))$同时学习条件分数$nabla_(bold(x)) ln p_t (bold(y)|bold(x))$和无条件分数$nabla_(bold(x)) ln p_t (bold(x))$。

在训练阶段，设定一个标签丢弃概率$p_"drop" in (0,1)$，以$p_"drop"$的概率将条件标签$bold(y)$替换为空标签$emptyset$（或特殊的空令牌）。这种随机丢弃策略使得神经网络能够在同一个模型中学习两种分数函数：
- 当输入标签为$bold(y)$时，学习$nabla_(bold(x)) ln p_t (bold(x)|bold(y))$
- 当输入标签为$emptyset$时，学习$nabla_(bold(x)) ln p_t (bold(x))$

$
  nabla_(bold(x)) ln p_t (bold(x)) + gamma nabla_(bold(x)) ln p_t (bold(y)|bold(x)) &= nabla_(bold(x)) ln p_t (bold(x)) + gamma (nabla_(bold(x)) ln p_t (bold(x)|bold(y)) - nabla_(bold(x)) ln p_t (bold(x)))\
  &= gamma nabla_(bold(x)) ln p_t (bold(x)|bold(y)) + (1-gamma) nabla_(bold(x)) ln p_t (bold(x)) \
  &approx gamma s_theta (bold(x),t,bold(y)) + (1-gamma) s_theta (bold(x),t,emptyset)
$

其中$gamma >= 0$称为引导强度（guidance scale），用于控制生成样本对条件的遵从程度：
- 当$gamma = 0$时，退化为无条件生成
- 当$gamma = 1$时，对应标准的条件生成
- 当$gamma > 1$时，增强条件约束，提高生成样本与条件的匹配度

在实际应用中，通常令$gamma = 1 + omega$（其中$omega >= 0$），采样时的条件分数通过以下线性插值公式计算：
$
  nabla_(bold(x)) ln p_t (bold(x)|bold(y)) = (1 + omega) s_theta (bold(x),t,bold(y)) - omega s_theta (bold(x),t,emptyset)
$

=== 损失指导的扩散 <LGD>

Loss-Guidance Diffusion (LGD) #cite(<song2023loss>) 直接使用先验知识定义的可微分损失函数$l(v(bold(x)),bold(y))$来估计条件分数$nabla_(bold(x)) ln p_t (bold(y)|bold(x))$，无需训练额外的神经网络。其中$v(bold(x))$是属性映射函数，$l$是度量属性与目标条件匹配程度的损失函数。通过$nabla_(bold(x)) -l(v(EE[bold(x)_0|bold(x)]),bold(y))$直接计算条件分数，具有即插即用的特性，可在推理阶段灵活应用于各种已训练的扩散模型。LGD的采样流程见#ref(<fig:LGD_sampling>) 。

设$l:RR^k times RR^k arrow.r RR^+$是一个定义在无噪声数据属性上的可微损失函数，$v:RR^d arrow.r RR^k$为属性提取函数，$bold(y) in RR^k$表示目标属性。损失函数$l$的设计原则是：当$v(bold(x)_0)$与$bold(y)$匹配程度越高时，$l(v(bold(x)_0),bold(y))$越小。

定义修正后的条件分布：
$
  p_l (bold(x)_0|bold(y)) := (p_0(bold(x)_0) e^(-l (v(bold(x)_0),bold(y)))) / Z(bold(y))
$
其中$Z(bold(y)) = integral_(bold(x)_0) p_0 (bold(x)_0) e^(-l (v(bold(x)_0),bold(y))) "d" bold(x)_0$是归一化常数。当损失函数$l$设计合理时，$p_l (bold(x)_0|bold(y)) approx p_0 (bold(x)_0|bold(y))$。

条件分数$nabla_(bold(x)) ln p_t (bold(y)|bold(x))$可通过如下方式近似：

$
  p_t (bold(y)|bold(x)) & approx p_l (bold(y)|EE[bold(x)_0|bold(x)]) \
  nabla_(bold(x)) ln p_t (bold(y)|bold(x)) & approx nabla_(bold(x)) ln p_l (bold(y)|EE[bold(x)_0|bold(x)]) \
  & attach(stretch(=), t: "bayes rule") nabla_(bold(x)) ln (p_l (EE[bold(x)_0|bold(x)]|bold(y))p_l(bold(y))) / (p_l (EE[bold(x)_0|bold(x)])) \
  & = nabla_(bold(x)) ln (p_l (EE[bold(x)_0|bold(x)]|bold(y))) / (p_l (EE[bold(x)_0|bold(x)])) \
  & = nabla_(bold(x)) ln (p_l (EE[bold(x)_0|bold(x)])e^(-l(v(EE[bold(x)_0|bold(x)]),bold(y))) / Z) / (p_l (EE[bold(x)_0|bold(x)])) \
  & = nabla_(bold(x)) -l(v(EE[bold(x)_0|bold(x)]),bold(y))
$
$nabla_(bold(x)) ln p_l (bold(y)|EE[bold(x)_0|bold(x)])$经过上述推导转化为$nabla_(bold(x)) -l(v(EE[bold(x)_0|bold(x)]),bold(y))$，因此不再需要训练额外的神经网络，大大降低了训练和推理的成本。

近似$p_t (bold(y)|bold(x)) approx p_l (bold(y)|EE[bold(x)_0|bold(x)])$的理由如下：
$
  p_t (bold(y)|bold(x)) & = integral p_t (bold(y)|bold(x), bold(x)_0) p_t (bold(x)_0|bold(x)) "d" bold(x)_0 \
                        & = integral p_0 (bold(y)|bold(x)_0) p_t (bold(x)_0|bold(x)) "d" bold(x)_0 \
                        & approx p_0(bold(y)|EE[bold(x)_0|bold(x)]) \
                        & approx p_l (bold(y)|EE[bold(x)_0|bold(x)])
$

当前向扩散过程采用线性高斯形式：
$
  bold(x)_t = a_t bold(x)_0 + b_t bold(epsilon), quad bold(epsilon) tilde cal("N")(bold(0), bold(I))
$

根据Tweedie公式#cite(<chung2022diffusion>)，条件期望$EE[bold(x)_0|bold(x)_t]$可以显式表达为：
$
  EE[bold(x)_0|bold(x)_t] = (b_t^2)/a_t nabla_(bold(x)) ln p_t (bold(x))|_(bold(x)=bold(x)_t) + 1/a_t bold(x)_t
$

证明过程见#ref(<general_posterior_mean_proof>)。

特别地：
- 对于去噪扩散概率模型（DDPM），它可以视为方差保持随机微分方程（VP-SDE）的离散版本，系数为：$a_t = sqrt(overline(alpha)_t)$ 和 $b_t = sqrt(1 - overline(alpha)_t)$。
- 对于方差爆炸随机微分方程（VE-SDE），系数为：$a_t = 1$ 和 $b_t = sigma_t$。

#figure(
  caption: "Loss-Guidance Diffusion 采样流程图",
  diagram(
    node-stroke: 0.8pt,
    node-fill: white,
    edge-stroke: 0.8pt,
    spacing: (0.1cm, 1.2cm),
    // 定义节点
    node((1, 0), [$x_t$], shape: rect, name: "xt"),
    node((2, 1), [Denoiser], shape: rect, name: "denoiser"),
    node((3, 1), [Predicted Unconditional Score], name: "pus"),
    node((3, 0), [Posterior Mean], shape: rect, name: "pm"),
    node((4, 1), [$E[x_0|x_t]$], name: "ex0xt"),
    node((4, 2), [attribute map], shape: rect, name: "am"),
    node((5, 2), [condition y], name: "cy"),
    node((4, 3), [condition loss function], shape: rect, name: "closs"),
    node((3, 3), [Predicted Conditional Score], name: "pcs"),
    node((3, 2), [$+$], shape: circle, name: "plus"),
    node((2, 2), [Predicted Score], name: "ps"),
    node((2, 3), [Sampler], shape: rect, name: "sampler"),
    node((1, 3), [$x_(t-1)$], shape: rect, name: "xt1"),

    // // 主要连接
    edge(<xt>, <denoiser>, "->", corner: right),
    edge(<denoiser>, <pus>, "->"),
    edge(<pus>, <pm>, "->"),
    edge(<xt>, <pm>, "->"),
    edge(<pm>, <ex0xt>, "->", corner: right),
    edge(<ex0xt>, <am>, "->"),
    edge(<am>, <closs>, "->"),
    edge(<cy>, <closs>, "->", corner: right),
    edge(<closs>, <pcs>, "->"),
    edge(<pcs>, <plus>, "->"),
    edge(<pus>, <plus>, "->"),
    edge(<plus>, <ps>, "->"),
    edge(<ps>, <sampler>, "->"),
    edge(<sampler>, <xt1>, "->"),
    edge(<xt1>, <xt>, "-->"),
  ),
) <LGD_sampling>

=== 模型指导的扩散
Model-Guidance Diffusion 是一种融合了 Classifier-Guidance 和 Loss-Guidance 优势的条件生成方法。它利用预训练的神经网络模型$c_(theta) (bold(x))$（如分类器或回归器）来提供引导信号，关键优势在于无需在含噪数据上重新训练这些预训练模型，从而大大降低了计算成本和训练复杂度。

该方法的核心思想是将预训练模型的输出作为属性映射或概率估计，然后通过梯度信息来指导扩散过程。根据任务类型的不同，Model-Guidance 的具体实现方式也有所区别：

*回归任务：*
对于回归问题，预训练模型$c_(theta) (bold(x))$输出对给定输入$bold(x)$的属性预测值$hat(bold(y))$。此时，$c_theta$的功能等价于 Loss-Guidance 中的属性映射函数$v(bold(x))$。通过定义均方误差损失函数：
$
  l(hat(bold(y)), bold(y)) = || hat(bold(y)) - bold(y) ||^2_2
$
条件分数可表示为：
$
  nabla_(bold(x)) ln p_t (bold(y)|bold(x)) approx nabla_(bold(x)) (-l(c_(theta)(bold(x)), bold(y))) = -2 nabla_(bold(x)) (c_(theta)(bold(x)) - bold(y))^T (c_(theta)(bold(x)) - bold(y))
$

*分类任务：*
对于分类问题，预训练模型$c_(theta) (bold(x))$输出给定输入$bold(x)$属于类别$bold(y)$的概率$c_(theta) (bold(x), bold(y))$。定义负对数似然损失函数：
$
  l(c_(theta) (bold(x)), bold(y)) = -ln(c_(theta) (bold(x), bold(y)))
$
此时，负对数损失函数$-ln(c_(theta) (bold(x), bold(y)))$的作用等价于 Loss-Guidance 中的损失函数$l(v(bold(x)), bold(y))$。相应的条件分数为：
$
  nabla_(bold(x)) ln p_t (bold(y)|bold(x)) approx nabla_(bold(x)) (-l(c_(theta) (bold(x)), bold(y))) = nabla_(bold(x)) ln(c_(theta) (bold(x), bold(y)))
$

Model-Guidance 的主要优势包括：充分利用现有的预训练模型，避免重复训练；适用性广，可处理多种类型的条件生成任务；Model-Guidance Diffusion 的样本生成效果如 @fig:model_guidance_diffusion 所示。首先在干净的数据集上训练一个分类模型，然后训练一个无条件扩散模型，采样时使用分类模型对输入的梯度指导扩散过程，生成2分类数据。

#figure(caption: "Model-Guidance Diffusion 采样过程")[
  #image("images/MGD-ddpm.png")
]<model_guidance_diffusion>

== 多维切比雪夫不等式 <app:chebyshev_inequality>

设$A in RR^(d times d)$为半正定矩阵，$Sigma:=EE[(bold(x) - E[bold(x)]) (bold(x) - EE[bold(x)])^T]$，则有
$
  PP (bold(x) - EE[bold(x)])^T A (bold(x) - EE[bold(x)]) >= c) <= tr(A Sigma) / c
$

证明：

$y:= (bold(x) - EE[bold(x)])^T A (bold(x) - EE[bold(x)])$

$
  PP(y >= c) <= EE[y] / c & = EE[tr(y)] / c \
                          & = tr(EE[y]) / c \
                          & = tr((bold(x) - EE[bold(x)])^T A (bold(x) - EE[bold(x)])) / c \
                          & = tr(A Sigma) / c
$
$
  PP(||bold(x) - bold(E[bold(x)])||>= c) & = PP (||bold(x) - bold(E[bold(x)])||^2 >= c^2) \
                                         & =PP ((bold(x) - bold(E[bold(x)]))^T I (bold(x) - bold(E[bold(x)])) >= c^2) \
                                         & <= tr(I Sigma) / c^2
$

若$bold(x) tilde cal(N)(bold(mu), sigma I))$，则:

$
  PP(||bold(x) - bold(mu)||>= c) <= (d sigma^2) / c^2
$


== 流匹配

Flow Matching (FM) 是一种生成模型，通过学习向量场来构建从简单先验分布到复杂数据分布的连续变换。其核心思想是利用连续归一化流（Continuous Normalizing Flow, CNF）在概率分布之间建立可逆映射。

=== 连续归一化流的基本理论<cnf_theory>

设 $(Omega, cal(F), Q)$ 为未知真实数据的概率空间，其中 $Omega$ 为样本空间，$cal(F)$ 为 $Omega$ 上的 $sigma$-代数，$Q$ 为 $cal(F)$ 上的概率测度，$q$ 为 $Q$ 对应的概率密度函数（假设存在）。

考虑一族时变向量场 ${v_t (bold(x)) := v(bold(x), t) : RR^d times [0,1] arrow.r RR^d}_{t in [0,1]}$，通过求解常微分方程可以定义连续归一化流 @chen2018neural 的微分同胚映射 $phi_t (bold(x)) := phi(bold(x), t) : RR^d times [0,1] arrow.r RR^d$：
$
  "d" phi(bold(x)_0, t) / ("d" t) = v (phi(bold(x)_0, t), t), quad phi(bold(x)_0, 0) = bold(x)_0
$<vf_cnf>

通过方程 @eqt:vf_cnf，向量场 $v_t$ 与微分同胚映射 $phi_t$ 一一对应。CNF 诱导一个概率分布族 ${P_t}_{t in [0,1]}$，其中 $P_0 = cal(N)(bold(0), I)$ 为简单的先验分布。Flow Matching 的目标是学习合适的向量场，使得 $P_1$ 能够很好地近似真实数据分布 $Q$。
设$P_t$的概率密度函数为$p_t$

=== 概率密度的变换公式

设 $bold(y) = phi_t^(-1)(bold(x)_t)$，时刻 $t$ 的概率测度 $P_t$ 通过先验测度 $P_0$ 在映射 $phi_t$ 下的推前测度（push-forward measure）定义：
$
  forall A in cal(F), quad P_t (A) = P_0(phi_t^(-1) (A))
$

根据测度变换公式，有：
$
  integral_A p_t (bold(x)_t) "d" bold(x)_t &= integral_(phi_t^(-1)(A)) p_0(bold(y)) "d" bold(y)\
  &= integral_A p_0(phi_t^(-1)(bold(x)_t)) bigg(|)det (partial phi_t^(-1)(bold(x)_t)) / (partial bold(x)_t) bigg(|) "d" bold(x)_t
$

因此，时刻 $t$ 的概率密度函数为：
$
  p_t (bold(x)) = p_0 (phi_t^(-1)(bold(x)_t)) bigg(|)det (partial phi_t^(-1)(bold(x)_t)) / (partial bold(x)_t)bigg(|)
$<density_transform>


=== 流匹配损失函数

理论上可以通过最小化如下对象来学习一个未知的向量场$u$
$
  cal(L)_"FM" = EE_(t in cal(U)(0,1), bold(x)_t tilde p_t) stretch(bracket.l, size: #200%)|| v_theta (bold(x)_t, t) - v (bold(x)_t, t)||^2 stretch(bracket.r, size: #200%)
$<l_FM>
但是由于$v$和$p_t$都是未知的，因此无法直接最小化 @eqt:l_FM。文献@chen2018neural 提出了使用条件CNF来学习向量场。

其中 $v_theta$ 是参数化的神经网络向量场，$u_t$ 是目标向量场。然而，由于真实向量场 $u_t$ 和概率密度 $p_t$ 都是未知的，无法直接优化损失函数 @eqt:l_FM。

=== 条件流匹配

为解决上述问题，Lipman et al. @chen2018neural 提出了条件流匹配（Conditional Flow Matching, CFM）方法。

考虑依赖于目标数据点 $bold(x)_1$ 的条件CNF映射 $psi_t$：
$
  psi_t (bold(x)_0|bold(x)_1) := psi(bold(x)_0|bold(x)_1, t) = mu_t (bold(x)_1) + sigma_t (bold(x)_1) bold(x)_0
$

其中路径参数满足边界条件：
- $sigma_0(bold(x)_1) = 1, quad mu_0(bold(x)_1) = bold(0)$（初始条件：标准高斯分布）
- $mu_1(bold(x)_1) = bold(x)_1, quad sigma_1(bold(x)_1) = sigma_"min"$（终止条件：集中在目标点）

这里 $sigma_"min"$ 是一个小常数，确保最终分布集中在 $bold(x)_1$ 附近。

该条件CNF对应的向量场为：
$
  v_t (bold(x)_t|bold(x)_1) = "d" (sigma_t (bold(x)_1)) / ("d" t) dot 1 / (sigma_t (bold(x)_1)) (bold(x)_t - mu_t (bold(x)_1)) + "d" (mu_t (bold(x)_1)) / ("d" t)
$
对应的条件概率密度为：：
$
  p_t (bold(x)|bold(x)_1) = cal(N)(bold(x); mu_t (bold(x)_1), sigma_t (bold(x)_1)^2 I)
$

边缘概率密度为：
$
  p_1(bold(x)) = integral cal(N)(bold(x); bold(x)_1, sigma_"min"^2 I) q(bold(x)_1) "d" bold(x)_1 approx q(bold(x))
$

第二约等号的证明见 @app:flow_matching_convergence

条件流匹配损失函数
$
  cal(L)_"CFM" := EE_(t tilde cal(U)[0,1], bold(x)_1 tilde q, bold(x)_t tilde p_t (dot|bold(x)_1)) stretch(\[, size: #200%)|| v_theta (bold(x)_t, t) - v_t (bold(x)_t|bold(x)_1) ||^2 stretch(\], size: #200%)
$<l_CFM>
与原始流匹配损失 @eqt:l_FM 仅相差一个与参数 $theta$ 无关的常数项。因此：
$
  nabla_theta cal(L)_"CFM" = nabla_theta cal(L)_"FM"
$

这意味着可以通过最小化可计算的条件流匹配损失 @eqt:l_CFM 来学习目标向量场$v$。

=== 流匹配之最优传输路径

在实际应用中，常采用最优传输（Optimal Transport, OT）路径作为条件流匹配的特殊情况。该路径也称为线性插值路径，通过直线连接起点和终点，具有最简洁的形式和最优的传输代价。

选取如下路径参数：
$
  mu_t (bold(x)_1) = t bold(x)_1, quad sigma_t (bold(x)_1) = 1 - t
$

此时边界条件自然满足：
- $t=0$：$mu_0 (bold(x)_1) = bold(0), quad sigma_0 (bold(x)_1) = 1$（标准高斯分布）
- $t=1$：$mu_1 (bold(x)_1) = bold(x)_1, quad sigma_1 (bold(x)_1) = 0$（退化到目标点）

条件路径为：
$
  psi_t (bold(x)_0|bold(x)_1) = (1-t) bold(x)_0 + t bold(x)_1
$<ot_path>

对应的条件向量场通过对路径求时间导数得到：
$
  v_t (bold(x)_t|bold(x)_1) = "d" / ("d" t) psi_t (bold(x)_0|bold(x)_1) = bold(x)_1 - bold(x)_0
$<ot_velocity>

值得注意的是，最优传输路径的向量场在整个时间区间 $[0,1]$ 上为常数，仅依赖于起点 $bold(x)_0$ 和终点 $bold(x)_1$，不依赖于时间 $t$。这使得训练和推理都极为高效。

此时条件流匹配损失简化为：
$
  cal(L)_"OT-CFM" = EE_(t tilde cal(U)[0,1], bold(x)_1 tilde q, bold(x)_0 tilde cal(N)(bold(0),I)) stretch(\[, size: #200%)|| v_theta ((1-t)bold(x)_0 + t bold(x)_1, t) - (bold(x)_1 - bold(x)_0) ||^2 stretch(\], size: #200%)
$<l_OT_CFM>

最优传输路径的优势在于：
+ 计算简单：向量场为常数，无需复杂的时间依赖计算
+ 几何直观：对应欧几里得空间中的最短路径
+ 传输代价最优：在$L^2$意义下的Wasserstein距离最小
+ 训练稳定：避免了路径参数选择的复杂性

== 流匹配收敛性证明 <app:flow_matching_convergence>

设$(X, cal(F), Q)$为未知真实数据的概率空间，其中 $X:=cal(RR^d)$ 为样本空间，$cal(F):=cal(B)(X)$ 为 $X$ 上的 $sigma$-代数，$Q$ 为 $cal(F)$ 上的概率测度，$q$ 为 $Q$ 对应的概率密度函数（假设存在）,且$q$连续，$||q(bold(x))||<M, quad forall bold(x) in X$。$P_0=cal(N)(bold(x)_0, I)$为初始时刻的原始数据分布。

$
  bold(x)_0 tilde P_0=cal(N)(bold(x)_0, I)
$
从$Q$中采样一个$bold(x)_1$, 根据$bold(x)_1$构造一个条件CNF：
$
  bold(x)_t = phi_t (bold(x)_0 | bold(x)_1) = mu_t (bold(x)_1) + sigma_t (bold(x)_1) bold(x)_0
$

- $sigma_0(bold(x)_1) = 1, quad mu_0(bold(x)_1) = bold(0)$（初始条件：标准高斯分布）
- $mu_1(bold(x)_1) = bold(x)_1, quad sigma_1(bold(x)_1) = sigma_"min"$（终止条件：集中在目标点）

设$bold(x)_t$服从的分布为$P_t$,

$phi_1(bold(x)_0 | bold(x)_1) tilde cal(N)(bold(x)_1, sigma_"min"^2 I)$

$phi_1(bold(x)_0) tilde integral cal(N)(bold(x)_1, sigma_"min"^2 I) q(bold(x)_1) "d" bold(x)_1$

$
  p_1(bold(x)) = integral cal(N)(bold(x); bold(x)_1, sigma_"min"^2 I) q(bold(x)_1) "d" bold(x)_1 approx q(bold(x))
$
待证：
$
  lim_(sigma_"min" arrow.r 0) integral cal(N)(bold(x); bold(x)_1, sigma_"min"^2 I) q(bold(x)_1) "d" bold(x)_1 = q(bold(x))
$

将积分区域分为两部分:$A,B, A inter B = emptyset and A union B = RR^d$
$
  A:= {bold(x) | ||bold(x) - bold(x)_1|| < c}, B:= {bold(x) | ||bold(x) - bold(x)_1|| >= c}
$

$
  & integral cal(N)(bold(x); bold(x)_1, sigma_"min"^2 I) q(bold(x)_1) "d" bold(x)_1 - q(bold(x)) \
  & = integral cal(N)(bold(x); bold(x)_1, sigma_"min"^2 I) (q(bold(x)_1)-q(bold(x))) "d" bold(x)_1\
  &= integral_A cal(N)(bold(x); bold(x)_1, sigma_"min"^2 I) (q(bold(x)_1)-q(bold(x))) "d" bold(x)_1 + integral_B cal(N)(bold(x); bold(x)_1, sigma_"min"^2 I) (q(bold(x)_1)-q(bold(x))) "d" bold(x)_1\
  & <= integral_A cal(N)(bold(x); bold(x)_1, sigma_"min"^2 I) (q(bold(x)_1)-q(bold(x))) "d" bold(x)_1 + 2 M integral_B cal(N)(bold(x); bold(x)_1, sigma_"min"^2 I) "d" bold(x)_1\
  &=: I_1 + I_2
$
由$q$的连续性易得$I_1 arrow.r 0$

由多维切比雪夫不等式 （@app:chebyshev_inequality） 易得$I_2 arrow.r 0$

因此
$
  lim_(sigma_"min" arrow.r 0) integral cal(N)(bold(x); bold(x)_1, sigma_"min"^2 I) q(bold(x)_1) "d" bold(x)_1 = q(bold(x))
$


== 损失指导的流匹配 <Loss-Guidance-FM>

Loss-Guidance Flow Matching (LGFM) 是对标准流匹配的扩展，通过引入损失函数指导，使生成过程能够优化特定的目标函数。

根据连续性方程 @villani2008optimal，概率密度的时间演化满足：
$
  ("d")/("d" t) p_t (bold(x)_t) + "div"(p_t (bold(x)_t) v_t (bold(x)_t)) = 0
$

通过变量替换，可以得到等价形式 @ben2022matching：
$
  ("d") / ("d"t) ln(p_t (phi_t (bold(x)_0))) + "div" v_t (phi_t (bold(x)_0)) = 0
$<continuity_eq>

考虑包含损失指导项的向量场：
$
  v_t (phi_t (bold(x)_0)) := ("d" phi_t (bold(x)_0))/("d" t) & = u_t (phi_t (bold(x)_0)) - nabla_(phi_t (bold(x)_0)) l (phi_t (bold(x)_0),bold(x)_1) \
  phi_0 (bold(x)_0) & = bold(x)_0
$
其中$u$为无条件向量场。
$
  ln(p_1 (phi_1 (bold(x)_0))) - ln(p_0 (phi_0 (bold(x)_0))) = -integral_0^1 "div" v_t (phi_t (bold(x)_0)) "d"t
$

$
  p_1(phi_1(bold(x)_0)) & = p_0 (phi_0 (bold(x)_0)) e^(-integral_0^1 "div" v_t (phi_t (bold(x)_0)) "d"t) \
  & = p_0 (phi_0 (bold(x)_0)) e^(-integral_0^1 "div" u_t (phi_t (bold(x)_0)) "d"t) e^(-integral_0^1 "div" -nabla_(phi_t (bold(x)_0)) l(phi_t (bold(x)_0), bold(x)_1) "d"t)\
  & = p_1^u (phi_1(bold(x)_0)) e^(integral_0^1 "div" nabla_(phi_t (bold(x)_0)) l(phi_t (bold(x)_0), bold(x)_1) "d"t)\
  & = p_1^u (phi_1(bold(x)_0)) e^(integral_0^1 Delta_(phi_t (bold(x)_0)) l(phi_t (bold(x)_0), bold(x)_1) "d"t)
$<LGFM>

其中$Delta$ 为拉普拉斯算子，$p_1^u (phi_1(bold(x)_0))$为在无条件向量场$u$的作用下的$p_1$，称$-nabla l (phi_t (bold(x)_0),bold(x)_1)$为损失指导向量场（Loss-Guidance Vector Feild）或指导向量场（Guidance Vector Feild）。从 @eqt:LGFM 可以看出，条件分数场会放大在损失函数景观为谷底的路径 （对应着拉普拉斯散度大于0），抑制在损失函数景观为峰顶的路径 （对应着拉普拉斯散度小于0）。

对标量场 $f(bold(x)):RR^d arrow.bar RR$，其梯度定义为：
$
  (partial / (partial x_1) f, partial / (partial x_2) f, dots, partial / (partial x_d) f)^T
$

拉普拉斯算子定义为梯度的散度：
$
  Delta f & = nabla dot (nabla f) \
          & = sum_(i=1)^(d) partial^2/(partial x_i^2) f
$

$partial^2/(partial x_i^2) f$表示$f$在$x_i$方向上的曲率（沿该方向的凹凸程度）。拉普拉斯是各方向曲率的总和，所以它测量了函数在该点处总体的“凹凸程度”。

== 口袋生成

RFdiffusion #cite(<watson2023novo>) 是一种基于扩散模型的蛋白质结构生成方法，其网络架构源自 RoseTTAFold。相较于依赖复杂物理能量函数与大量人工试错的传统蛋白质设计流程，RFdiffusion 借鉴扩散模型在图像生成领域的成功经验，通过结构去噪任务进行训练，使模型能够从随机初始化的结构逐步恢复出符合物理与几何约束的蛋白质骨架。该模型能够统一处理多种设计场景，包括无约束与拓扑约束的单体设计、蛋白质结合物设计、对称寡聚体设计、酶活性位点支架设计，以及治疗用蛋白和金属结合蛋白的对称基序支架设计。在多项实验中，研究人员对数百种生成蛋白进行了实验验证，其中部分设计（如流感血凝素结合物）的冷冻电镜解析结构与计算模型高度一致，表明 RFdiffusion 在骨架生成层面具有较高准确性与稳定性。总体而言，RFdiffusion 能够根据较为简洁的分子规格生成结构多样、物理合理且具备功能潜力的蛋白质，为计算蛋白设计提供了通用而高效的生成范式。

在此基础上，RoseTTAFold All-Atom（RFAA） #cite(<krishna2024generalized>) 进一步扩展了建模粒度，提出了一种混合表示策略：对氨基酸残基与核酸碱基采用残基级表示，而对小分子、金属离子及共价修饰等非聚合物组分采用原子级表示，从而缓解了小分子非规则结构难以建模的问题。RFAA 在 Protein Data Bank（PDB）中的完整生物分子组装体结构上进行训练，覆盖蛋白质、核酸、小分子及金属离子的高度多样性。在对去噪任务进行微调后，作者提出了 RFdiffusion All-Atom（RFdiffusionAA），使扩散模型能够在目标小分子周围直接生成蛋白质结构。该方法从围绕配体的随机氨基酸残基分布出发，通过迭代去噪过程逐步形成稳定的结合口袋，从而实现配体条件下的蛋白结构生成。

尽管 RFdiffusion 及 RFdiffusionAA 在整体结构生成方面表现出较强能力，但其对蛋白口袋局部几何特征的直接控制仍然有限。例如，口袋的形状、体积以及疏水/亲水分布难以被精确约束，在针对特定配体进行设计时，生成口袋往往在几何上合理但在实际结合能或选择性上表现不足。此外，蛋白质口袋通常伴随显著的构象变化（conformational selection），而 RFdiffusion 系列方法本质上生成的是静态结构，难以刻画口袋开合及柔性对配体结合的影响，从而可能导致生成口袋在真实生理环境中稳定性或兼容性不足。

针对上述问题，FAIR（Full-Atom Iterative Refinement） #cite(<zhang2023full>) 提出了一种面向蛋白质口袋设计的全原子生成方法。该方法认识到蛋白口袋在药物研发与生物工程中的核心作用，并指出传统基于能量函数或模板匹配的方法在效率和精度上均存在明显局限，尤其难以准确建模关键侧链原子与配体之间的相互作用。FAIR 采用“由粗到细”的两阶段生成流程：首先在主链与残基类型层面进行预测与优化，随后引入侧链原子并进行全原子级的迭代更新，从而在保证序列与结构一致性的同时显式考虑配体的柔性变化。技术上，FAIR 通过层次化编码器融合原子级与残基级信息，并利用双结构精炼模块分别建模口袋内部及口袋–配体相互作用，实现全局迭代式的精炼优化。实验结果表明，FAIR 在 AAR、RMSD 等关键指标上相较现有方法取得了 10%–15% 的提升，同时生成效率显著高于传统物理方法。

然而，FAIR 主要依赖神经网络及损失函数来约束几何合理性，相较于显式引入物理能量函数的方法，仍可能生成在化学或能量层面不稳定的构象，因此通常需要额外的后验验证。此外，其“先骨架、后全原子”的两阶段优化流程在阶段衔接处可能引入不一致性，从而在一定程度上限制了最终设计性能的上限。

PocketGen #cite(<zhang2024efficient>) 进一步推动了口袋设计向端到端全原子建模发展。该方法在生成过程中同时优化口袋区域的氨基酸序列与原子级结构，从而在设计阶段即保证二者的一致性。其核心包括双层级图注意力网络，用于捕捉原子、残基及配体之间的多尺度相互作用，以及基于蛋白质语言模型的序列精炼模块，通过结构适配器实现结构与序列的协同更新。得益于这一端到端框架，PocketGen 在保持高结构保真度与较强结合亲和力的同时显著提升了设计效率。实验结果显示，该方法在多项基准任务中取得了超过 64% 的氨基酸恢复率，且约 95% 的生成口袋在结合亲和力上优于参考口袋，展现出较强的实用潜力。

尽管如此，PocketGen 在口袋尺寸增大时性能仍会出现一定下降，例如当设计范围从 3.5 $angstrom$ 扩展至 5.5 $angstrom$ 时，其 AAR、RMSD 以及 #cite(<trott2010autodock>) 评分均呈现轻微退化。此外，该方法在生成过程中缺乏对特定序列或结构约束的显式可控机制，限制了其在定向设计场景下的灵活性。同时，PocketGen 采用的是 E(3) 等变模型而非更严格的 SE(3) 等变建模，在处理镜像反射等情形时可能引入潜在不稳定性。


// RFdiffusion #cite(<watson2023novo>) 是一种基于扩散的蛋白质生成模型，由 RoseTTAFold 网络发展而来。传统的蛋白质设计方法往往需要复杂的物理建模和大量试错，而 RFdiffusion 则借鉴了扩散模型在图像生成中的成功经验，通过结构去噪任务训练，使模型能够从随机结构逐步“还原”出合理的蛋白质骨架结构。经过训练的 RFdiffusion 能够处理多种设计任务，包括无约束和拓扑约束下的单体设计、蛋白质结合物设计、对称寡聚体设计、酶活性位点支架，以及疗用和金属结合蛋白的对称基序支架。它不仅能生成符合物理规律的蛋白质骨架，还能在特定结构和功能要求下，设计出具有实际生物学作用的蛋白质。研究人员利用 RFdiffusion 设计并实验验证了数百种对称结构、金属结合蛋白和蛋白质结合物。其中一个设计的流感血凝素结合物，其冷冻电镜解析结构与计算设计几乎完全一致，证明了 RFdiffusion 的高准确性。RFdiffusion 能根据简单的分子规格，生成多样且功能化的蛋白质，为药物开发和新功能蛋白设计开辟了新道路。

// RoseTTAFold All-Atom (RFAA) #cite(<krishna2024generalized>) 采用了一种混合表示策略，对于氨基酸和核酸碱基使用基于残基的表示，而对小分子、金属离子和共价修饰等非聚合物组分使用原子级表示。这种方法解决了小分子非聚合物性质带来的建模挑战。
// RFAA 在蛋白质数据库（Protein Data Bank, PDB）中的完整生物分子组装体结构上进行训练，涵盖蛋白质、核酸、小分子、金属和共价修饰的多样性。通过在去噪任务（denoising tasks）上对RFAA进行微调，作者开发了RFdiffusion All-Atom (RFdiffusionAA)，一种生成模型，能够围绕目标小分子直接构建蛋白质结构，生成具有特定结合位点的蛋白质。RFdiffusionAA 从围绕目标小分子的随机氨基酸残基分布开始，通过迭代去噪过程生成结合口袋。

// RFdiffusion和RFdiffusionAA这两个方法虽然能通过扩散模型生成整体结构，但对口袋的形状、大小、疏水/亲水特征等空间几何特征的直接控制有限。特别是在需要针对特定配体设计时，生成的口袋往往缺乏高度匹配性。生成的口袋看起来合理，但在实际结合能或选择性上表现不佳。蛋白口袋往往存在构象变化（conformational selection），而 RFdiffusion 系列方法本质上生成的是静态结构，不能捕捉口袋开合和柔性对配体结合的重要性。这导致在真实环境中口袋可能无法稳定存在或与配体兼容性差。

// FAIR (Full-atom iterative refinement) #cite(<zhang2023full>) 提出了一种用于蛋白质口袋设计的新方法。蛋白质口袋是配体分子结合的位置，其序列与三维结构设计在药物研发和生物工程中具有重要意义。传统方法往往依赖能量函数或模板匹配，效率低且难以准确捕捉口袋与配体的相互作用，尤其忽略了关键的侧链原子。为解决这些问题，FAIR通过一个粗到细的两阶段流程进行全原子级别的口袋生成：首先预测并逐步优化主链原子与残基类型，然后引入侧链原子并迭代更新，实现序列与结构的一致性，同时考虑配体的柔性结构变化。

// 在技术上，FAIR利用层次化编码器（结合原子级和残基级信息）和双结构精炼模块（分别建模口袋内部与口袋-配体的相互作用）进行全局迭代式优化（full-shot refinement）。实验结果显示，FAIR在设计质量上显著优于现有方法，在AAR和RMSD等指标上提升超过10%~15%，且生成速度比传统方法快十倍以上。

// 然而，FAIR主要依赖神经网络生成结构，并通过损失函数来约束几何合理性，但与基于物理能量函数的方法相比，仍有可能产生在化学或能量上不稳定的构象，因此需要额外验证。此外，其口袋设计采用“从粗到细”的两阶段迭代优化策略（先骨架，后全原子），这两个阶段之间存在潜在脱节，可能引入不稳定性，从而限制最终性能的发挥。

// PocketGen #cite(<zhang2024efficient>) 同时设计口袋的原子结构和序列，直接进行全原子的优化。与传统依赖物理建模或模板匹配的方法相比，PocketGen 能够同时生成口袋区域的氨基酸序列和原子结构，从而保证二者的一致性。其核心由两个模块组成：双层级图注意力网络（捕捉原子、残基和配体多尺度相互作用）以及基于蛋白质语言模型的序列精炼模块（通过结构适配器实现序列和结构的一致性）。这种端到端的设计使 PocketGen 在生成蛋白口袋时既能保持高保真度和高亲和力，又能显著提升效率，比物理方法快约十倍。作者在多项基准测试上验证了 PocketGen 的性能，结果显示其氨基酸恢复率超过 64%，并且 95% 的生成口袋在结合亲和力上优于参考口袋。同时，该方法还能生成结构多样且功能有效的蛋白口袋，为药物发现中的小分子结合蛋白设计提供了新的思路和工具。

// 但是当设计的蛋白口袋尺寸增大（例如从 3.5 $angstrom$ 扩展至 5.5$angstrom$）时，PocketGen 的关键性能指标如平均氨基酸恢复率（AAR）、RMSD 以及 #cite(<trott2010autodock>) 得分会出现轻微下降。此外，模型在生成过程中缺乏可控性，难以对特定序列或结构进行引导。同时，PocketGen 使用的是 E(3) 等变模型，而非更严格的 SE(3) 等变模型，这可能在处理镜像反射时带来潜在的不稳定性。


= 基于扩散的蛋白质口袋设计(DiffPocket) <dynamic_aware_protein_pocket_diffusion_model>

本文将实际的蛋白质口袋设计问题转化为基于扩散模型的生成建模问题。蛋白质口袋的三维结构本质上是一组$C alpha$原子在三维空间中的坐标分布，而口袋设计的目标是在给定配体约束下生成能够与之高效结合的原子坐标配置。扩散模型通过逐步去噪过程学习从噪声分布到数据分布的映射，天然适合建模这种连续空间中的结构生成问题。选择对$C alpha$原子坐标而非全原子坐标进行扩散的原因在于：$C alpha$原子构成了蛋白质骨架的主链，其位置唯一确定了蛋白质的整体拓扑结构，而侧链原子可以通过后续的序列设计步骤进行优化，从而在保证生成效率的同时维持结构的主要几何特征。此外，将配体作为条件输入使得模型能够学习配体-口袋相互作用的几何约束，而口袋掩码则明确指定了需要生成的口袋区域，这种条件化机制将原本复杂的多约束优化问题转化为条件概率建模问题，使得模型能够通过数据驱动的方式学习复杂的配体-口袋相互作用模式。

针对现有蛋白质口袋生成方法在生成质量、可控性和计算效率方面存在的不足，本文提出了一种基于扩散模型的蛋白质口袋生成方法DiffPocket。该方法将蛋白质口袋生成问题建模为条件扩散生成任务，通过DDPM框架对蛋白质的$C alpha$原子坐标进行扩散建模，以配体和口袋掩码作为条件输入指导生成过程，并采用全原子表示配体以保留其精细几何信息。采样完成后，使用ProteinMPNN对生成的口袋结构进行序列设计，从而得到最终的口袋序列。

本方法的主要创新点包括：（1）将蛋白质口袋生成问题转化为条件扩散生成任务，利用扩散模型的强大生成能力实现高质量口袋结构生成；（2）采用旋转不变编码器与旋转等变解码器的组合架构，确保模型对坐标旋转的几何不变性与等变性，提升生成结构的几何合理性；（3）通过配体全原子表示与口袋掩码的条件输入机制，实现对生成过程的精确控制，提升方法的可控性；（4）将结构生成与序列设计解耦，先通过扩散模型生成口袋结构，再使用ProteinMPNN进行序列设计，保证了结构-序列的一致性。

== 模型

本文的模型结构如 @fig:model_structure 所示。模型采用旋转不变编码器（Invariant Encoder）与旋转等变解码器（Equivariant Decoder）的组合架构。具体而言，Invariant Encoder 对输入坐标的任意旋转变换保持不变性，即对输入坐标执行旋转操作不会改变编码器的输出特征表示；Equivariant Decoder 对输入坐标的旋转变换具有等变性，即当输入坐标发生旋转时，解码器输出的坐标也会相应地执行相同的旋转变换，从而保证生成结构的几何一致性。解码器由 AlphaFold 的 IPA（Invariant Point Attention）模块与前馈神经网络（Feed-Forward Network）复合而成。编码器负责提取并融合蛋白质、配体和口袋的几何与化学特征，解码器则基于这些特征生成蛋白质的$C alpha$原子坐标。详细的模型参数配置如 @tbl:model_parameters 所示。

模型还包含两个交互网络模块：Protein Pocket Interaction Network 和 Ligand Pocket Interaction Network。这两个模块均采用交叉注意力机制（Cross-Attention）与前馈神经网络的复合结构，分别用于建模蛋白质-口袋和配体-口袋之间的相互作用模式，通过注意力机制捕获不同组件间的几何与化学依赖关系，为后续的坐标生成提供丰富的交互特征。

在 @fig:model_structure 中，蛋白质结构的灰色区域表示非口袋区域，蓝色区域表示口袋区域；图下方序列框中的黑色字母表示非口袋残基，红色字母表示口袋残基。
#figure(
  caption: [
    模型结构
  ],
)[
  #let redt = text.with(fill: red)

  #diagram(
    spacing: (2em, 3em),
    node(
      (0, 0),
      [ #set par(leading: 1em)
        #v(3em)
        不变\ 编码器
        #v(3em)
      ],
      name: <ie>,
      ..module_node_args,
    ),
    node(
      (1, 0),
      [ #set par(leading: 1em)
        #v(3em)
        等变\ 解码器
        #v(3em)
      ],
      name: <id>,
      ..module_node_args,
    ),

    node(
      (-1, -0.5),
      [$t tilde cal(U)(0,1000)$],
      name: "t",
      ..io_node_args(right),
    ),
    node(
      (-1, 0.1),
      [#image("images/p_o.png", width: 5em)],
      name: <pocket>,
    ),
    node(
      enclose: (<t>, <pocket>),
      ..enclose_node_args,
      name: <input>,
    ),
    node(
      (3, -0.5),
      name: <p_pocket>,
      [#image("images/p_g.png", width: 6em)],
    ),
    node((3, 0.5), [ProteinMPNN], name: <mpnn>, ..module_node_args),
    node(
      (-1, 1),
      [LLA#redt("LLQ")VGHQ#redt("HQ")LMG],
      shape: rect,
      stroke: 1pt,
      fill: rgb("#f1eaf0"),
      name: "p_o_seq",
    ),
    node(
      (3, 1),
      [LLA#redt("MGQ")VGHQ#redt("VL")LMG],
      shape: rect,
      stroke: 1pt,
      fill: rgb("#f1eaf0"),
      name: "p_g_seq",
    ),
    edge((<input.east>, 15%, <input.south>), <ie.west>, ..edge_args),
    edge(<ie>, <id>, ..edge_args),
    edge(<id>, "r", ..edge_args),
    edge(<p_pocket>, <mpnn>, ..edge_args),
    edge(<mpnn>, <p_g_seq>, ..edge_args),
  )
]<model_structure>

#pagebreak()

#[
  #show figure: set block(breakable: true)

  #figure(caption: [模型参数表], kind: table)[
    #set par(leading: 0.4em)

    #grid(
      columns: (2fr, 1.4fr, 1fr, 1fr),
      inset: 0.3em,
      grid.hline(),
      [名称], [描述], [类型], [值],
      grid.hline(),

      [`c_s`], [单原子特征维度], [`int`], [128],
      [`c_p`], [边特征维度], [`int`], [128],
      [`c_pos_emb`], [位置嵌入维度], [`int`], [128],
      [`c_timestep_emb`], [时间步嵌入维度], [`int`], [128],
      [`relpos_k`], [相对位置键维度], [`int`], [32],
      [`template_type`], [模板类型], [`str`], [v1],
      [`n_pair_transform_layer`], [边变换层数], [`int`], [5],
      [`include_mul_update`], [包含三角乘法更新], [`bool`], [True],
      [`include_tri_att`], [包含三角注意力], [`bool`], [False],
      [`c_hidden_mul`], [三角乘法隐藏维度], [`int`], [128],
      [`c_hidden_tri_att`], [三角注意力隐藏维度], [`int`], [32],
      [`n_head_tri`], [三角注意力头数], [`int`], [4],
      [`tri_dropout`], [三角注意力丢弃率], [`float`], [0.25],
      [`pair_transition_n`], [边变换步数], [`int`], [4],
      [`n_structure_layer`], [结构层数], [`int`], [5],
      [`n_structure_block`], [结构块数], [`int`], [1],
      [`c_hidden_ipa`], [结构隐藏维度], [`int`], [16],
      [`n_head_ipa`], [结构头数], [`int`], [12],
      [`n_qk_point`], [结构QK点数], [`int`], [4],
      [`n_v_point`], [结构V点数], [`int`], [8],
      [`ipa_dropout`], [结构丢弃率], [`float`], [0.1],
      [`n_structure_transition
      _layer`],
      [结构变换层数],
      [`int`],
      [1],

      [`structure_transition
      _dropout`],
      [结构变换丢弃率],
      [`float`],
      [0.1],
      grid.hline(),
    )
  ]<model_parameters>
]

在训练过程中，配体不参与扩散过程，仅将其全原子坐标作为条件信息输入模型，用于指导蛋白质口袋的生成。本文方法针对小分子配体进行设计，为控制计算复杂度，将配体分子的原子数量上限设置为50个原子，超出部分将被截断。

蛋白质碳骨架中每三个连续的$C alpha$原子唯一确定一个局部右手坐标系，该坐标系的建立流程如 @local_coordinate_system_representation 所示。该局部坐标系作为模型输入的重要组成部分，能够为模型提供蛋白质骨架的局部几何结构信息，包括主链的弯曲角度和扭转角度等关键几何特征，从而帮助模型更好地理解蛋白质的三维空间构象。

#figure(caption: [
  不变的编码器
])[
  #import "invariant_encoder.typ": invariant_encoder
  #invariant_encoder(spacing: (0.9em, 4em))
]<invariant_encoder>


#figure(
  caption: [结点特征网络结构图],
)[
  #import "single_feature_network.typ": single_feature_network
  #single_feature_network(spacing: (0.8em, 3em))
]<single_feature_network>

#figure(
  caption: [边特征网络结构图],
)[
  #import "pair_feature_network.typ": pair_feature_network
  #pair_feature_network(spacing: (0.8em, 1.5em))
]<pair_feature_network>

#figure(
  kind: "algorithm",
  pseudocode-list(booktabs: true, numbered-title: [局部坐标系的表示方法])[
    + *def* get_local_coordinate_system($bold(x)_1: RR^3$, $bold(x)_2: RR^3$, $bold(x)_3: RR^3$):
      + $bold(v)_1 = bold(x)_1 - bold(x)_2$
      + $bold(v)_2 = bold(x)_3 - bold(x)_2$
      + $bold(e)_1 = bold(v)_1 / (||bold(v)_1||)$
      + $bold(u)_2 = bold(v)_2 - (bold(v)_2 dot bold(e)_1) bold(e)_1$
      + $bold(e)_2 = bold(u)_2 / (||bold(u)_2||)$
      + $bold(e)_3 = bold(e)_1 times bold(e)_2$
      + $R = [bold(e)_1, bold(e)_2, bold(e)_3]$
      + $bold(z) = bold(x)_2$
      + $T = (R, bold(z))$
      + *return* $T$
    // + #line(length: 100%)
    // + Backbone Local Coordinate System
    //   + get_local_coordinate_system($N$,$C alpha$,$C$)
  ],
) <local_coordinate_system_representation>

=== 结点特征网络

#grid(columns: (1fr, 0.8fr), column-gutter: 1em, align: bottom + center)[
  #figure(
    caption: [模板编码距离对],
    image("images/distance_m.png"),
  )<template_enc>
][
  #figure(
    caption: [正弦位置编码],
    image("images/sin_emb.png", height: 30%),
  )<sin_emb>
]
蛋白质与配体采用相同的结点特征网络（Node Feature Network）架构。该网络负责对扩散过程的时间步以及残基/配体在序列中的位置进行编码，编码方法采用正弦位置编码（Sinusoidal Positional Encoding）。正弦编码通过不同频率的正弦和余弦函数组合，能够为不同位置和时间步生成唯一的连续向量表示，从而保留位置信息的相对关系。具体的编码算法实现如 @sinusoidal_encoding_algorithm 所示，结点特征网络的整体结构如 @fig:single_feature_network 所示，正弦编码的可视化表示如 @fig:sin_emb 所示。

模板编码（Template Encoding）用于捕获蛋白质结构中原子对之间的空间距离信息，该编码以对称矩阵的形式表示所有原子对间的欧氏距离，如 @template_enc 所示。这种距离编码为模型提供了蛋白质结构的全局几何约束信息，有助于模型理解原子间的空间关系。
#figure(
  kind: "algorithm",
  pseudocode-list(booktabs: true, numbered-title: [正弦位置编码算法])[
    + *input*：待编码的标量或向量 $bold(v) in RR^n$，最大编码值 $N in NN^+$，目标编码维度 $D in NN^+$（$D$ 为偶数）
    + 生成维度索引序列：$bold(k) = [1, 2, ..., D] in NN^D$
    + 计算正弦编码项：
      + 对于每个维度 $i in {1,2,...,D}$，计算除数项：$d_i^sin = N^(2k_i \/ D)$
      + 将 $bold(d)^sin = [d_1^sin, d_2^sin, ..., d_D^sin] in RR^D$ 通过广播机制扩展为与 $bold(v)$ 兼容的形状
      + 计算正弦编码：$bold(e)^sin = sin(bold(v) dot pi \/ bold(d)^sin) in RR^(n times D)$
    + 计算余弦编码项：
      + 对于每个维度 $i in {1,2,...,D}$，计算除数项：$d_i^cos = N^(2(k_i - 1) \/ D)$
      + 将 $bold(d)^cos = [d_1^cos, d_2^cos, ..., d_D^cos] in RR^D$ 通过广播机制扩展为与 $bold(v)$ 兼容的形状
      + 计算余弦编码：$bold(e)^cos = cos(bold(v) dot pi \/ bold(d)^cos) in RR^(n times D)$
    + 初始化输出编码矩阵：$bold(e) = bold(0)_(n times D) in RR^(n times D)$
    + 交替填充编码值：
      + 将余弦值填充到偶数索引位置：$bold(e)[..., 0\:\:2] = bold(e)^cos[..., 0\:\:2]$ #h(1em) // 索引 0, 2, 4, ...
      + 将正弦值填充到奇数索引位置：$bold(e)[..., 1\:\:2] = bold(e)^sin[..., 1\:\:2]$ #h(1em) // 索引 1, 3, 5, ...
    + *return* $bold(e) in RR^(n times D)$
  ],
) <sinusoidal_encoding_algorithm>



=== 边特征网络

蛋白质与配体采用相同的边特征网络（Edge Feature Network）架构。边特征网络负责将单个残基的结点特征（Node Features, $bold(s)$）与残基对之间的几何信息（包括相对位置、模板结构中的距离信息等）进行融合，生成残基对特征（Edge Features, $bold(p)$）。该网络通过交叉注意力机制和前馈神经网络，能够有效捕获残基对之间的相互作用模式和空间几何约束，为后续的坐标生成提供丰富的成对交互特征。边特征网络的前向传播算法如 @pair_feature_forward_algorithm 所示，相对位置编码算法如 @relative_position_encoding_algorithm 所示，网络的整体结构如 @fig:pair_feature_network 所示。

#figure(
  kind: "algorithm",
  pseudocode-list(booktabs: true, numbered-title: [边特征网络前向传播算法])[
    + *input*：结点特征 $bold(s) in RR^(b times n times c_s)$，原子坐标 $bold(x) in RR^(b times n times 3)$，边掩码 $bold(m) in RR^(b times n times n)$
    + *参数*：$c_s in NN^+$ (结点特征维度)，$c_p in NN^+$ (边特征维度)，$k in NN^+$ (相对位置编码范围)
    + 将结点特征投影到边特征空间：
      + $bold(p)_i = W_i bold(s) in RR^(b times n times c_p)$ #h(1em) // $W_i in RR^(c_s times c_p)$ 为投影矩阵
      + $bold(p)_j = W_j bold(s) in RR^(b times n times c_p)$ #h(1em) // $W_j in RR^(c_s times c_p)$ 为投影矩阵
    + 通过广播加法构建初始边特征矩阵：
      + $bold(p)_(b,i,j,k) = bold(p)_i^(b,i,k) + bold(p)_j^(b,j,k) in RR^(b times n times n times c_p)$ #h(1em) // 通过广播机制将 $[b, n, c_p]$ 扩展为 $[b, n, n, c_p]$ 后逐元素相加
    + 生成残基位置索引序列：
      + $bold(r) = [0, 1, 2, ..., n-1] in NN^n$ #h(1em) // 残基在序列中的位置索引
    + 添加相对位置编码：
      + $bold(p) = bold(p) + R(bold(r)) in RR^(b times n times n times c_p)$ #h(1em) // $R$ 为相对位置编码函数，见 @relative_position_encoding_algorithm
    + 添加模板结构信息：
      + $bold(p) = bold(p) + T(bold(x)) in RR^(b times n times n times c_p)$ #h(1em) // $T$ 为模板编码函数，编码原子对间的距离信息
    + 应用边掩码过滤无效边：
      + $bold(p)_(b,i,j,k) = bold(p)_(b,i,j,k) * bold(m)_(b,i,j) in RR^(b times n times n times c_p)$ #h(1em) // 通过广播将掩码 $[b, n, n]$ 应用到边特征上，$*$ 表示逐元素乘法
    + *return* $bold(p) in RR^(b times n times n times c_p)$
  ],
) <pair_feature_forward_algorithm>

相对位置编码（Relative Position Encoding）是边特征网络中的关键组件，用于捕获残基对之间的序列距离信息。与绝对位置编码不同，相对位置编码关注残基之间的相对关系而非绝对位置，这对于蛋白质结构建模尤为重要。蛋白质的局部结构（如 $alpha$-螺旋、$beta$-折叠）和长程相互作用往往由序列上相邻或相距较远的残基共同决定，因此相对位置信息能够为模型提供更直接的结构约束。

相对位置编码的核心思想源自 AlphaFold 2 @AlphaFold2021，其设计基于以下四个关键考虑：

+ *序列距离的重要性*：在蛋白质结构中，序列上相近的残基往往在三维空间中也存在相互作用。例如，$alpha$-螺旋中相邻残基通过氢键形成稳定的螺旋结构，$beta$-折叠中序列上相距较远的残基也可能通过氢键形成片层结构。相对位置编码能够显式地建模这种序列距离与空间结构之间的关联。

+ *离散化策略*：为了处理任意长度的蛋白质序列，将连续的相对位置差离散化为有限个区间（bins）。设定范围参数 $k in NN^+$，将所有可能的相对位置差 $d = j - i$ 映射到离散值集合 $[-k, -k+1, ..., 0, ..., k-1, k]$，共 $2k+1$ 个离散值。超出范围 $[-k, k]$ 的相对位置差会被截断到边界值 $-k$ 或 $k$。这种离散化策略既显著减少了参数量（从 $O(n^2)$ 降低到 $O(k)$），又增强了模型对不同长度序列的泛化能力。

+ *对称性与方向性*：相对位置编码保留了序列的方向信息，这是其与对称距离编码的关键区别。对于残基对 $(i, j)$，从残基 $i$ 到残基 $j$ 的相对位置为 $d_(i arrow.r j) = j - i$，而从残基 $j$ 到残基 $i$ 的相对位置为 $d_(j arrow.r i) = i - j = -d_(i arrow.r j)$。这种非对称性使得模型能够区分序列的方向性，这对于理解蛋白质从 N 端到 C 端的定向结构特征（如螺旋的手性、折叠的方向性）至关重要。

+ *可学习的嵌入*：通过将离散化的相对位置值转换为 one-hot 编码向量，再经过可学习的线性变换层 $W^"pos" in RR^((2k+1) times c_p)$ 映射到边特征空间，模型能够自动学习不同相对距离对蛋白质结构形成的影响权重。这种可学习的机制使得模型能够根据数据自适应地调整不同相对位置的重要性。

相对位置编码算法的具体实现如 @relative_position_encoding_algorithm 所示。算法首先计算所有残基对之间的相对位置差矩阵 $bold(d) in ZZ^(n times n)$，其中 $d_(i,j) = j - i$；然后通过截断和离散化操作将每个相对位置差映射到最近的离散区间；最后通过 one-hot 编码和线性变换得到相对位置特征 $bold(p)^"pos" in RR^(n times n times c_p)$，该特征将被添加到边特征中。

这种编码方式使得模型能够有效地学习从局部相互作用（如相邻残基的共价键）到长程相互作用（如相距较远的残基通过空间折叠形成的非共价相互作用）的多种残基相互作用模式，为蛋白质结构的准确建模提供了重要的序列结构先验信息。

#figure(
  kind: "algorithm",
  pseudocode-list(booktabs: true, numbered-title: [相对位置编码算法])[
    + *input*：残基位置索引 $bold(r) in RR^(b times n)$
    + *参数*：相对位置范围 $k in NN^+$，边特征维度 $c_p in NN^+$
    + 计算残基对之间的相对位置差矩阵：
      + $bold(d)_(b,i,j) = bold(r)_(b,j) - bold(r)_(b,i) in ZZ^(b times n times n)$ #h(1em) // $bold(d)_(b,i,j)$ 表示批次 $b$ 中残基 $i$ 到残基 $j$ 的相对位置
    + 生成离散化的相对位置区间集合：
      + $n_b = 2k + 1 in NN^+$ #h(1em) // $n_b$ 为离散区间的数量
      + $bold(v) = [-k, -k+1, ..., 0, ..., k-1, k] in ZZ^(n_b)$ #h(1em) // 离散化的相对位置值集合
    + 通过广播机制扩展 $bold(v)$ 以匹配 $bold(d)$ 的形状：
      + $bold(v)^e_(b,i,j,l) = bold(v)_l in RR^(b times n times n times n_b)$ #h(1em) // 通过广播将 $[n_b]$ 扩展为 $[b, n, n, n_b]$
    + 找到每个相对位置差最接近的离散区间索引：
      + $bold(b)_(b,i,j) = "argmin"_(l in {1,2,...,n_b}) |bold(d)_(b,i,j) - bold(v)_l| in NN^(b times n times n)$ #h(
          1em,
        ) // 返回最接近的离散区间索引
    + 将离散区间索引转换为 one-hot 编码：
      + 对 $forall (b,i,j,l)$，$bold(o)_(b,i,j,l) = delta_(bold(b)_(b,i,j), l) in {0,1}^(b times n times n times n_b)$ #h(1em) // $delta_(i,j)$ 为 Kronecker delta 函数，当 $i = j$ 时为 1，否则为 0
    + 通过线性变换层映射到边特征空间：
      + $bold(p)^r = bold(o) W^"pos" in RR^(b times n times n times c_p)$ #h(1em) // $W^"pos" in RR^(n_b times c_p)$ 为可学习的权重矩阵
    + *return* $bold(p)^r in RR^(b times n times n times c_p)$
  ],
) <relative_position_encoding_algorithm>

交叉注意力网络是本模型中实现蛋白质与口袋掩码、配体特征融合的核心模块。该网络采用标准的Transformer交叉注意力机制，允许目标序列（蛋白质特征）关注源序列（配体或口袋特征），从而实现不同模态特征之间的信息交互。

=== 交叉注意力网络

交叉注意力网络的前向传播算法如 @cross_attention_forward_algorithm 所示。该算法首先将目标特征和源特征投影到相同的特征空间，然后通过多头注意力机制计算交叉注意力，最后通过前馈网络和残差连接得到输出特征。

#figure(
  kind: "algorithm",
  pseudocode-list(booktabs: true, numbered-title: [交叉注意力网络前向传播算法])[
    + *input*：目标特征 $bold("tgt") in RR^(b times n_"tgt" times c_"tgt")$，源特征 $bold("src") in RR^(b times n_"src" times c_"src")$，源掩码 $bold("src_mask") in RR^(b times n_"src")$
    + *output*：输出特征 $bold("output") in RR^(b times n_"tgt" times c_"tgt")$
    + *parameters*：
      - 目标投影层 $W_"tgt" in RR^(c_"tgt" times c_"feature")$
      - 源投影层 $W_"src" in RR^(c_"src" times c_"feature")$
      - 多头注意力层 $"MHA"$（头数 $h$，特征维度 $c_"feature"$）
      - 前馈网络 $"FFN": RR^(c_"feature") arrow.r RR^(c_"feature")$
      - 逆投影层 $W_"inv" in RR^(c_"feature" times c_"tgt")$
      - 层归一化 $"LN"_1, "LN"_2, "LN"_3$
    + $bold("tgt")_"proj" arrow.l bold("tgt") W_"tgt"$ // 投影目标特征到统一空间
    + $bold("src")_"proj" arrow.l bold("src") W_"src"$ // 投影源特征到统一空间
    + $bold("attn")_"out" arrow.l "MHA"(bold("tgt")_"proj", bold("src")_"proj", bold("src")_"proj", bold("src_mask"))$ // 多头交叉注意力
    + $bold("attn")_"out" arrow.l "LN"_1(bold("tgt")_"proj" + "Dropout"(bold("attn")_"out"))$ // 残差连接与层归一化
    + $bold("ff")_"out" arrow.l "FFN"(bold("attn")_"out")$ // 前馈网络
    + $bold("output")_"proj" arrow.l "LN"_2(bold("attn")_"out" + "Dropout"(bold("ff")_"out"))$ // 残差连接与层归一化
    + $bold("output") arrow.l "LN"_3(W_"inv" bold("output")_"proj")$ // 逆投影回原始维度
    + *return* $bold("output")$
  ],
) <cross_attention_forward_algorithm>

交叉注意力网络的整体结构如 @fig:cross_attention_network 所示。网络采用编码器-解码器架构，主要包含三个核心组件：（1）特征投影层，通过线性变换将目标特征和源特征从各自的原始维度映射到统一的特征空间 $RR^(c_"feature")$，确保不同模态的特征能够在同一空间中进行交互；（2）多头交叉注意力层，采用多头自注意力机制（Multi-Head Attention）计算目标序列对源序列的交叉注意力，通过查询（Query）、键（Key）和值（Value）的交互实现特征融合，并利用残差连接和层归一化稳定训练过程；（3）输出层，包含前馈神经网络（Feed-Forward Network）和逆投影层，前馈网络通过非线性变换增强特征表达能力，逆投影层将融合后的特征映射回目标特征的原始维度空间，保持输出维度与输入维度的一致性。

#figure(
  caption: [交叉注意力网络结构图],
)[
  #diagram(
    spacing: (1em, 1em),
    // 左侧输入：目标特征
    node(
      (-3, 0),
      [
        目标特征
      ],
      name: "tgt",
      ..io_node_args(right),
    ),
    // 目标投影
    node(
      (-3, 0.5),
      [Linear],
      name: "tgt_proj",
      ..module_node_args,
    ),

    // 右侧输入：源特征
    node(
      (3.5, 0),
      [源特征],
      name: "src",
      ..io_node_args(left),
    ),


    // 源投影
    node(
      (3.5, 0.5),
      [Linear],
      name: "src_proj",
      ..module_node_args,
    ),

    // 多头注意力
    node(
      (0, 0),
      [
        #import "my_pkg_typ/graphlet/single_head_attention.typ": single_head_attention
        #single_head_attention(length: 2em)
      ],
      name: "mha",
      ..module_node_args,
    ),

    // 残差连接和层归一化1
    node(
      (0, 1),
      [Residual + LayerNorm],
      name: "ln1",
      ..function_node_args,
    ),

    // 前馈网络
    node(
      (1, 2),
      [
        #import "my_pkg_typ/graphlet/ffn.typ": ffn_with_dropout
        #rotate(180deg, ffn_with_dropout(length: 0.8em))
      ],
      name: "ffn",
      ..module_node_args,
    ),

    // 残差连接和层归一化2
    node(
      (0, 2),
      [Residual + LayerNorm],
      name: "ln2",
      ..function_node_args,
    ),

    // 逆投影
    node(
      (0, 3),
      [Linear + LayerNorm],
      name: "inv_proj",
      ..module_node_args,
    ),

    // 输出
    node(
      (1, 3),
      [输出特征],
      name: "output",
      ..io_node_args(right),
    ),

    // 数据流
    edge(<tgt>, <tgt_proj>, ..edge_args),
    edge(<src>, <src_proj>, ..edge_args),
    edge(<tgt_proj>, "rrr", label: [Q], ..edge_args),
    edge(<src_proj>, "lll", label: [K, V], ..edge_args),
    edge(<mha>, <ln1>, ..edge_args),
    edge(<tgt_proj>, <ln1>, label: [Residual], corner: left, ..residual_edge_args),
    edge(<ln1>, <ffn>, ..edge_args, corner: right),
    edge(<ffn>, <ln2>, ..edge_args),
    edge(<ln1>, <ln2>, label: [Residual], ..residual_edge_args),
    edge(<ln2>, <inv_proj>, ..edge_args),
    edge(<inv_proj>, <output>, ..edge_args),
  )
]<cross_attention_network>

蛋白质-配体交叉注意力网络（Protein-Ligand Cross-Attention Network, PLCrossAttentionNet）是交叉注意力网络的特化版本，专门用于融合蛋白质边特征和配体边特征，从而建模蛋白质-配体之间的相互作用模式。该网络将蛋白质的边特征矩阵 $bold(p)^p in RR^(b times n_r times n_r times c_p)$ 和配体的边特征矩阵 $bold(p)^l in RR^(b times n_l times n_l times c_l)$ 重塑为序列形式，然后通过交叉注意力机制实现特征融合。具体处理流程如下：

1. *特征重塑*：将蛋白质边特征从 $[b, n_r, n_r, c_p]$ 重塑为 $[b, n_r^2, c_p]$，将配体边特征从 $[b, n_l, n_l, c_l]$ 重塑为 $[b, n_l^2, c_l]$，将二维的边特征矩阵转换为序列形式以便进行注意力计算。

2. *交叉注意力计算*：将重塑后的蛋白质边特征作为目标序列（Query），配体边特征作为源序列（Key 和 Value），通过多头交叉注意力机制计算蛋白质残基对与配体原子对之间的注意力权重，实现特征融合。

3. *输出重塑*：将融合后的特征从 $[b, n_r^2, c_p]$ 重塑回 $[b, n_r, n_r, c_p]$，恢复为边特征矩阵形式。

这种设计使得蛋白质的每个残基对都能够关注配体的所有原子对，通过注意力机制自适应地学习不同残基-原子对之间的相互作用强度，从而捕获蛋白质-配体界面的几何和化学相互作用模式。

口袋交叉注意力网络（Pocket Cross-Attention Network, PocketCrossAttentionNet）用于融合蛋白质特征和口袋掩码信息，确保模型在生成过程中能够区分口袋区域和非口袋区域，并保持非口袋区域的结构不变。该网络的输入包括：

- 蛋白质边特征 $bold(p)^p in RR^(b times n_r times n_r times c_p)$：待更新的蛋白质残基对特征
- 掩码后的蛋白质坐标 $bold(x)^m in RR^(b times n_r times 3)$：经过掩码处理的 $C alpha$ 原子坐标
- 口袋掩码 $bold(m)^p in {0,1}^(b times n_r)$：二值掩码，标识哪些残基属于口袋区域
- 填充掩码 $bold(m)^f in {0,1}^(b times n_r)$：二值掩码，标识有效残基位置

处理流程如下：

+ *特征重塑*：将蛋白质边特征从 $[b, n_r, n_r, c_p]$ 重塑为 $[b, n_r^2, c_p]$，转换为序列形式。

+ *口袋特征构建*：将口袋掩码 $bold(m)^p$ 扩展维度为 $[b, n_r, 1]$，然后与掩码坐标 $bold(x)^m$ 拼接，构建口袋结点特征 $bold(s)^p = [bold(x)^m; bold(m)^p] in RR^(b times n_r times 4)$，其中前3维为坐标信息，第4维为口袋掩码信息。

+ *交叉注意力融合*：将重塑后的蛋白质边特征作为目标序列，口袋结点特征作为源序列，通过交叉注意力机制使蛋白质残基对关注口袋区域的位置和掩码信息。

+ *输出重塑*：将融合后的特征从 $[b, n_r^2, c_p]$ 重塑回 $[b, n_r, n_r, c_p]$，恢复为边特征矩阵形式。

这种设计使得模型能够根据口袋的位置信息和掩码，有针对性地更新蛋白质的边特征，使得属于口袋区域的残基对获得更强的更新信号，而非口袋区域的残基对保持相对稳定，从而在生成过程中保持非口袋区域的结构不变，同时专注于口袋区域的生成。

=== 特征变换网络

特征变换网络（Pair Transform Network, PairTransformNet）是用于处理边特征的核心模块，其设计借鉴了 AlphaFold 2 @AlphaFold2021 中的 Evoformer 架构。该网络通过三角乘法更新（Triangle Multiplication）和三角注意力（Triangle Attention）机制，在边特征矩阵的不同维度（行和列）上进行信息传播和特征增强，使得残基对之间的相互作用信息能够在整个特征矩阵中有效传播，从而提升模型对蛋白质结构的理解能力。

#figure(
  caption: [特征变换层结构图],
)[
  #diagram(
    spacing: (2em, 1em),
    // 输入
    node(
      (0, 0),
      [边特征],
      name: "input",
      ..io_node_args(right),
    ),

    // 外向三角乘法
    node(
      (0, 1.0),
      [
        #set par(leading: 0.8em)
        外向三角乘法
      ],
      name: "tri_mul_out",
      ..module_node_args,
    ),

    // Dropout行1
    node(
      (0, 2.0),
      [
        #set par(leading: 0.8em)
        行Dropout
      ],
      name: "dropout1",
      ..module_node_args,
    ),

    // 加法节点1
    node(
      (0, 3),
      [$+$],
      name: "add1",
      ..operator_node_args,
    ),

    // 内向三角乘法
    node(
      (1, 2),
      [
        内向三角乘法
      ],
      name: "tri_mul_in",
      ..module_node_args,
    ),

    // Dropout行2
    node(
      (1, 1),
      [
        行Dropout
      ],
      name: "dropout2",
      ..module_node_args,
    ),

    // 加法节点2
    node(
      (1, 0),
      [$+$],
      name: "add2",
      ..operator_node_args,
    ),

    // 起始节点三角注意力
    node(
      (2, 1),
      [
        起始节点注意力
      ],
      name: "tri_att_start",
      ..module_node_args,
    ),

    // Dropout行3
    node(
      (2, 2),
      [
        行Dropout
      ],
      name: "dropout3",
      ..module_node_args,
    ),

    // 加法节点3
    node(
      (2, 3),
      [$+$],
      name: "add3",
      ..operator_node_args,
    ),

    // 结束节点三角注意力
    node(
      (2, 4),
      [
        结束节点注意力
      ],
      name: "tri_att_end",
      ..module_node_args,
    ),

    // Dropout列
    node(
      (2, 5),
      [
        列Dropout
      ],
      name: "dropout4",
      ..module_node_args,
    ),

    // 加法节点4
    node(
      (2, 6),
      [$+$],
      name: "add4",
      ..operator_node_args,
    ),

    // 边转换
    node(
      (1, 6),
      [
        边转换
      ],
      name: "pair_transition",
      ..module_node_args,
    ),

    // 加法节点5
    node(
      (0, 6),
      [$+$],
      name: "add5",
      ..operator_node_args,
    ),

    // 掩码应用
    node(
      (0, 5),
      [
        掩码应用
      ],
      name: "mask",
      ..function_node_args,
    ),

    // 输出
    node(
      (0, 4),
      [边特征],
      name: "output",
      ..io_node_args(left),
    ),

    // 数据流
    edge(<input>, <tri_mul_out>, ..edge_args),
    edge(<tri_mul_out>, <dropout1>, ..edge_args),
    edge(<dropout1>, <add1>, ..edge_args),
    edge(<input>, "ll", "ddd", <add1>, label: [Residual], corner: right, ..residual_edge_args, label-pos: 40%),

    edge(<add1>, <tri_mul_in>, corner: left, ..edge_args),
    edge(<tri_mul_in>, <dropout2>, ..edge_args),
    edge(<dropout2>, <add2>, ..edge_args),
    edge(<add1>, (0.5, 3), "uuu", <add2>, label: [Residual], corner: right, ..residual_edge_args, label-pos: 28%),

    edge(<add2>, <tri_att_start>, corner: right, ..edge_args),
    edge(<tri_att_start>, <dropout3>, ..edge_args),
    edge(<dropout3>, <add3>, ..edge_args),
    edge(<add2>, (1.5, 0), "ddd", <add3>, label: [Residual], corner: right, ..residual_edge_args, label-pos: 28%),

    edge(<add3>, <tri_att_end>, ..edge_args),
    edge(<tri_att_end>, <dropout4>, ..edge_args),
    edge(<dropout4>, <add4>, ..edge_args),
    edge(<add3>, "rr", "ddd", <add4>, label: [Residual], corner: right, ..residual_edge_args, label-pos: 40%),

    edge(<add4>, <pair_transition>, ..edge_args),
    edge(<pair_transition>, <add5>, ..edge_args),
    edge(<add4>, "dd", "ll", <add5>, label: [Residual], corner: right, ..residual_edge_args, label-pos: 40%),

    edge(<add5>, <mask>, ..edge_args),
    edge(<mask>, <output>, "ll", ..edge_args),
    edge((0, -1), <input>, ..edge_args),
  )
]<pair_transform_layer>


特征变换层（Pair Transform Layer, PairTransformLayer）是特征变换网络的基本单元，其结构如 @fig:pair_transform_layer 所示。该层采用模块化设计，包含以下四个核心组件：

+ *三角乘法更新*：包括外向三角乘法（Triangle Multiplication Outgoing）和内向三角乘法（Triangle Multiplication Incoming）两个子模块。外向三角乘法沿着边特征矩阵的行方向（即固定起始节点）进行信息聚合，内向三角乘法沿着列方向（即固定结束节点）进行信息聚合。这两个模块通过矩阵乘法操作，使得每个边特征能够聚合来自共享节点的其他边的信息，从而捕获三角形路径上的信息传播模式。

+ *三角注意力*：包括起始节点注意力（Triangle Attention Starting Node）和结束节点注意力（Triangle Attention Ending Node）两个子模块。起始节点注意力在行方向上计算注意力权重，使得每条边能够关注与其共享起始节点的其他边；结束节点注意力在列方向上计算注意力权重，使得每条边能够关注与其共享结束节点的其他边。这种设计使得模型能够捕获边特征在不同维度上的复杂依赖关系。

+ *边转换*：通过前馈神经网络（Feed-Forward Network）对边特征进行非线性变换，增强特征的表达能力。该模块通常包含两个线性变换层和一个激活函数，能够学习复杂的特征映射关系。

+ *残差连接和正则化*：每个子模块都采用残差连接（Residual Connection）机制，将输入特征与变换后的特征相加，有助于梯度传播和训练稳定性。同时，在行或列方向上应用 Dropout 正则化，防止过拟合并提升模型的泛化能力。

特征变换网络由多个特征变换层（通常为 $L$ 层）堆叠而成，形成深度网络架构，其整体结构如 @fig:pair_transform_net 所示。网络的输入包括边特征矩阵 $bold(p)^(0) in RR^(b times n times n times c_p)$ 和边掩码 $bold(m) in {0,1}^(b times n times n)$，其中边掩码用于标识有效的残基对，防止无效边参与计算。网络通过逐层的前向传播，将输入边特征 $bold(p)^(0)$ 依次经过 $L$ 个特征变换层的处理，最终输出更新后的边特征 $bold(p)^(L) in RR^(b times n times n times c_p)$。每一层的输出作为下一层的输入，通过这种逐层的信息传播和特征增强机制，网络能够逐步提取和整合边特征中的复杂依赖关系，包括局部相互作用模式和长程依赖关系，从而为后续的坐标生成提供丰富的结构先验信息。

#figure(
  caption: [特征变换网络结构图],
)[
  #diagram(
    spacing: (2em, 0.8em),
    let edge = edge.with(..edge_args),

    // 输入
    node(
      (0, 0),
      [
        边特征\
      ],
      name: "input",
      ..io_node_args(right),
    ),

    // 掩码输入
    node(
      (4, 0),
      [
        掩码
      ],
      name: "mask_input",
      ..io_node_args(right),
    ),

    // Layer 1
    node(
      (1.5, 0),
      [
        特征变换层 1
      ],
      name: "layer1",
      ..module_node_args,
    ),

    // Layer 2
    node(
      (1.5, 1),
      [
        特征变换层 2
      ],
      name: "layer2",
      ..module_node_args,
    ),

    // 省略号
    node(
      (1.5, 2),
      [$dots.v$],
      stroke: none,
      name: "dots",
    ),

    // Layer N
    node(
      (1.5, 3),
      [
        特征变换层
      ],
      name: "layerN",
      ..module_node_args,
    ),

    // 输出
    node(
      (1.5, 4),
      [
        边特征
      ],
      name: "output",
      ..io_node_args(right),
    ),

    // 数据流
    edge(<input>, <layer1>),
    edge(<mask_input>, <layer1>),
    edge(<layer1>, <layer2>),
    edge(<mask_input>, "d", <layer2>),
    edge(<layer2>, <dots>),
    edge(<dots>, <layerN>),
    edge(<mask_input>, "ddd", <layerN>),
    edge(<layerN>, <output>),
  )
]<pair_transform_net>

=== 结构解码网络(Equivariant Decoder)

结构解码网络（Structure Decoder Network, StructureNet）是本模型中负责预测蛋白质三维结构的核心模块，采用旋转等变神经网络架构来处理蛋白质的几何信息。该网络的设计借鉴了 AlphaFold 2 @AlphaFold2021 的结构模块（Structure Module），通过不变点注意力（Invariant Point Attention, IPA）机制实现对三维空间中蛋白质结构的迭代优化。网络的等变性保证了当输入坐标发生旋转变换时，输出的坐标也会相应地执行相同的旋转变换，从而保持几何一致性。

结构解码网络采用分层架构，由多个结构层（Structure Layer）堆叠而成，每个结构层包含三个核心子模块：不变点注意力模块（IPA Module）、结构转换模块（Structure Transition Module）和骨架更新模块（Backbone Update Module）。网络的输入包括以下四个组件：

- *结点特征* $bold(s) in RR^(b times n_r times c_s)$：每个残基的特征表示，包含从编码器和特征变换网络提取的几何与化学信息
- *边特征* $bold(p) in RR^(b times n_r times n_r times c_p)$：残基对之间的关系特征，编码了残基对之间的相互作用模式
- *刚体变换* $bold(T) = {(R_i, bold(t)_i)}_(i=1)^(n_r)$：每个残基的局部坐标系，其中 $R_i in "SO"(3)$ 为旋转矩阵（$"SO"(3)$ 表示三维特殊正交群），$bold(t)_i in RR^3$ 为平移向量，定义了残基在三维空间中的位置和朝向
- *掩码* $bold(m) in {0,1}^(b times n_r)$：二值掩码，标识批次中每个位置的有效残基，用于处理不同长度的蛋白质序列

网络的整体结构如 @fig:structure_net 所示。网络采用多块（Block）迭代的架构设计，每个结构块包含若干结构层（通常为 $L_b$ 层）。在每个结构层中，不变点注意力模块基于结点特征和边特征计算注意力权重，结构转换模块通过前馈网络更新结点特征，骨架更新模块根据更新后的特征预测残基的刚体变换更新量 $Delta bold(T)$，并通过组合更新得到新的刚体变换 $bold(T)^' = bold(T) compose Delta bold(T)$（其中 $compose$ 表示刚体变换的组合操作）。通过多个结构块的迭代优化，网络能够逐步细化蛋白质的三维结构预测，从初始的粗略结构逐步收敛到精确的原子坐标。

#figure(
  caption: [结构解码网络整体架构],
)[
  #diagram(
    spacing: (0.5em, 1.5em),
    let edge = edge.with(..edge_args),

    // 输入
    node(
      (-3, 0),
      [
        结点特征
      ],
      name: "input_s",
      ..io_node_args(right),
    ),

    node(
      (-3, 2),
      [
        边特征
      ],
      name: "input_p",
      ..io_node_args(right),
    ),

    node(
      (-3, 1),
      [
        刚体变换
      ],
      name: "input_t",
      ..io_node_args(right),
    ),

    // Block 1
    node(
      (0, 1),
      [
        结构块 1
      ],
      name: "block1",
      ..module_node_args,
    ),

    // Block 2
    node(
      (3, 1),
      [
        结构块 2
      ],
      name: "block2",
      ..module_node_args,
    ),

    // 省略号
    node(
      (5, 1),
      [$dots.h$],
      stroke: none,
      name: "dots",
    ),

    // Block N
    node(
      (7, 1),
      [
        结构块 $N$
      ],
      name: "blockN",
      ..module_node_args,
    ),

    // 输出
    node(
      (10, 1),
      [
        刚体变换
      ],
      name: "output",
      ..io_node_args(right),
    ),

    // 数据流
    edge(<input_s>, <block1>, corner: right),
    edge(<input_t>, <block1>),
    edge(<input_p>, <block1>, corner: left),
    edge(<block1>, <block2>),
    edge(<block2>, <dots>),
    edge(<dots>, <blockN>),
    edge(<blockN>, <output>),
  )
]<structure_net>

=== 结构层

结构层（Structure Layer, StructureLayer）是结构解码网络的基本单元，其结构如 @fig:structure_layer 所示。每个结构层通过三个核心模块的协同工作，实现对蛋白质三维结构的迭代优化：

+ *不变点注意力（Invariant Point Attention, IPA）*：该模块是结构层的核心组件，能够在三维空间中计算残基之间的注意力权重，同时保持旋转等变性。IPA 模块的创新之处在于它能够同时处理标量特征（结点特征和边特征）和几何信息（刚体变换），通过在三维空间中定义不变点（invariant points）并计算基于这些点的注意力，使得网络能够感知残基在三维空间中的相对位置关系和几何约束。该模块的输出是更新后的结点特征，其中融合了几何信息。

+ *结构转换（Structure Transition）*：该模块通过前馈神经网络对结点特征进行非线性变换，增强特征的表达能力。具体而言，该模块采用两层前馈网络架构，第一层将输入特征从 $c_s$ 维扩展到 $alpha c_s$ 维（通常 $alpha = 4$），第二层将特征维度压缩回 $c_s$ 维。中间层使用 ReLU 激活函数引入非线性，并在训练过程中应用 Dropout 正则化以防止过拟合。

+ *骨架更新（Backbone Update）*：该模块根据更新后的结点特征预测刚体变换的增量，用于更新残基的局部坐标系。具体而言，该模块通过线性变换将结点特征 $bold(s) in RR^(c_s)$ 映射为旋转参数和平移参数。旋转参数采用四元数（quaternion）表示 $bold(q) in RR^4$，通过归一化得到单位四元数，然后转换为旋转矩阵 $R in "SO"(3)$，这种表示方法相比欧拉角具有更好的数值稳定性和无奇异性。平移参数直接预测为三维向量 $Delta bold(t) in RR^3$。最终得到刚体变换增量 $Delta bold(T) = (R, Delta bold(t))$。


#figure(
  caption: [结构层架构],
)[
  #diagram(
    spacing: (2em, 1.0em),
    // 输入
    node(
      (-3, 0),
      [
        结点特征
      ],
      name: "input_s",
      ..io_node_args(right),
    ),

    node(
      (-3, 1),
      [
        边特征
      ],
      name: "input_p",
      ..io_node_args(right),
    ),
    node(
      (3, 3),
      [
        边特征
      ],
      name: "output_p",
      ..io_node_args(right),
    ),

    node(
      (-3, 2),
      [
        刚体变换
      ],
      name: "input_t",
      ..io_node_args(right),
    ),

    // IPA模块
    node(
      (0, 1),
      [
        不变点注意力
      ],
      name: "ipa",
      ..module_node_args,
    ),

    node(
      (0, 2),
      [$+$],
      shape: circle,
      name: "add1",
      ..operator_node_args,
    ),

    // Dropout
    node(
      (0, 3),
      [Dropout],
      name: "dropout1",
      ..module_node_args,
    ),

    // LayerNorm
    node(
      (0, 4),
      [LayerNorm],
      name: "ln1",
      ..module_node_args,
    ),

    // Structure Transition
    node(
      (0, 5),
      [
        #set par(leading: 0.8em)
        结构转换\
        FFN + Dropout + LayerNorm
      ],
      name: "transition",
      ..module_node_args,
    ),

    // Backbone Update
    node(
      (0, 6),
      [
        #set par(leading: 0.8em)
        骨架更新
      ],
      name: "bb_update",
      ..module_node_args,
    ),

    // 刚体变换组合
    node(
      (0, 7),
      [
        刚体变换组合
      ],
      name: "compose",
      ..module_node_args,
    ),

    // 输出
    node(
      (3, 5),
      [
        结点特征
      ],
      name: "output_s",
      ..io_node_args(right),
    ),

    node(
      (3, 7),
      [
        刚体变换
      ],
      name: "output_t",
      ..io_node_args(right),
    ),

    // // 数据流
    edge(<input_s>, <ipa>, ..edge_args),
    edge(<input_p>, <ipa>, ..edge_args),
    edge(<input_t>, <ipa>, ..edge_args),
    edge(<ipa>, <dropout1>, ..edge_args),
    edge(<dropout1>, <ln1>, ..edge_args),
    edge(<input_s>, "rrrr", "dd", <add1>, label: [Residual], label-side: left, ..residual_edge_args),
    edge(<ln1>, <transition>, ..edge_args),
    edge(<transition>, <output_s>, ..edge_args),
    edge(<transition>, <bb_update>, ..edge_args),
    edge(<bb_update>, <compose>, label: [$Delta bold(T)$], ..edge_args),
    edge(<input_t>, <compose>, corner: left, label: [$bold(T)$], ..edge_args),
    edge(<compose>, <output_t>, ..edge_args),
    edge(
      <input_p>,
      "l",
      "uu",
      "rrrrrrr",
      <output_p>,
      label: [直接拷贝],
      label-side: center,
      label-pos: 0.7,
      ..edge_args,
    ),
    edge(<output_p>, "r", ..edge_args),
    edge(<output_t>, "r", ..edge_args),
    edge(<output_s>, "r", ..edge_args),
  )
]<structure_layer>


结构层的前向传播过程遵循严格的顺序，具体流程如下：（1）*IPA 模块处理*：不变点注意力模块接收输入结点特征 $bold(s)^(l) in RR^(b times n_r times c_s)$、边特征 $bold(p) in RR^(b times n_r times n_r times c_p)$ 和当前刚体变换 $bold(T)^(l) in RR^(b times n_r times 7)$（四元数和平移向量的拼接），通过注意力机制计算更新后的结点特征 $bold(s)_"ipa" in RR^(b times n_r times c_s)$。（2）*残差连接与归一化*：将 IPA 模块的输出与输入结点特征相加，应用 Dropout 和层归一化（Layer Normalization），得到 $bold(s)_"norm1" = "LN"("Dropout"(bold(s)^(l) + bold(s)_"ipa"))$。（3）*结构转换处理*：结构转换模块对归一化后的特征进行非线性变换，得到 $bold(s)_"trans" = "FFN"(bold(s)_"norm1")$。（4）*再次残差连接与归一化*：将结构转换的输出与 $bold(s)_"norm1"$ 相加，再次应用 Dropout 和层归一化，得到 $bold(s)_"norm2" = "LN"("Dropout"(bold(s)_"norm1" + bold(s)_"trans"))$。（5）*骨架更新*：骨架更新模块根据最终的结点特征 $bold(s)_"norm2"$ 预测刚体变换增量 $Delta bold(T) in RR^(b times n_r times 7)$，并通过组合操作与当前刚体变换合并，得到新的刚体变换 $bold(T)^(l+1) = bold(T)^(l) compose Delta bold(T)$，同时更新结点特征 $bold(s)^(l+1) = bold(s)_"norm2"$。通过这种迭代更新机制，结构层能够逐步优化蛋白质的三维结构预测。


=== 骨架更新与四元数变换

骨架更新模块（Backbone Update Module, BackboneUpdate）负责根据更新后的结点特征预测刚体变换的增量，用于迭代优化残基的局部坐标系。该模块采用四元数（quaternion）表示旋转，相比欧拉角具有更好的数值稳定性和无奇异性。模块通过线性变换层将结点特征映射为旋转和平移参数，然后通过四元数归一化和旋转矩阵转换，最终得到刚体变换增量。


#figure(
  caption: [骨架更新与四元数变换流程],
)[
  #diagram(
    spacing: (1em, 1em),
    let edge = edge.with(..edge_args),

    // 输入
    node(
      (0, 0),
      [
        结点特征
      ],
      name: "input",
      ..io_node_args(right),
    ),

    // 线性层
    node(
      (1, 0),
      [
        Linear
      ],
      name: "linear",
      ..module_node_args,
    ),

    // 参数分解
    node(
      (2, 0),
      [
        参数分解
      ],
      name: "split",
      ..function_node_args,
    ),


    // 右分支：平移向量
    node(
      (3, 0),
      [
        平移向量
        $bold(t) in RR^3$
      ],
      name: "trans",
      ..ffn_node_args,
    ),
    // 左分支：四元数处理
    node(
      (2, 1),
      [
        四元数虚部\
        $bold(q)_"imag" in RR^3$
      ],
      name: "quat_imag",
      ..ffn_node_args,
    ),

    // 四元数构造
    node(
      (1, 1),
      [
        构造四元数\
        $bold(q) = [1, bold(q)_"imag"]$
      ],
      name: "quat_construct",
      ..ffn_node_args,
    ),

    // 归一化
    node(
      (0, 1),
      [
        归一化\
        $bold(q) arrow.l bold(q) / sqrt(1 + ||bold(q)_"imag"||^2)$
        #v(1em)

      ],
      name: "normalize",
      ..ffn_node_args,
    ),

    // 四元数转旋转矩阵
    node(
      (0, 2),
      [
        四元数转提取旋转\
        $mat(
          1 - 2(q_2^2 + q_3^2), 2(q_1 q_2 - q_0 q_3), 2(q_1 q_3 + q_0 q_2);
          2(q_1 q_2 + q_0 q_3), 1 - 2(q_1^2 + q_3^2), 2(q_2 q_3 - q_0 q_1);
          2(q_1 q_3 - q_0 q_2), 2(q_2 q_3 + q_0 q_1), 1 - 2(q_1^2 + q_2^2)
        )$
        #v(1em)
      ],
      name: "quat_to_rot",
      ..ffn_node_args,
    ),

    // 旋转矩阵
    node(
      (1, 2),
      [
        旋转矩阵\
        $bold(R) in RR^(3 times 3)$
      ],
      name: "rot",
      ..ffn_node_args,
    ),

    // 组合刚体变换
    node(
      (2, 2),
      [
        组合刚体变换\
        $bold(T) = (bold(R), bold(t))$
      ],
      name: "combine",
      ..ffn_node_args,
    ),

    // 输出
    node(
      (2, 3),
      [
        刚体变换 $Delta bold(T)$
      ],
      name: "output",
      ..io_node_args(right),
    ),

    edge(<input>, <linear>),
    edge(<linear>, <split>),
    edge(<split>, <quat_imag>),
    edge(<split>, <trans>),
    edge(<quat_imag>, <quat_construct>),
    edge(<quat_construct>, <normalize>),
    edge(<normalize>, <quat_to_rot>),
    edge(<quat_to_rot>, <rot>),
    edge(<rot>, <combine>),
    edge(<trans>, <combine>, corner: right),
    edge(<combine>, <output>),
  )
]<backbone_update>

四元数变换的处理流程如 @fig:backbone_update 所示。具体步骤如下：

+ 通过线性层将结点特征 $bold(s) in RR^(c_s)$ 映射为6维参数向量
+ 将参数向量分解为四元数虚部 $bold(q)_"imag" in RR^3$ 和平移向量 $bold(t) in RR^3$
+ 构造完整四元数：$bold(q) = [1, bold(q)_"imag"]$
+ 归一化四元数：$bold(q) arrow.l bold(q) / sqrt(1 + ||bold(q)_"imag"||^2)$
+ 将四元数转换为旋转矩阵 $bold(R) in RR^(3 times 3)$
+ 组合旋转和平移得到刚体变换 $bold(T) = (bold(R), bold(t))$

在三维旋转的学习与回归任务中，单位四元数是一种常用且稳定的表示方式。然而，直接回归完整的四元数存在表示冗余、符号二义性以及单位范数约束等问题。为此，本文采用一种固定实部的四元数参数化方法来表示旋转。本文的网络仅预测一个三维向量 $bold(u) in RR^3$，并据此构造四元数：

$ tilde(bold(q)) = (1, bold(u)) $

随后通过归一化得到单位四元数：

$ bold(q) = (tilde(bold(q)))/(||tilde(bold(q))||) = ((1, bold(u)))/(sqrt(1 + ||bold(u)||^2)) $

该四元数用于表示三维旋转，并进一步转换为旋转矩阵参与后续计算。设归一化后的四元数为 $bold(q) = a + bold(b)$，其中 $a > 0$，则其对应的轴–角表示满足：

$ a = cos(theta/2), quad bold(b) = bold(n) sin(theta/2) $

其中 $bold(n)$ 为单位旋转轴，$theta$ 为旋转角。由此可得：

$ bold(u) = (bold(b))/a = bold(n) tan(theta/2) $

因此，该参数化等价于一种隐式的轴–角重参数化，其中旋转轴由 $bold(u)$ 的方向决定，旋转角由其模长通过非线性映射确定。其具有如下优势：

+ 消除四元数符号二义性：标准单位四元数表示中，$bold(q)$ 与 $-bold(q)$ 对应相同的空间旋转，导致表示存在二义性。通过固定实部为正，该方法在每一对 $+- bold(q)$ 中选取唯一代表，从而在大多数旋转情形下建立了旋转与参数之间的一一对应关系，有利于稳定的学习与优化。

+ 最小化参数维度并避免显式约束：该方法仅需回归三个自由参数，与三维旋转的本征自由度一致。同时，单位范数约束通过归一化操作隐式满足，无需在损失函数中引入额外正则项或约束条件，从而简化了优化过程。

+ 数值稳定性与计算效率：相比直接回归四元数并强制单位约束，固定实部参数化避免了约束优化带来的数值问题。归一化操作 $bold(q) arrow.l bold(q) / sqrt(1 + ||bold(u)||^2)$ 在 $bold(u)$ 的取值范围内具有良好的数值稳定性，且计算开销较小。此外，四元数表示旋转比欧拉角更稳定，避免了万向节锁问题，四元数的插值和组合操作在数值上更加稳定。

+ 与神经网络架构的兼容性：通过预设实部为1，网络仅需预测三维向量，可以直接使用标准的全连接层或线性层输出，无需特殊的激活函数或约束层。归一化过程作为后处理步骤。


== 训练

本文采用去噪扩散概率模型（Denoising Diffusion Probabilistic Model, DDPM）作为扩散生成方法，其训练目标为最小化预测噪声与真实噪声之间的均方误差（Mean Squared Error, MSE）。DDPM训练算法的核心思想是训练一个去噪网络 $epsilon_theta(bold(x)_t, t)$，使其能够预测在前向扩散过程中添加到原始数据 $bold(x)_0$ 上的高斯噪声 $bold(epsilon) tilde cal(N)(bold(0), bold(I))$。训练过程采用随机时间步采样策略，即在每次迭代中从均匀分布 $t tilde "Uniform"({1, 2, ..., T})$ 中随机采样一个时间步 $t$，从而使模型能够学习到不同噪声水平下的去噪能力。


#figure(
  kind: "algorithm",
  caption: [DDPM训练算法],

  pseudocode-list(booktabs: true, numbered-title: [DDPM训练算法])[
    + *input*：训练数据集 $cal(D)$，去噪网络 $epsilon_theta$，时间步数 $T$，噪声调度 ${beta_t}_(t=1)^T$
    + *repeat* until 收敛:
      + 从数据集中随机采样一个批次 $bold(x)_0 tilde cal(D)$
      + 随机采样时间步 $t tilde "Uniform"({1, 2, ..., T})$
      + 从标准正态分布采样噪声 $bold(epsilon) tilde cal(N)(bold(0), I)$
      + 计算噪声系数：
        + $overline(alpha)_t = product_(s=1)^t (1 - beta_s)$
        + $a_t = sqrt(overline(alpha)_t)$
        + $b_t = sqrt(1 - overline(alpha)_t)$
      + 根据前向扩散过程计算加噪数据：
        + $bold(x)_t = a_t bold(x)_0 + b_t bold(epsilon)$
      + 使用去噪网络预测噪声：
        + $hat(bold(epsilon)) = epsilon_theta (bold(x)_t, t)$
      + 计算均方误差损失：
        + $cal(L) = bar.v.double bold(epsilon) - hat(bold(epsilon)) bar.v.double^2_2$
      + 反向传播并更新网络参数 $theta$
    + *end repeat*
    + *return* 训练好的去噪网络 $epsilon_theta$
  ],
) <ddpm_training_algorithm>

噪声调度 ${beta_t}_(t=1)^T$ 控制了前向扩散过程中每一步添加噪声的强度。通过累积这些噪声调度参数，可以得到 $overline(alpha)_t = product_(s=1)^t (1 - beta_s)$，它表示从原始数据到时间步 $t$ 的总体信号保留比例。基于此，系数 $a_t = sqrt(overline(alpha)_t)$ 和 $b_t = sqrt(1 - overline(alpha)_t)$ 分别控制原始数据和噪声在加噪数据中的权重，满足 $a_t^2 + b_t^2 = 1$，保证了方差守恒。

前向扩散过程 $bold(x)_t = a_t bold(x)_0 + b_t bold(epsilon)$ 是一个重参数化技巧，它允许我们直接从原始数据 $bold(x)_0$ 一步到达任意时间步 $t$ 的加噪状态，而无需逐步迭代。这大大提高了训练效率。训练目标是最小化真实噪声 $bold(epsilon)$ 与预测噪声 $hat(bold(epsilon))$ 之间的均方误差，这等价于最大化变分下界（ELBO），从而使模型学习到数据分布的逆向去噪过程。


=== 采样/推理

在采样阶段，批次大小设置为1，因此无需考虑填充掩码（padding mask）。这是因为：首先，填充掩码全为1，表明不存在填充区域；其次，口袋掩码（pocket mask）中值为1的区域对应蛋白质的非口袋区域，这些区域必然不是填充区域。

本文采用文献 @lugmayr2022repaint 提出的Repaint算法进行采样（inpainting）。给定原始蛋白质结构 $bold(x)_0 in RR^(N times 3)$ 和口袋掩码 $bold(m) in {0, 1}^N$，其中 $N$ 为原子数量，掩码中值为1的位置表示非口袋区域（需保持不变），值为0的位置表示口袋区域（需进行修复）。算法流程如下：

首先，通过逐元素相乘 $bold(x)_0^' := bold(x)_0 dot.o bold(m)$ 提取非口袋区域的坐标，其中 $dot.o$ 表示逐元素相乘（Hadamard积）。然后，对 $bold(x)_0^'$ 执行前向扩散过程，得到各时间步的加噪状态 ${bold(x)_t^'}_(t in [0,T])$。在逆向去噪过程中，以 $bold(x)_T^'$ 作为初始噪声，使用训练好的去噪模型 $epsilon_theta$ 逐步去噪。在去噪的每一步，得到预测的去噪结果 $hat(bold(x))_t^'$ 后，需要将非口袋区域的坐标恢复为原始值，以保持这些区域的固定性。具体而言，通过掩码混合操作更新预测结果：

$ hat(bold(x))_t^' := hat(bold(x))_t^' dot.o (bold(1) - bold(m)) + bold(x)_t^' dot.o bold(m) $

其中 $bold(1)$ 表示全1向量。该操作确保非口袋区域的坐标始终保持为前向扩散过程中的对应值，而仅对口袋区域进行去噪修复。完整的算法流程如@repaint_algorithm 所示。

#figure(
  kind: "algorithm",
  caption: [蛋白质口袋repainting 算法],

  pseudocode-list(booktabs: true, numbered-title: [蛋白质口袋repainting 算法])[
    + *input*：原始蛋白质结构 $bold(x)_0 in RR^(N times 3)$，口袋掩码 $bold(m) in {0, 1}^N$，去噪模型 $epsilon_theta$，总时间步数 $T$，repainting 次数 $u$
    + *output*：修复后的蛋白质结构 $hat(bold(x))_0^'$
    + // 提取非口袋区域坐标
    + $bold(x)_0^' arrow.l bold(x)_0 dot.o bold(m)$
    + // 执行前向扩散至最大时间步
    + $hat(bold(x))_T^' arrow.l "ForwardDiffusion"(bold(x)_0^', T)$
    + // 逆向去噪过程
    + *for* $t in [T, T-1, ..., 1]$:
      + // Repainting 循环
      + *for* $i in [1, 2, ..., u]$:
        + // 计算前向扩散状态（用于掩码恢复）
        + $bold(x)_(t-1)^' arrow.l "ForwardDiffusion"(bold(x)_0^', t-1)$
        + // 执行一步逆向去噪
        + $hat(bold(x))_(t-1)^' arrow.l "InverseDiffusion"(hat(bold(x))_t^', t)$
        + // 掩码混合：恢复非口袋区域坐标
        + $hat(bold(x))_(t-1)^' arrow.l hat(bold(x))_(t-1)^' dot.o (bold(1) - bold(m)) + bold(x)_(t-1)^' dot.o bold(m)$
        + // 若非最后一次repainting且未到最终时间步，则重新加噪
        + *if* $i < u$ *and* $t > 1$:
          + $hat(bold(x))_t^' arrow.l "ForwardDiffusion"(hat(bold(x))_(t-1)^', t)$
    + *return* $hat(bold(x))_0^'$
  ],
) <repaint_algorithm>


== 实验

=== 数据

本文采用 CrossDocked 数据集 @francoeur2020three 进行实验，该数据集包含蛋白质-配体复合物的三维结构数据。经过预处理筛选与长度过滤后，构建了一个最大长度为300个残基的蛋白质-配体对数据集。数据集划分如下：训练集包含40,000个样本，验证集和测试集各包含150个样本。

口袋（pocket）被定义为与配体原子距离小于给定阈值的蛋白质残基集合。具体而言，对于每个残基，计算其 $C alpha$ 原子到所有配体原子的最短距离，若该距离小于阈值，则该残基被标记为口袋残基。本文设置距离阈值为 $4.0 angstrom$。

设 $b in NN^+$ 为批次大小（batch size），$n in NN^+$ 为蛋白质残基数量，$m in NN^+$ 为配体原子数量。经过预处理后的数据格式如 @tbl:data_format 所示。

#figure(
  kind: table,
  caption: [处理后的数据格式],
)[
  #grid(
    columns: (1.7fr, 0.8fr, 1.2fr, 3.8fr),
    inset: 0.8em,
    align: (left, center, center, left),
    grid.hline(),
    [*字段名称*], [*数据类型*], [*张量形状*], [*说明*],
    grid.hline(),

    [`bb_coords`], [Tensor], [$(3, b, n, 3)$], [骨架原子坐标，包含 $N$、$C alpha$、$C$ 三种原子类型],
    [`ca_coords`], [Tensor], [$(b, n, 3)$], [$C alpha$ 原子坐标，用于表示残基位置],
    [`padding_mask`], [Tensor], [$(b, n)$], [填充掩码，$1$ 表示有效残基，$0$ 表示填充区域],
    [`lig_coords`], [Tensor], [$(b, m, 3)$], [配体原子坐标],
    [`lig_mask`], [Tensor], [$(b, m)$], [配体掩码，$1$ 表示有效原子，$0$ 表示填充区域],
    [`pocket_mask`], [Tensor], [$(b, n)$], [口袋掩码，$0$ 表示口袋残基（需修复），$1$ 表示非口袋残基（保持不变）],
    grid.hline(),
  )
]<data_format>


本文的训练集和测试集的蛋白质长度分布如 @fig:protein_length_distribution_train 所示，大部分蛋白质的长度集中在100到300之间。

#grid(columns: 2)[
  #figure(caption: [训练集蛋白质长度分布])[
    #image("images/data_len_train.png")
  ]<protein_length_distribution_train>
][
  #figure(caption: [测试集蛋白质长度分布])[
    #image("images/data_len_test.png")
  ]<protein_length_distribution_test>
]

在扩散模型的逆向去噪过程中，需要对口袋残基进行初始化以提供合理的起始状态。本文采用基于序列距离的初始化策略：对于每个口袋残基（掩码值为 $0$），在序列上找到距离最近的非口袋残基（掩码值为 $1$），并将该非口袋残基的 $C alpha$ 原子坐标作为口袋残基的初始位置。该策略假设序列上相邻的残基在空间上通常也较为接近，从而为口袋残基提供合理的初始坐标估计。

具体算法如 @pocket_initialization_algorithm 所示。初始化后的结果如 @pocket_initialization_figure 所示，其中红色点表示口袋残基的初始位置（与非口袋残基的蓝色点重合），模型生成后的口袋结构如 @pocket_generated_figure 所示。

#figure(
  kind: "algorithm",
  caption: [口袋初始化算法],

  pseudocode-list(booktabs: true, numbered-title: [口袋初始化算法])[
    + *input*：蛋白质残基坐标 $bold(x) in RR^(n times 3)$，口袋掩码 $bold(m) in {0, 1}^n$，其中 $n$ 为残基数量
    + *output*：初始化后的残基坐标 $bold(x)^' in RR^(n times 3)$
    + // 初始化输出坐标
    + $bold(x)^' arrow.l bold(x)$
    + // 遍历所有残基
    + *for* $i in [1, 2, ..., n]$:
      + // 若当前残基为口袋残基（掩码值为0）
      + *if* $m_i == 0$:
        + // 在序列上找到距离最近的非口袋残基索引
        + $j arrow.l "argmin"_(j in {k in [1, n]: m_k == 1}) |i - j|$
        + // 将非口袋残基的坐标赋给口袋残基
        + $bold(x)^'_i arrow.l bold(x)_j$
    + *return* $bold(x)^'$
  ],
) <pocket_initialization_algorithm>

#grid(columns: (1fr, 1fr), align: bottom)[
  #figure(
    caption: [口袋初始化示意图],
  )[
    #image("images/x_init_post.png", height: 180pt)
  ]<pocket_initialization_figure>
][
  #figure(
    caption: [模型生成的口袋],
  )[
    #image("images/x_gen.png", height: 180pt)
  ]<pocket_generated_figure>
]

=== 训练配置

本文的训练配置参数如 @training_config_table 所示，优化器参数如 @optimizer_config_table 所示。

#figure(
  caption: [训练配置参数],
  kind: table,
  grid(
    columns: (2.5fr, 1.5fr, 2.5fr),
    align: (left, center, left),
    inset: 0.3em,
    grid.hline(),
    [*参数名称*], [*值*], [*说明*],
    grid.hline(),
    [随机种子 (seed)], [31], [确保实验可重复性],
    [训练策略 (train_strategy)], [epochs], [按轮次训练，可选steps或epochs],
    [训练轮数 (n_epochs)], [10], [总训练轮数],
    [总训练步数 (n_steps)], [40388], [等价于15轮的总步数],
    [数据加载线程 (num_workers)], [1], [并行加载数据的工作线程数],
    [数据打乱 (train_shuffle)], [true], [每轮训练前打乱数据顺序],
    [预热步数 (n_warmup_steps)], [500], [学习率线性预热的步数],
    [学习率调度器 (lr_scheduler)], [cosine_with_warmup], [余弦退火调度器],
    [单设备批次大小 (batch_size)], [1], [每个GPU的批次大小],
    [梯度裁剪策略 (grad_clip)], [norm], [按范数裁剪梯度],
    [最大梯度范数 (max_grad_norm)], [1.0], [梯度范数上限],
    [梯度累积步数 (grad_accum)], [8], [累积8步后更新参数],
    [实际批次大小 (real_batch_size)], [4], [等效批次大小为1×8=8],
    [训练目标 (train_for)], [o_ca_pl], [训练口袋$C alpha$坐标和配体],
    [混合精度 (mixed_precision)], [fp16], [使用半精度浮点数加速训练],
    grid.hline(),
  ),
) <training_config_table>

#figure(
  caption: [AdamW优化器参数],
  kind: table,
  grid(
    columns: (1.5fr, 1fr, 2.5fr),
    inset: 0.3em,
    align: (left, center, left),
    grid.hline(),
    [*参数名称*], [*值*], [*说明*],
    grid.hline(),
    [优化器类型 (name)], [AdamW], [带权重衰减的Adam优化器],
    [学习率 (lr)], [$1 times 10^(-4)$], [初始学习率],
    [动量系数 (betas)], [[0.9, 0.999]], [一阶和二阶矩估计的指数衰减率],
    [数值稳定项 (eps)], [$1 times 10^(-8)$], [防止除零的小常数],
    [权重衰减 (weight_decay)], [0.01], [L2正则化系数],
    [AMSGrad变体 (amsgrad)], [false], [不使用AMSGrad变体],
    [最大化目标 (maximize)], [false], [最小化损失函数],
    [可微分 (differentiable)], [false], [优化器本身不可微],
    grid.hline(),
  ),
) <optimizer_config_table>

训练配置采用了梯度累积技术，通过设置 `gradient_accumulation_steps=8` 和 `batch_size=1`，实现了等效批次大小为8的训练效果。这种策略在显存受限的情况下特别有用，能够在保持较大有效批次的同时避免显存溢出。学习率调度采用了带预热的余弦退火策略，前500步线性增加学习率，随后按余弦曲线逐渐衰减，这有助于训练初期的稳定性和后期的收敛精度。

混合精度训练（FP16）通过使用半精度浮点数进行前向和反向传播，显著降低了显存占用并加速了计算，同时通过损失缩放（loss scaling）技术保持了数值稳定性。梯度裁剪策略限制梯度范数不超过1.0，有效防止了梯度爆炸问题，这在处理复杂的蛋白质结构数据时尤为重要。

优化器选择AdamW而非标准Adam的原因在于其改进的权重衰减实现方式。AdamW将权重衰减与梯度更新解耦，直接在参数更新时应用L2正则化，而不是将其添加到梯度中。这种方式在使用自适应学习率时更加有效，能够更好地控制模型复杂度，防止过拟合。动量系数 $beta_1=0.9$ 和 $beta_2=0.999$ 分别控制梯度的一阶矩（均值）和二阶矩（方差）的指数移动平均，这些标准值在大多数深度学习任务中都表现良好。

训练与评估损失曲线如 @fig:train_loss_curve 和 @fig:eval_loss_curve 所示。

#grid(columns: 2, align: bottom)[
  #figure(
    caption: [训练损失曲线],
    image("images/train_loss_diff.png"),
  ) <train_loss_curve>
][
  #figure(
    caption: [评估损失曲线],
    image("images/eval_loss_diff.png"),
  ) <eval_loss_curve>
]

训练损失曲线（@fig:train_loss_curve）展示了模型训练过程中损失随训练步数的变化情况。训练过程可以划分为三个主要阶段。初始阶段（$0$ 到约 $5000$ 步）中，损失曲线呈现非常陡峭的下降趋势，损失值从接近 $3.0$ 迅速下降到 $1.0$ 左右，表明模型在训练初期学习速度非常快，能够有效地捕捉数据中的主要模式。中期阶段（约 $5000$ 到约 $20000$ 步）中，损失继续下降，但下降速度明显放缓，从 $1.0$ 左右逐渐下降到 $0.5$ 附近，这通常标志着模型进入了精细调整（fine-tuning）阶段，开始学习更细微的特征。后期阶段（约 $20000$ 到约 $40000$ 步）中，损失曲线在较低范围内（$0.5$ 到 $0.2$ 之间）波动，整体趋势仍呈缓慢下降，表明模型正在持续学习，但改进幅度逐渐减小，接近收敛状态。

整个训练曲线呈现出较高的波动性，存在许多尖锐的峰值。这种高波动性在深度学习模型，尤其是扩散模型的训练中是常见的现象，可能由以下因素引起：（1）批量大小：较小的批量大小会导致每个训练步骤的梯度估计噪声较大，从而产生损失波动。本文采用的批量大小为 $1$（有效批量大小为 $8$），相对较小，这可能是波动性的主要原因之一；（2）学习率：较高的学习率可以加速收敛，但也会增加波动性。本文采用的学习率调度策略为带预热的余弦退火，初始学习率为 $1 times 10^(-4)$；（3）模型结构与损失函数：扩散模型的训练目标（预测噪声）本身就可能导致损失在不同的训练样本上差异较大，这是扩散模型训练的内在特性；（4）周期性变化：某些峰值可能与训练数据的特定批次或学习率调度策略的周期性变化有关。

图中的局部放大图清晰地展示了 $0$ 到 $4000$ 步的损失变化情况，进一步强调了初始阶段的急剧下降趋势。放大图展示了在损失值约为 $1.0$ 之后曲线的波动细节，其 Y 轴范围与主图相似（$0$ 到 $3$），主要作用是更清晰地展示训练前期的波动特征。

尽管存在波动，但损失的平均值（moving average）在整个训练过程中持续下降，并在训练结束时达到了相对较低的水平（约 $0.2$ 到 $0.3$）。这表明模型成功地实现了收敛，训练过程是有效的。如果目标是获得更平滑的收敛曲线，可以考虑以下优化策略：在训练后期减小学习率，以降低波动性；增大批量大小（如果计算资源允许），以减少梯度估计的方差；使用更复杂的学习率调度策略，如自适应学习率调整。

评估损失曲线（@fig:eval_loss_curve）展示了模型在验证集上的性能表现。与训练损失曲线类似，评估损失在训练开始的前几千步迅速从接近 $3.0$ 下降到 $1.0$ 以下，随后继续平稳下降，在大约 $10000$ 步时达到 $0.5$ 左右。在 $20000$ 步之后，损失曲线变得非常平坦，维持在 $0.3$ 到 $0.4$ 的区间，最终稳定在约 $0.3$ 的水平。

相比于训练损失曲线，评估损失曲线的波动性要低得多，更为平滑。这是因为评估损失通常是在整个验证集或较大批次的验证集上计算的，其平均效果更稳定。评估损失曲线显示损失持续下降并最终稳定在较低水平，没有明显的上升趋势，表明模型没有明显的过拟合现象。评估损失在训练后期保持平坦或略微下降，说明模型在新数据上的表现与在训练数据上的表现保持一致，具有良好的泛化能力。图中的局部放大图清晰地展示了早期快速下降和随后的平滑过程，进一步印证了模型收敛的稳定性。

=== 口袋评估指标

==== Vina Score

Vina Score 是由 AutoDock Vina @trott2010autodock 提供的一种广泛使用的蛋白质-配体结合亲和力评估指标。它通过计算配体与受体蛋白之间的相互作用能量来预测结合强度，分数越低表示结合亲和力越强。Vina Score 在虚拟筛选、药物设计和蛋白质工程等领域被广泛应用，是评估生成口袋质量的重要标准之一。AutoDock Vina 在计算结合能量时对分子系统做出以下假设：

- *不变属性：*
  - 分子的质子化状态和电荷分布保持固定
  - 受体蛋白的骨架结构保持刚性，共价键长度和键角不变

- *可变属性：*
  - 配体分子内部的可旋转共价键允许旋转
  - 配体的整体构象可以进行刚体旋转和平移

基于这些假设，系统的总能量 $c$ 可以表示为原子对之间相互作用的总和：

$
  c = sum_(i<j) f_(t_i comma t_j) (r_(i j))
$

其中 $f_(t_i comma t_j)$ 是原子类型 $t_i$ 和 $t_j$ 之间的相互作用函数，$r_(i j)$ 是原子 $i$ 和 $j$ 之间的距离。总能量可以分解为分子间相互作用能和配体分子内能两部分：

$
  c = c_"inter" + c_"intra"
$

其中 $c_"inter"$ 表示配体与受体之间的相互作用能，$c_"intra"$ 表示配体分子内部的应变能。

AutoDock Vina 采用全局搜索与局部优化相结合的策略来探索配体的结合构象空间。首先通过全局扰动生成多个候选构象，然后对每个构象进行局部能量最小化，得到一系列优化后的结合构象。将这些构象按总能量从低到高排序，记为 $(c_i)_(i=1)^n$。为了消除不同构象下配体分子内应变能的影响，Vina Score 的计算方式如下：

1. 找到总能量最小的构象（$i=1$），记录其配体分子内能量 $c_"intra1"$
2. 对每个构象 $i$，计算相对结合亲和力：

$
  s_i = c_i - c_"intra1"
$

3. 最终的 Vina Score 定义为所有构象中的最小相对能量：

$
  "Vina Score" = min_(i=1,...,n) s_i
$

这种计算方式的优势在于，通过减去参考构象的分子内能量，可以更公平地比较不同构象的结合强度，避免了配体内部应变能对评分的干扰。在本文的实验中，我们使用 Vina Score 来评估生成的蛋白质口袋与给定配体的结合质量，分数越低表示生成的口袋越能有效容纳配体并形成稳定的复合物结构。


==== sc-RMSD 与 sc-TM

从序列到结构的过程称为蛋白质折叠（Protein Folding），指的是线性氨基酸链自发形成稳定的三维结构，从而得到功能性蛋白质。这一过程具有自发性，在可逆折叠条件下蛋白质还可以恢复原有结构。而从结构到序列的过程称为反向折叠（Inverse Folding），指的是根据已知蛋白质三维结构预测可能的氨基酸序列，从而设计或识别能够折叠成该结构的序列。需要注意的是，反向折叠是一种计算或设计上的推断，并非物理上直接的"逆折叠"过程。

在评估生成结构的质量时，本文采用以下流程：首先对模型生成的蛋白质结构进行逆折叠，得到对应的氨基酸序列；然后使用结构预测工具（如 AlphaFold 或 ESMFold）根据该序列重新预测三维结构。本文将这一"逆折叠-再折叠"的完整过程称为*伪逆向折叠*（Pseudo Inverse Folding）。

sc-RMSD 与 sc-TM 中的"sc"表示"self consistent"（自一致性）。自一致性指标通过度量模型所预测的蛋白质结构与伪逆向折叠后得到的结构之间的相似度，来评估生成结构的序列-结构一致性。该指标的核心思想在于：一个高质量的口袋设计应该满足序列-结构映射的自洽性，即从结构预测的序列能够通过结构预测工具重新折叠回相似的结构。如果生成的结构与重新预测的结构差异较大，则说明该结构可能不符合蛋白质的折叠规律。其核心理念的示意图如 @fig:self-consistent-diagram 所示。

#figure(
  caption: [自一致性示意图],
  fletcher.diagram(
    edge-stroke: 1pt,
    spacing: (3.5em, 3em),
    let sedge = edge.with(marks: "-|>"),
    node((0, 0), [模型], name: "model"),
    node((1, 0), [结构1], name: "structure1"),
    node((2, 0), [序列], name: "sequence"),
    node((6, 0), [结构2], name: "structure2"),
    sedge(<model>, <structure1>, [预测]),
    sedge(<structure1>, <sequence>),
    sedge(<sequence>, <structure2>, [AlphaFold or ESMFold]),
    edge(<structure1>, <structure2>, "<=>", [相似度/自一致性], "dashed", bend: -30deg),
  ),
)<self-consistent-diagram>


RMSD（Root Mean Square Deviation，均方根偏差）是衡量两个蛋白质结构之间差异的经典指标，其计算公式为：
$
  "RMSD"(X,X^"true") = sqrt(1 / N_"res" sum_(i=1)^(N_"res") ||X_i - X^"true"_i||^2)
$
其中$X_i$和$X^"true"_i$分别表示第$i$个残基在预测结构和参考结构中的坐标，$N_"res"$为残基总数。RMSD值越小，表示两个结构越相似。

TM-score（Template Modeling Score）是另一个广泛使用的结构相似性指标，它对局部结构差异的敏感性较低，更适合评估整体结构的相似性。其计算公式为：
$
  "TM"(X,X^"true") = max_(T_"align" in "SE"(3)) 1 / N_"res" sum_(i=1)^(N_"res") f(||X_i - T_"align" X^"true"_i||^2)
$
其中$T_"align" in "SE"(3)$表示在三维欧几里得群中寻找最优刚体变换，$f(x) = 1 / (1 + (x/y)^2)$为权重函数，$y$为归一化常数。TM-score的取值范围为$[0, 1]$，值越大表示结构相似性越高。

sc-RMSD与sc-TM的计算方法如下：将标准RMSD和TM-score公式中的$X$替换为模型所预测的蛋白质结构，将$X^"true"$替换为AlphaFold或ESMFold根据伪逆向折叠得到的序列所预测的蛋白质结构。通过比较这两个结构，可以量化生成结构的自一致性。

==== UniGSSA

Uni‑GBSA 是一个自动化工作流程工具，用于快速计算蛋白–配体复合物的结合自由能（Binding Free Energy, BFE）。该工具基于经典的分子力学/广义 Born 或 Poisson-Boltzmann 表面积方法（MM/GB(PB)SA），通过对大规模配体集进行快速能量排序和结合强度估算，极大地提升了药物虚拟筛选（Virtual Screening）的效率。Uni‑GBSA 自动完成从拓扑准备、结构优化到能量计算的全过程，支持批量处理多个配体，非常适合药物虚拟筛选和配体能量排序。

MM/GB(PB)SA 是一种计算结合自由能的终态（end-point）方法。它通过评估结合反应前后体系的自由能变化来估算结合自由能，即计算复合物（PL）、单独的蛋白（P）和单独的配体（L）之间的自由能差：
$
  Delta G_"bind" = G_("PL") - (G_P + G_L)
$
其中，单个组分的自由能 $G_X$ 被分解为三个主要项：分子力学能项 $E_"MM"$、溶剂化自由能项 $G_"solvation"$ 和构象熵项 $-T Delta S$：
$
  G_X = E_"MM" + G_"solvation" - T Delta S
$
因此，结合自由能 $Delta G_"bind"$ 可以表示为各能量项的差值之和：
$
  Delta G_"bind" = Delta E_"MM" + Delta G_"solvation" - T Delta S
$

==== PLDDT

pLDDT（predicted Local Distance Difference Test，预测局部距离差异测试）是一种局部置信度评分指标，由 AlphaFold 和 ESMFold 等先进的蛋白质结构预测工具输出，旨在量化预测结构中每个残基的局部准确性。pLDDT 值范围为 0 到 100（或归一化到 0 到 1），本质上是对实验结构验证指标 LDDT-C$alpha$（Local Distance Difference Test on C$alpha$ atoms）的预测，分数越高代表模型对该区域结构预测的可信度越高。

根据评分范围，pLDDT 值可以划分为不同的置信度等级：pLDDT > 90 的区域被认为是极高置信度，其预测精度可媲美高分辨率实验结构；pLDDT 在 70 到 90 之间的区域表明主链预测高度准确，但侧链细节可能存在误差；而 pLDDT < 50 的区域则表明该局部结构不可信，常用于识别天然状态下的内在无序区域（Intrinsically Disordered Regions, IDRs）或高度柔性的接头区域。

因此，pLDDT 不仅是评估结构预测质量的关键参考指标，也是指导后续功能分析的重要工具。它帮助研究人员迅速识别稳定、可信的结构域和柔性、不确定的区域，从而有效地规划对接研究、突变实验和结构功能分析等后续研究工作。


==== AAR

氨基酸恢复率（Amino Acid Recovery, AAR）是评估蛋白质序列设计质量的重要指标，用于衡量设计序列与参考序列之间的匹配程度。在蛋白质口袋设计任务中，AAR 反映了模型生成的氨基酸序列与原始口袋序列的相似性，是评估设计方法性能的关键指标之一。

AAR 的计算公式为：
$
  "AAR" = (N_"correct") / (N_"total") times 100%
$
其中 $N_"correct"$ 表示设计序列中与参考序列在相同位置匹配的氨基酸残基数量，$N_"total"$ 表示口袋区域的总残基数量。AAR 的取值范围为 $[0, 100%]$，值越高表示设计序列与参考序列的匹配程度越高。

在蛋白质口袋设计任务中，AAR 的计算通常针对口袋区域的残基进行。具体而言，对于每个口袋残基位置，如果设计序列中该位置的氨基酸类型与参考序列中对应位置的氨基酸类型相同，则认为该位置恢复成功。将所有成功恢复的位置数量除以口袋区域的总残基数，即可得到 AAR 值。

=== 评估结果与分析


#figure(
  image("images/vina_score_hist_diff.png", height: 180pt),
  caption: [亲和力直方图],
)<vina_score_figure>

口袋亲和力指标的测评结果如 @tbl:affinity_result 所示。

#let headers = ([模型], [Vina Score], [Uni‑GBSA])
#let data = (
  ("DEPACT", (-6.632, 0.18), (-32.534, 0.680)),
  ("dyMEAN", (-6.855, 0.06), (-33.118, 0.269)),
  ("FAIR", (-7.015, 0.12), (-33.670, 0.440)),
  ("RFDiffusion", (-6.936, 0.07), (-45.726, 0.830)),
  ("PocketGen", (-7.135, 0.08), (-54.800, 0.406)),
  ("DiffPocket", (-7.599, 0.15), (-55.585, 0.421)),
)

#let rules = (
  "1": "min",
  "2": "min",
)

#figure(
  caption: [亲和力指标测评结果],
  kind: table,
  highlight-table(
    headers: headers,
    data: data,
    rules: rules,
    cols: (1.5fr, 1fr, 1fr),
  ),
) <affinity_result>

从 @tbl:affinity_result 可以看出，在亲和力指标方面，DiffPocket 和 PocketGen 两个模型表现最为优异。在 Vina Score 指标上，DiffPocket 取得了最低值 $-7.599$，显著优于其他模型，PocketGen 以 $-7.135$ 紧随其后。在 Uni-GBSA 指标上，同样呈现出类似的趋势：DiffPocket 和 PocketGen 分别取得了 $-55.585$ 和 $-54.800$ 的优异表现，明显优于其他模型。值得注意的是，RFDiffusion 在 Uni-GBSA 指标上表现相对较好（$-45.726$），但在 Vina Score 上表现一般（$-6.936$），显示出两个指标之间存在一定的差异。相比之下，DEPACT、dyMEAN 和 FAIR 三个模型在亲和力指标上的表现相对较弱，其中 DEPACT 在两个指标上均为最差。总体而言，基于扩散模型的生成方法（DiffPocket 和 PocketGen）在亲和力预测方面展现出明显优势，这可能与其能够更好地建模配体-蛋白质相互作用的复杂分布有关。

sc-RMSD与sc-TM的测评结果如 @tbl:sc-result 所示。

#let headers = ([模型], [sc-RMSD], [sc-$Delta$TM])
#let data = (
  ("DEPACT", (0.64, 0.024), (-0.025, 0.002)),
  ("dyMEAN", (0.622, 0.017), (-0.014, 0.001)),
  ("FAIR", (0.620, 0.025), (-0.026, 0.002)),
  ("RFDiffusion", (0.581, 0.018), (0.014, 0.003)),
  ("PocketGen", (0.572, 0.016), (0.022, 0.001)),
  ("DiffPocket", (0.585, 0.021), (0.23, 0.002)),
)

#let rules = (
  "1": "min",
  "2": "max",
)

#figure(
  caption: [结构自一致性指标测评结果],
  kind: table,
  highlight-table(
    headers: headers,
    data: data,
    rules: rules,
    cols: (1.5fr, 1fr, 1fr),
  ),
) <sc-result>

@tbl:sc-result 展示了各模型在结构自一致性指标上的表现。PocketGen 在 sc-RMSD 上取得最低值 $0.572$，DiffPocket 和 RFDiffusion 分别为 $0.585$ 和 $0.581$，三者差距不大。在 sc-ΔTM 指标上，DiffPocket 的 $0.23$ 明显高于其他模型，PocketGen 和 RFDiffusion 分别为 $0.022$ 和 $0.014$，而 DEPACT、dyMEAN 和 FAIR 均为负值，表明这些模型生成的结构在伪逆向折叠后与原始结构的相似度下降。结合两个指标来看，PocketGen 和 DiffPocket 在结构自一致性方面表现较好，能够生成更符合蛋白质折叠规律的口袋结构。

pLDDT的测评结果如 @tbl:res_result 所示。

#let headers = ([模型], [pLDDT], [AAR])
#let data = (
  ("DEPACT", (81.520, 0.317), (31.52, "3.26%")),
  ("dyMEAN", (82.467, 0.255), (38.71, "2.16%")),
  ("FAIR", (83.271, 0.228), (40.16, "1.17%")),
  ("RFDiffusion", (84.080, 0.190), (46.57, "2.07%")),
  ("PocketGen", (85.945, 0.139), (63.40, "1.64%")),
  ("DiffPocket", (86.422, 0.131), (53.75, "1.82%")),
)

#let rules = (
  "1": "max",
  "2": "max",
)

#figure(
  caption: [序列设计指标测评结果],
  kind: table,
  highlight-table(
    headers: headers,
    data: data,
    rules: rules,
    cols: (1.5fr, 1fr, 1fr),
  ),
)<res_result>


在蛋白质口袋序列设计任务中，氨基酸恢复率（Amino Acid Recovery, AAR）衡量模型生成序列与参考序列在口袋区域的一致性。从表格结果来看，DiffPocket 的 AAR 为 53.75%，相比 PocketGen 的 63.40% 略低，主要原因在于当前版本尚未引入 ESM 模块（Evolutionary Scale Modeling）。

ESM 基于大规模蛋白质序列的预训练语言模型，能够捕捉序列进化共性与氨基酸间的依赖关系，在口袋设计中带来：

+ 提高残基类型预测准确性。口袋残基类型不仅取决于局部结构，还受远程序列和整体折叠模式影响。ESM 提供全局序列上下文，使模型更精确地预测各位置的最优氨基酸。
+ 增强序列—结构耦合信息。在缺少 ESM 的情况下，DiffPocket 主要依赖口袋几何与局部结构特征，未直接利用序列进化统计特性，可能错过参考序列中保守的关键残基，因而降低 AAR。
+ 口袋内氨基酸存在协同选择与共变关系。ESM 的自注意力机制可捕捉远程依赖，而几何驱动模型往往仅能学习局部模式，难以恢复参考序列的复杂组合。

因此，DiffPocket 当前的 AAR 偏低并不意味着功能设计存在缺陷，更多反映缺少进化信息对序列恢复的支持。结合 ESM 或同类蛋白质语言模型后，氨基酸恢复率有望显著提升，更贴近参考序列的保守性特征。

#let headers = ([模型], [AAR (↑)])
#let data = (
  ("PocketGen w/o ligand update", (59.20, "1.56%")),
  ("PocketGen w/o residue-level attention", (58.19, "1.78%")),
  ("PocketGen w/o pLM", (42.70, "1.45%")),
  ("PocketGen w/ EGNN encoder", (58.85, "1.21%")),
  ("PocketGen w/ GVP encoder", (61.10, "0.90%")),
  ("PocketGen w/ GMN encoder", (60.49, "1.33%")),
)

#let rules = (
  "1": "max",
)

#figure(
  caption: [消融实验结果],
  kind: table,
  highlight-table(
    headers: headers,
    data: data,
    rules: rules,
    cols: (2fr, 1fr),
  ),
) <ablation_result>

结合 @tbl:res_result 和 @tbl:ablation_result 的结果，可以观察到 pLDDT 与 AAR 之间存在一定的相关性，但两者反映的是不同层面的设计质量。从主实验结果来看，DiffPocket 的 pLDDT 为 86.422，在所有模型中最高，表明其生成的口袋结构在局部几何准确性上表现优异；而 PocketGen 的 pLDDT 为 85.945，略低于 DiffPocket，但其 AAR 为 63.40%，显著高于 DiffPocket 的 53.75%。这一差异说明高结构置信度并不必然对应高序列恢复率，两者分别关注结构准确性和序列保守性。

从消融实验结果来看，移除不同组件对 AAR 的影响存在显著差异。移除 pLM（蛋白质语言模型）导致 AAR 从 63.40% 大幅下降至 42.70%，降幅超过 20 个百分点，这表明序列进化信息对氨基酸恢复至关重要。相比之下，移除配体更新机制或残基级注意力机制对 AAR 的影响相对较小（分别降至 59.20% 和 58.19%），降幅约 4–5 个百分点。编码器架构的替换（EGNN、GVP、GMN）对 AAR 的影响也较为有限，变化范围在 58.85% 至 61.10% 之间。

pLDDT 主要反映生成结构的局部几何准确性，受结构建模能力（如编码器架构、几何约束）影响较大；而 AAR 则更依赖于序列建模能力（如 pLM、序列上下文编码）。因此，虽然 DiffPocket 在结构置信度上表现优异，但在序列恢复方面仍有提升空间，特别是通过引入 ESM 等蛋白质语言模型来增强序列进化信息的利用。这也解释了为何 PocketGen 在 AAR 上表现更好，因为其集成了 pLM 模块，能够更好地捕捉序列保守性特征。



== 扩散的后验均值 <general_posterior_mean_proof>

=== Tweedie 公式
Tweedie 公式 @chung2022diffusion 是指数族分布的性质，用于计算后验均值。

设 $p(bold(y)|bold(eta))$ 属于指数族分布：

$
  p(bold(y)|bold(eta)) = p_0(bold(y)) exp(bold(eta)^T T(bold(y)) - phi(bold(eta)))
$

其中 $bold(eta)$ 是指数族的经典参数向量，$T(bold(y))$ 是 $bold(y)$ 的某个函数，$phi(bold(eta))$ 是累积量生成函数用于归一化密度，$p_0(bold(y))$ 是当 $bold(eta) = bold(0)$ 时的比例因子密度。那么，后验均值 $hat(bold(eta)) := EE[bold(eta)|bold(y)]$ 应满足：

$
  (nabla_y T(bold(y)))^T hat(bold(eta)) = nabla_y ln p(bold(y)) - nabla_y ln p_0(bold(y))
$

=== Tweedie 公式在线性高斯扩散中的应用

对于一般的线性高斯前向扩散过程：

$
  bold(x)_t = a_t bold(x)_0 + b_t bold(epsilon), quad bold(epsilon) tilde cal(N)(bold(0), I)
$ <linear_gaussian_forward>

其中 $a_t, b_t in RR$ 是时间 $t$ 的确定性函数，且通常满足 $a_t > 0, b_t > 0$。此时，前向转移概率密度函数为：

$
  p(bold(x)_t|bold(x)_0) = cal(N)(bold(x)_t; a_t bold(x)_0, b_t^2 I)
$

根据 Tweedie 公式，后验均值具有如下显式表达：

$
  EE[bold(x)_0|bold(x)_t] = (b_t^2)/a_t nabla_(bold(x)_t) ln p_t (bold(x)_t) + 1/a_t bold(x)_t
$ <general_posterior_mean>

*证明：*

线性高斯前向过程的转移概率密度为：

$
  p(bold(x)_t|bold(x)_0) = 1/((2pi b_t^2)^(d/2)) exp(- (||bold(x)_t - a_t bold(x)_0||^2)/(2 b_t^2))
$

展开指数项：
$
  - (||bold(x)_t - a_t bold(x)_0||^2)/(2 b_t^2) &= - (bold(x)_t^T bold(x)_t - 2 a_t bold(x)_t^T bold(x)_0 + a_t^2 bold(x)_0^T bold(x)_0)/(2 b_t^2) \
  &= - (||bold(x)_t||^2)/(2 b_t^2) + (a_t bold(x)_t^T bold(x)_0)/(b_t^2) - (a_t^2 ||bold(x)_0||^2)/(2 b_t^2)
$

因此，转移概率可写成指数族的标准形式：

$
  p(bold(x)_t|bold(x)_0) = p_0(bold(x)_t) exp(bold(x)_0^T T(bold(x)_t) - phi(bold(x)_0))
$

其中各项定义为：

$
  p_0(bold(x)_t) & := 1/((2pi b_t^2)^(d/2)) exp(- (||bold(x)_t||^2)/(2 b_t^2)) \
    T(bold(x)_t) & := (a_t)/(b_t^2) bold(x)_t \
  phi(bold(x)_0) & := (a_t^2 ||bold(x)_0||^2)/(2 b_t^2)
$

对于指数族分布，Tweedie 公式表明后验均值 $hat(bold(x))_0 := EE[bold(x)_0|bold(x)_t]$ 满足：

$
  (nabla_(bold(x)_t) T(bold(x)_t))^T hat(bold(x))_0 = nabla_(bold(x)_t) ln p_t (bold(x)_t) - nabla_(bold(x)_t) ln p_0(bold(x)_t)
$

计算充分统计量函数的梯度：
$
  nabla_(bold(x)_t) T(bold(x)_t) = nabla_(bold(x)_t) ((a_t)/(b_t^2) bold(x)_t) = (a_t)/(b_t^2) I
$

计算基础密度的对数梯度：
$
  nabla_(bold(x)_t) ln p_0(bold(x)_t) = nabla_(bold(x)_t) (- (||bold(x)_t||^2)/(2 b_t^2)) = - (bold(x)_t)/(b_t^2)
$

将梯度项代入 Tweedie 公式：

$
  (a_t)/(b_t^2) hat(bold(x))_0 = nabla_(bold(x)_t) ln p_t (bold(x)_t) - (- (bold(x)_t)/(b_t^2))
$

整理得：
$
  (a_t)/(b_t^2) hat(bold(x))_0 = nabla_(bold(x)_t) ln p_t (bold(x)_t) + (bold(x)_t)/(b_t^2)
$

两边同乘 $(b_t^2)/(a_t)$，最终得到后验均值的显式表达：

$
  hat(bold(x))_0 = (b_t^2)/a_t nabla_(bold(x)_t) ln p_t (bold(x)_t) + 1/a_t bold(x)_t
$

这完成了一般线性高斯扩散过程后验均值公式的严格推导。

=== 特殊情况与应用

公式 @eqt:general_posterior_mean 涵盖了扩散模型中的多种重要特殊情况：

*DDPM/VP-SDE 情况：*
设 $a_t = sqrt(overline(alpha)_t)$，$b_t = sqrt(1 - overline(alpha)_t)$，其中 $overline(alpha)_t = product_(s=1)^t alpha_s$。代入公式 @eqt:general_posterior_mean：

$
  EE[bold(x)_0|bold(x)_t] &= ((1 - overline(alpha)_t))/(sqrt(overline(alpha)_t)) nabla_(bold(x)_t) ln p_t (bold(x)_t) + 1/(sqrt(overline(alpha)_t)) bold(x)_t \
  &= 1/(sqrt(overline(alpha)_t)) (bold(x)_t + (1 - overline(alpha)_t) nabla_(bold(x)_t) ln p_t (bold(x)_t))
$

这正是 DDPM 中经典的后验均值公式。

*VE-SDE 情况：*
有 $a_t = 1$，$b_t = sigma_t$，其中 $sigma_t$ 是噪声标准差。此时：

$
  EE[bold(x)_0|bold(x)_t] = sigma_t^2 nabla_(bold(x)_t) ln p_t (bold(x)_t) + bold(x)_t
$

=== 理论意义与实际应用

Tweedie 公式在线性高斯扩散中的应用具有重要的理论和实践价值：

1. 统一理论框架：为不同类型的扩散模型提供了统一的数学基础
2. 条件生成：在 Loss-Guidance 等方法中，通过 $EE[bold(x)_0|bold(x)_t]$ 估计无噪声数据
3. 采样算法许多确定性采样器（如 DDIM）都依赖于后验均值的准确估计
4. 模型分析：有助于理解不同扩散过程的内在联系和差异

该公式建立了分数函数 $nabla_(bold(x)_t) ln p_t (bold(x)_t)$ 与后验均值 $EE[bold(x)_0|bold(x)_t]$ 之间的直接联系，为扩散模型的理论分析和实际应用提供了坚实的数学基础。


= 基于流匹配的蛋白质口袋设计(FlowPocket)

流匹配相比于扩散有如下几个优点：（1）更快的采样速度与更高的效率；（2）训练更加稳定与简单：流匹配的损失函数通常是简单的均方误差（MSE），直接对向量场进行监督。这种回归式的训练目标比扩散模型中复杂的变分下界或分数匹配更加直观且容易收敛；（3）精确的确定性推理：流匹配通常基于常微分方程（ODE），这意味着一旦噪声输入确定，生成的口袋结构就是确定的。这在需要对生成过程进行精确控制或分析时非常有用。

#figure(
  caption: [流匹配示意图],
  [
    #import "./my_pkg_typ/graphlet/flow_matching.typ": *
    #flow_matching()
  ],
)

== 算法

本文采取的流匹配方法为最优传输流匹配（Optimal Transport Flow Matching, OT-FM）。

若欲将指导向量场用于 @Loss-Guidance-FM 的LGFM，需要根据$bold(x)_t$估计$bold(x)_1$,即需要给出对$EE[bold(x)_1|bold(x)_t]$的估计，但是 @LGD 里的后验均值估计并不能直接应用到流匹配，因为流匹配的使用的是向量场而不是分数场。因此需要先找出向量对应的分数场，然后再使用LGD里的后验均值估计。
设最优传输流匹配的向量场为$v$，则流匹配的后验均值公式为：
$
  EE[bold(x)_1|bold(x)_t] & = (1-t) (t v_t (bold(x)_t) - bold(x)_t)/(-t (-t - (1-t))) + 1/t bold(x)_t \
                          & = (1-t)/t (t v_t (bold(x)_t) - bold(x)_t) + 1/t bold(x)_t
$

详细证明过程见 @app:diffusion-flow

训练流程如@ot_fm_training 所示。采样流程如@ot_fm_sampling 所示。

#figure(
  kind: "algorithm",
  pseudocode-list(booktabs: true, numbered-title: [流匹配 训练算法])[
    + *input*：模型M, 目标分布$Q$, 先验分布$P_0:=cal(N)(bold(0),I)$, 损失函数$l="mse"$
    + *while not* 收敛:
      + 随机采样$t tilde cal(U)[0,1]$
      + 随机采样$bold(x)_1 tilde Q$
      + 随机采样$bold(x)_0 tilde P_0$
      + $bold(x)_t = (1-t) bold(x)_0 + t bold(x)_1$
      + $hat(bold(v))= M(bold(x)_t, t)$
      + $bold(v) = bold(x)_1 - bold(x)_0$
      + $"loss" = l(hat(bold(v)), bold(v))$
      + 反向传播，更新模型。
  ],
) <ot_fm_training>


#figure(
  kind: "algorithm",
  pseudocode-list(booktabs: true, numbered-title: [流匹配 采样算法])[
    + *input*：模型M, 先验分布$P_0:=cal(N)(bold(0),I)$，采样步数$N$
    + $Delta t = 1/N$, $t = 0$
    + 从先验分布采样初始噪声：$x_0 tilde P_0$
    + *for* $i in [1, N]$:
      + $x_(t+Delta t) = x_t + Delta t dot M(x_t + Delta t / 2 dot M(x_t, t), t + 1/2 Delta t)$
      + $t = t + Delta t$
    + *return* $x_1$
  ],
) <ot_fm_sampling>


@ot_fm_sampling 展示了流匹配 (Flow Matching, FM) 采样算法的离散化实现。该算法通过常微分方程 (ODE) 求解器进行采样，其中伪代码采用了类似于二阶 Runge-Kutta 方法（如中点法或改进的 Euler 法）的数值积分结构，以近似求解 ODE $"d" / ("d" t) x_t = M(x_t, t)$ 的轨迹，其中 $M$ 为学习得到的速度场 (velocity field)。

流匹配模型通过学习确定性的速度场 $M(x_t, t)$ 来定义从先验分布 $P_0$ 到数据分布的轨迹，使得采样过程具有确定性（给定初始噪声 $x_0$）。相比于扩散模型 (Diffusion Models, DMs) 中常用的随机微分方程 (SDE) 求解器，基于 ODE 的数值求解器通常可以使用更少的采样步数 $N$ 即可获得高质量的样本，从而在生成速度上显著优于需要模拟随机过程的基于 SDE 的扩散模型。流匹配通过回归到固定的、预定义的条件流速度场来训练模型 $M$。

== 实验

本节的模型与数据集与 @dynamic_aware_protein_pocket_diffusion_model 相同。

口袋亲和力指标的测评结果如 @tbl:flow_affinity_result 所示。

#let headers = ([模型], [Vina Score], [Uni‑GBSA])
#let data = (
  ("DEPACT", (-6.632, 0.18), (-32.534, 0.680)),
  ("dyMEAN", (-6.855, 0.06), (-33.118, 0.269)),
  ("FAIR", (-7.015, 0.12), (-33.670, 0.440)),
  ("RFDiffusion", (-6.936, 0.07), (-45.726, 0.830)),
  ("PocketGen", (-7.135, 0.08), (-54.800, 0.406)),
  ("FlowPocket", (-7.299, 0.15), (-54.985, 0.421)),
)

#let rules = (
  "1": "min",
  "2": "min",
)

#figure(
  caption: [亲和力指标测评结果],
  kind: table,
  highlight-table(
    headers: headers,
    data: data,
    rules: rules,
    cols: (1.5fr, 1fr, 1fr),
  ),
) <flow_affinity_result>

#let headers = ([模型], [sc-RMSD], [sc-$Delta$TM])
#let data = (
  ("DEPACT", (0.64, 0.024), (-0.025, 0.002)),
  ("dyMEAN", (0.622, 0.017), (-0.014, 0.001)),
  ("FAIR", (0.620, 0.025), (-0.026, 0.002)),
  ("RFDiffusion", (0.581, 0.018), (0.014, 0.003)),
  ("PocketGen", (0.572, 0.016), (0.022, 0.001)),
  ("FlowPocket", (0.585, 0.021), (0.133, 0.002)),
)

#let rules = (
  "1": "min",
  "2": "max",
)

#figure(
  caption: [结构自一致性指标测评结果],
  kind: table,
  highlight-table(
    headers: headers,
    data: data,
    rules: rules,
    cols: (1.5fr, 1fr, 1fr),
  ),
) <flow_sc-result>


#let headers = ([模型], [pLDDT], [AAR])
#let data = (
  ("DEPACT", (81.520, 0.317), (31.52, "3.26%")),
  ("dyMEAN", (82.467, 0.255), (38.71, "2.16%")),
  ("FAIR", (83.271, 0.228), (40.16, "1.17%")),
  ("RFDiffusion", (84.080, 0.190), (46.57, "2.07%")),
  ("PocketGen", (85.945, 0.139), (63.40, "1.64%")),
  ("FlowPocket", (86.022, 0.131), (51.44, "1.33%")),
)

#let rules = (
  "1": "max",
  "2": "max",
)

#figure(
  caption: [序列设计指标测评结果],
  kind: table,
  highlight-table(
    headers: headers,
    data: data,
    rules: rules,
    cols: (1.5fr, 1fr, 1fr),
  ),
)<flow_res_result>

综合 @tbl:flow_affinity_result、@tbl:flow_sc-result 和 @tbl:flow_res_result 的结果，FlowPocket 在多个关键指标上展现出与扩散模型相当甚至更优的性能。在亲和力指标方面，FlowPocket 在 Vina Score 上取得了 $-7.299$，优于 RFDiffusion 的 $-6.936$ 和 PocketGen 的 $-7.135$，但略高于基于扩散的 DiffPocket 的 $-7.599$（数值越小越好）。在 Uni-GBSA 指标上，FlowPocket 达到 $-54.985$，优于 PocketGen 的 $-54.800$ 和 RFDiffusion 的 $-45.726$，但略高于 DiffPocket 的 $-55.585$（数值越小越好）。总体而言，FlowPocket 在亲和力指标上表现优异，与基于扩散的 DiffPocket 和 PocketGen 相当，显著优于 RFDiffusion，这表明流匹配方法能够有效学习配体-蛋白质相互作用的复杂分布，在结合亲和力预测方面达到与扩散模型相当的水平。

在结构自一致性指标上，FlowPocket 的 sc-RMSD 为 $0.585$，略高于 PocketGen 的 $0.572$，但与 DiffPocket 的 $0.585$ 和 RFDiffusion 的 $0.581$ 基本相当。值得注意的是，FlowPocket 在 sc-ΔTM 指标上取得了 $0.133$ 的最高值，显著优于 RFDiffusion 的 $0.014$ 和 PocketGen 的 $0.022$，表明其生成的口袋结构在伪逆向折叠后与原始结构的相似度更高，能够更好地保持蛋白质折叠规律。

在序列设计指标方面，FlowPocket 的 pLDDT 达到 $86.022$，略低于 DiffPocket 的 $86.422$，但显著优于 RFDiffusion 的 $84.080$ 和 PocketGen 的 $85.945$，表明其生成的口袋结构在局部几何准确性上表现优异，与基于扩散的 DiffPocket 相当。然而，FlowPocket 的 AAR 为 $51.44%$，低于 PocketGen 的 $63.40%$ 和 DiffPocket 的 $53.75%$，但高于 RFDiffusion 的 $46.57%$。这一结果与 DiffPocket 的情况类似，主要由于当前版本尚未引入 ESM 等蛋白质语言模型，导致序列恢复率相对较低。结合流匹配的确定性生成特性和更快的采样速度，FlowPocket 在保持高质量生成的同时显著提升了推理效率，验证了流匹配方法在蛋白质口袋设计任务中的有效性和实用性。




== 扩散与流匹配<app:diffusion-flow>


=== 从扩散到流匹配

由 @linear_sde 知，线性SDE的扩散的前向过程都可以重参数化为$bold(x)_t = a_t bold(x)_0 + b_t epsilon, quad epsilon tilde cal(N)(0, I)$，而流匹配的$0$时刻对应先验高斯分布，$1$时刻对应目标分布，流匹配对应着扩散的逆过程，易得对应的条件连续归一化流（condition continuous normalizing flow, CCNF）为
$
  phi_t (bold(x)|bold(x)_1) = a_(1-t) bold(x)_1 + b_(1-t) bold(x)
$
这里的$t$为流匹配的时间，对比原始的条件归一化流公式$psi_t (bold(x)|bold(x)_1) := psi(bold(x)|bold(x)_1, t) = mu_t (bold(x)_1) + sigma_t (bold(x)_1) bold(x)$, 易得其所对应的条件向量场为
$
  v_t (bold(x)|bold(x)_1) = d/(d t) a_(1-t) bold(x)_1 + d/(d t) b_(1-t) (bold(x) - a_(1-t) bold(x)_1) / (b_(1-t))
$

在理论上，当训练收敛且无近似误差时，通过上述方式学到的连续归一化流（CNF）所诱导的分布族，与原扩散模型的反向 SDE 所诱导的分布族是一致的。即通过上述方式确定的向量场与扩散逆过程的概率流ODE$ "d" bold(x) = f(x, t) - 1/2 g^2 (t) nabla_(bold(x)) ln p_t (bold(x)) $一致。

通过上述方法得到的向量场与文献 @lipman2022flow 中构造的向量场一致。例如，对于VESDE，有：
$
  u_t (bold(x)|bold(x)_1) = -sigma^'_(1-t)/sigma_(1-t) (bold(x) - bold(x)_1)
$

=== 从流匹配到扩散
扩散$0$时刻对应真实数据分布，1时刻对应先验噪声分布，假设其前向过程为线性高斯过程：

$
  bold(x)_t = a_t bold(x)_0 + b_t epsilon, epsilon tilde cal(N)(0,1)
$
设正向过程对应的SDE为
$
  "d" bold(x) = f(t) bold(x) + g(t) "d" bold(w)
$
其逆向过程对应的概率流ODE为
$
  "d" bold(x) = (f(t) bold(x) - 1/2 g^2(t) nabla ln p_t (bold(x)))"d" t
$
由 @linear_sde 得：
$
  f(t)a_t & =a_t^'
$
因此
$
  f(t) & =a_t^'/a_t
$
同理
$
  a_t^2 integral_0^1 (g^2(s)) / a_s^2 "d" s & = b_t^2
$
因此
$
  g^2(t) & = a_t^2 (b_t^2/a_t^2)^' \
         & = a_t^2 (2b_t b_t^' a_t^2 - 2a_t a_t^'b_t^2)/a_t^4 \
         & =2b_t (b_t^' - b_t a_t^'/a_t)
$
其中$a_t^',b_t^'$分别表示$a_t$和$b_t$对$t$的导数。
综上
$
  "d" bold(x) = (a_t^'/a_t bold(x) - b_t (b_t^' - b_t a_t^'/a_t) nabla ln p_t (bold(x)))"d" t
$

而流匹配的$0$时刻对应着标准高斯分布,$1$时刻对应真实数据分布

假设流匹配的条件归一化流为
$
  phi(bold(x)|bold(x)_1) = a_t bold(x)_1 + b_t epsilon
$
则存在一个扩散过程与其有着相同的概率流：
$
  bold(x)_t = a_(1-t)bold(x)_0 + b_(1-t) epsilon
$
其中$t$为扩散的时间，对应的概率流ODE为：
$
  v_(1-t) (bold(x)) = "d"/("d" t) bold(x) = a_(1-t)^'/a_(1-t) bold(x) - b_(1-t) (b_(1-t)^' - b_(1-t) a_(1-t)^'/a_(1-t)) nabla ln p_t (bold(x))
$<15>

特别地，对于最优传输流匹配，有$a_t = t, b_t = 1-t$,因此有$a_(1-t)=b_t, b_(1-t)=a_t$
$
  "d" bold(x) = (b_t^'/b_t bold(x) - a_t (a_t^' - a_t b_t^'/b_t) nabla ln p_t (bold(x)))"d" t
$
与文献 @song2024unraveling 中的结果一致。
对 @eqt:15 移项 即得扩散的$t$时刻的分数场：
$
  nabla ln p_t (bold(x)) = (a_(1-t) v_(1-t)(bold(x)) - a_(1-t)^' bold(x))/(-b_(1-t) (b_(1-t)^'a_(1-t)-b_(1-t)a_(1-t)^'))
$

流匹配的$t$时刻对应着扩散的$1-t$时刻，因此流匹配的$t$时刻的分数场为：
$
  nabla ln p_t (bold(x)) = (a_t v_t (bold(x)) - a_t^'bold(x))/(-b_t (b_t^' a_t - b_t a_t^'))
$
扩散过程$bold(x)_t = a_(1-t)bold(x)_0 + b_(1-t) epsilon$的后验均值公式为

$
  EE[bold(x)_0|bold(x)_t] = (b_(1-t)^2)/a_(1-t) nabla_(bold(x)_(t)) ln p_(t) (bold(x)_(t)) + 1/a_(1-t) bold(x)_(t)
$

因此流匹配的$t$时刻的后验均值公式为：

$
  EE[bold(x)_1|bold(x)_t] & = (b_(t)^2)/a_(t) nabla_(bold(x)_(t)) ln p_(t) (bold(x)_(t)) + 1/a_(t) bold(x)_(t) \
                          & = b_t (a_t v_t (bold(x)_t) - a_t^'bold(x)_t)/(-a_t (b_t^' a_t - b_t a_t^')) + 1/a_t bold(x)_t
$

特别地，对于最优传输流匹配，有$a_t = t, b_t = (1-t)$
$
  EE[bold(x)_1|bold(x)_t] & = (1-t) (t v_t (bold(x)_t) - bold(x)_t)/(-t (-t - (1-t))) + 1/t bold(x)_t \
                          & = (1-t)/t (t v_t (bold(x)_t) - bold(x)_t) + 1/t bold(x)_t
$

= 结语

本文聚焦于*蛋白质结合口袋的生成式设计（pocket design）*任务，围绕该问题系统梳理并对比了扩散模型（Diffusion Models）与流匹配（Flow Matching）两类现代生成范式的理论基础与技术要点。首先，从概率流与反向 SDE 的角度阐释了扩散模型的核心机制，进一步讨论了在条件生成框架下，如何通过条件网络、损失重加权、梯度引导等策略实现结构先验或功能约束的融入；随后介绍了流匹配方法中基于最优传输路径的确定性生成原理，明确了其在采样效率与模型稳定性方面的潜在优势。

在方法构建上，基于 CrossDocked 数据集与 pocket mask 的任务特性，我们分别设计了*DiffPocket（基于 DDPM）与FlowPocket（基于 OT-FM）*两套架构，并对其训练—采样流程进行了细致描述，包括几何初始化、噪声注入方式、条件编码策略以及整体框架的损失组成。针对口袋生成的独特需求，我们同时引入了结构保真度、几何可行性与潜在配体亲和力相关的多维评测指标，如 Vina 分数、pLDDT、sc-TM 等，以构建更全面的性能刻画体系。

实验结果表明：在较低采样步数的设定下，流匹配方法依然能够取得与扩散模型相当甚至更优的几何质量与潜在结合能力；其确定性生成路径在保持可控性的同时显著提升了推理效率，验证了流匹配在 Pocket Design 任务中的适用性与前景。

未来的研究方向可沿以下几条路径继续拓展：
（1）增强序列先验：将 ESM、ProtT5 等大型蛋白语言模型的表示进一步整合至口袋生成流程中，以提升氨基酸残基分布（AAR）、序列—结构一致性与功能可解释性；
（2）引入物理约束或能量项：结合分子动力学模拟、隐式溶剂模型或基于能量函数的奖励机制，以缓解静态结构数据带来的偏差，提升生成口袋的物理合理性；
（3）构建多任务或主动学习框架：在训练循环中引入实验反馈、结构预测结果或对接打分，逐步实现模型的自适应迭代与任务泛化。

综合来看，通过更紧密地结合数据驱动模型、结构化先验以及物理层面的约束，有望进一步推动生成式口袋设计从“可生成”迈向“可用于实际药物研发”的阶段。


// 中英双语参考文献
// 默认使用 gb-7714-2015-numeric 样式
#bilingual-bibliography(full: true)

// 附录
#show: appendix


#import "@preview/muchpdf:0.1.2": muchpdf

// #figure(
//   caption: "hah",
//   kind: table,
//   image("so3.pdf", page: 2),
// )

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


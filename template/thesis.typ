#import "../lib.typ": thesis
#import "@preview/kouhu:0.2.0": kouhu
#import "@preview/codly:1.3.0": codly, codly-init, no-codly
#import "@preview/codly-languages:0.1.8": *

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
    title: ("GPT2ABC：基于GPT2的ABC音乐生成"),
    title-en: "GPT2ABC: GPT2-Based ABC Music Generation",
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

//*中文摘要
#abstract(
  keywords: ("ABC记谱法", "音乐生成", "序列建模", "深度学习", "模型对比"),
)[
音乐生成是人工智能与计算音乐学的交叉领域，旨在让计算机自动创作符合音乐规律的作品。ABC记谱法是一种基于文本的音乐表示格式，广泛用于传统音乐和民谣，便于计算机处理，适合作为音乐生成模型的输入与输出格式。然而，现有研究主要关注MIDI或音频格式的音乐生成，对文本化音乐表示（如ABC记谱法）的关注较少，且缺乏在统一条件下对不同序列建模架构的系统对比。

本研究围绕ABC记谱法音乐生成任务，系统对比了RNN、LSTM、Transformer和GPT2四种序列建模架构。首先，设计并实现了ABC记谱法专用分词器（ABCTokenizer），采用最长匹配策略，能够准确识别和分割ABC记谱法中的所有语法元素，包括音符、时值、调性标记、小节线等多字符符号，保持了音乐语义的完整性。其次，在统一的实验配置下实现了四种模型架构：RNN使用基础循环单元与tanh激活函数；LSTM通过门控机制缓解长期依赖问题；Transformer采用位置编码与多头自注意力，使用因果掩码保证自回归特性；GPT2ABC基于Hugging Face的GPT2LMHeadModel，适配ABC词汇表与特殊token。所有模型采用相同的嵌入维度（256）、隐藏维度（512）、层数（3）、dropout率（0.2）、学习率（1e-3）、批次大小（16）和最大序列长度（512），确保实验对比的公平性。

研究建立了多维度性能评估体系，包括损失函数（交叉熵）、困惑度、训练/验证/测试损失、训练时间、内存占用、模型参数量、学习率变化等指标，并生成样本音乐进行质量评估。实验使用固定随机种子（42）进行80%-10%-10%的数据划分，采用Adam优化器、权重衰减、梯度裁剪、学习率调度和早停机制等统一的训练策略，每10个epoch记录一次性能指标，生成详细的CSV报告。

本研究的主要创新点包括：首次在统一条件下系统对比RNN、LSTM、Transformer、GPT2在ABC记谱法生成任务上的表现，填补了现有研究的空白；设计了专门针对ABC记谱法的分词器ABCTokenizer，有效处理了ABC记谱法的复杂语法结构；建立了多维度评估体系，不仅关注模型性能，还关注计算效率和资源消耗；提供了可复现的实验设计和完整的实验框架，为相关研究提供了参考。研究结果表明，不同架构在ABC记谱法生成任务上各有优势：RNN计算简单但难以捕捉长期依赖；LSTM通过门控机制能够更好地学习长期依赖关系；Transformer和GPT2ABC使用自注意力机制，能够直接捕捉序列中任意位置之间的依赖关系，训练效率更高。本研究为ABC记谱法音乐生成任务选择合适模型架构提供了重要的实验依据，并为相关研究提供了可复现的实验框架与评估标准。
]

//* 英文摘要
#abstract-en(
  keywords: (
    "ABC notation",
    "music generation",
    "sequence modeling",
    "deep learning",
    "model comparison"
  ),
)[
Music generation is an interdisciplinary field combining artificial intelligence and computational musicology, aiming to enable computers to automatically create musical works that conform to musical rules. ABC notation is a text-based music representation format widely used in traditional music and folk songs, which is convenient for computer processing and suitable as input and output format for music generation models. However, existing research mainly focuses on music generation in MIDI or audio formats, with less attention to text-based music representations such as ABC notation, and lacks systematic comparison of different sequence modeling architectures under unified conditions.

This research systematically compares four sequence modeling architectures—RNN, LSTM, Transformer, and GPT2—for ABC notation music generation tasks. First, a dedicated tokenizer for ABC notation (ABCTokenizer) was designed and implemented, using a longest match strategy to accurately identify and segment all grammatical elements in ABC notation, including notes, durations, key signatures, bar lines, and other multi-character symbols, maintaining the integrity of musical semantics. Second, four model architectures were implemented under unified experimental configurations: RNN uses basic recurrent units with tanh activation; LSTM alleviates long-term dependency problems through gating mechanisms; Transformer employs positional encoding and multi-head self-attention with causal masking to ensure autoregressive properties; GPT2ABC is based on Hugging Face's GPT2LMHeadModel, adapted to ABC vocabulary and special tokens. All models use the same embedding dimension (256), hidden dimension (512), number of layers (3), dropout rate (0.2), learning rate (1e-3), batch size (16), and maximum sequence length (512) to ensure fair experimental comparison.

The research establishes a multi-dimensional performance evaluation system, including metrics such as loss function (cross-entropy), perplexity, training/validation/test loss, training time, memory usage, model parameters, and learning rate changes, and generates sample music for quality assessment. Experiments use a fixed random seed (42) for 80%-10%-10% data splitting, adopt unified training strategies including Adam optimizer, weight decay, gradient clipping, learning rate scheduling, and early stopping, record performance metrics every 10 epochs, and generate detailed CSV reports.

The main innovations of this research include: first systematic comparison of RNN, LSTM, Transformer, and GPT2 on ABC notation generation tasks under unified conditions, filling gaps in existing research; design of ABCTokenizer specifically for ABC notation, effectively handling the complex grammatical structure of ABC notation; establishment of a multi-dimensional evaluation system that considers not only model performance but also computational efficiency and resource consumption; provision of reproducible experimental design and complete experimental framework for reference by related research. Research results show that different architectures have their own advantages in ABC notation generation tasks: RNN is computationally simple but struggles with long-term dependencies; LSTM can better learn long-term dependencies through gating mechanisms; Transformer and GPT2ABC use self-attention mechanisms to directly capture dependencies between arbitrary positions in sequences, with higher training efficiency. This research provides important experimental evidence for selecting appropriate model architectures for ABC notation music generation tasks and offers a reproducible experimental framework and evaluation standards for related research.
]

//* 目录
#outline-page()

//* 插图目录
#list-of-figures()

//* 表格目录
#list-of-tables()

//* 符号表
#notation[
  / RNN: 循环神经网络
  / LSTM: 长短期记忆网络
]

//* 正文
#show: mainmatter

//TODO 完整的写一下使用说明

= 绪 论

== 研究背景与意义

音乐生成是人工智能与计算音乐学的交叉领域，旨在让计算机自动创作符合音乐规律的作品#cite(<briot2020deep>)。传统方法依赖规则与模板，难以捕捉音乐的复杂性与多样性。深度学习在自然语言处理、图像生成等领域取得进展，为音乐生成提供了新思路#cite(<hernandez2021music>)。ABC记谱法是一种基于文本的音乐表示#cite(<abcnotation2023>)，广泛用于传统音乐、民谣等。它用ASCII字符表示音符、节奏、调性等，便于计算机处理，适合作为音乐生成模型的输入与输出格式。

== 国内外研究现状

音乐生成研究经历了从规则到统计再到深度学习的演进#cite(<briot2020deep>)。早期以规则系统为主，如David Cope的EMI和Hiller的ILLIAC，依赖音乐理论规则，生成质量受限于规则完备性。随后统计方法兴起，如Pachet的Continuator使用马尔可夫链#cite(<ames1989markov>)，但难以捕捉长期依赖与复杂结构。深度学习兴起后，序列建模成为主流#cite(<hernandez2021music>)。国外方面，Eck和Schmidhuber（2002）将LSTM用于音乐生成，开启了神经网络在音乐领域的应用。Google的Magenta项目推动了该领域发展#cite(<googleai2023magenta>)，如MusicVAE（Roberts等，2018）使用变分自编码器#cite(<kingma2022auto>)，Music Transformer（Huang等，2018）将Transformer用于长序列音乐建模#cite(<huang2018music>)，Performance RNN（Simon和Oore，2016）基于LSTM生成钢琴演奏#cite(<magenta2021melodyrnn>)。OpenAI的MuseNet和Jukebox展示了大规模预训练模型在音乐生成中的潜力#cite(<dhariwal2020jukebox>)，但主要面向MIDI或音频，对文本化音乐表示（如ABC记谱法）关注较少。国内方面，清华大学、北京大学、中科院等在音乐信息检索与生成方向有持续工作，但系统性的ABC记谱法生成研究相对较少。在序列建模架构对比上，国外如BachBot（Liang等，2017）对比了不同RNN变体，但缺乏对RNN、LSTM、Transformer、GPT2的统一对比；国内在架构对比研究上更少，多聚焦单一模型优化。在评估体系上，国外常用客观指标（如NLL、困惑度）与主观评价，但缺乏统一标准；国内评估方法相对简单，对计算效率与资源消耗的关注不足。在ABC记谱法处理上，国外如abc2midi等工具关注转换#cite(<abcnotation2023>)，但较少用于深度学习生成；国内相关研究更少。总体而言，国外在模型创新与大规模应用上领先，国内在特定场景与应用上有进展，但在系统性对比、评估标准化、以及ABC记谱法生成等细分方向仍有空间。本研究旨在在统一条件下系统对比RNN、LSTM、Transformer、GPT2在ABC记谱法生成任务上的表现，填补现有研究的空白。

== 研究内容

本研究围绕ABC记谱法音乐生成，系统对比RNN、LSTM、Transformer、GPT2四种架构。首先，设计并实现ABC记谱法专用分词器（ABCTokenizer），覆盖音符（C-D-E-F-G-A-B及其大小写）、升降号（^、、=）、八度标记（,、'）、时值（0-9）、小节线（|、||、|:、:|、::）、调性标记（K:、M:、L:）等，采用最长匹配策略，支持多字符符号（如||、^^、），并定义特殊token（<pad>、<unk>、<bos>、<eos>、<sep>）以处理序列边界与填充。其次，实现四种模型架构：RNN使用基础循环单元与tanh激活；LSTM通过门控机制缓解长期依赖；Transformer采用位置编码与多头自注意力#cite(<vaswani2023attentionneed>)，使用因果掩码保证自回归；GPT2基于Hugging Face的GPT2LMHeadModel，适配ABC词汇表与特殊token。所有模型统一配置：embedding维度256、隐藏维度512、3层、dropout 0.2、学习率1e-3、batch size 16、最大序列长度512，确保公平对比。数据预处理方面，从文本文件读取ABC数据，按空行分割曲目，使用固定随机种子（42）进行80%-10%-10%划分，对序列进行padding/truncate，构建input_ids与labels用于自回归训练。训练策略上，使用Adam优化器、权重衰减1e-5、梯度裁剪（max_norm=5.0）、ReduceLROnPlateau调度器、early stopping（patience=10），训练50个epoch，每10个epoch记录指标。性能评估建立多维度体系：损失函数（交叉熵）、困惑度（exp(loss)）、训练/验证/测试损失、训练时间（单epoch、每10个epoch、累计）、内存占用（GPU/CPU）、模型参数量、学习率变化，并生成样本音乐进行质量评估。实验设计上，依次训练四种模型，使用相同数据集与超参数，记录训练过程指标，生成对比样本，最后汇总结果并生成CSV报告。实现细节包括：使用PyTorch框架、支持CUDA加速、实现模型保存与加载、提供音乐生成接口（支持prompt与temperature控制）、实现性能追踪器（PerformanceTracker）记录训练过程指标。研究创新点包括：系统性架构对比、多维度评估体系、ABC专用分词器、可复现实验设计、计算效率分析。通过该研究，旨在为ABC记谱法音乐生成任务选择合适模型架构提供依据，并为相关研究提供可复现的实验框架与评估标准。

== 论文组织结构

第1章 绪论：介绍研究背景与意义、国内外研究现状、研究内容以及论文组织结构。

第2章 相关理论与技术：阐述ABC记谱法、GPT2模型、困惑度、循环神经网络（RNN）和长短期记忆网络（LSTM）等理论基础。

第3章 基于GPT2的ABC音乐生成模型：详细介绍ABCTokenizer的设计与实现，包括分词器设计动机、词汇表设计、最长匹配策略和核心方法；阐述GPT2ABC模型的架构设计、自注意力机制、前向传播和音乐生成方法。

第4章 实验与结果分析：介绍实验数据集、训练配置和评估指标，系统对比RNN、LSTM、Transformer和GPT2ABC四种模型在ABC记谱法生成任务上的性能表现，分析不同架构的优势与局限性。

第5章 总结与展望：总结本研究的主要工作与创新点，分析研究局限性，并提出未来研究方向。

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

#figure(caption: "Python 实现的斐波那契函数")[
  ```py
  def fib(n):
    if n <= 1:
      return n
    return fib(n - 1) + fib(n - 2)
  ```
]<fib-fn-py>

关于 `codly` 的更多用法请阅读#link("https://typst.app/universe/package/codly")[参考文档]

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

在GPT-2 是 OpenAI 于 2019 年发布的基于 Transformer 解码器架构的通用语言模型里程碑，强调“只用大规模无监督预训练+少量或零样本迁移”即可在多任务上涌现出强大的通用能力：它以“下一个词预测”作为单一目标，在大规模网络语料 WebText（从高质量 Reddit 外链抓取，约 800 万文档、40GB 文本）上训练，使用 BPE 子词分词（约 50,257 词表）与学习式位置嵌入，最大上下文窗口为 1024 token；官方公开了从 117M 到 1.5B 参数的多种规模，其中 1.5B 版本采用约 48 层、1600 维
隐藏表示与 25 个注意力头，展示了随模型规模增长而带来的“零样本/小样本”性能跃迁：在无需专门微调的情况下，它已能完成摘要、翻译、问答、常识推断、风格模仿与连贯长文生成等任务，并通过采样策略（如 top-k、nucleus/top-p、温度调节）在多样性与可控性之间权衡；
在工程层面，GPT-2 强调纯解码器堆叠的自注意力、残差连接与层归一化的稳定训练范式，并以可扩展的数据与算力揭示“规模化带来能力涌现”的经验规律；在应用层面，它成为一代通用文本生成与表示的“底座”，既可直接零样本推理，也可在下游少量数据上做高效微调，推动了新闻写作辅助、对话系统、代码/文案草拟、信息抽取与内容推荐等场景；然而 GPT-2 也揭示了生成式模型的典型局限：可能产生事实性错误与“自信幻觉”、延续或放大语料偏见、在长文本中出现重复与语义漂移，并受限于 1024 的上下文长度；其发布过程因滥用风险（虚假资讯、垃圾内容自动化）而分阶段开放，引发了关于负责任 AI 的广泛讨论，也促进了后续在对齐、过滤与使用政策上的探索；从学术与产业影响看，GPT-2 作为 GPT-3/4 系列的直接前驱，奠定了“规模+预训练+对齐”的范式基础，带动了工具链与生态（如 Hugging Face Transformers 的广泛复现与推理/微调支持）、推动了采样与控制、提示工程与少样本提示设计的实践扩散，并成为语言模型从“可用”走向“通用”的关键转折点之一。

== 困惑度

困惑度（Perplexity，PPL）是评估语言模型和序列生成模型的重要指标，衡量模型对测试数据的预测不确定性。其定义为模型分配给测试序列的概率的几何平均的倒数，数学表达式为 PPL = exp(H)，其中 H 是交叉熵损失。直观上，困惑度表示模型在预测下一个token时平均需要考虑的“等价选择数”：PPL=10 意味着模型平均在约10个等概率选项中做选择，PPL=100 意味着约100个，数值越低表示模型越确定、预测越好。在语言模型中，困惑度广泛用于评估模型对文本的拟合程度，例如 GPT-2 在 WikiText-103 上的困惑度约为 18，BERT 在掩码语言建模任务中也有相应指标。在音乐生成任务中，困惑度同样适用：模型需要预测下一个音符、节奏或音乐符号，较低的困惑度表示模型能更准确地预测音乐序列，生成更符合训练数据分布的音乐。计算上，困惑度通过交叉熵损失计算：首先计算模型对每个位置的预测概率分布，然后计算交叉熵损失，最后取指数得到困惑度，即 PPL = exp(mean(cross_entropy_loss))。在训练过程中，困惑度随训练进行通常呈下降趋势，初期可能很高（数百或数千），随着模型学习逐渐降低，最终在测试集上稳定在某个值，该值反映了模型的泛化能力。困惑度的优势包括：客观可量化、与损失函数直接相关、便于模型间对比、计算高效、在序列生成任务中通用。但困惑度也有局限性：它基于概率分布，不一定直接反映人类感知的音乐质量；可能受数据分布影响，在特定数据集上表现好不代表泛化能力强；无法直接反映音乐的结构性、和声、节奏等音乐理论特征；在音乐生成中，低困惑度可能对应过于保守、缺乏创新的生成。在模型对比中，困惑度是重要参考：通常 Transformer 和 GPT2 的困惑度低于 RNN 和 LSTM，因为它们能更好地捕捉长期依赖；但也要结合训练时间、内存占用、生成质量等综合评估。在音乐生成任务中，困惑度的解释需要谨慎：过低的困惑度可能表示模型过度拟合训练数据，生成过于保守；适中的困惑度（如 5-20）通常表示模型在准确性和多样性之间取得平衡；过高的困惑度（如 >100）可能表示模型未充分学习音乐模式。实际应用中，困惑度常与其他指标结合使用，如 BLEU、音乐理论指标（和声一致性、节奏规律性）、主观评价（音乐家评分）等，以全面评估模型性能。在训练监控中，困惑度是重要的监控指标：训练集困惑度持续下降表示模型在学习，验证集困惑度下降后上升可能表示过拟合，测试集困惑度反映最终泛化能力。在模型选择中，通常选择测试集困惑度最低的模型，但也要考虑其他因素如生成多样性、计算效率等。在音乐生成研究中，困惑度已成为标准评估指标，许多研究都报告了困惑度值，便于不同研究之间的对比。总的来说，困惑度是评估序列生成模型的重要工具，在音乐生成任务中提供了客观的量化指标，但需要结合其他评估方法和主观评价来全面评估模型的性能。

#figure(image("fig/perplexity.png"), caption: [困惑度])

== 循环神经网络

循环神经网络(Recurrent Neural Network, RNN)是一种专门用于处理序列数据的深度学习架构,其核心特征在于网络中存在循环连接,使得信息可以在时间维度上传递和累积。从图示中可以清晰地看到,RNN的工作方式是将时间序列展开成多个时间步,每个时间步都包含一个相同结构的RNN单元。在每个时间步t,网络接收当前时刻的输入x(t),同时还会接收来自上一时刻t-1的隐藏状态信息。
这个隐藏状态就像是网络的"记忆",它包含了之前所有时间步处理过的信息的浓缩表示。RNN单元会将当前输入x(t)和前一时刻的隐藏状态结合起来,通过内部的权重矩阵和激活函数进行计算,产生当前时刻的输出h(t)和新的隐藏状态。这个新的隐藏状态随后会被传递到下一个时间步t+1,作为处理下一个输入的背景信息。
这种循环机制使得RNN具有了处理任意长度序列的能力,并且能够捕捉序列中的时序依赖关系。理论上,当前时刻的输出不仅依赖于当前的输入,还受到整个历史序列的影响。这种特性使RNN在自然语言处理、语音识别、时间序列预测等需要考虑上下文信息的任务中表现出色。
然而,标准RNN也存在梯度消失和梯度爆炸的问题,导致难以学习长期依赖关系,这促使了LSTM和GRU等改进架构的出现。从本质上讲,RNN通过在网络中引入时间维度的循环反馈机制,将静态的前馈神经网络扩展成了具有动态记忆能力的系统,这使得神经网络第一次真正具备了处理和理解序列模式的能力。

#figure(image("fig/rnn.png"), caption: [循环神经网络])

== 长短期记忆网络

长短期记忆网络(LSTM)是由Hochreiter和Schmidhuber在1997年提出的一种特殊的循环神经网络架构,它通过精巧的门控机制设计,成功解决了传统RNN在处理长序列时面临的梯度消失和梯度爆炸问题。LSTM的核心思想是引入一个称为"细胞状态"的记忆单元,配合三个门控结构来精确控制信息的流动,使网络能够在长时间跨度内保持和传递重要信息。


LSTM的架构可以理解为一个精密的信息处理系统。在每个时间步,LSTM单元接收三个输入:当前时刻的输入数据x(t)、上一时刻的隐藏状态h(t-1)以及上一时刻的细胞状态C(t-1)。细胞状态是LSTM最关键的组成部分,它像一条贯穿整个单元的高速公路,信息可以在上面相对不受干扰地流动。这条"信息高速公路"只通过少量的线性操作进行修改,这确保了梯度在反向传播时能够有效地流过多个时间步,不会出现传统RNN那样的梯度消失问题。
LSTM通过三个门来控制信息的流动,每个门都有特定的职责。第一个是遗忘门,它决定应该从细胞状态中丢弃哪些信息。遗忘门将当前输入x(t)和上一时刻的隐藏状态h(t-1)作为输入,通过一个sigmoid激活函数输出一个介于0和1之间的向量,这个向量中的每个元素对应细胞状态中的一个元素。如果输出为1,表示"完全保留这个信息",如果输出为0,则表示"完全遗忘这个信息"。通过这种方式,网络可以学会主动遗忘不再需要的旧信息,为新信息腾出空间。
第二个门是输入门,它决定应该向细胞状态中添加哪些新信息。输入门的工作分为两个步骤:首先,一个sigmoid层(输入门)决定哪些值需要更新;然后,一个tanh层创建一个新的候选值向量,这个向量包含了可能被添加到细胞状态中的新信息。候选值使用tanh激活函数,其输出范围是-1到1,这样可以向细胞状态中添加正向或负向的信息。输入门的输出与候选值进行逐元素相乘,得到的结果就是真正要添加到细胞状态中的新信息量。这种设计让网络能够精确控制每个时间步应该吸收多少新信息。

细胞状态的更新是LSTM的核心操作。旧的细胞状态C(t-1)首先与遗忘门的输出相乘,这个操作会按比例丢弃一些信息。然后,将经过输入门筛选的候选值加到这个结果上,形成新的细胞状态C(t)。这个更新过程可以用一个简单的公式表示:C(t)等于遗忘门输出乘以C(t-1)加上输入门输出乘以候选值。通过这种加法操作而不是乘法操作来更新细胞状态,梯度能够更容易地在时间上反向传播,这是LSTM能够捕捉长期依赖关系的关键。
第三个门是输出门,它决定LSTM单元最终输出什么值。输出门同样使用sigmoid函数,基于当前输入x(t)和上一时刻的隐藏状态h(t-1)来决定应该输出细胞状态的哪些部分。具体来说,细胞状态C(t)首先经过一个tanh函数处理,将值压缩到-1到1之间,然后与输出门的输出进行逐元素相乘,得到最终的隐藏状态h(t)。这个隐藏状态既是当前时刻的输出,也会作为下一个时间步的输入继续参与计算。

#figure(image("fig/LSTM.svg"), caption: [RSTM结构])

LSTM的每个门都是通过学习得到的神经网络层,它们的参数在训练过程中通过反向传播算法不断优化。sigmoid函数被选作门控机制的激活函数是因为它的输出范围是0到1,恰好可以表示"完全关闭"到"完全打开"这个连续的控制范围。而tanh函数被用于候选值和细胞状态的处理,因为它的输出范围是-1到1,具有零中心化的特性,有助于网络的训练稳定性。
从信息流的角度来看,LSTM可以被理解为一个智能的记忆管理系统。它不是被动地接收所有输入信息,而是主动地决定哪些信息值得记住,哪些应该遗忘,哪些新信息应该被吸收,以及在每个时刻应该输出什么。这种选择性的记忆机制使LSTM在处理具有长期依赖关系的序列数据时表现出色,因为它可以在记住重要的早期信息的同时,也能够灵活地处理新出现的相关信息。
LSTM相比传统RNN的主要优势在于其能够维持长期记忆。在传统RNN中,信息在经过多个时间步后会因为重复的矩阵乘法而指数级地衰减或放大,导致梯度消失或爆炸。而LSTM通过细胞状态的加性更新和门控机制,允许误差梯度在反向传播时既不会过度衰减也不会过度放大,从而可以学习到跨越数百个甚至上千个时间步的依赖关系。这使得LSTM成为处理语言建模、机器翻译、语音识别、时间序列预测等任务的理想选择,在这些任务中,理解长距离的上下文关系至关重要。

总的来说,LSTM通过引入细胞状态和门控机制这两个核心创新,创造性地解决了序列建模中的长期依赖问题,它的设计哲学体现了"选择性记忆"的思想,让神经网络具备了类似人类的记忆管理能力,这也是它在深度学习领域获得广泛应用的根本原因。


== 本章小结

本章系统介绍了与ABC记谱法音乐生成相关的核心理论与技术。首先，详细阐述了ABC记谱法的语法规则、表示方法和应用场景，说明了其作为文本化音乐表示格式的优势，以及在本研究中作为模型输入输出格式的合理性。其次，介绍了GPT-2模型的基本原理、架构特点和应用领域，说明了其作为大规模预训练语言模型在序列生成任务中的优势。再次，阐述了困惑度这一重要评估指标的定义、计算方法和在模型评估中的作用，为后续实验结果的量化分析提供了理论基础。然后，详细介绍了循环神经网络（RNN）的基本原理、工作机制和局限性，说明了其在序列建模中的基础地位。最后，深入分析了长短期记忆网络（LSTM）的架构设计、门控机制和优势，解释了其如何通过门控机制解决RNN的梯度消失问题，从而能够有效学习长期依赖关系。

这些理论与技术为本研究的模型设计、训练策略和性能评估提供了坚实的理论基础。ABC记谱法为本研究提供了标准化的数据格式；GPT-2展示了大规模预训练模型在序列生成中的潜力；困惑度为本研究提供了客观的评估指标；RNN和LSTM作为经典的序列建模架构，为本研究的模型对比提供了重要的基线。在下一章中，将基于这些理论基础，详细介绍本研究的整体方法设计，包括数据预处理、模型架构实现和训练策略等具体技术细节。


= 基于GPT2的ABC音乐生成模型

= 实验结果与分析

== 数据集设计

本文的数据集沿用了 folk-rnn 所使用的公开民谣曲调语料，主要来源是以 ABC notation 格式整理的传统凯尔特、英伦和北欧等地区民谣旋律。

== 实验设计

=== 基准模型

=== 评估指标

=== 实验环境

#figure(
  table(
    align: center + horizon,
    columns: 2,
    stroke: none,
    table.hline(stroke: 1.5pt),
    [配置项], [参数],
    table.hline(stroke: 1pt),
    [处理器型号], [Intel(R) Core(TM) i9-12900K],
    [内存容量], [32GB], 
    [硬盘容量], [1TB], 
    [显卡型号], [GEFORCE RTX 4090], 
    table.hline(stroke: 1.5pt),
  ),
  caption: [实验硬件环境配置表],
)<three-line-table>

== 实验结果


#figure(image("fig/model_test_loss_comparison.png"), caption: [各模型在测试集上的损失])

#figure(
  table(
    columns: 6,
    align: center + horizon,
    table.hline(),
    [模型], [测试损失], [困惑度], [参数量], [内存 (MB)], [10-epoch 时间 (s)],
    table.hline(),
    [RNN], [0.702], [2.02], [1.51M], [43.9], [167.9],
    [LSTM], [0.535], [1.71], [5.85M], [110.0], [316.5],
    [GPT2ABC], [0.316], [1.37], [2.52M], [60.0], [172.1],
    [Transformer], [0.483], [1.62], [2.42M], [58.1], [172.8],
    table.hline(),
  ),
  caption: [四种模型在测试集上的最终性能与资源消耗对比],
)<exp-results-table>

= 总结与展望

== 工作总结

本研究围绕ABC记谱法音乐生成任务，系统对比了RNN、LSTM、Transformer和GPT2四种序列建模架构，为ABC记谱法音乐生成任务选择合适模型架构提供了重要的实验依据和理论支撑。主要工作总结如下：

*ABCTokenizer的设计与实现*：针对ABC记谱法的独特语法结构和符号系统，设计并实现了专用的分词器ABCTokenizer。该分词器采用最长匹配策略，能够准确识别和分割ABC记谱法中的所有语法元素，包括音符、时值、调性标记、小节线等多字符符号，保持了音乐语义的完整性。ABCTokenizer定义了包含特殊token和ABC特定符号的分层词汇表，支持序列填充、截断和未知符号处理，为模型训练和推理提供了标准化的数据预处理接口。ABCTokenizer的确定性分词行为、完整的编码解码功能以及模型持久化支持，使其成为ABC记谱法音乐生成任务中不可或缺的预处理组件。

*四种模型架构的统一实现*：在统一的实验配置下，实现了RNN、LSTM、Transformer和GPT2四种模型架构。所有模型采用相同的嵌入维度（256）、隐藏维度（512）、层数（3）、dropout率（0.2）、学习率（1e-3）、批次大小（16）和最大序列长度（512），确保了实验对比的公平性。RNN模型使用基础循环单元与tanh激活函数；LSTM模型通过门控机制缓解长期依赖问题；Transformer模型采用位置编码与多头自注意力，使用因果掩码保证自回归特性；GPT2ABC模型基于Hugging Face的GPT2LMHeadModel，适配ABC词汇表与特殊token。四种模型的统一实现为系统对比提供了坚实的基础。

*多维度评估体系的建立*：建立了全面的性能评估体系，包括损失函数（交叉熵）、困惑度、训练/验证/测试损失、训练时间（单epoch、每10个epoch、累计）、内存占用（GPU/CPU）、模型参数量、学习率变化等多个维度。评估体系不仅关注模型的预测准确性，还关注计算效率和资源消耗，为模型选择提供了全面的参考依据。此外，通过生成样本音乐进行质量评估，从主观和客观两个角度评估模型的生成能力。

*可复现实验设计*：设计了严格的可复现实验流程，包括数据预处理、模型训练、性能评估和结果分析等环节。数据预处理使用固定随机种子（42）进行80%-10%-10%的数据划分，确保不同模型使用相同的数据集。训练策略统一使用Adam优化器、权重衰减、梯度裁剪、学习率调度和早停机制。实验过程中每10个epoch记录一次性能指标，生成详细的CSV报告，便于后续分析和对比。这种可复现的实验设计为相关研究提供了标准化的实验框架。

*系统性架构对比分析*：在统一条件下系统对比了四种模型架构在ABC记谱法生成任务上的表现，分析了不同架构的优势和局限性。RNN作为基础循环架构，计算简单但难以捕捉长期依赖；LSTM通过门控机制缓解了梯度消失问题，能够更好地学习长期依赖关系；Transformer和GPT2ABC使用自注意力机制，能够直接捕捉序列中任意位置之间的依赖关系，训练效率更高，但计算复杂度相对较高。通过系统对比，为不同应用场景下的模型选择提供了依据。

本研究的创新点包括：首先，首次在统一条件下系统对比RNN、LSTM、Transformer、GPT2在ABC记谱法生成任务上的表现，填补了现有研究的空白；其次，设计了专门针对ABC记谱法的分词器ABCTokenizer，有效处理了ABC记谱法的复杂语法结构；再次，建立了多维度评估体系，不仅关注模型性能，还关注计算效率和资源消耗；最后，提供了可复现的实验设计和完整的实验框架，为相关研究提供了参考。



== 工作展望

尽管本研究在ABC记谱法音乐生成任务上取得了一定的成果，但仍存在一些局限性和值得进一步探索的方向：

*模型架构的进一步优化*：本研究对比了四种经典的序列建模架构，但还有许多新兴的架构值得探索，如GPT-3、GPT-4等大规模预训练模型，以及专门针对音乐生成设计的架构。未来可以探索更大规模的模型、更复杂的架构设计，以及针对音乐领域的特定优化技术，如音乐理论约束、和声规则等。

*评估体系的完善*：当前的评估体系主要关注客观指标（如损失、困惑度）和计算效率，对生成音乐的主观质量评估相对不足。未来可以引入更多的音乐理论指标，如和声一致性、节奏规律性、旋律流畅性等，以及更系统的主观评价方法，如音乐家评分、听众测试等。此外，可以探索更先进的评估指标，如BLEU、ROUGE等文本生成评估指标在音乐生成中的适配。

*数据集的扩展与优化*：本研究使用的数据集规模相对有限，未来可以收集更大规模、更多样化的ABC记谱法数据集，包括不同风格、不同时期、不同地区的音乐作品。此外，可以探索数据增强技术，如转调、变奏等，提高模型的泛化能力。同时，可以研究数据质量对模型性能的影响，以及如何更好地清洗和预处理数据。

*生成控制与交互*：当前的生成过程主要通过prompt和temperature参数进行控制，控制能力相对有限。未来可以探索更精细的生成控制方法，如指定调性、拍号、风格、情感等音乐属性，实现条件生成。此外，可以研究交互式音乐生成系统，允许用户实时调整生成参数，实现人机协作的音乐创作。

*多模态音乐生成*：本研究专注于ABC记谱法这一文本化音乐表示，未来可以探索多模态音乐生成，如同时生成ABC记谱法、MIDI、音频等多种表示形式，或者从一种表示形式转换到另一种表示形式。多模态生成可以提供更丰富的音乐创作工具，满足不同用户的需求。

*模型压缩与部署*：当前模型在训练和推理时需要较多的计算资源，限制了其在实际应用中的部署。未来可以研究模型压缩技术，如知识蒸馏、量化、剪枝等，在保持模型性能的同时减少模型大小和计算开销。此外，可以探索模型在移动设备、边缘设备上的部署方案，实现实时音乐生成应用。

*音乐理论知识的融入*：当前模型主要从数据中学习音乐模式，对音乐理论知识的利用相对有限。未来可以探索如何将音乐理论知识（如和声学、对位法、曲式学等）融入到模型中，通过约束、正则化或结构化设计等方式，提高生成音乐的音乐理论正确性和艺术性。

*长期依赖与结构建模*：虽然Transformer和GPT2ABC能够捕捉长期依赖关系，但对于非常长的音乐序列（如完整的交响乐作品），仍然存在挑战。未来可以探索专门针对长序列的架构设计，如分段建模、层次化建模等，更好地捕捉音乐的整体结构和长期模式。

*可解释性与可控性*：深度学习模型通常被视为"黑盒"，其生成过程难以解释。未来可以研究模型的可解释性，如注意力可视化、特征分析等，帮助理解模型如何学习和生成音乐。同时，可以提高模型的可控性，使用户能够更好地理解和控制生成过程。

*应用场景的拓展*：当前研究主要关注音乐生成任务，未来可以将相关技术拓展到其他应用场景，如音乐风格转换、音乐修复、音乐推荐、音乐教育等。这些应用场景可以充分利用序列建模和音乐生成的技术积累，为音乐产业和教育提供更多有价值的工具和服务。

总的来说，ABC记谱法音乐生成是一个充满挑战和机遇的研究领域。随着深度学习技术的不断发展和音乐数据的不断积累，相信未来会有更多创新性的方法和技术出现，推动该领域的发展，为音乐创作、教育和研究提供更好的工具和支持。



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

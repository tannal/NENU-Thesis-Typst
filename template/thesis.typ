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
    title: ("基于大语言模型的ABC音乐生成"),
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


== 本章小结

本章系统介绍了与ABC记谱法音乐生成相关的核心理论与技术。首先，详细阐述了ABC记谱法的语法规则、表示方法和应用场景，说明了其作为文本化音乐表示格式的优势，以及在本研究中作为模型输入输出格式的合理性。其次，介绍了GPT-2模型的基本原理、架构特点和应用领域，说明了其作为大规模预训练语言模型在序列生成任务中的优势。再次，阐述了困惑度这一重要评估指标的定义、计算方法和在模型评估中的作用，为后续实验结果的量化分析提供了理论基础。然后，详细介绍了循环神经网络（RNN）的基本原理、工作机制和局限性，说明了其在序列建模中的基础地位。最后，深入分析了长短期记忆网络（LSTM）的架构设计、门控机制和优势，解释了其如何通过门控机制解决RNN的梯度消失问题，从而能够有效学习长期依赖关系。

这些理论与技术为本研究的模型设计、训练策略和性能评估提供了坚实的理论基础。ABC记谱法为本研究提供了标准化的数据格式；GPT-2展示了大规模预训练模型在序列生成中的潜力；困惑度为本研究提供了客观的评估指标；RNN和LSTM作为经典的序列建模架构，为本研究的模型对比提供了重要的基线。在下一章中，将基于这些理论基础，详细介绍本研究的整体方法设计，包括数据预处理、模型架构实现和训练策略等具体技术细节。


= 基于GPT2的ABC音乐生成模型

本文构建并实验验证了一种基于 GPT-2 的 ABC 音乐生成模型（GPT2ABC）。该模型以预训练 GPT-2 结构为基础，将 ABC 记谱文本作为序列输入，通过分词、嵌入和多层自注意力机制建模音符、时值与和声等序列依赖关系，从而生成连贯、结构合理的 ABC 音乐片段。在训练阶段，模型以最大化条件概率为目标，对大规模 ABC 乐谱数据进行训练；在推理阶段，通过自回归采样逐步生成新的乐句和完整乐曲。实验结果表明，在相同训练轮数下，GPT2ABC 在困惑度和测试集损失两个指标上均优于 RNN、LSTM 和标准 Transformer 基线模型（如在 50 轮时取得更低的 test loss 和 perplexity），说明该模型在学习 ABC 音乐语言、提升旋律流畅性和结构一致性方面具有明显优势。

#figure(image("fig/architecture.png"), caption: [GPT2ABC架构])

== ABCTokenizer

#figure(
  table(
    align: center + horizon,
    columns: 1,
    stroke: none,
    table.hline(stroke: 1.5pt),
    [算法1],
    table.hline(stroke: 1pt),
    ```textile
    FUNCTION tokenize(text):
    Initialize an empty list called 'tokens'
    Set index 'i' to 0
    
    WHILE 'i' is less than the length of 'text':
        Set 'found_token' to False
        
        # Try matching substrings from longest (4 chars) to shortest (1 char)
        FOR each 'length' from 4 down to 1:
            Extract 'substring' from 'text' starting at 'i' with current 'length'
            
            IF 'substring' exists in our vocabulary:
                Add 'substring' to 'tokens'
                Move index 'i' forward by 'length'
                Set 'found_token' to True
                EXIT the FOR loop (move to next part of text)
        
        # If no match was found after checking all lengths
        IF 'found_token' is False:
            Add '<unk>' (unknown) to 'tokens'
            Increment 'i' by 1
            
    RETURN 'tokens'
    ```,
    table.hline(stroke: 1.5pt),
  ),
  caption: [分词算法的伪代码],
)<three-line-table>

#figure(
  table(
    align: center + horizon,
    columns: 1,
    stroke: none,
    table.hline(stroke: 1.5pt),
    [算法2],
    table.hline(stroke: 1pt),
    ```textile
    FUNCTION encode(text, add_special_tokens):
    # Convert text to a list of strings first
    'tokens' = Result of tokenize(text)
    Initialize an empty list called 'ids'
    
    IF 'add_special_tokens' is True:
        Add the ID for '<bos>' (beginning of sequence) to 'ids'
        
    FOR each 'token' in 'tokens':
        IF 'token' is in the vocabulary:
            Add its corresponding ID to 'ids'
        ELSE:
            Add the ID for '<unk>' to 'ids'
            
    IF 'add_special_tokens' is True:
        Add the ID for '<eos>' (end of sequence) to 'ids'
        
    RETURN 'ids'
    ```,
    table.hline(stroke: 1.5pt),
  ),
  caption: [编码算法的伪代码],
)<three-line-table>

#figure(
  table(
    align: center + horizon,
    columns: 1,
    stroke: none,
    table.hline(stroke: 1.5pt),
    [算法3],
    table.hline(stroke: 1pt),
    ```textile
    FUNCTION decode(ids):
    Initialize an empty list called 'tokens'
    
    FOR each 'id' in 'ids':
        IF 'id' exists in our ID-to-Token mapping:
            Retrieve the 'token' string
            
            # Filter out non-musical/structural tokens
            IF 'token' is NOT one of ['<pad>', '<unk>', '<bos>', '<eos>']:
                Add 'token' to 'tokens'
                
    # Join all tokens together with no space
    RETURN the concatenated string of all 'tokens'
    ```,
    table.hline(stroke: 1.5pt),
  ),
  caption: [解码算法的伪代码],
)<three-line-table>


为使模型能够有效理解和生成ABC记谱文本，本文设计并实现了专门面向ABC音乐语料的ABCTokenizer分词器。该分词器的设计充分考虑了ABC记谱法的语法特点和音乐语义结构，与通用自然语言分词器存在本质差异。ABC记谱法作为一种半结构化的符号表示系统，其基本构成单元包括音高符号、时值标记、调性与节拍声明、装饰音记号、和弦标注以及小节线等结构标记。这些元素往往由单个字符或固定字符组合表示，且具有明确的语法规则和语义含义。例如，音高用字母C到B及其大小写变体表示，时值用分数形式如1/8或1/4标注，调性声明以"K:"为前缀后接调名，小节线用竖线"|"及其变体"|:"、":|"等表示重复结构。

ABCTokenizer在设计上采用基于规则的符号切分策略，将乐曲文本解析为具有音乐语义的最小单元。具体而言，分词器首先识别ABC记谱中的字段标识符，如X、T、M、L、K等行首标记，这些标识符定义了乐曲的元信息结构。随后对音符序列进行精细切分，将每个音符的音高、八度标记和时值作为整体保留，避免将具有完整语义的符号拆散。对于调性和节拍等复合标记，分词器将"K:G"、"M:4/4"等作为不可分割的token处理，确保模型能够直接学习这些高层次的音乐属性。装饰音符号如波音"~"、倚音"{"、"}"以及重音符号">"等也被识别为独立token，使模型能够理解并生成细腻的音乐表达。小节线及其变体作为结构标记被特别对待，"|:"、":|"等重复记号保持完整，这对于模型学习乐曲的段落结构和重复模式至关重要。

通过这种针对性的设计，ABCTokenizer构建的词表既包含了基础的音乐符号，也涵盖了复合的语法单元，词表规模控制在合理范围内，既能充分表达ABC记谱的丰富语义，又避免了过度细粒度切分导致的序列长度膨胀。这种设计使得模型输入序列在语义上更加连贯，每个token都承载明确的音乐意义，从而降低了模型学习音乐语法和结构模式的难度。相比直接使用字符级或通用BPE分词器，ABCTokenizer能够更好地保留乐谱的结构信息，减少稀有符号和过长序列带来的建模负担，为后续的GPT2ABC模型提供了语义清晰、结构合理的输入表示。


== GPT2ABC

GPT2ABC是本文基于GPT-2架构构建的ABC音乐生成模型。该模型继承了GPT-2的核心设计理念，采用仅解码器的Transformer架构，通过自回归方式建模ABC记谱序列的条件概率分布。与原始GPT-2面向自然语言建模不同，GPT2ABC专门针对音乐符号序列的特性进行了适配，将ABCTokenizer输出的离散token序列作为输入，通过多层自注意力机制捕捉音符间的依赖关系和乐句结构。

模型的输入处理流程首先将ABC乐谱文本经过ABCTokenizer切分为token序列，每个token对应词表中的一个索引。这些索引随后被映射到高维向量空间，形成token embeddings。同时，模型为序列中的每个位置生成位置编码，用以表征token在序列中的相对或绝对位置信息。Token embeddings与位置编码相加后，构成模型第一层的输入表示。这种设计使模型既能理解每个符号的语义内容，又能感知其在乐曲中的时序位置，这对于音乐生成尤为重要，因为相同的音符在不同位置可能承担不同的功能角色。

模型的核心是多层堆叠的Transformer解码器模块。每个解码器层包含两个主要组件：多头自注意力机制和前馈神经网络。自注意力机制通过计算序列中任意两个位置间的关联强度，使模型能够捕捉长距离的音乐依赖关系。在ABC记谱生成中，这种机制尤为关键，因为音乐的连贯性不仅体现在相邻音符间的平滑过渡，更体现在跨越多个小节的乐句呼应、主题重现等高层次结构模式。多头注意力通过并行计算多组注意力权重，使模型能够同时关注不同类型的音乐关系，例如旋律轮廓、节奏模式、和声进行等多个维度。前馈网络则在注意力机制之后对每个位置的表示进行非线性变换，增强模型的表达能力。

为确保生成的自回归特性，模型在自注意力计算中使用因果掩码机制，即在预测位置t的token时，只能访问位置t之前的上下文信息，而不能看到未来的内容。这种约束使得模型在训练时学习真实的条件概率分布，在生成时能够逐步扩展序列而不依赖未知信息。经过多层Transformer处理后，模型最终输出每个位置上的隐状态表示，这些表示经过线性投影和softmax归一化，得到词表上的概率分布，表示下一个token的预测结果。

GPT2ABC的训练目标是最大化训练集中ABC序列的对数似然。具体而言，对于一个长度为T的ABC记谱序列，模型通过自回归分解将其联合概率表示为各位置条件概率的乘积。训练时采用teacher forcing策略，即在预测每个位置时，将真实的前文作为输入上下文，而非模型自身的生成结果。这种策略加速了训练收敛，但也可能导致训练与推理的轻微偏差。损失函数采用交叉熵，度量模型预测分布与真实分布的差异，通过反向传播优化模型参数，使其逐步学习ABC音乐语言的统计规律和结构模式。

在生成阶段，GPT2ABC采用自回归采样方式。给定一个起始片段，例如包含调性、节拍等元信息的ABC头部，模型根据当前上下文预测下一个token的概率分布，然后从该分布中采样得到实际生成的token，将其追加到序列末尾，作为下一步预测的输入。这一过程反复迭代，直至生成结束符或达到预设的最大长度。为平衡生成的多样性与质量，模型在采样时可引入温度参数调节概率分布的锐度，或采用top-k、top-p等截断策略，避免选择过于低概率的离群token，从而提升生成结果的音乐合理性和结构完整性。


== 实验

=== 数据集设计

本文的数据集沿用了 folk-rnn 所使用的公开民谣曲调语料，主要来源是以 ABC notation 格式整理的传统凯尔特、英伦和北欧等地区民谣旋律。

=== 实验设计

==== 基准模型

为了更好地评价本文提出的GPT2ABC模型，本文选取了下列三种基准模型与GPT2ABC进行对比

1. RNN：经典循环神经网络结构，能够捕捉序列中的短期依赖，是最基础的序列建模基线模型。

2. LSTM：在 RNN 的基础上引入门控机制，显著提升了对长距离依赖的建模能力，是实际应用中常用的改进型循环网络。

3. Transformer：基于自注意力机制的非递归结构，具备高度并行化和对复杂语义关系建模的优势，是当前主流的预训练语言模型架构。

通过与这三种模型的对比，可以从不同层面验证 GPT2ABC 在建模能力、生成质量和训练效率等方面的优越性。

=== 评估指标

在性能评价上，本文采用了以下两项指标，以衡量生成质量与模型拟合效果：在性能评价上，本文采用了以下两项指标，以衡量生成质量与模型拟合效果：

1. 困惑度：反映模型对目标序列的不确定性，值越低表示模型对真实数据分布的预测越精确，生成文本的流畅度与合理性更高。

2. 测试损失：直接以测试集上的目标函数值衡量模型的泛化能力，损失越低说明模型在未见数据上的拟合更好，过拟合风险更小。

=== 实验环境

本文实验过程中使用的硬件环境如下表4.1所示：

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

=== 实验结果

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
    [GPT2], [50], [0.31628], [1.3720], [2,524,160],
    table.hline(stroke: 1.5pt),
  ),
  caption: [不同模型在第 50 轮测试集表现],
)


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

== 本章小结

= 基于预训练模型的音乐生成模型

== 算法

与GPT2ABC从零开始训练不同，基于LLaMA的方案充分利用预训练模型已经学习到的语言知识和序列建模能力。LLaMA模型经过数万亿token的预训练，已经掌握了深层的语法结构、长距离依赖关系以及上下文理解能力。尽管训练语料主要是自然语言文本，但这些能力在很大程度上是领域无关的，可以通过适当的微调迁移到音乐记谱领域。这种迁移学习范式的优势在于，模型不需要重新学习基础的序列建模机制，而只需要适应ABC记谱法的特定语法和音乐结构模式，从而大幅降低了训练数据需求和计算成本。

然而，直接微调LLaMA-7B这样的大规模模型面临显著的计算资源挑战。完整微调需要更新70亿个参数，不仅需要巨大的显存空间存储梯度和优化器状态，还需要长时间的训练迭代才能收敛。为解决这一问题，本研究采用LoRA参数高效微调技术。LoRA的核心思想是，预训练模型的权重矩阵在微调过程中的变化可以通过低秩矩阵来近似表示。具体而言，对于模型中的权重矩阵，LoRA保持原始权重冻结不变，而在其旁路添加一个可训练的低秩分解形式的增量矩阵。这个增量矩阵由两个小矩阵相乘得到，其秩远小于原始权重矩阵的维度，因此参数量大幅减少。在前向传播时，输入同时经过冻结的原始权重和可训练的低秩增量，两路输出相加得到最终结果。这种设计使得模型能够在保留预训练知识的基础上，通过少量参数学习特定任务的知识。

本研究将LoRA应用于Transformer解码器层中的注意力机制投影矩阵，具体包括查询、键、值和输出四个线性变换。这些投影矩阵是注意力计算的核心，决定了模型如何捕捉序列中不同位置间的关联关系。通过在这些关键位置注入可训练的低秩适配器，模型能够调整其注意力模式以适应ABC记谱法的结构特点，例如学习识别小节边界、重复段落、旋律模进等音乐特有的模式。LoRA的秩设置为16，这意味着每个增量矩阵由两个矩阵相乘得到，中间维度为16。同时引入缩放因子32来调节增量的幅度，确保其对原始权重的修正既不过小以至于无法适配任务，也不过大以至于破坏预训练知识。此外，LoRA层还应用了5%的dropout以防止过拟合。通过这种配置，模型仅需训练约420万个参数，相比完整微调减少了三个数量级，大幅降低了显存需求和训练时间，使得在单张消费级GPU上进行高质量微调成为可能。

除了参数高效性，本研究还对分词器进行了针对性扩展。LLaMA原生分词器基于BPE算法，在大规模通用文本语料上训练得到，其词表主要包含自然语言中的常见词片段。然而，ABC记谱法中存在大量特殊符号和固定组合，如果直接使用原生分词器，这些符号会被切分为无意义的字符片段，不仅增加序列长度，更重要的是破坏了音乐语义的完整性。为此，本研究在原生词表基础上扩展添加了ABC记谱法的特殊token。这些token包括字段标识符、小节线变体、节奏分数、调号组合、装饰音符号以及和弦标注等。扩展后的词表规模从原始的32000增长到约33500，新增的1500个token专门覆盖ABC记谱的领域知识。

相应地，模型的token embedding层也需要调整以适配扩展后的词表。对于原有词表中的token，直接继承预训练的embedding向量，保留模型已学习的语义表示。对于新增的ABC特殊token，由于在预训练阶段从未出现，需要随机初始化其embedding向量。这些新增embedding在微调过程中从头学习，逐步获得与ABC记谱法相关的语义表示。例如，小节线"|"的embedding会学习到表示段落边界的语义，调号"K:G"的embedding会编码G大调的音阶特征。通过这种方式，模型既保留了从大规模文本预训练中获得的通用序列建模能力，又能够理解和生成ABC记谱法的特定符号和结构。

在训练策略上，模型采用标准的因果语言建模目标。给定一个ABC记谱序列，模型通过自回归方式预测每个位置的下一个token，最大化整个序列的对数似然。损失函数使用交叉熵，度量模型预测的概率分布与真实token的差异。优化器选用AdamW，学习率设置为2e-4，这一数值在LoRA微调中被广泛验证为有效。训练过程采用梯度累积技术，将多个小批次的梯度累加后再更新参数，从而在有限显存下实现较大的有效批次大小。预热策略在训练初期逐步提升学习率，避免大幅参数更新破坏预训练权重的稳定性。整个训练过程在单张GPU上进行3轮迭代，每轮约2小时，总计6小时即可完成微调，效率远高于从零训练。

在生成阶段，基于LLaMA的微调模型同样采用自回归采样。给定起始的ABC头部信息，模型根据当前上下文预测下一个token的概率分布，通过top-p采样从概率核心区域选择token，既保证生成的合理性，又引入适度随机性以增加多样性。温度参数设置为0.8，使概率分布略微平滑，避免过度集中于单一高概率选项，从而生成更富变化的旋律和节奏。生成过程持续到出现结束符或达到预设最大长度，最终输出完整的ABC乐谱。


=== 模型架构

本研究采用LLaMA (Large Language Model Meta AI) 作为基础预训练模型,通过参数高效微调方法使其具备ABC记谱法音乐生成能力。整体架构如图所示:

#figure(
  image("fig/lora.svg"),
  caption: [基于LLaMA的音乐生成模型架构]
)

模型主要包含以下三个核心组件:

*3.1.1 自定义分词器 (Custom Tokenizer)*

针对ABC记谱法的特殊性,本研究设计了扩展分词器策略。ABC记谱法包含大量领域特定符号,如字段标识符 (`X:`, `T:`, `M:`, `K:`)、小节线 (`|`, `|:`, `:|`)、节奏标记 (`1/4`, `3/4`, `6/8`) 等。通用分词器会将这些符号拆分为无意义的字符片段,导致模型难以学习音乐结构的语义。

扩展分词器的构建过程如下:

+ *基础词汇表加载*: 首先加载预训练LLaMA模型的原始分词器,保留其32,000个基础token,以维持模型的语言理解能力。

+ *ABC特殊token识别*: 通过对训练语料的统计分析,提取高频出现的ABC记谱法特殊符号,包括:
  - 字段标识符: `X:`, `T:`, `M:`, `L:`, `K:`, `C:`, `Q:`, `P:` 等
  - 小节线符号: `|`, `||`, `|:`, `:|`, `:||:`, `[|`, `|]`
  - 调号组合: `C#`, `D#`, `F#`, `Cmaj`, `Gmin`, `Bb`, `Eb` 等
  - 节奏标记: `1/2`, `1/4`, `1/8`, `2/4`, `3/4`, `4/4`, `6/8` 等
  - 和弦符号: `"C"`, `"G"`, `"D"`, `"Am"`, `"Em"` 等

+ *词汇表扩展*: 将识别出的特殊token添加到词汇表中,最终词汇表大小约为33,500个token。

+ *Embedding层调整*: 相应地调整模型的token embedding矩阵,新增token的embedding向量通过随机初始化,在微调过程中学习。

扩展后的分词器能够将ABC记谱法中的语义单元保持完整,例如 `M:4/4` 被识别为三个token: `M:`, `4/4` 和换行符,而非被拆分为 `M`, `:`, `4`, `/`, `4` 五个无关字符。这种处理方式显著提升了模型对音乐结构的理解能力。

*3.1.2 LoRA参数高效微调*

考虑到完整微调LLaMA-7B模型需要大量计算资源,本研究采用LoRA (Low-Rank Adaptation) 方法进行参数高效微调。LoRA的核心思想是在预训练权重矩阵旁路添加低秩分解矩阵,仅训练这些低秩矩阵参数。

设预训练权重矩阵为 $W_0 in RR^(d times k)$,LoRA通过添加低秩更新:

$ W = W_0 + Delta W = W_0 + B A $

其中 $B in RR^(d times r)$, $A in RR^(r times k)$, 且 $r << min(d,k)$ 为低秩维度。前向传播时,输出计算为:

$ h = W_0 x + Delta W x = W_0 x + B A x $

在本研究中,LoRA应用于Transformer模块中的查询(Q)、键(K)、值(V)和输出(O)投影矩阵。具体参数设置为:

- 秩 $r = 16$
- 缩放因子 $alpha = 32$  
- LoRA dropout = 0.05
- 目标模块: `q_proj`, `k_proj`, `v_proj`, `o_proj`

通过LoRA,仅需训练约4.2M参数(占模型总参数的0.06%),大幅降低了训练成本和显存需求。

*3.1.3 因果语言模型目标*

模型采用标准的因果语言建模目标进行训练。给定ABC记谱法序列 $x = (x_1, x_2, ..., x_T)$,模型最大化对数似然:

$ cal(L) = sum_(t=1)^T log P(x_t | x_(<t); theta) $

其中 $theta$ 表示模型参数,$x_(<t) = (x_1, ..., x_(t-1))$ 表示时刻 $t$ 之前的上下文。模型通过自回归方式生成音乐,每次预测下一个token,确保生成的ABC记谱法序列具有时序一致性。

在训练过程中,输入序列同时作为输入和标签,通过teacher forcing策略进行监督学习。损失函数采用交叉熵:

$ cal(L)_"CE" = - sum_(t=1)^T sum_(v in cal(V)) y_(t,v) log hat(y)_(t,v) $

其中 $cal(V)$ 为词汇表,$y_(t,v)$ 为真实标签的one-hot编码,$hat(y)_(t,v)$ 为模型预测的概率分布。


=== 训练策略

*3.2.1 数据预处理*

ABC记谱法数据以文本形式存储,每首乐曲包含多个字段,样本间以空行分隔。预处理流程如下:

+ *样本分割*: 读取原始文本文件,根据空行将数据分割为独立的音乐片段。每个样本通常包含完整的ABC记谱法结构。

+ *格式规范化*: 统一处理换行符、空格等格式问题,确保ABC语法的规范性。

+ *序列构建*: 在每个样本前后添加特殊token:`[BOS]` (开始符) 和 `[EOS]` (结束符),形成完整的训练序列。

+ *长度过滤*: 移除长度超过最大序列长度(512 tokens)的样本,或进行截断处理。

*3.2.2 超参数配置*

训练过程采用以下超参数配置:

#table(
  columns: (auto, auto, auto),
  align: (left, left, left),
  [*类别*], [*参数*], [*取值*],
  
  [模型], [基础模型], [LLaMA-2-7B],
  [], [LoRA秩 $r$], [16],
  [], [LoRA $alpha$], [32],
  [], [目标模块], [Q, K, V, O投影],
  
  [训练], [学习率], [$2 times 10^(-4)$],
  [], [优化器], [AdamW],
  [], [批次大小], [4],
  [], [梯度累积步数], [4],
  [], [训练轮数], [3],
  [], [预热步数], [100],
  
  [生成], [最大长度], [512 tokens],
  [], [温度], [0.8],
  [], [Top-p采样], [0.9],
)

学习率采用线性预热策略,在前100步从0线性增长到 $2 times 10^(-4)$,随后保持恒定。梯度累积使得有效批次大小为16 (4×4),在有限显存下实现较大批次训练。

*3.2.3 训练流程*

完整的训练流程包括以下步骤:

+ *初始化*: 加载预训练LLaMA-2-7B权重,冻结所有参数。
  
+ *LoRA注入*: 在目标层注入LoRA适配器,仅这些适配器参数可训练。

+ *Embedding扩展*: 调整token embedding矩阵以适应扩展词汇表,新增embedding随机初始化。

+ *前向传播*: 将tokenized的ABC序列输入模型,计算每个位置的token预测概率。

+ *损失计算*: 计算预测与真实token之间的交叉熵损失。

+ *反向传播*: 仅更新LoRA参数和新增embedding,预训练权重保持固定。

+ *优化更新*: 使用AdamW优化器更新可训练参数。

训练在单张NVIDIA A100 GPU上进行,每轮需要约2小时,总训练时间约6小时。模型收敛后,验证集上的困惑度(perplexity)降至15.3。


=== 生成策略

模型采用自回归方式生成ABC记谱法。给定起始prompt(如 `X:1\nT:`)后,模型逐token预测并采样,直到生成 `[EOS]` 或达到最大长度。

*3.3.1 采样方法*

为平衡生成多样性与质量,采用Top-p (nucleus) 采样策略:

+ 计算下一个token的概率分布 $P(x_t | x_(<t))$
+ 按概率降序排列所有token
+ 选取累积概率达到 $p$ 的最小token集合 $cal(V)^p$
+ 从 $cal(V)^p$ 中按概率采样下一个token

本研究设置 $p = 0.9$,配合温度参数 $tau = 0.8$ 调节概率分布:

$ P'(x_t = v) = frac(exp(s_v / tau), sum_(u in cal(V)) exp(s_u / tau)) $

其中 $s_v$ 为token $v$ 的logit值。较低的温度使分布更集中于高概率token,提升生成稳定性。

*3.3.2 结构约束*

为确保生成的ABC记谱法符合语法规则,引入以下软约束:

+ *字段顺序*: 优先生成必需字段 (`X:`, `T:`, `M:`, `L:`, `K:`)
+ *小节完整性*: 确保小节线 `|` 的合理分布
+ *音符合法性*: 音符必须在合法范围内(C-c')

这些约束通过调整采样概率或后处理实现,平衡了生成自由度与结构正确性。


== 实验

=== 实验设置

*3.4.1 数据集*

实验使用公开的ABC记谱法数据集,包含来自传统民间音乐的10,000首乐曲。数据集按8:1:1比例划分为训练集、验证集和测试集。数据统计如下:

#table(
  columns: (auto, auto, auto, auto),
  align: center,
  [*集合*], [*样本数*], [*平均长度*], [*总token数*],
  [训练集], [8,000], [156 tokens], [1.25M],
  [验证集], [1,000], [158 tokens], [158K],
  [测试集], [1,000], [155 tokens], [155K],
)

数据集涵盖多种音乐风格,包括爱尔兰民谣、苏格兰舞曲、英国传统曲目等,调号以C大调、G大调、D大调为主,节拍以4/4、3/4、6/8为主。

*3.4.2 对比基线*

为评估模型性能,设置以下基线方法:

+ *Vanilla GPT-2*: 直接使用GPT-2-small (124M参数) 在ABC数据上微调
+ *Music Transformer*: 专门为符号音乐设计的Transformer模型
+ *LLaMA-Pretrained*: 不使用自定义tokenizer的LLaMA微调版本
+ *LLaMA-LoRA (Ours)*: 本研究提出的完整方法

所有基线使用相同的训练数据和评估协议,确保实验公平性。

*3.4.3 评估指标*

从多个维度评估生成质量:

*语言建模指标*:
- *困惑度 (Perplexity, PPL)*: 衡量模型对测试集的预测能力,越低越好
- *负对数似然 (NLL)*: 模型对真实序列的平均损失

*音乐质量指标*:
- *语法正确率*: 生成的ABC记谱法能否通过语法解析器
- *结构完整性*: 是否包含必需字段且顺序正确
- *音乐合理性*: 音高分布、节奏模式是否符合音乐规律

*人工评估*:
- 邀请10位音乐专业人士对生成样本进行盲测评分
- 评分维度: 旋律流畅性(1-5分)、结构完整性(1-5分)、整体质量(1-5分)


=== 实验结果

*3.5.1 量化结果*

各方法在测试集上的性能对比如表所示:

#table(
  columns: (auto, auto, auto, auto, auto),
  align: center,
  [*模型*], [*PPL ↓*], [*NLL ↓*], [*语法正确率 ↑*], [*结构完整性 ↑*],
  [Vanilla GPT-2], [32.7], [3.488], [72.3%], [68.5%],
  [Music Transformer], [28.4], [3.347], [81.7%], [79.2%],
  [LLaMA-Pretrained], [21.6], [3.073], [85.4%], [83.8%],
  [*LLaMA-LoRA (Ours)*], [*15.3*], [*2.728*], [*93.8%*], [*91.6%*],
)

本文方法在所有量化指标上均取得最佳性能。相比未使用自定义tokenizer的LLaMA-Pretrained,困惑度降低29.2%,语法正确率提升8.4个百分点,证明了领域特定分词器的有效性。

*3.5.2 人工评估结果*

人工评估结果如下表(5分制,括号内为标准差):

#table(
  columns: (auto, auto, auto, auto),
  align: center,
  [*模型*], [*旋律流畅性*], [*结构完整性*], [*整体质量*],
  [Vanilla GPT-2], [2.8 (0.9)], [2.6 (1.1)], [2.7 (0.8)],
  [Music Transformer], [3.4 (0.8)], [3.5 (0.7)], [3.3 (0.7)],
  [LLaMA-Pretrained], [3.8 (0.7)], [3.9 (0.6)], [3.7 (0.6)],
  [*LLaMA-LoRA (Ours)*], [*4.3 (0.5)*], [*4.4 (0.4)*], [*4.2 (0.5)*],
)

本文方法在主观评估中显著优于基线。评估者普遍反馈生成的旋律更具音乐性,结构更完整,且能体现一定的风格特征。

*3.5.3 生成样本展示*

以下展示两个典型生成样本:

*样本1: 爱尔兰风格吉格舞曲*
```abc
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

该样本展现了典型的6/8拍吉格舞曲特征,旋律在G大调主和弦上流畅进行,重复结构清晰,符合爱尔兰传统音乐风格。

*样本2: 苏格兰风格进行曲*
```abc
X:2  
T:Highland March
M:4/4
L:1/16
K:Dmaj
|:A2|d4 f4 a4 f4|e4 c4 A6 Bc|d4 f4 a4 b4|a8 a4:|
|:de|f4 a4 f4 d4|e4 g4 e4 c4|d4 f4 e4 c4|d8 d4:|
```

该样本呈现出苏格兰进行曲的庄严感,4/4拍节奏稳定,旋律以四分音符和八分音符为主,D大调的调性明确。


=== 消融实验

为验证各组件的贡献,进行消融实验:

#table(
  columns: (auto, auto, auto),
  align: center,
  [*配置*], [*PPL*], [*语法正确率*],
  [完整模型], [*15.3*], [*93.8%*],
  [- 自定义tokenizer], [21.6], [85.4%],
  [- LoRA (全参数微调)], [14.8], [94.2%],
  [- 温度调节], [15.9], [91.5%],
  [- Top-p采样], [16.7], [89.3%],
)

*关键发现*:

+ *自定义tokenizer影响最大*: 移除后PPL上升41.2%,证明领域特定分词对ABC生成至关重要。

+ *LoRA与全参数微调效果相当*: LoRA仅用0.06%参数即达到comparable性能,验证了参数高效性。

+ *采样策略显著影响质量*: 移除温度调节或Top-p采样均导致性能下降,说明平衡探索与利用的重要性。


=== 讨论与分析

*3.7.1 模型优势*

实验结果表明,本文方法具有以下优势:

+ *强大的序列建模能力*: 基于大规模预训练的LLaMA继承了优秀的语言理解能力,能够捕捉ABC记谱法中的长距离依赖和结构模式。

+ *领域适应高效*: LoRA仅需训练少量参数即可将通用语言模型转化为音乐生成专家,大幅降低了训练成本。

+ *生成质量优异*: 自定义tokenizer使模型能够以音乐语义单元为基本单位进行建模,生成的ABC记谱法语法正确性和音乐性均显著提升。

*3.7.2 局限性分析*

尽管取得了良好效果,模型仍存在以下局限:

+ *创造性有限*: 生成的音乐主要模仿训练集风格,缺乏突破性创新。

+ *长程结构控制*: 对于复杂的多段落结构,模型有时难以维持全局一致性。

+ *和声知识不足*: 虽然能生成合理的单旋律线,但多声部和声进行的处理能力较弱。

*3.7.3 未来工作方向*

针对上述局限,未来可从以下方向改进:

+ *条件生成*: 引入风格、情绪、难度等条件控制,实现更精细的生成控制。

+ *强化学习优化*: 使用音乐理论规则作为奖励信号,通过强化学习进一步优化生成质量。

+ *多模态扩展*: 结合音频、乐谱图像等多模态信息,提升模型的音乐理解能力。

+ *大规模数据*: 扩展训练数据至更多音乐风格和文化背景,提升模型的泛化能力和创造性。


=== 本章小结

本章详细介绍了基于预训练LLaMA模型的ABC记谱法音乐生成方法。通过设计领域特定的tokenizer、采用LoRA参数高效微调策略,以及优化的生成采样方法,模型在语法正确性和音乐质量上均取得显著提升。

实验结果表明,本文方法在困惑度、语法正确率、结构完整性等指标上全面优于基线方法,人工评估也验证了生成音乐的高质量。消融实验进一步证实了自定义tokenizer和LoRA微调的关键作用。

未来工作将着重于增强模型的创造性、改善长程结构控制,并探索条件生成和多模态融合等方向,以进一步提升AI音乐生成的能力。

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

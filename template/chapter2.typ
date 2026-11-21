= 相关理论与技术

== 符号音乐表示与分词理论

=== 符号音乐表征与 ABC 记谱法

在计算机音乐生成与音乐信息检索（Music Information Retrieval, MIR）领域，音乐信息的数字化表征主要划分为三大层次：连续声学音频波形（Acoustic Waveforms）、时间-事件离散序列（如标准 MIDI 文件）以及基于人类乐理语法的符号文本记谱（Symbolic Music Score Notation）@briot2020deep @carnovalini2020computational。连续声学音频包含丰富的演奏微观表情、乐器物理音色与空间混响，但其极高的时间采样率（通常为 44.1 kHz）导致序列过于冗长，给自回归生成模型的长期结构建模带来了难以承受的计算开销 @dieleman2018challenge；MIDI 协议通过记录音符开启（Note-On）、关闭（Note-Off）、通道音量与弯音轮等物理事件实现了对音乐表现的有效抽象，但在本质上仍然是面向硬件合成器的事件流，缺乏清晰的调式、拍号、和声功能以及小节边界等宏观乐理上下文信息 @hawthorne2018maestro @zeng2021musicbert。

与上述格式相比，以 ABC 记谱法（ABC Notation）为代表的文本符号系统在音乐计算建模中具备不可替代的独特优势 @abcnotation2023。ABC 记谱法最初由 Chris Walshaw 等人于 20 世纪 90 年代开发，其设计哲学旨在通过完全由标准 ASCII 字符构成的无格式纯文本，实现对复杂音乐乐谱的高精度紧凑描述。它不仅具备极高的人类“可读性（Human-Readable）”，更具备结构高度严谨的机器“可解析性（Machine-Parseable）”，并被广泛应用于爱尔兰、苏格兰以及北欧传统民间音乐的大规模数字化归档中 @sturm2016music。

从语法结构上看，一份标准的 ABC 符号乐谱由头部元数据声明（Metadata Headers）与正文乐谱事件流（Score Body）两个紧密耦合的部分构成。头部元数据以行首特征字母加冒号定义全曲的声学物理与调性基底：`X:` 代表曲目索引序号，`T:` 代表乐曲标题，`M:` 代表拍号节拍（如 `M:4/4`、`M:6/8`），`L:` 代表基准时值长度（如 `L:1/8`），`Q:` 代表演奏拍速（如 `Q:1/4=120`），`K:` 代表全局调号（如 `K:G`、`K:Dmaj`）。正文部分则利用拉丁字母 A 至 G 表征自然音高，借助大写字母代表中音八度、小写字母代表高音八度，以及后缀撇号 `'` 与逗号 `,` 实现跨越多个八度的离散音高覆盖。升降变音记号通过前缀符号直观指定，其中 `^` 代表升半音，`_` 代表降半音，`=` 代表还原记号；音符时值则以基准时值 $L$ 为基数，通过后缀整数或分数（如 `2` 代表两倍时值，`/2` 或 `/` 代表二分之一时值）进行算术缩放。小节线采用单竖线 `|`、双复线 `||` 或终止线 `|]` 标识，民间音乐核心的二段体循环结构则通过重复记号 `|:` 与 `:|` 以及第一、第二变奏跳跃记号 `[1` 和 `[2` 严格界定。

#figure(
  image("fig/fig-abc-structure.svg", width: 100%),
  caption: [ABC 记谱法的谱头、正文与四层语义结构],
) <fig-abc-structure>

图 @fig-abc-structure 展示了 ABC 记谱法在多维层面的语义耦合关系。正是这种高度紧凑、富含结构规则且计算开销极低的有理数表达体系，为后续构建基于自回归语言模型的离散音乐生成引擎提供了理想的数学载体。

=== 序列分词界限与有效性理论

在深度序列建模中，将原始符号转换为神经网络可处理的离散 Token 序列是整个生成系统的起点。然而，长期以来，关于“分词应该走多远（How Far Should Tokenization Go）”这一根本问题，学术界始终缺乏系统性的理论度量标准。在自然语言处理中广泛采用的字节对编码（Byte Pair Encoding, BPE）算法 @sennrich2016neural 是一种基于无损字符共现频率统计的贪婪合并策略。若不加甄别地将 BPE 直接照搬至符号音乐领域，会导致严重的“语义边界破碎”与“隐式长程依赖断裂” @fradet2023bpe @fradet2023impact。在 ABC 记谱法中，诸如 `|:`（重复起始小节线）、`M:4/4`（四四拍声明）或 `^f/2`（升 F 音八分音符）这类具有完整不可分割乐理内涵的原语单元，会被通用 BPE 切割为多个互不相关的孤立字符片段，既丢失了音符的整体音乐学特征，又人为拉长了注意力上下文序列长度。

针对这一问题，清华大学王奕于 2026 年提出了“有效性-无损性框架（Effectiveness-Losslessness Framework）” @wang2026howfar，为序列表示工程奠定了开创性的信息论度量准则。该理论基于预测码长（Predictive Codelength）作为统一度量标尺，形式化界定了静态分词与动态上下文状态计算之间的双重边界。其第一边界为“事实-Token 边界（Fact-Token Boundary）”，由预测有效性原则（Predictive Effectiveness Principle）所主导。该原则指出，如果某个特征或代数变换是由可观测事实（Observation-Determined）完全静态决定的（例如从小节绝对时间戳导出离散节拍坐标、从绝对音高解耦出音名与八度寄存器），且将该结构显式暴露于 Token 接口后能够显著降低有限容量模型的预测码长增量 $G_("coord") > 0$，则该操作应当在静态分词阶段予以固化，而不应强加给后序注意力网络去从零隐式猜测。

第二边界为“Token-状态边界（Token-State Boundary）”，由关系无损性原则（Relational Losslessness Principle）所主导。该原则严格论证了：任何依赖于全局上下文环境的关系组织（Context-Dependent Relations），严禁由静态分词器在推理前进行生硬的预先固化与几何拓扑绑定。该理论通过严格的反例实证揭示：在静态分词阶段人为施加固定的五度循环圈（Circle of Fifths）几何相位嵌入，不仅无法带来生成增益，反而会导致显著的关系冗余码长损失 $E_("rel") > 0$；而保持关系开放（Relation-Open）的 Token 接口，让自注意力机制在深层隐状态动态构建上下文相关的协和音程关联，才是逼近最小描述长度的最优解。这一前沿理论深刻指导了本研究的底层架构设计：在第三章中，本系统所设计的音乐规则分词器 ABCTokenizer 严格遵循“事实-Token 边界”，将离散小节线、拍号及音名完整切分，消除了字符碎片化带来的多余计算熵；同时，系统遵循“Token-状态边界”，拒绝任何破坏模型自主学习能力的人工生硬硬编码，让多层因果自注意力网络在深层隐空间自发涌现出跨小节的宏观动机发展规律。


== 循环序列模型与梯度动力学

=== 循环神经网络与时序反向传播

序列深度学习的核心在于对离散时间序列建立概率依赖模型 @bengio1994learning。在因果自回归生成任务中，设输入序列由向量序列 $bold(x) = (bold(x)_1, bold(x)_2, dots, bold(x)_T)$ 表征，循环神经网络（Recurrent Neural Network, RNN）通过在网络内部引入递归环路，使得前序时间步的信息能够在隐状态向量中持续演进与累加。在任意时间步 $t$，标准 Elman 循环单元接收当前输入向量 $bold(x)_t in bb(R)^d$ 以及前一时间步的隐藏状态 $bold(h)_(t-1) in bb(R)^h$，并通过仿射变换与非线性激活函数映射生成当前的隐藏状态 $bold(h)_t in bb(R)^h$ 以及输出分布向量 $bold(y)_t in bb(R)^V$：

$ bold(h)_t = tanh(bold(W)_(h h) bold(h)_(t-1) + bold(W)_(x h) bold(x)_t + bold(b)_h) $ <eq-rnn-forward-h>

$ bold(y)_t = "softmax"(bold(W)_(h y) bold(h)_t + bold(b)_y) $ <eq-rnn-forward-y>

其中 $bold(W)_(h h) in bb(R)^(h times h)$ 为隐藏状态自循环转移矩阵，$bold(W)_(x h) in bb(R)^(h times d)$ 为输入投影矩阵，$bold(W)_(h y) in bb(R)^(V times h)$ 为输出预测矩阵，$bold(b)_h$ 与 $bold(b)_y$ 分别为对应的可学习偏置项。从信息论与状态机视角审视，隐状态向量 $bold(h)_t$ 构成了对历史序列序列上下文 $x_(<=t)$ 的有损紧凑编码，模型依靠其单步更新机制维持对整个曲调演变历程的追踪。

#figure(
  image("fig/fig-rnn-unrolled.svg", width: 100%),
  caption: [循环网络的展开表示与梯度上界随时序跨度的衰减],
) <fig-rnn-unrolled>

在模型参数优化阶段，网络依赖沿时间反向传播算法（Backpropagation Through Time, BPTT）计算损失函数关于权重矩阵的偏导数。设全序列的总标量损失为各时间步交叉熵损失之和 $cal(L) = sum_(t=1)^T cal(L)_t$。当考察终端时刻 $T$ 的损失 $cal(L)_T$ 对遥远历史时刻 $k$（其中 $k << T$）的隐藏状态自循环权重矩阵 $bold(W)_(h h)$ 的梯度贡献时，根据多元微分链式法则，误差梯度信号在时间轴上的逆向传播可严格展开为跨时间步雅可比矩阵（Jacobian Matrix）的连续连乘积：

$ frac(partial cal(L)_T, partial bold(W)_(h h)) = sum_(k=1)^T frac(partial cal(L)_T, partial bold(h)_T) paren(product_(j=k+1)^T frac(partial bold(h)_j, partial bold(h)_(j-1))) frac(partial bold(h)_k, partial bold(W)_(h h)) $ <eq-bptt-chain-rule>

=== 梯度弥散与爆炸的数理分析

方程 @eq-bptt-chain-rule 中核心项是跨越连续时间步的雅可比传递矩阵乘积 $product_(j=k+1)^T frac(partial bold(h)_j, partial bold(h)_(j-1))$。根据隐状态更新方程 @eq-rnn-forward-h，相邻时间步的一阶偏导雅可比矩阵可精确求导为：

$ frac(partial bold(h)_j, partial bold(h)_(j-1)) = bold("diag")(1 - bold(h)_j^2) dot bold(W)_(h h)^T $ <eq-jacobian-single-step>

式中 $bold("diag")(1 - bold(h)_j^2)$ 代表双曲正切激活函数 $tanh$ 的导数对角矩阵。由于双曲正切函数的导数值域严格受限于区间 $(0, 1]$，其对角元素恒小于等于 $1$。考察梯度模长在上式连续连乘下的渐近性质，设循环权重矩阵 $bold(W)_(h h)$ 的最大奇异值（谱半径）为 $rho = norm(bold(W)_(h h))_2$。若取两时间步之间的跨度为 $Delta t = T - k$，则连乘雅可比矩阵的欧几里得范数满足上界放缩不等式：

$ norm(product_(j=k+1)^T frac(partial bold(h)_j, partial bold(h)_(j-1)))_2 <= product_(j=k+1)^T norm(bold("diag")(1 - bold(h)_j^2))_2 norm(bold(W)_(h h)^T)_2 <= (gamma dot rho)^(Delta t) $ <eq-gradient-bound>

其中常数 $gamma in (0, 1)$。由方程 @eq-gradient-bound 可知，梯度的渐近动力学完全由有效模长因子 $gamma rho$ 的量级所主宰 @bengio1994learning @pascanu2013difficulty。当循环权重矩阵的谱半径满足 $rho < 1 / gamma$ 时，随着时间跨度 $Delta t$ 的线性增大，该乘积项以几何级数速度指数级衰减至零：

$ lim_(Delta t -> oo) (gamma dot rho)^(Delta t) = bold(0) $ <eq-gradient-vanishing-limit>

这一极限即为深度学习理论中著名的“梯度弥散（Gradient Vanishing）定理”。在符号音乐生成的应用场景中，这一失效带来明显的建模困难：民间舞曲或古典乐段中核心的平行乐句、调式回归与小节线反复通常跨越数十乃至上百个离散音符 Token（即 $Delta t > 100$）。当梯度弥散发生时，网络深层的权重更新信号完全被局部短程噪声所淹没，模型根本无法感知上百步之前的调号声明或起始动机，因而不可避免地陷入调式漂移与结构失忆。相反地，若初始化或训练扰动导致 $rho > 1 / gamma$，连乘项将以指数级发生爆炸（Gradient Explosion），导致数值溢出与训练坍塌。这种严重的非线性动力学不稳定性，使得朴素循环神经网络在长程结构音乐生成任务上遭遇了不可逾越的理论天花板。

=== 长短期记忆网络的门控机制

#figure(
  image("fig/fig-lstm-gate.svg", width: 100%),
  caption: [LSTM 的四个门与加性细胞状态更新],
) <fig-lstm-gate>


为打破乘性雅可比链式传递引发的指数衰减诅咒，Hochreiter 与 Schmidhuber 于 1997 年开创性地提出了长短期记忆网络（Long Short-Term Memory, LSTM）@hochreiter1997long。LSTM 的改进在于在传统的非线性隐藏状态 $bold(h)_t$ 之外，引入了一条具备恒等直连特性的内部存储通道——细胞状态（Cell State, $bold(C)_t in bb(R)^h$），并通过三个可微的门控机制（遗忘门、输入门、输出门）对该通路的信息流动实施精细的动态调控。

在时间步 $t$，LSTM 单元接收当前时刻输入 $bold(x)_t$、上一时刻隐藏状态 $bold(h)_(t-1)$ 以及上一时刻细胞状态 $bold(C)_(t-1)$。系统运算按照如下完备代数方程组执行：

$ bold(f)_t = sigma(bold(W)_(f) [bold(h)_(t-1), bold(x)_t] + bold(b)_f) $ <eq-lstm-forget-gate>

$ bold(i)_t = sigma(bold(W)_(i) [bold(h)_(t-1), bold(x)_t] + bold(b)_i) $ <eq-lstm-input-gate>

$ tilde(bold(C))_t = tanh(bold(W)_(c) [bold(h)_(t-1), bold(x)_t] + bold(b)_c) $ <eq-lstm-candidate>

$ bold(C)_t = bold(f)_t dot.o bold(C)_(t-1) + bold(i)_t dot.o tilde(bold(C))_t $ <eq-lstm-cell-update>

$ bold(o)_t = sigma(bold(W)_(o) [bold(h)_(t-1), bold(x)_t] + bold(b)_o) $ <eq-lstm-output-gate>

$ bold(h)_t = bold(o)_t dot.o tanh(bold(C)_t) $ <eq-lstm-hidden-output>

其中 $sigma(z) = frac(1, 1 + exp(-z))$ 为 Sigmoid 激活函数，其输出值域严格限制在 $(0, 1)$ 之间，在物理上等价于可平滑调节的阀门开度；$dot.o$ 表示向量逐元素积（Hadamard Product）；$[bold(h)_(t-1), bold(x)_t] in bb(R)^(h+d)$ 为向量拼接操作。

方程 @eq-lstm-cell-update 构成 LSTM 缓解梯度弥散的核心机制。与朴素 RNN 强行通过稠密矩阵乘法更新全部隐状态不同，细胞状态 $bold(C)_t$ 的更新是一个线性的*加性操作（Additive Operation）*。考察误差梯度从 $t$ 时刻的细胞状态向 $t-1$ 时刻细胞状态的反向传递雅可比矩阵：

$ frac(partial bold(C)_t, partial bold(C)_(t-1)) = bold("diag")(bold(f)_t) $ <eq-lstm-additive-grad>

从方程 @eq-lstm-additive-grad 可以清晰地看到，若遗忘门激活向量 $bold(f)_t$ 的元素饱和接近于 $1$，则雅可比矩阵退化为一个恒等映射矩阵，误差梯度便能沿直接通路跨越较长的时间间隔近乎无损地逆向流淌回遥远的历史时刻。这种加性恒等流动机制使得 LSTM 第一次具备了稳定捕捉数百步音乐依赖模式的能力 @eck2002finding @liang2017automatic，并直接孕育了民谣音乐生成领域的早期里程碑工作 folk-rnn @sturm2016music。


== 因果自注意力与大语言模型

=== Transformer 架构与因果自注意力

尽管 LSTM 凭借门控机制显著延缓了梯度弥散，但其基于时间步严格串行的递归计算本质，使得其在现代大规模并行处理器（如 GPU）上无法实现跨序列位置的并发计算；更为关键的是，即便引入加性细胞通路，当序列长度超越千步时，将无限维度的音乐历史硬性压缩入有限维度隐向量 $bold(h)_t$ 的物理限制，依然会导致长程音乐动机记忆的渐进式退化。

2017 年，Vaswani 等人提出了 Transformer 架构 @vaswani2017attention，不再依赖循环与卷积拓扑，建立在完全基于全局成对注意力（Self-Attention）的全新计算范式之上。在单向自回归音乐生成任务中，为了保证时间因果性（即在预测当前音符 $x_t$ 时，网络严禁感知未来的后序音符 $x_(>t)$），系统采用了纯解码器（Decoder-only）架构，这也正是 OpenAI GPT 系列大模型的核心基石 @radford2019language。针对长程音乐建模，该机制还进一步延伸至相对位置偏置的 Music Transformer @huang2018music 与稀疏自注意力机制 @child2019generating。

设输入序列经过词表嵌入矩阵 $bold(W)_(t e) in bb(R)^(V times d)$ 与可学习位置编码矩阵 $bold(W)_(p e) in bb(R)^(T times d)$ 映射后，得到初始表征张量 $bold(X)_0 in bb(R)^(T times d)$。在每一层解码器块中，输入张量首先通过三个独立的线性权重矩阵投影生成查询（Query, $bold(Q)$）、键（Key, $bold(K)$）与值（Value, $bold(V)$）矩阵：

$ bold(Q) = bold(X) bold(W)_Q, quad bold(K) = bold(X) bold(W)_K, quad bold(V) = bold(X) bold(W)_V $ <eq-qkv-proj>

式中 $bold(W)_Q, bold(W)_K, bold(W)_V in bb(R)^(d times d)$。因果缩放点积注意力（Causal Scaled Dot-Product Attention）的核心代数运算定义为：

$ "Attention"(bold(Q), bold(K), bold(V)) = "softmax"(frac(bold(Q) bold(K)^T, sqrt(d_k)) + bold(M)) bold(V) $ <eq-attention-core>

其中 $d_k = d / h$ 为单个注意力头的特征维度，除以缩放因子 $sqrt(d_k)$ 的物理目的在于防止在高维点积空间中内积数值过大导致 Softmax 函数落入梯度极小的饱和区。矩阵 $bold(M) in bb(R)^(T times T)$ 为严格的因果下三角掩码矩阵（Causal Mask），其定义满足：

$ bold(M)_(i, j) = cases(
  0 & i >= j,
  -oo & i < j,
) $ <eq-causal-mask>

上式确保了在计算注意力亲和力得分矩阵时，任意位置 $i$ 对未来位置 $j$ 的注意力权重在经过 Softmax 归一化后被严格压制为绝对零度。为了使模型能够同时在不同的子空间表征多元化的乐理关系（例如一组头关注局部小节切分节奏，另一组头捕捉跨小节的纯五度跳进），多头注意力机制（Multi-Head Attention, MHA）将特征切分为 $h$ 个互不重叠的头并行运算，最后通过输出投影矩阵 $bold(W)_O in bb(R)^(d times d)$ 完成信息融合：

$ "MHA"(bold(X)) = "Concat"("head"_1, "head"_2, dots, "head"_h) bold(W)_O $ <eq-mha-concat>

$ "head"_m = "Attention"(bold(Q) bold(W)_m^Q, bold(K) bold(W)_m^K, bold(V) bold(W)_m^V) $ <eq-single-head>

在深层堆叠稳定性方面，现代因果 Transformer 普遍采用了前置层归一化（Pre-LayerNorm）残差连接拓扑，每一层解码块由自注意力模块与双层全连接前馈网络（MLP）级联组成：

$ bold(X)_("mid") = bold(X) + "MHA"("LayerNorm"(bold(X))) $ <eq-pre-ln-mha>

$ bold(X)_("out") = bold(X)_("mid") + "MLP"("LayerNorm"(bold(X)_("mid"))) $ <eq-pre-ln-mlp>

其中 MLP 模块通常包含四倍隐层维度的中间非线性扩张映射：

$ "MLP"(bold(Z)) = "GELU"(bold(Z) bold(W)_(f c 1) + bold(b)_(f c 1)) bold(W)_(f c 2) + bold(b)_(f c 2) $ <eq-mlp-gelu>

由于自注意力机制在任意两个时间步 $i$ 与 $j$ 之间建立的信息交互路径长度恒定为 $cal(O)(1)$，它消除了距离衰减壁垒，使长程复杂动机的发展与曲式结构呼应在数学上获得了最直接的表征通道 @geerlings2020interacting。在工程训练方面，现代 Transformer 广泛结合解耦权重衰减（AdamW）优化算法 @loshchilov2017decoupled 与前沿无锁纯原生算子栈 @karpathy2024llmc，进一步释放了自回归注意力的训练吞吐潜力。

#figure(
  image("fig/fig-attention-mask.svg", width: 100%),
  caption: [因果自注意力的可见性结构：位置 $i$ 只能访问 $j <= i$ 的前缀],
) <fig-attention-mask>

=== 预训练大语言模型演进

基于上述 Decoder-only 架构的深度语言模型，在经过数万亿级 Token 的海量文本语料无监督预训练后，展现出较强的泛化与上下文学习（In-Context Learning）能力 @brown2020language。在开源大模型技术演进中，Meta 提出的 LLaMA 家族（LLaMA-1、LLaMA-2、LLaMA-3）代表了当今开源基础语言模型的事实标准 @touvron2023llama @touvron2023llama2。

与标准 GPT 架构相比，现代高性能大语言模型在底层算子层面融合了三项关键的架构改进：
第一，*均方根层归一化（RMSNorm）*。相较于传统 LayerNorm 依赖均值与方差的双重统计，RMSNorm 移除了对隐状态均值的零中心化计算，仅利用均方根标量实施缩放：
$ "RMSNorm"(bold(x)) = frac(bold(x), "RMS"(bold(x))) dot.o bold(g), quad "RMS"(bold(x)) = sqrt(frac(1, d) sum_(i=1)^d x_i^2 + epsilon) $
这一简化在不损失模型表征精度的前提下，减少了约 20% 的规范化算子访存开销，显著提升了底层 CUDA 算子执行效率；
第二，*旋转位置编码（Rotary Position Embedding, RoPE）*。RoPE 摒弃了绝对可学习位置嵌入，创新性地通过复数乘法与正交旋转矩阵将相对位置信息直接注入到查询向量 $bold(Q)$ 与键向量 $bold(K)$ 的内积计算中，使得自注意力得分能够原生保持内积的相对平移不变性，赋予了模型优异的上下文窗口外推能力；
第三，*门控激活函数 SwiGLU*。采用包含元素级门控调制的 Swish 激活函数替代传统的 ReLU 或 GELU，极大地增强了非线性特征变换的表达容量。

预训练语言模型的核心价值在于其所积累的“通用序列归纳偏置” @zeng2021musicbert。尽管其原始语料以自然语言文本为主，但自然语言与符号音乐在宏观层面上皆由离散符号序列所驱动，二者在层级语法嵌套、跨周期模式重复以及上下文指代逻辑上共享深刻的底层数学结构相似性。这一跨领域的结构同构性，为将大规模预训练模型的通用序列建模能力高效迁移至符号音乐生成领域奠定了坚实的理论可行性。在采样解码阶段，此类因果模型通常结合 Top-$k$ @fan2018hierarchical 与核采样（Top-$p$ / Nucleus Sampling）@holtzman2019curious 策略，以平衡音乐旋律的结构确定性与艺术创造多样性。

=== 参数高效微调与 LoRA 理论

直接对数十亿参数规模的大语言模型（如 LLaMA-7B）针对垂直领域的 ABC 音乐语料进行全参数微调，面临着难以逾越的工程与理论阻碍。从计算物理层面审视，全参数更新需要为全部 70 亿个参数分配等量的梯度显存，并在 AdamW 优化器中存储两倍于参数量的一阶动量与二阶动量张量，仅优化器状态即需耗费高达 $84 "GB"$ 的超大显存空间，远超单张消费级 GPU 的承载极限；从泛化理论层面审视，由于高保真标注音乐语料规模相对有限，盲目更新全部权重容易引发过拟合与灾难性遗忘，破坏预训练阶段所习得的深层通用序列特征表示。

为攻克该难题，参数高效微调（PEFT）系列方法相继被提出，如适配器调优（Adapter Tuning）@houlsby2019adapter、前缀微调（Prefix-Tuning）@li2021prefix 等。在此基础上，Hu 等人于 2022 年提出了低秩自适应（Low-Rank Adaptation, LoRA）参数高效微调框架 @hu2022lora。该理论基于一个深刻的经验数学假设——预训练模型在针对特定下游垂直任务实施适配时，其密集权重矩阵的变化量 $Delta bold(W)$ 具有远低于全维度矩阵秩的*“内在秩（Intrinsic Rank）”* @aghajanyan2021intrinsic。

设某一线性投影层的原始预训练冻结权重矩阵为 $bold(W)_0 in bb(R)^(d_"out" times d_"in")$。在微调过程中，LoRA 将权重的增量矩阵 $Delta bold(W)$ 参数化分解为两个低秩小矩阵的乘积：

$ bold(W) = bold(W)_0 + Delta bold(W) = bold(W)_0 + frac(alpha, r) dot bold(B) bold(A) $ <eq-lora-formulation>

式中秩超参数满足 $r << min(d_"out", d_"in")$，矩阵因子尺寸分别为 $bold(B) in bb(R)^(d_"out" times r)$ 与 $bold(A) in bb(R)^(r times d_"in")$。在前向推理传播中，对于任意激活输入向量 $bold(x) in bb(R)^(d_"in")$，经由 LoRA 旁路适配后的输出映射方程为：

$ bold(h) = bold(W)_0 bold(x) + frac(alpha, r) dot bold(B) bold(A) bold(x) $ <eq-lora-forward>

为了保证训练起点的无缝稳定性，参数初始化采取了极具匠心的非对称设计：矩阵 $bold(A)$ 采用均值为 0、标准差为 $sigma$ 的截断高斯随机初始化，而矩阵 $bold(B)$ 则完全初始化为零矩阵：

$ bold(A) ~ cal(N)(0, sigma^2 bold(I)), quad bold(B) equiv bold(0) $ <eq-lora-init>

该初始化策略确保了在训练第 0 步时，恒有 $Delta bold(W) = bold(B) bold(A) equiv bold(0)$，即初始状态下模型的输入输出行为与纯净预训练基线完全严格等价，消除了微调介入初期的冷启动扰动。参数缩放因子 $alpha / r$ 则充当了自适应学习率解耦控制系数，保证在调整低秩维度 $r$ 时无需重新搜索优化器超参数。同时，这一低秩增量亦支持跨任务算术组合与解耦融合 @ilharco2023editing。

#figure(
  image("fig/fig-lora.svg", width: 100%),
  caption: [LoRA 的低秩旁路：冻结主干权重，仅训练分解矩阵],
) <fig-lora-architecture>

图 @fig-lora-architecture 直观展示了 LoRA 的参数旁路机制。以隐藏维度为 $d = 4096$ 的标准自注意力查询投影层为例，全参数更新需要维护 $d^2 approx 1.68 times 10^7$ 个浮点数；而当选定低秩维度 $r = 16$ 时，可训练参数量骤降至 $2 times d times r approx 1.31 times 10^5$ 个。参数压缩比高达：

$ rho = frac(d^2, 2 d r) = frac(d, 2r) = frac(4096, 32) = 128 $

全模型维度的显存占用由此被压缩至原本的不足 $1\%$。在部署推理阶段，低秩乘积矩阵 $frac(alpha, r) bold(B) bold(A)$ 可直接通过单次矩阵加法无损熔断并入原始主干参数 $bold(W)_0$，因而在前向生成时不会引入任何额外的推理时延，实现了参数效率与工业部署的终极平衡。


== 神经语言模型扩展定律

=== 幂律缩放假说与参数统计标准

2020 年，Kaplan 等人针对自回归因果 Transformer 模型在大量多源文本建模上的实证分析，确立了深度序列生成模型领域里程碑式的扩展定律（Scaling Laws）@kaplan2020scaling。随后 Hoffmann 等人（Chinchilla 定律）进一步完善了在计算预算约束下的最优参数-Token 配比关系 @hoffmann2022training。该理论打破了长期以来依靠工程试错设计网络的范式，首次证明了模型的测试交叉熵损失 $cal(L)$ 与其非嵌入参数量 $N$、语料规模 $D$ 以及训练总浮点运算量 $C$ 之间，在横跨数个数量级的广阔区间内严格服从确定性的幂律函数关系：

$ cal(L)(N) = (frac(N_c, N))^(alpha_N) + cal(L)_oo $ <eq-ch2-kaplan-n>

式中 $alpha_N$ 称为参数标度指数（Scaling Exponent），在几何上直接对应于双对数坐标系（Log-Log Plot）下损失下降曲线的渐近斜率；$N_c$ 为特征尺度标度常数；$cal(L)_oo$ 为当模型容量趋于无穷大时、由目标序列自身的内在不可约信息熵所决定的理论下界。

在扩展定律的理论推导与经验拟合中，对参数规模 $N$ 的统计标准具有严格的规范约束。系统必须将词表嵌入矩阵（Token Embedding）与位置编码矩阵（Position Embedding）从总参数量中剥离排除，仅统计直接参与序列内部时空多维特征提取与非线性推理的 Transformer 骨干层参数。其核心数学根据在于：嵌入参数在物理上仅承担离散标识符与连续向量之间的静态查找表（Lookup Table）功能，其参数膨胀并不直接提升网络解决复杂因果长程依赖与时序组合爆炸的能力。对于包含 $L$ 层解码器、隐层维度为 $d$ 的标准因果模型，非嵌入参数量的解析表达严格定义为：

$ N = L dot (12 d^2 + 13 d) $ <eq-ch2-exact-nonemb>

这一解析式表明非嵌入参数量与网络隐层宽度 $d$ 呈严格的二次方依赖关系，决定了通过横向扩宽网络可实现参数规模的高效指数跃升。

=== 数据容量与过拟合边界

孤立扩大模型参数规模并不必然带来生成质量的提升。若训练数据量 $D$ 无法提供足够的样本多样性，模型庞大的自由度将诱发对有限样本的高次多项式过拟合。在泛化误差分析中，过拟合损失增量 $delta cal(L) = cal(L)_("val") - cal(L)_("train")$ 与模型参数、数据规模之间的幂律耦合方程为 @kaplan2020scaling @hoffmann2022training：

$ delta cal(L) approx (frac(N^(alpha_N / alpha_D), D))^sigma $ <eq-ch2-overfit-ratio>

实证研究测得的临界比值通常满足 $frac(alpha_N, alpha_D) approx 0.74$，由此推导出避免过拟合发生的数据协同扩展下界公式：

$ D_("min") prop N^(0.74) $ <eq-ch2-dmin>

方程 @eq-ch2-dmin 揭示了一个残酷的理论边界：当模型参数规模扩大 10 倍时，所需训练语料的有效规模必须至少扩大 5.5 倍；若模型跨越两个数量级扩张 100 倍，有效数据需求将剧增至原本的 30 倍以上。在符号音乐领域，高保真标准乐谱数据天生稀缺 @wang2020pop909，这在理论上严密确立了：在开展任何高阶大参数量音乐大模型研究前，必须构筑具有代数数学保真度的巨量数据扩增流水线。

=== 符号音乐的固有信息熵下界

方程 @eq-ch2-kaplan-n 中的理论极限损失 $cal(L)_oo$ 具有深刻的信息论与统计物理内涵。在香农信息论体系中，任何平稳遍历随机过程皆存在一个固有的条件信息熵率（Entropy Rate）：

$ H(cal(X)) = lim_(T -> oo) frac(1, T) H(X_1, X_2, dots, X_T) $ <eq-ch2-entropy-rate>

对于开放域通用自然语言，由于日常会话包含广泛的世界常识不确定性、语用模糊性以及多义词发散性，其实测测得的不可约熵界通常在 $1.5 ~ 1.8 " nats"$ 之间浮动。而在符号音乐体系中，音符序列受到西方十二平均律协和和声体系、调式五度循环调性中心（Tonal Center）以及强小节对称律动的严格物理制约。在给定前序调号与前半句动机后，终止式主音的收束在统计上呈现高度确定的尖峰概率分布。因此，符号音乐语言模型的真实不可约物理熵界 $cal(L)_oo^("Music")$ 必然显著低于自然语言，其理论下界收敛于更低区间（如第四章在实测拟合中严格测定的 $0.725 " nats"$），展现出符号音乐高度自洽的理性代数美感。为进一步捕获音乐在长程动机与曲式反复中的自相似结构，结合自相似矩阵（Self-Similarity Matrix, SSM）的可视化与拓扑分析方法 @foote2000visualizing，亦构成了剖析离散符号长程动机关联的重要分析工具。


== 生成评估与计算音乐学指标

=== 交叉熵损失与困惑度

评估自回归序列概率生成模型的质量，首要的客观统计度量标准是交叉熵损失与困惑度。对于长度为 $T$ 的测试乐谱序列 $bold(x) = (x_1, x_2, dots, x_T)$，模型对该序列赋予的联合发生概率为其单步条件预测概率的因果连乘积。对应的平均对数损失定义为交叉熵：

$ H(P, Q) = - frac(1, T) sum_(t=1)^T log_e Q(x_t | x_1, x_2, dots, x_(t-1)) $ <eq-ch2-cross-entropy>

困惑度（Perplexity, PPL）在数学定义上为该交叉熵损失的指数形式映射：

$ "PPL" = exp(H(P, Q)) = exp(- frac(1, T) sum_(t=1)^T log_e Q(x_t | x_(<t))) = (product_(t=1)^T frac(1, Q(x_t | x_(<t))))^(1 / T) $ <eq-ch2-ppl>

从几何与信息论视角审视，困惑度在物理上代表了语言模型在推断下一个音符或语法标记时，平均面临的*“等价有效分支选择数（Equivalent Branching Factor）”*。若模型的测试困惑度为 $"PPL" = 10$，意味着模型在每个预测时间步的不确定性等价于在 10 个等概率的候选分支中进行均匀随机选择。困惑度越低，表明模型对真实音乐语法分布的拟合越精确。在符号音乐微型词表（$|V|=91$）中，若困惑度能从基线模型的 7.28（Vanilla RNN）与 4.59（LSTM）显著压降至 GPT-2 Large 的 2.47 附近，意味着模型在每个决策点的不确定性被极限压缩到了约 2.47 个候选分支，足以证明模型已经深度内化了音级跳进与调式骨干音的确定性规则。此外，在下游物理合成与声学回放中，生成的符号序列还可无缝对接 Karplus-Strong 离散物理弦振动合成管线 @karplus1983digital，实现由文本到物理波形的闭环音响校验。

=== 客观计算音乐学指标

尽管困惑度提供了强大的信息论统计测度，但纯粹的标量概率无法完全表征生成乐曲在人类乐理层面的旋律美学特征。为此，本文全面复现并引入了由 Dong 等人提出的国际通用符号音乐客观评估系统 MusPy @dong2020muspy。该体系涵盖 9 个互不重叠的计算音乐学维度，通过对比生成乐曲集与人类真实数据集在各特征上的均值（Mean）与标准差（Standard Deviation）的一致性，实现对生成质量的客观量化对账：

1. *音高跨度（Pitch Range）*：全曲中最高音与最低音之间的半音绝对差值，反映了旋律的声部纵向活动空间与物理乐器音域适配度；
2. *独特音高数（Number of Unique Pitches）*：全曲所使用的离散绝对半音种类总数；
3. *独特音级数（Number of Unique Pitch Classes）*：将所有音符折叠至一个纯八度模 12 空间内所呈现的音阶种类数。对于自然大调，其理论理想值应严格收敛于 7 附近；
4. *多音织体度（Polyphony）*：单步时间切片上平均并发发音的音符数，对于单旋律民乐，该值应严格恒等于 1.0；
5. *调式音阶一致性（Scale Consistency）*：落入最佳拟合调式音阶内的音符占全曲音符总数的比例，直接衡量旋律的调性纯净度；
6. *音高信息熵（Pitch Entropy）*：全曲绝对音高分布的香农熵，量化音符分布的广义离散度；
7. *音级信息熵（Pitch Class Entropy）*：模 12 音级概率分布的香农熵，衡量调内各音阶偏好度的丰富程度；
8. *空白节拍率（Empty Beat Rate）*：在全曲有效时间网格内，未包含任何发音音符的空白节拍占比；
9. *律动一致性（Groove Consistency）*：相邻小节之间在击弦点与强弱时值模式上的余弦相关性，反映音乐是否具备稳定的节拍律动骨架。

== 本章小结

本章全面阐述了与本文符号音乐深度生成系统紧密相关的核心理论体系、算法机制与评测准则。首先，系统解析了 ABC 记谱法的代数文本结构及其多维乐理语义映射，深入探讨了清华大学王奕于 2026 年最新确立的“有效性-无损性分词框架”，为后续章节设计无损规则分词器 ABCTokenizer 提供了坚实的信息论准绳；其次，从动力系统与矩阵分析层面深入剖析了循环神经网络（RNN）沿时间反向传播时不可避免的梯度弥散物理根源，并从加性恒等映射角度推导了长短期记忆网络（LSTM）克服长程依赖衰减的数学本质；再次，详尽形式化推导了解码器专属因果多头自注意力 Transformer 与预训练大语言模型的技术演进，深入阐述了低秩自适应（LoRA）的内在低秩假设与参数效率压缩方程；随后，引入神经语言模型扩展定律（Scaling Laws），确立了非嵌入参数统计标准、数据-参数协同演进边界以及符号音乐固有信息熵下界理论；最后，建立了涵盖因果交叉熵困惑度（PPL）、MusPy 9 维客观计算音乐学统计度量在内的全方位多轨评价理论体系。

本章系统梳理与推导的理论与技术基石，在逻辑上直接贯通并支撑了后续各章节的深入展开：ABC 记谱法与分词理论为第三章多模型对比与数据流通奠定了规范的数据协议；循环网络与注意力的梯度流动分析直接从机理上解释了第三章实验中 RNN 梯度坍塌与 GPT-2 稳定收敛的物理原因；而模型扩展定律理论、十二平均律对称性与 SSM 矩阵分析法，则直接构成了第四章在单卡算力约束下系统探索五阶模型规模跃迁的理论航标。


// ============================================================
// 第三章 正文（软件学报体例 + 去除防御性否定表述）
// 改写原则：
//   1) 边界用正面陈述（"限于……"/"取决于……"）表达，不用"不能断定"；
//   2) 成因用正面陈述（"由 A 与 B 共同决定"）表达，不用"不能归因于"；
//   3) 性质用正面定义（"它度量的是……"）表达，不用"不等同于"。
// 表格、图、算法、公式、引用保持原样。
// ============================================================


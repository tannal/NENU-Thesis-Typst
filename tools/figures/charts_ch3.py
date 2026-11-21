"""Chapter 3 data figures (matplotlib)."""
import os, sys, csv
sys.path.insert(0, os.path.dirname(__file__))
import numpy as np
import matplotlib.pyplot as plt
from collections import defaultdict
from chartstyle import *

D = "/home/user/bundles/abc_writing/abc_ai_paper_writing/data"
OUT = os.path.join(os.path.dirname(__file__), "../../template/fig/")
D3 = D + "/derived/chapter3"


def rows(path):
    with open(path, encoding="utf-8") as f:
        return list(csv.DictReader(f))


# ---------------------------------------------------------------- 3.2 BPC curves
lc = rows(D3 + "/learning_curves.csv")
names = {"token_char": ("字符级", TEAL), "token_bpe": ("BPE-256", AMBER),
         "gpt2abc": ("乐理词法", PURPLE)}
fig, axes = plt.subplots(1, 2, figsize=(7.4, 2.9), gridspec_kw={"width_ratios": [1.35, 1]})
for key, (label, colour) in names.items():
    agg = defaultdict(list)
    for r in lc:
        if r["figure"] == "2" and r["model"] == key:
            agg[float(r["epoch"])].append(float(r["value"]))
    xs = sorted(agg)
    mean = np.array([np.mean(agg[x]) for x in xs])
    sd = np.array([np.std(agg[x]) for x in xs])
    axes[0].plot(xs, mean, color=colour, lw=1.6, label=label)
    axes[0].fill_between(xs, mean - sd, mean + sd, color=colour, alpha=0.12, lw=0)
    m = [i for i, x in enumerate(xs) if 5 <= x <= 15]
    axes[1].plot([xs[i] for i in m], mean[m], color=colour, lw=1.6)
    axes[1].fill_between([xs[i] for i in m], mean[m]-sd[m], mean[m]+sd[m], color=colour, alpha=0.12, lw=0)
    k = int(np.argmin(mean))
    if 5 <= xs[k] <= 15:
        axes[1].scatter([xs[k]], [mean[k]], color=colour, s=16, zorder=5)
axes[0].set_xlabel("完整训练遍历次数（epoch）"); axes[0].set_ylabel("验证集 BPC（bit/字符）")
axes[0].legend(loc="lower center", ncol=3, fontsize=9); finish(axes[0])
axes[1].set_xlabel("epoch"); finish(axes[1])
axes[0].set_title("完整 50 轮区间", pad=8); axes[1].set_title("第 5–15 轮放大", pad=8)
panel_label(axes[0], "a"); panel_label(axes[1], "b")
fig.savefig(OUT + "chart-ch3-tokenizer-learning.svg")
plt.close(fig)

# ---------------------------------------------------------------- 3.3 tradeoff
tw = rows(D3 + "/tokenizer_tradeoff.csv")
order = ["token_char", "token_bpe", "gpt2abc"]
label = {"token_char": "字符级", "token_bpe": "BPE-256", "gpt2abc": "乐理词法"}
colour = {"token_char": TEAL, "token_bpe": AMBER, "gpt2abc": PURPLE}
fig, axes = plt.subplots(1, 3, figsize=(7.6, 2.5))
for ax, field, title, unit in [
        (axes[0], "characters_per_token", "文本压缩", "字符 / 词元"),
        (axes[1], "test_bpc", "测试编码成本", "BPC"),
        (axes[2], "wall_hours_50epochs", "50 轮训练时间", "小时")]:
    vals = [float(next(r for r in tw if r["model"] == m)[field]) for m in order]
    ax.bar(range(3), vals, color=[colour[m] for m in order], width=0.62)
    for i, v in enumerate(vals):
        ax.text(i, v, f"{v:.3f}" if v < 10 else f"{v:.2f}", ha="center", va="bottom", fontsize=8.5, color=INK)
    ax.set_xticks(range(3)); ax.set_xticklabels([label[m] for m in order], fontsize=9)
    ax.set_title(title, pad=6); ax.set_ylabel(unit); finish(ax)
    ax.set_ylim(0, max(vals)*1.18)
for ax, s in zip(axes, "abc"):
    panel_label(ax, s)
fig.savefig(OUT + "chart-ch3-tokenizer-tradeoff.svg")
plt.close(fig)

# ---------------------------------------------------------------- 3.4 arch curves
arch = {"rnn": ("RNN", TEAL), "lstm": ("LSTM", AMBER),
        "transformer": ("Post-LN", PURPLE), "gpt2abc": ("GPT2ABC", SLATE)}
fig, axes = plt.subplots(1, 2, figsize=(7.4, 2.9), gridspec_kw={"width_ratios": [1.35, 1]})
for key, (label_, colour_) in arch.items():
    agg = defaultdict(list)
    for r in lc:
        if r["figure"] == "4" and r["model"] == key:
            agg[float(r["epoch"])].append(float(r["value"]))
    xs = sorted(agg)
    mean = np.array([np.mean(agg[x]) for x in xs]); sd = np.array([np.std(agg[x]) for x in xs])
    axes[0].plot(xs, mean, color=colour_, lw=1.6, label=label_)
    axes[0].fill_between(xs, mean-sd, mean+sd, color=colour_, alpha=0.10, lw=0)
    m = [i for i, x in enumerate(xs) if 5 <= x <= 15]
    axes[1].plot([xs[i] for i in m], mean[m], color=colour_, lw=1.6)
    axes[1].fill_between([xs[i] for i in m], mean[m]-sd[m], mean[m]+sd[m], color=colour_, alpha=0.10, lw=0)
axes[0].set_xlabel("完整训练遍历次数（epoch）"); axes[0].set_ylabel("验证集 NLL（nat/词元）")
axes[0].legend(loc="lower right", ncol=2, fontsize=9); finish(axes[0])
axes[1].set_xlabel("epoch"); finish(axes[1])
axes[0].set_title("完整 50 轮区间", pad=8); axes[1].set_title("第 5–15 轮放大", pad=8)
panel_label(axes[0], "a"); panel_label(axes[1], "b")
fig.savefig(OUT + "chart-ch3-arch-learning.svg")
plt.close(fig)

# ---------------------------------------------------------------- 3.5 prediction cost
pc = rows(D3 + "/prediction_cost.csv")
fig, axes = plt.subplots(1, 2, figsize=(7.4, 2.8), gridspec_kw={"width_ratios": [1, 1.15]})
for i, r in enumerate(pc):
    m = r["model"]; lo, hi = float(r["family_ci_low"]), float(r["family_ci_high"])
    v = float(r["test_nll_mean"])
    axes[0].plot([lo, hi], [i, i], color=GRAY, lw=1.4, zorder=1)
    axes[0].scatter([v], [i], color=PALETTE[i % len(PALETTE)], s=28, zorder=3)
    axes[0].text(hi + 0.012, i, f"{v:.4f}", va="center", fontsize=8.5, color=MUTED)
axes[0].set_yticks(range(len(pc)))
axes[0].set_yticklabels(["RNN", "LSTM", "Post-LN", "GPT2ABC"])
axes[0].invert_yaxis(); axes[0].set_xlabel("测试集 NLL（nat/词元）")
axes[0].set_xlim(0.80, 1.44); finish(axes[0], xgrid=True, ygrid=False)
axes[0].set_title("家族 bootstrap 95% 区间", pad=8)

for i, r in enumerate(pc):
    h = float(r["train_wall_hours_mean"]); v = float(r["test_nll_mean"])
    n = float(r["parameters"]) / 1e6
    axes[1].scatter([h], [v], s=28 + n*5, color=PALETTE[i % len(PALETTE)], alpha=0.85, edgecolor="white", lw=1)
    axes[1].annotate(f" {n:.2f}M", (h, v), fontsize=8.5, color=MUTED, va="bottom")
axes[1].set_xlabel("50 轮训练墙钟（小时）"); axes[1].set_ylabel("测试集 NLL")
finish(axes[1])
axes[1].set_title("训练成本与预测误差", pad=8)
panel_label(axes[0], "a"); panel_label(axes[1], "b")
fig.savefig(OUT + "chart-ch3-prediction-cost.svg")
plt.close(fig)

# ---------------------------------------------------------------- 3.6 coverage
gr = rows(D3 + "/generation_reliability.csv")
order = ["rnn", "lstm", "transformer", "gpt2abc", "token_char", "token_bpe"]
names6 = ["RNN", "LSTM", "Post-LN", "GPT2ABC", "字符级", "BPE-256"]
fig, axes = plt.subplots(1, 2, figsize=(7.4, 3.15), gridspec_kw={"width_ratios": [1.32, 1]})
left = [int(r["eight_bar_eligible"]) for r in gr]
short = [int(r["accepted_short"]) for r in gr]
fail = [int(r["parse_failed"]) for r in gr]
y = np.arange(len(gr))
axes[0].barh(y, left, color=TEAL, height=0.62, label="八小节可用")
axes[0].barh(y, short, left=left, color=AMBER, height=0.62, label="可解析但不足窗口")
axes[0].barh(y, fail, left=np.array(left)+np.array(short), color=RED, height=0.62, label="解析失败")
for i, r in enumerate(gr):
    axes[0].text(3010, i, f"{left[i]} / {short[i]} / {fail[i]}", va="center", fontsize=8, color=MUTED)
axes[0].set_yticks(y); axes[0].set_yticklabels(names6, fontsize=9); axes[0].invert_yaxis()
axes[0].set_xlabel("请求数（共 3,000）"); axes[0].set_xlim(0, 3600)
axes[0].legend(loc="upper center", bbox_to_anchor=(0.5, -0.30), ncol=3, fontsize=8.5); finish(axes[0], xgrid=True, ygrid=False)
axes[0].set_title("请求结果构成", pad=8)

for i, r in enumerate(gr):
    lo, hi = float(r["interior_bar_consistency_seed_min"]), float(r["interior_bar_consistency_seed_max"])
    mean = float(r["interior_bar_consistency_seed_mean"])
    axes[1].plot([lo, hi], [i, i], color=GRAY, lw=1.4)
    axes[1].scatter([mean], [i], color=PALETTE[i % len(PALETTE)], s=24, zorder=3)
axes[1].set_yticks(y); axes[1].set_yticklabels([]); axes[1].invert_yaxis()
axes[1].set_xlabel("内部小节时值一致性"); axes[1].set_xlim(0.885, 0.965)
finish(axes[1], xgrid=True, ygrid=False)
axes[1].set_title("可解析输出中的小节一致性", pad=8)
panel_label(axes[0], "a"); panel_label(axes[1], "b")
fig.savefig(OUT + "chart-ch3-coverage.svg")
plt.close(fig)

# ---------------------------------------------------------------- 3.7 music shift heatmap
ms = rows(D3 + "/music_meter_standardized.csv")
metrics = ["pitch_range", "n_pitches", "n_pitch_classes", "polyphony",
           "scale_consistency", "pitch_entropy", "pitch_class_entropy",
           "empty_beat_rate", "groove_consistency"]
mlabel = ["音域", "独特音高", "独特音级", "复调度", "音阶一致性",
          "音高熵", "音级熵", "空拍率", "律动一致性"]
models = ["rnn", "lstm", "transformer", "gpt2abc"]
mlabel_m = ["RNN", "LSTM", "Post-LN", "GPT2ABC"]
Z = np.zeros((len(metrics), len(models)))
for j, m in enumerate(models):
    for i, met in enumerate(metrics):
        r = next(x for x in ms if x["model"] == m and x["metric"] == met)
        Z[i, j] = float(r["standardized_mean_shift"])
fig, axes = plt.subplots(1, 2, figsize=(7.8, 3.1), gridspec_kw={"width_ratios": [1.15, 1], "wspace": 0.42})
im = axes[0].imshow(Z, cmap="RdBu_r", vmin=-0.7, vmax=0.7, aspect="auto")
axes[0].set_xticks(range(4)); axes[0].set_xticklabels(mlabel_m, fontsize=9)
axes[0].set_yticks(range(len(metrics))); axes[0].set_yticklabels(mlabel, fontsize=9)
for i in range(len(metrics)):
    for j in range(4):
        axes[0].text(j, i, f"{Z[i,j]:+.2f}", ha="center", va="center", fontsize=8,
                     color="white" if abs(Z[i, j]) > 0.4 else INK)
axes[0].set_title("相对真实测试集的均值偏移（拍号标准化）", pad=8)
for sp in axes[0].spines.values():
    sp.set_visible(False)
axes[0].tick_params(length=0)
cb = fig.colorbar(im, ax=axes[0], fraction=0.030, pad=0.03)
cb.ax.tick_params(labelsize=8); cb.outline.set_visible(False)

# ECDF for pitch range
ec = rows(D3 + "/music_ecdf.csv")
print("ecdf cols", list(ec[0].keys()))
fig2 = axes[1]
for k, (m, lab, col) in enumerate([("reference", "真实测试集", INK)] + list(zip(models, mlabel_m, PALETTE))):
    sub = [r for r in ec if r.get("group") == m or r.get("model") == m]
    if not sub:
        continue
    xs = [float(r["value"]) for r in sub if r["metric"] == "pitch_range"]
    if not xs:
        continue
    xs.sort()
    ys = np.arange(1, len(xs)+1)/len(xs)
    fig2.plot(xs, ys, color=col, lw=1.5, label=lab)
fig2.set_xlabel("音域（半音）"); fig2.set_ylabel("累计概率")
fig2.legend(fontsize=8.5, loc="lower right"); finish(fig2)
fig2.set_title("音域经验累计分布", pad=8)
panel_label(axes[0], "a"); panel_label(axes[1], "b")
fig.savefig(OUT + "chart-ch3-music.svg")
plt.close(fig)
print("chapter 3 charts done")

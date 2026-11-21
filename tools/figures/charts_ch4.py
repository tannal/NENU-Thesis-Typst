"""Chapter 4 data figures (matplotlib)."""
import os, sys, csv, json
sys.path.insert(0, os.path.dirname(__file__))
import numpy as np
import matplotlib.pyplot as plt
from collections import defaultdict
from chartstyle import *

D = "/home/user/bundles/abc_writing/abc_ai_paper_writing/data"
OUT = os.path.join(os.path.dirname(__file__), "../../template/fig/")
D4 = D + "/derived/chapter4"


def rows(path):
    with open(path, encoding="utf-8") as f:
        return list(csv.DictReader(f))


TIERS = [("scale_nano", "Nano", 224000, TEAL), ("scale_mini", "Mini", 1237760, AMBER),
         ("scale_base", "Base", 14340096, PURPLE), ("scale_medium", "Medium", 25411584, SLATE),
         ("scale_large", "Large", 85343232, GRAY), ("scale_xl", "XL", 302694400, RED)]

ms = {r["model"]: r for r in rows(D + "/results/model_summary.csv")}

# ---------------------------------------------------------------- 4.1 ladder
fig, ax = plt.subplots(figsize=(7.2, 2.9))
for key, lab, n, col in TIERS:
    y = float(ms[key]["joint_nll_mean"]); e = float(ms[key]["joint_nll_sd"])
    ax.errorbar(n, y, yerr=e, fmt="o", ms=6, color=col, ecolor=col, elinewidth=1.2, capsize=2.5)
    ax.annotate(lab, (n, y), textcoords="offset points", xytext=(0, 9), ha="center", fontsize=8.8, color=col)
ax.set_xscale("log")
ax.set_xlabel("非嵌入参数量 N"); ax.set_ylabel("独立测试 NLL（nat/词元）")
finish(ax)
ax.set_title("六档容量梯队的独立测试误差", pad=8)
fig.savefig(OUT + "chart-ch4-ladder.svg")
plt.close(fig)

# ---------------------------------------------------------------- 4.2 trajectories
vt = rows(D4 + "/validation_trajectories.csv")
fig, axes = plt.subplots(1, 2, figsize=(7.6, 3.3), gridspec_kw={"width_ratios": [1.25, 1]})
for key, lab, n, col in TIERS:
    agg = defaultdict(list)
    for r in vt:
        if r["model"] == key:
            agg[int(r["scored_targets"])].append(float(r["validation_nll"]))
    xs = sorted(agg)
    tx = np.array(xs) / 1e6
    mu = np.array([np.mean(agg[x]) for x in xs])
    sd = np.array([np.std(agg[x]) for x in xs])
    axes[0].plot(tx, mu, color=col, lw=1.5, label=lab)
    axes[0].fill_between(tx, mu - sd, mu + sd, color=col, alpha=0.10, lw=0)
axes[0].set_xlabel("累计评分目标数（百万）"); axes[0].set_ylabel("验证 NLL")
axes[0].set_ylim(0.8, 5.2)
axes[0].legend(ncol=3, fontsize=8.4, loc="upper center", bbox_to_anchor=(0.5, -0.33)); finish(axes[0])
axes[0].set_title("验证轨迹", pad=8)

off = {"scale_base": (-4, 12), "scale_medium": (10, -16), "scale_large": (8, 10),
       "scale_xl": (2, 8), "scale_nano": (2, 9), "scale_mini": (2, 9)}
for key, lab, n, col in TIERS:
    y = float(ms[key]["joint_nll_mean"]); e = float(ms[key]["joint_nll_sd"])
    axes[1].errorbar(n, y, yerr=e, fmt="o", ms=5.5, color=col, ecolor=col, elinewidth=1.1, capsize=2)
    axes[1].annotate(lab, (n, y), textcoords="offset points", xytext=off[key], ha="center",
                     fontsize=8.2, color=col)
axes[1].set_xscale("log"); axes[1].set_xlabel("N（对数轴）"); axes[1].set_ylabel("测试 NLL")
axes[1].set_ylim(0.80, 1.80)
finish(axes[1])
axes[1].set_title("验证选模后的独立测试", pad=8)
panel_label(axes[0], "a"); panel_label(axes[1], "b")
fig.savefig(OUT + "chart-ch4-capacity.svg")
plt.close(fig)

# ---------------------------------------------------------------- 4.3 matched targets
mt = rows(D4 + "/matched_targets.csv")
targets = [15000000, 20000000, 25000000]
fig, ax = plt.subplots(figsize=(7.0, 2.8))
width = 0.13
xs = np.arange(len(TIERS))
cols = ["#cfe3e0", "#8fc3bc", TEAL]
for k, t in enumerate(targets):
    vals, errs = [], []
    for key, *_ in TIERS:
        sel = [r for r in mt if r["model"] == key and int(r["targets"]) == t]
        vals.append(float(sel[0]["validation_nll_interpolated"]))
        errs.append(0.0)
    b = ax.bar(xs + (k-1)*width, vals, width, color=cols[k], label=f"{t//1000000}M 目标")
    for i, v in enumerate(vals):
        ax.text(xs[i]+(k-1)*width, v+0.012, f"{v:.3f}", ha="center", fontsize=7.2, color=MUTED, rotation=90)
ax.set_xticks(xs); ax.set_xticklabels([t[1] for t in TIERS], fontsize=9.5)
ax.set_ylabel("验证 NLL（插值）"); ax.set_ylim(0.85, 1.95)
ax.legend(fontsize=9, ncol=3, loc="upper right"); finish(ax)
ax.set_title("共同累计目标数处的容量比较", pad=8)
fig.savefig(OUT + "chart-ch4-matched.svg")
plt.close(fig)

# ---------------------------------------------------------------- 4.4 forecast
fb = rows(D + "/results/scaling_forecast.csv")
fig, axes = plt.subplots(1, 2, figsize=(7.4, 2.9), gridspec_kw={"width_ratios": [1.25, 1]})
model = "scale_xl_s42"
sub = sorted([r for r in fb if r["run"] == model], key=lambda r: int(r["tokens"]))
tx = [int(r["tokens"]) / 1e6 for r in sub]
obs = [float(r["observed"]) for r in sub]
pred = [float(r["predicted"]) for r in sub]
base = [float(r["data_only"]) for r in sub]
inside = [r["D_in_training_range"] == "True" for r in sub]
cut = max([t for t, f in zip(tx, inside) if f], default=max(tx))
axes[0].axvspan(cut, max(tx)*1.01, color=GRID, alpha=0.75, lw=0)
axes[0].plot(tx, obs, "o", color=INK, ms=3.2, label="XL 实测")
axes[0].plot(tx, pred, color=TEAL, lw=1.6, label="参数＋目标联合模型")
axes[0].plot(tx, base, color=AMBER, lw=1.5, ls="--", label="仅目标数基线")
axes[0].set_xlabel("累计评分目标数（百万）"); axes[0].set_ylabel("验证 NLL")
axes[0].legend(fontsize=8.6, loc="upper right"); finish(axes[0])
axes[0].set_title("XL 整档留出预测", pad=8)

axes[1].axhline(0, color=GRAY, lw=0.9)
axes[1].axvspan(cut, max(tx)*1.01, color=GRID, alpha=0.75, lw=0)
axes[1].plot(tx, np.array(pred) - np.array(obs), color=TEAL, lw=1.6, label="联合模型")
axes[1].plot(tx, np.array(base) - np.array(obs), color=AMBER, lw=1.4, ls="--", label="仅目标数基线")
axes[1].set_xlabel("累计评分目标数（百万）"); axes[1].set_ylabel("预测 − 实测")
axes[1].legend(fontsize=8.6); finish(axes[1])
axes[1].set_title("残差", pad=8)
panel_label(axes[0], "a"); panel_label(axes[1], "b")
fig.savefig(OUT + "chart-ch4-forecast.svg")
plt.close(fig)

# ---------------------------------------------------------------- 4.5 augmentation
ap = rows(D4 + "/augmentation_seed_pairs.csv")
fig, axes = plt.subplots(1, 2, figsize=(6.9, 2.9), gridspec_kw={"wspace": 0.38})
for ax, dom, title in [(axes[0], "in_domain", "域内测试"),
                       (axes[1], "shift_plus5", "整体 +5 半音")]:
    for i, tr in enumerate(["scale_mini_original", "scale_mini"]):
        ys = [float(r["test_nll"]) for r in ap if r["training"] == tr and r["domain"] == dom]
        xs = np.random.default_rng(7 + i).normal(i, 0.035, len(ys))
        ax.scatter(xs, ys, s=26, color=TEAL if i == 0 else AMBER, zorder=3,
                   edgecolor="white", lw=0.8)
        ax.plot([i-0.10, i+0.10], [np.mean(ys)]*2, color=INK, lw=1.4)
    for seed in {r["seed"] for r in ap}:
        a = next(float(r["test_nll"]) for r in ap if r["training"] == "scale_mini_original" and r["domain"] == dom and r["seed"] == seed)
        b = next(float(r["test_nll"]) for r in ap if r["training"] == "scale_mini" and r["domain"] == dom and r["seed"] == seed)
        ax.plot([0.05, 0.95], [a, b], color=GRAY, lw=0.9, zorder=1)
    ax.set_xticks([0, 1]); ax.set_xticklabels(["原始训练", "十二偏移增强"])
    if ax is axes[0]:
        ax.set_ylabel("独立测试 NLL")
    finish(ax)
    ax.set_title(title, pad=8)
panel_label(axes[0], "a"); panel_label(axes[1], "b")
fig.savefig(OUT + "chart-ch4-augmentation.svg")
plt.close(fig)

# ---------------------------------------------------------------- 4.6 music + coverage
msc = rows(D4 + "/music_meter_standardized.csv")
metrics = ["pitch_range", "n_pitches", "n_pitch_classes", "polyphony", "scale_consistency",
           "pitch_entropy", "pitch_class_entropy", "empty_beat_rate", "groove_consistency"]
mlabel = ["音域", "独特音高", "独特音级", "复调度", "音阶一致性",
          "音高熵", "音级熵", "空拍率", "律动一致性"]
sel = [("scale_medium", "Medium"), ("scale_large", "Large"), ("scale_xl", "XL")]
Z = np.zeros((len(metrics), len(sel)))
for j, (m, _) in enumerate(sel):
    for i, met in enumerate(metrics):
        Z[i, j] = float(next(x for x in msc if x["model"] == m and x["metric"] == met)["standardized_mean_shift"])
cov = rows(D + "/results/generation_coverage.csv")
fig, axes = plt.subplots(1, 2, figsize=(7.6, 3.0), gridspec_kw={"width_ratios": [1.25, 1], "wspace": 0.42})
im = axes[0].imshow(Z, cmap="RdBu_r", vmin=-0.6, vmax=0.6, aspect="auto")
axes[0].set_xticks(range(3)); axes[0].set_xticklabels([l for _, l in sel], fontsize=9.5)
axes[0].set_yticks(range(len(metrics))); axes[0].set_yticklabels(mlabel, fontsize=9)
for i in range(len(metrics)):
    for j in range(3):
        axes[0].text(j, i, f"{Z[i,j]:+.2f}", ha="center", va="center", fontsize=8,
                     color="white" if abs(Z[i,j]) > 0.38 else INK)
axes[0].set_title("相对真实测试集的均值偏移", pad=8)
for sp in axes[0].spines.values(): sp.set_visible(False)
axes[0].tick_params(length=0)
cb = fig.colorbar(im, ax=axes[0], fraction=0.030, pad=0.03)
cb.ax.tick_params(labelsize=8); cb.outline.set_visible(False)

names = {"scale_nano": "Nano", "scale_mini": "Mini", "scale_base": "Base",
         "scale_medium": "Medium", "scale_large": "Large", "scale_xl": "XL"}
order = ["scale_nano", "scale_mini", "scale_base", "scale_medium", "scale_large", "scale_xl"]
vals = []
for m in order:
    r = next((x for x in cov if x["model"] == m), None)
    if r:
        vals.append((names[m], int(r["eight_bar_eligible"]) / int(r["requested"]) * 100))
axes[1].bar(range(len(vals)), [v for _, v in vals], color=TEAL, width=0.62)
for i, (_, v) in enumerate(vals):
    axes[1].text(i, v + 0.1, f"{v:.1f}", ha="center", fontsize=8, color=MUTED)
axes[1].set_xticks(range(len(vals))); axes[1].set_xticklabels([n for n, _ in vals], rotation=30, ha="right", fontsize=9)
axes[1].set_ylim(85, 101); axes[1].set_ylabel("八小节覆盖率（%）"); finish(axes[1])
axes[1].set_title("共同窗口覆盖率", pad=8)
panel_label(axes[0], "a"); panel_label(axes[1], "b")
fig.savefig(OUT + "chart-ch4-music.svg")
plt.close(fig)

# ---------------------------------------------------------------- 4.7 prefix
pp = rows(D4 + "/prefix_paired_deltas.csv")
fams = json.load(open(D4 + "/analysis.json", encoding="utf-8"))["prefix_family_bootstrap"]
fig, axes = plt.subplots(1, 2, figsize=(7.4, 2.9))
metrics2 = [("chroma_similarity", "音级相似度"), ("onset_cosine", "起音相似度")]
models3 = [("gpt2abc_s42", "GPT2ABC"), ("scale_large_s42", "Large"), ("scale_xl_s42", "XL")]
for ax, (met, mlabel2) in zip(axes, metrics2):
    for i, (m, ml) in enumerate(models3):
        d = [float(r["delta"]) for r in pp if r["model"] == m and r["metric"] == met]
        xs = np.random.default_rng(11 + i).normal(i, 0.055, len(d))
        ax.scatter(xs, d, s=10, color=PALETTE[i], alpha=0.35, lw=0)
        f = next(x for x in fams if x["model"] == m and x["metric"] == met)
        lo, hi, mu = f["ci_low"], f["ci_high"], f["paired_mean_delta"]
        ax.plot([i, i], [lo, hi], color=INK, lw=1.5)
        ax.scatter([i], [mu], marker="D", s=26, color=INK, zorder=4)
    ax.axhline(0, color=GRAY, lw=0.9, ls=":")
    ax.set_xticks(range(3)); ax.set_xticklabels([m for _, m in models3], fontsize=9.5)
    ax.set_ylabel(f"{mlabel2}差值"); finish(ax)
    ax.set_title(mlabel2, pad=8)
panel_label(axes[0], "a"); panel_label(axes[1], "b")
fig.savefig(OUT + "chart-ch4-prefix.svg")
plt.close(fig)

# ---------------------------------------------------------------- 4.8 SSM
case = json.load(open(D4 + "/shared_ssm_case.json", encoding="utf-8"))
mats = case["matrices"]
print("ssm keys:", list(mats)[:8] if isinstance(mats, dict) else type(mats))
LAB = {"gpt2abc_s42/free": "GPT2ABC · 自由", "gpt2abc_s42/prefix": "GPT2ABC · 前缀",
       "scale_large_s42/free": "Large · 自由", "scale_large_s42/prefix": "Large · 前缀",
       "scale_xl_s42/free": "XL · 自由", "scale_xl_s42/prefix": "XL · 前缀"}
fig, axes = plt.subplots(2, 3, figsize=(7.0, 4.6))
keys = list(mats)[:6]
for ax, k in zip(axes.ravel(), keys):
    M = np.array(mats[k])
    im = ax.imshow(M, cmap="magma_r", vmin=0, vmax=1, interpolation="nearest")
    ax.set_title(LAB.get(k, k), fontsize=9.2, pad=5)
    ax.set_xticks(range(M.shape[0])); ax.set_yticks(range(M.shape[0]))
    ax.set_xticklabels([]); ax.set_yticklabels([])
    ax.tick_params(length=0)
    for sp in ax.spines.values(): sp.set_visible(False)
cb = fig.colorbar(im, ax=axes, fraction=0.022, pad=0.015)
cb.ax.tick_params(labelsize=8); cb.outline.set_visible(False)
cb.set_label("小节音级自相似度", fontsize=8.5)
fig.suptitle("同一提示（提示 1）下的续写自相似矩阵，仅取生成后的八小节", fontsize=10.5, y=0.98)
fig.savefig(OUT + "chart-ch4-ssm.svg")
plt.close(fig)
print("chapter 4 charts done")

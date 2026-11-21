"""Hand-drawn architecture diagrams for the thesis.

Layout is authored explicitly (bands, boxes, arrows); no data is plotted here.
Style follows tools/figures/README.md: numbered section bands, faint grid,
white cards with a bold title and a quiet subtitle line.
"""

FONT = "Noto Sans CJK SC, Source Han Sans SC, sans-serif"

INK = "#1f2933"       # primary text
MUTED = "#6b7a8f"     # subtitle text
LINE = "#3c4a5a"      # card borders
BAND = "#f4f6f9"      # band fill
GRID = "#e8eef5"      # graph-paper grid
ACCENT = "#0f766e"    # teal accent
CYAN = "#22b8cf"      # marker crosses
ARROW = "#5b6b7c"


def header(w, h):
    return (
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{w}" height="{h}" '
        f'viewBox="0 0 {w} {h}" font-family="{FONT}">\n'
        f'<defs>\n'
        f'<marker id="ah" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" '
        f'markerHeight="7" orient="auto-start-reverse">'
        f'<path d="M 0 0 L 10 5 L 0 10 z" fill="{ARROW}"/></marker>\n'
        f'<pattern id="grid" width="20" height="20" patternUnits="userSpaceOnUse">'
        f'<path d="M 20 0 L 0 0 0 20" fill="none" stroke="{GRID}" stroke-width="0.7"/></pattern>\n'
        f'</defs>\n'
        f'<rect width="{w}" height="{h}" fill="white"/>\n'
        f'<rect width="{w}" height="{h}" fill="url(#grid)"/>\n'
    )


def footer():
    return "</svg>\n"


def band(x, y, w, h, num, title):
    """Numbered section band."""
    out = [f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="4" '
           f'fill="{BAND}" stroke="{LINE}" stroke-width="1.4"/>']
    out.append(f'<text x="{x+20}" y="{y+34}" font-size="24" font-weight="700" '
               f'fill="{INK}">{num}</text>')
    out.append(f'<text x="{x+64}" y="{y+33}" font-size="19" font-weight="700" '
               f'fill="{INK}">{title}</text>')
    return "".join(out)


def card(x, y, w, h, title, sub="", size=16, sub_size=13, fill="white"):
    title, sub = _esc(title), _esc(sub)
    out = [f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="3" '
           f'fill="{fill}" stroke="{LINE}" stroke-width="1.1"/>']
    if sub:
        out.append(f'<text x="{x+w/2}" y="{y+h/2-4}" font-size="{size}" '
                   f'font-weight="600" text-anchor="middle" fill="{INK}">{title}</text>')
        lines = sub.split("\n")
        for i, ln in enumerate(lines):
            out.append(f'<text x="{x+w/2}" y="{y+h/2+16+i*17}" font-size="{sub_size}" '
                       f'text-anchor="middle" fill="{MUTED}">{ln}</text>')
    else:
        out.append(f'<text x="{x+w/2}" y="{y+h/2+5}" font-size="{size}" '
                   f'font-weight="600" text-anchor="middle" fill="{INK}">{title}</text>')
    return "".join(out)


def arrow(x1, y1, x2, y2, dashed=False):
    d = ' stroke-dasharray="5 4"' if dashed else ""
    return (f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{ARROW}" '
            f'stroke-width="1.4"{d} marker-end="url(#ah)"/>')


def elbow(x1, y1, x2, y2, mid=None):
    """Orthogonal connector: down, across, down."""
    my = mid if mid is not None else (y1 + y2) / 2
    return (f'<path d="M {x1} {y1} L {x1} {my} L {x2} {my} L {x2} {y2}" fill="none" '
            f'stroke="{ARROW}" stroke-width="1.4" marker-end="url(#ah)"/>')


def _esc(t):
    return t.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def label(x, y, text, size=12.5, fill=MUTED, anchor="middle", weight="400"):
    text = _esc(text)
    return (f'<text x="{x}" y="{y}" font-size="{size}" fill="{fill}" '
            f'text-anchor="{anchor}" font-weight="{weight}">{text}</text>')


def tick(x, y, kind="x"):
    """Small registration cross, echoing the example figure."""
    return (f'<path d="M {x-5} {y} L {x+5} {y} M {x} {y-5} L {x} {y+5}" '
            f'stroke="{CYAN}" stroke-width="1.6"/>')


def dot(x, y, r=9):
    return (f'<circle cx="{x}" cy="{y}" r="{r}" fill="none" stroke="{ACCENT}" '
            f'stroke-width="2"/>'
            f'<path d="M {x-4} {y} L {x+4} {y} M {x} {y-4} L {x} {y+4}" '
            f'stroke="{ACCENT}" stroke-width="2"/>')


def band3(x, y, w, num, title, items, card_h=84, band_h=170, title_size=16, sub_size=12.5):
    """A numbered band holding three evenly spaced cards."""
    out = [band(x, y, w, band_h, num, title)]
    gap = 16
    cw = (w - 48 - gap * 2) / 3
    cy = y + band_h - card_h - 20
    for i, (t, sub) in enumerate(items):
        out.append(card(x + 24 + i * (cw + gap), cy, cw, card_h, t, sub,
                        size=title_size, sub_size=sub_size))
        if i:
            out.append(arrow(x + 24 + i * (cw + gap) - gap + 2, cy + card_h / 2,
                             x + 24 + i * (cw + gap) - 3, cy + card_h / 2))
    return "".join(out)

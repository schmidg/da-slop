# Optimal Distributed Algorithm for Optimal Coloring

## Context

Distributed graph algorithms, LOCAL model.

Vertices know $n=|V|$ and a supplied integer $q$ with $\chi(G) \le q \le n$; $q$-colorability is promised. Identifiers are arbitrary and distinct. Messages and local computation are unrestricted, as usual in LOCAL.

## New result

For every fixed $c>0$, there is a randomized $O_c(n/q)$-round algorithm to compute a $q$-coloring, with global success probability at least $1-n^{-c}$.
For a supplied $q=\chi(G)$, this gives an optimal $O_c(n/\chi(G))$-round algorithm for exact coloring; the algorithm does not compute $\chi(G)$.
A matching worst-case $\Omega(n/\chi(G))$-round lower bound holds for clique-expansions of even cycles.

## Lineage

A question posed several times in recent years is if $\Delta+1$-coloring can be computed in $O(1)$-rounds, for sufficiently high values of $\Delta$, or if there is a $\Omega(\log^\* n)$-lower bound matching the known upper bound (Halldorsson, Kuhn, Nolin, Tonoyan, STOC'22).

In September 2025, Fabian and I answered the former positively for $\Delta = \Omega(n)$, but never wrote it down.

On September 20, I wanted to explore the most basic version and asked Astra and Fable for a O(1)-round algorithm for a $n$-coloring. Astra gave up; Fable barfed. Asked for a $2n$-coloring, Astra gave an algorithm for $n+\tilde{O}(\sqrt{n})$ colors. I saw a way to reduce it to our original question of $\Delta+1$-coloring for $\Delta = 2n/3$. Astra found a way to generalize it to $\Delta = \Omega(n)$. I realized that only one part of the argument needed more than $\chi$ colors and this could be overcome. Astra wrote up the full result.

## Documents

- [AI-generated write-up](writeup.pdf)
- [Editable Typst source](writeup.typ)

To rebuild the PDF with [Typst](https://github.com/typst/typst), run in this directory:

```sh
typst compile writeup.typ writeup.pdf
```

Tested with Typst 0.15.1; no external packages, figures, or bibliography files are needed.

## Discovered by

GPT-6 in Codex

## Communicated by

Magnús M. Halldórsson

## Confidence

I was informally convinced by the original ideas, but have not vetted the writeup.



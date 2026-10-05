# Local potential problems

## Context

Label the nodes with labels 0 and 1, call an edge between a node with label 0 and a node with label 1 a cut edge, then Locally Optimal Cut (LOC) is the problem of assigning 0s and 1s in such a way, that no node can (single handedly) increase the number of cut edges, by changing its label. Note that if a 0/1-assignment is not a solution, then there must exist an "unhappy" node with strictly less than half of its adjacent edges being cut edges.

LOC is just one example of a problem where we can prove that a solution always exists using a simple potential argument. Start with an arbitrary solution and let $b<|E|$ be the number of non-cut edges. If the solution is not correct, then there exists an unhappy node that we can 'flip' to decrease the number of non-cut edges. Hence after doing this finitely often we obtain a valid solution. 

Local potential problems are essentially all problems for which we can do such an argument, that is there is some global potential that is just the sum over all local potentials. If the solution is not correct, then a node can make a small local change to improve the global potential. 

## New result

- Tight $\widetilde{O}(\min\lbrace \Delta, n^{1/2} \rbrace)$ upper bound for LOC.
- $\widetilde{O}(\min\lbrace K\Delta^r, (Kn)^{1/2} \rbrace)$ upper bound for generic local potential problems with radius $r$ and local scale $K$.
- $\Omega(\Delta^{r+1})$ lower bound for LOC with a larger radius ($r=0$ gives the usual LOC), showing that the $\Delta$ dependence in the generic upper bound is tight.

## Prior work

The most important prior work is [Balliu, Boudier, d'Amore, Kuhn, Olivetti, Schmid, Suomela, PODC 2026](https://arxiv.org/abs/2507.12038).

They already provide the $\Omega(\min\lbrace \Delta, n^{1/2} \rbrace)$ lower bound for LOC, but their upper bound is essentially $\min\lbrace \Delta, n^{1/2} \rbrace^2$.

Similarly, their generic upper bound is $O(\Delta^{2r} \cdot \text{poly}(\log n))$, so roughly the square of the above improvement.

## Documents

- [AI-generated write-up](writeup.pdf)
- [Human-written notes](human-notes.md)

## Discovered by

GPT-6 

## Communicated by

[Gustav Schmid](https://ac.informatik.uni-freiburg.de/schmid/)

## Confidence

The main improvement is just an improved analysis of the original work. I tried to get this to work for roughly a month, but did not find the right formulation. The new sequence lemma (which is the main new ingredient) is exactly what I would have expected it to be. So I am confident in both upper bounds.

I have not verified the lower bounds, but they should also be a straightforward adaptation of the existing lower-bound construction.

## Thanks

Thanks to Francesco d'Amore for first prompting GPT about this.

## Assigned to

[Gustav Schmid](https://ac.informatik.uni-freiburg.de/schmid/)

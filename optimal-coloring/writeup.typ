#set document(title: "Optimal Distributed Algorithm for Optimal Coloring", author: "", date: datetime(year: 2026, month: 10, day: 1))
#set page(paper: "a4", margin: (top: 23mm, bottom: 22mm, left: 23mm, right: 23mm), numbering: "1", number-align: right,
  header: context if counter(page).get().first() > 1 {
    set text(size: 8pt, fill: rgb("65717d"))
    [OPTIMAL DISTRIBUTED ALGORITHM FOR OPTIMAL COLORING #h(1fr) RESEARCH NOTE]
    line(length: 100%, stroke: 0.35pt + rgb("d5dee4"))
  })
#set text(font: "New Computer Modern", size: 10.5pt, fill: rgb("15212c"))
#set par(justify: true, leading: 0.5em, spacing: 0.65em)
#set heading(numbering: "1.1")
#show heading.where(level: 1): set text(size: 14pt, weight: "bold", fill: rgb("174e66"))
#show heading.where(level: 2): set text(size: 11.3pt, weight: "bold", fill: rgb("174e66"))
#set math.equation(numbering: none)
#let Pr = math.op("Pr")
#let EE = math.op("E")
#let Bin = math.op("Bin")
#let dist = math.op("dist")
#let tag(x) = h(1em) + text("(" + x + ")")
#let result(name, body) = block(inset: (left: 10pt, right: 10pt, top: 8pt, bottom: 8pt), fill: rgb("f0f5f7"), radius: 2pt, breakable: true)[*#name* #body]
#let qed = h(1fr) + $square$

#text(size: 22pt, weight: "bold", fill: rgb("174e66"))[Optimal Distributed Algorithm]
#v(1mm)
#text(size: 18pt)[for Optimal Coloring]
#v(2mm)
#text(size: 9pt, fill: rgb("65717d"))[Full proof · Research note · 1 October 2026]
#v(4mm)

*Abstract.* Given an integer $q$ and the promise that an $n$-vertex graph is $q$-colorable, we give a randomized LOCAL algorithm that finds a proper coloring from $[q]$ in $O(n/q)$ rounds with high probability. The algorithm permits arbitrary distinct identifiers. For a supplied $q=chi(G)$, it computes an optimal coloring in $O(n/chi(G))$ rounds. The main construction postpones a small number of bounded-radius sets, colors the remaining vertices by local multicoloring, and repairs the postponed vertices together with a high-degree core. A separate argument handles small palettes using a standard network decomposition. Even-cycle clique blow-ups give a matching worst-case $Omega(n/q)$ lower bound for exact coloring.

= Statement and model

#result([Theorem 1 (upper bound).], [Fix $c>0$. There is a randomized LOCAL algorithm which, on every simple $n$-vertex graph $G$ supplied with integers $n,q$ satisfying $chi(G) <= q <= n$, terminates in $O_c (n/q)$ rounds and outputs a proper coloring $V(G) -> [q]$ with probability at least $1-n^(-c)$. Its round bound is independent of the magnitude of the distinct input identifiers.])

Communication is synchronous, with unlimited message size and unrestricted local computation. Vertices initially know their own distinct identifiers, their incident ports, and $n,q$. A constant number of initial rounds can reveal neighbor identifiers and degrees. Random bits are private and independent. The success probability is global: with the stated probability, every edge is properly colored. The round bound holds for every outcome of the random choices.

The promise of $q$-colorability is essential to the specification. The algorithm does not determine $chi(G)$, test the promise, or bound its centralized computation time. Exhaustive searches for colorings of gathered subgraphs are allowed in LOCAL. The cases $n=1$ and $q=1$ are immediate; for the latter, the promise says that the graph is edgeless. Henceforth assume $n>=2$ and $q>=2$.

All distances, balls, and weak diameters are measured in the original graph $G$. A set has weak diameter $R$ if every two of its vertices are at distance at most $R$ in $G$; connecting paths may leave the set. All vertices remain communication relays throughout the algorithm, including vertices whose colors are fixed and vertices postponed for later processing. There is no congestion cost when many gathered subgraphs use the same relay.

*Proof outline.* For $q<n^(3/4)$, first color the components induced by vertices of degree at least $q$, whose weak diameters are $O(n/q)$, and then solve a degree-plus-one list-coloring instance in polylogarithmic time. This fits within $O(n/q)$. For $q>=n^(3/4)$, use randomly sampled clusters and local color allocation. An excessive local allocation budget exposes more than $q/2$ nearby vertices that can be postponed. There are fewer than $2n/q$ such blocks in total. A deterministic repair lemma then finishes the coloring in $O(n/q)$ rounds. The threshold $n^(3/4)$ is chosen for convenience.

#pagebreak()
= Geometry and deterministic repair

Write $N_G [X]$ for the closed neighborhood of a set $X$, and $B_G (z,r)$ for the radius-$r$ ball around $z$. The graph $G^h [U]$ has vertex set $U$, with distinct vertices adjacent when their original distance is at most $h$.

#result([Lemma 2 (a cover bounds weak diameter).], [Suppose $U$ is covered by $K$ balls of radius $r$ in $G$. Every connected component $C$ of $G^h [U]$ has weak diameter at most
$ (2r+h)(K-1)+2r. $
The centers need not belong to $U$ or to $C$.])

*Proof.* Assign each vertex of $U$ to one covering center. The centers assigned to vertices of $C$ form a connected auxiliary graph: connect two centers whenever some edge of $G^h [C]$ has endpoints assigned to them. Each auxiliary edge spans original distance at most $r+h+r$. There are at most $K$ assigned centers, so any two of them are joined by a simple auxiliary path of at most $K-1$ edges. Adding the two radius-$r$ paths from the endpoints gives the claim. #qed

#result([Lemma 3 (packing the high-degree vertices).], [Let $H_q={v in V(G): deg_G (v)>=q}$. There is a set $P subset.eq H_q$ of size at most $n/(q+1)$ whose radius-two balls cover $H_q$. Moreover, every connected component of $G[H_q]$ has weak diameter less than $5n/q$.])

*Proof.* Choose a maximal subset $P$ of $H_q$ whose pairwise original distances are at least three. Its closed neighborhoods are disjoint, and each contains at least $q+1$ vertices. Thus $|P|<=n/(q+1)$. Maximality ensures that every vertex of $H_q$ is within distance two of $P$.

For the second assertion, apply the same packing construction inside one component $C$ of $G[H_q]$, still measuring distances in $G$. Lemma 2 with $r=2$ and $h=1$ gives weak diameter at most $5(|P|-1)+4=5|P|-1<5n/q$. These packings are used only in the analysis; the algorithm never computes them. #qed

#result([Lemma 4 (repair lemma).], [Suppose $G$ is $q$-colorable and a proper partial $[q]$-coloring has uncolored set $S$. Suppose $S$ is covered by at most $B_0$ radius-four balls, where the integer bound $B_0$ is known. In $O(B_0+n/q+1)$ deterministic LOCAL rounds, one can complete the coloring, allowing recoloring of previously colored vertices. The covering centers need not be supplied.])

*Proof.* Enlarge the uncolored core to
$ U=S union H_q. $
By Lemma 3, $H_q$ is covered by at most $n/(q+1)$ radius-two balls. Thus $U$ has a radius-four cover using at most
$ K <= B_0+n/(q+1) $
centers. If $U$ is empty, the coloring is already complete. Otherwise, let $cal(C)$ be the components of $G^3 [U]$. Lemma 2 gives, for each $C in cal(C)$,
$ "weak-diam"_G (C) <= 11(K-1)+8 < 11K. $

Define the patch of $C$ to be $Q_C=N_G [C]$. Distinct core components have original distance at least four. Their patches are consequently disjoint and have no edges between them: an intersection would put the cores at distance at most two, and an edge between patches would put them at distance at most three. In addition,
$ Q_C ∩ U=C. $
In particular, every vertex of $Q_C$ outside $C$ has original degree less than $q$.

Gather each core component, its patch, and the colors on the exterior neighbors of the patch. This takes $O(B_0+n/q+1)$ rounds, as detailed below. Its minimum-ID vertex computes any proper $q$-coloring of $G[C]$, which exists by the promise. Discard the old colors throughout $Q_C$. After coloring $C$, process the vertices of $Q_C$ outside $C$ in increasing ID order, always choosing the smallest color absent from their already colored neighbors, including the fixed exterior. Each such vertex has at most $q-1$ neighbors in the entire graph, so a color is always available. This greedy computation is centralized and costs no additional communication rounds. Broadcast the resulting assignment to the patch.

All patches can be processed simultaneously because they are disjoint and nonadjacent. Every originally uncolored vertex lies in a core and is colored. The exterior was properly colored to begin with; the greedy boundary step respects its colors. Therefore the resulting global coloring is proper. #qed

*How gathering works.* A known weak-diameter bound is sufficient; an explicit cover, an induced connectedness guarantee, and precomputed routes are unnecessary. Each vertex first records its identifier, its neighbors, its membership in $U$, and its current color. Flood these records to distance $R+5$, where
$ R=ceil(11(B_0+n/(q+1)))+1. $
Every core vertex sees its entire component of $G^3 [U]$, every length-at-most-three path needed to determine its incident core adjacencies, its patch, and the exterior colors needed for repair. It can recognize the complete component by exploring those core adjacencies. All its members identify the same minimum-ID leader. The leader's assignment is flooded for a further $R+2$ rounds. Members of its patch accept the assignment addressed to them. Overlapping floods have no cost beyond their radius in LOCAL.

This is also a bounded-time subroutine when the claimed cover bound fails: vertices that cannot certify a complete component within the allotted view may output an arbitrary color after the prescribed schedule. The application below guarantees the bound on its success event. No global failure detection or unbounded search for a leader is required.

= Small palettes

Assume $q<n^(3/4)$. Put $H=H_q$ and $L=V(G) without H$. By Lemma 3, every component of $G[H]$ has weak diameter less than $5n/q$. Flooding to this radius plus a constant reveals each component completely, including its incident edges. Its minimum-ID leader finds a $q$-coloring of the component and distributes it. Different components of $G[H]$ have no edges between them, so this gives a proper coloring of $H$ in $O(n/q)$ rounds.

For each $v in L$, remove from $[q]$ the colors used on its neighbors in $H$, obtaining a list $A(v)$. If $d_H (v)$ and $d_L (v)$ are the numbers of its neighbors in $H$ and $L$, respectively, then
$ |A(v)| >= q-d_H (v) >= d_L (v)+1, $
because $deg_G (v)<q$.

We use the standard consequence of deterministic polylogarithmic-time network decomposition [RG20]: there is a fixed constant $a$ for which degree-plus-one list coloring with polynomial-range identifiers can be solved in $O(log^a n)$ LOCAL rounds. To see this consequence, obtain a decomposition with polylogarithmically many classes and polylogarithmic cluster diameter. Process the classes sequentially. Clusters of one class are pairwise nonadjacent, so they can be gathered and greedily list-colored in parallel, respecting previously colored neighbors. A vertex's remaining list always has at least its remaining degree plus one. This finishes all clusters in polylogarithmic time.

Arbitrary original identifiers do not obstruct this subroutine. Let $b=ceil(c)+6$. Independently give each vertex a fresh temporary identifier uniform in $[n^b]$. The probability of any collision is at most
$ binom(n,2)n^(-b) <= (1/2)n^(2-b) <= n^(-c). $
Conditioned on no collision, these are distinct $O_c (log n)$-bit identifiers suitable for the decomposition. The original identifiers remain available for other purposes. One can run the decomposition on the graph with $n$ vertices obtained by deleting all edges incident to $H$, so that the known value $n$ remains valid. Its isolated high vertices are ignored when coloring $L$.

The total number of rounds is
$ O_c (n/q+log^a n)=O_c (n/q), $
since $n/q>n^(1/4)$ and $log^a n=O(n^(1/4))$ for every fixed $a$. On the no-collision event, this branch is correct. The decomposition is run for its predetermined polynomial-logarithmic time bound, also on the collision event.

= Large palettes: clustering and postponement

Assume now that $q>=n^(3/4)$. We first construct a proper partial coloring whose uncolored vertices are covered by fewer than $2n/q$ radius-four balls. Lemma 4 will then complete it.

== Parameters and the finite fallback

Define
$ b=ceil(c)+6, quad ell=ceil(log_2 n), quad t=b ell, $
$ D=ceil(q/(16t)), quad p=t/D, quad M=ceil(2n p), $
$ F=2sqrt(M n t)+(2t+1)M. $
The main construction is used only when
$ p<=1, quad D<=q/(8t), quad F<=q/2. tag("P") $
These conditions are determined from $n,q,c$ alone, so every vertex makes the same branch decision.

They hold uniformly for all sufficiently large $n$, depending only on $c$. Indeed, for sufficiently large $n$, $q/(16t)>=1$ and $q>=16t^2$. Hence $D<=q/(8t)$ and $p<=1$. Also,
$ M<=32n t^2/q+1=O_c ((n/q)log^2 n), $
and therefore
$ F=O_c ((n log^(3/2) n)/sqrt(q)+(n log^3 n)/q). $
Using $q>=n^(3/4)$ gives
$ F/q=O_c (n^(-1/8)log^(3/2) n+n^(-1/2)log^3 n)=o(1). $
Thus there is a constant $n_0 (c)$ such that (P) holds whenever $n>=n_0 (c)$ in this branch.

If (P) fails, every connected component is gathered in $n+1$ rounds and colored by exhaustive search. Here $n<n_0 (c)$ and $q<=n_0 (c)$, so $n+1=O_c (n/q)$. This deterministic fallback avoids any asymptotic proviso in Theorem 1. In the rest of this section, assume (P).

== Sample fixed clusters

Call a vertex *high for clustering* if its original degree is at least $D$, and *low* otherwise. Every original vertex independently becomes a center with probability $p$. Each high vertex attaches to an adjacent sampled center, choosing the one with smallest ID. Nonempty attachment sets are the initial clusters. Their members are all high vertices, but a center may be low, may belong to another center's cluster, or may not itself be a cluster member.

Centers are coordinators, and this role persists even if their own vertices are later postponed or recolored. Membership is fixed except for deletion of postponed vertices. Such vertices continue to relay messages. A cluster always has weak radius one about its coordinator.

Let $E_0$ be the event that every high vertex has a sampled neighbor and that the total number of sampled centers is at most $M$. For an individual high vertex,
$ Pr["no sampled neighbor"] <= (1-p)^D <= e^(-p D)=e^(-t). $
If $Y$ is the number of sampled centers and $mu=n p$, then $M>=2mu$. By the Chernoff upper-tail bound and (P),
$ Pr[Y>M] <= e^(-mu/3), quad mu=(n t)/D >= (8n t^2)/q >= 8t^2. $
Consequently
$ Pr[not E_0] <= n e^(-t)+e^(-t)=(n+1)e^(-t). tag("1") $
Condition on $E_0$ for the structural analysis that follows.

== The padding bound survives every deletion

Initially all high vertices are active. For a current nonempty cluster $i$, let $s_i$ be its number of active members and assign the integer weight
$ w_i=s_i+ceil(2sqrt(s_i t))+2t. $
An empty cluster has weight zero and is omitted. Let $J$ be the current virtual cluster graph: two distinct clusters are adjacent exactly when an original edge joins active members of the two clusters. Write
$ Z_i=sum_(j in N_J [i]) w_j. $

At every stage, there are at most $M$ nonempty clusters and their total membership is at most $n$. By Cauchy-Schwarz,
$ sum_i (w_i-s_i) &<= 2sqrt(t)sum_i sqrt(s_i)+(2t+1)M \
 &<= 2sqrt(M n t)+(2t+1)M=F. tag("2") $
This is a deterministic consequence of $E_0$ and holds for all subsequent deletion patterns simultaneously. There is no probability loss for the number of phases or their adaptivity.

Call a cluster *bad* when $Z_i>q$. The union $W_i$ of the active members in its closed virtual neighborhood satisfies
$ |W_i|=sum_(j in N_J [i])s_j >= Z_i-F>q-F>=q/2. tag("3") $
All these vertices lie within original distance four of the center $z_i$. For a neighboring cluster $j$, take an active edge $x y$ with $x$ in cluster $i$ and $y$ in cluster $j$. Any other member $v$ of cluster $j$ is reached by the walk
$ z_i -> x -> y -> z_j -> v. $
Members of $i$ are already at distance one. Notice that the large set in (3) consists of *distinct active vertices*, rather than just weighted demand.

== A fixed number of phases

Execute $T=ceil(2n/q)+1$ phases. In each phase:

1. Recompute the nonempty clusters, their weights, virtual adjacencies, and bad status.
2. Select a bad center precisely when its ID is smallest among all bad centers at original distance at most nine from it.
3. For every selected center $z$, postpone all currently active high vertices in $B_G (z,4)$. Record this set as one block.

Every phase uses $O(1)$ LOCAL rounds. Membership reports travel one hop to coordinators; information between adjacent clusters travels at most three hops through their members. Bad-center IDs are flooded nine hops, and selected-center announcements four hops. These are a fixed number of communication stages independent of $n$ and $q$.

Selected centers have mutual distance at least ten. Their radius-four balls are disjoint and nonadjacent. In particular, their recorded blocks are disjoint. By (3), *each* recorded block contains more than $q/2$ newly postponed vertices. Blocks from later phases are disjoint from earlier blocks because only active vertices are postponed. Thus the total number $B$ of blocks over all phases obeys
$ B(q/2)<n, quad "so" quad B<2n/q. tag("4") $
When $B=0$, the latter inequality also holds. This bounds the total number of selected centers, including centers selected simultaneously; merely bounding the number of phases would not suffice for the repair argument.

If any bad cluster exists, the globally smallest-ID bad center is selected. Thus every nonempty phase records at least one block. Cluster sizes, weights, and virtual neighborhoods only shrink, so each surviving cluster's $Z_i$ is nonincreasing. Once no cluster is bad, none becomes bad later. By (4), the prescribed $T$ phases cannot all be nonempty. Therefore at their end
$ Z_i<=q quad "for every remaining cluster" i. tag("5") $
Let $S$ be the set of postponed vertices. Equation (4) supplies a cover of $S$ by fewer than $2n/q$ radius-four balls. Blocks need not induce connected subgraphs and need not contain their coordinators.

= Color allocation and completion

== Weighted local multicoloring

We first state the allocation primitive separately. It uses local random minima, as in the local multicoloring literature [K09]. The additional padding is chosen for the unequal cluster demands in this construction.

#result([Lemma 5 (weighted allocation).], [Let $J$ be a graph of clusters with positive integer demands $s_i$. For an integer $t>=1$, set
$ w_i=s_i+ceil(2sqrt(s_i t))+2t. $
If $Z_i=sum_(j in N_J [i])w_j<=q$ for every $i$, then an allocation using ideal continuous priorities gives every cluster $i$ at least $s_i$ colors, except with probability at most $e^(-t)$ for that cluster. It uses a constant number of communication stages on $J$, and adjacent clusters receive disjoint color sets.])

*Proof with ideal continuous priorities.* Independently for each color $a in [q]$, cluster $i$ draws $w_i$ independent uniform keys from $(0,1)$. It uses the minimum of these keys as its priority for $a$, and wins $a$ when its priority is smallest in its closed neighborhood. All $Z_i$ keys in that neighborhood are identically distributed, so
$ Pr[i " wins " a]=w_i/Z_i. $
The trials for different colors are independent. Thus the number of colors won by $i$ is
$ X_i ~ Bin(q,w_i/Z_i), quad mu_i=EE X_i=q w_i/Z_i>=w_i. $
The Chernoff lower-tail bound gives
$ Pr[X_i<s_i] <= exp(-(mu_i-s_i)^2/(2mu_i))
 <= exp(-(w_i-s_i)^2/(2w_i)) <= e^(-t). tag("6") $
For the middle inequality, $(x-s)^2/(2x)$ is nondecreasing for $x>=s$. For the last, set $u=s+2sqrt(s t)+2t$ and compute
$ (u-s)^2-2t u=2s t+4t sqrt(s t)>=0. $
Rounding upward from $u$ to $w$ preserves the inequality by the same monotonicity. Finally, adjacent clusters cannot both have the smallest priority on a given color. Their won color sets are therefore disjoint. #qed

In our application, (5) supplies the premise of Lemma 5. Use fresh randomness after all postponement decisions. Conditioned on any history satisfying $E_0$, there are at most $n$ remaining clusters. By a union bound, all receive enough colors except with probability at most $n e^(-t)$. Each successful cluster assigns distinct won colors to its active members in increasing ID order. This gives a proper coloring of all unpostponed high vertices. In the original graph, a constant number of rounds suffices for coordinators to exchange their priorities through members and distribute the assignments.

== Finish the original low vertices

The vertices originally classified as low have degree less than $D$ and have never been postponed. Each low vertex $v$ excludes the colors of its already colored high neighbors. For *every* color, including excluded colors, it draws an independent priority and exchanges it with all low neighbors. It wins a color if its priority is smallest among itself and these neighbors. It chooses the smallest won color that was not excluded.

For the analysis, let $d_h$ count the colored high neighbors of $v$ and let $d_l$ count all its low neighbors. There may also be postponed high neighbors, which remain uncolored. Thus
$ d_h+d_l<=deg_G (v)<=D-1. $
At least $q-d_h$ colors are admissible. For each one, the probability of winning is $1/(d_l+1)$, independently across colors. Condition on the high-vertex coloring and use fresh low-vertex randomness. The probability of winning no admissible color is at most
$ exp(-(q-d_h)/(d_l+1)) <= exp(-q/D) <= e^(-8t). tag("7") $
Indeed, $d_l+1<=D-d_h$, while $q>=D$, and therefore
$ (q-d_h)/(d_l+1) >= (q-d_h)/(D-d_h) >= q/D. $
The last inequality in (7) follows from (P).

Adjacent low vertices cannot both win the same color. They also avoid every already colored high neighbor. Consequently, except with probability at most $n e^(-8t)$, this step yields a proper partial coloring of all of $V(G)$ outside $S$. Competing on excluded colors is harmless and ensures the simple winning probability above.

== Deterministic repair

Apply Lemma 4 to the partial coloring with the known bound $B_0=ceil(2n/q)$. By (4), the uncolored set $S$ satisfies its cover premise. The repair takes $O(n/q)$ rounds and completes the coloring.

For completeness, its particularly useful diameter estimate here is explicit. Put $U=S union H_q$, where $H_q$ uses the threshold $q$ and *original* degrees; it is not the threshold-$D$ classification used for clustering. There is a radius-four cover of $U$ with
$ K<=B+n/(q+1)<3n/q $
centers. Every component of $G^3 [U]$ therefore has weak diameter less than $33n/q$. The patches of these components are pairwise nonadjacent. All their boundary vertices have original degree below $q$, so any $q$-coloring of a core can be extended over its boundary while respecting the fixed exterior. In particular, this step imposes no maximum-degree restriction on $G$.

== Finite random keys

The continuous priorities in the analysis can be implemented with finite random choices. Let
$ R_0=n^(b+4). $
Replace each continuous key by an independent uniform integer in $[R_0]$. Break cluster-key ties by the pair (center ID, ticket index), and low-vertex key ties by vertex ID. These are strict total orders, so the disjointness properties of winning color sets hold even when numerical keys tie.

On $E_0$, equation (2) and (P) imply
$ sum_i w_i <= n+F<=3n/2. $
For a fixed color there are at most $3n/2$ cluster tickets and at most $n$ low-vertex keys. A union bound over colors and the two separate allocation stages shows that the probability of any within-color numerical collision is at most
$ (q/R_0)(binom(ceil(3n/2),2)+binom(n,2)) <= (5n^3)/R_0. tag("8") $
This bound also holds conditionally on any preceding history satisfying $E_0$.

To couple with the ideal analysis, obtain an integer key by placing a continuous uniform key into one of $R_0$ equal intervals. When all relevant integer keys are distinct, every comparison agrees with the continuous-key procedure. It follows that the finite implementation adds at most (8) to the failure probability. Keys used for different colors and for the two allocation stages are independent. Center sampling uses the exact probability $p=t/D$, implemented by a uniform integer from $[D]$.

== Failure probability and termination

Combining (1), (6), (7), and (8), the failure probability in the large-palette construction is at most
$ (n+1)e^(-t)+n e^(-t)+n e^(-8t)+5n^3/R_0. $
Since $t=b ceil(log_2 n)>=b ln n$, this is at most
$ (2n+1)n^(-b)+n^(1-8b)+5n^(-b-1)
 <=4n^(1-b)+5n^(-b-1) <= n^(-c). tag("9") $
The last inequality holds for $n>=2$ and $b=ceil(c)+6$: after factoring out $n^(-c)$, the two terms are at most $4n^(-5)+5n^(-7)<1$.

All communication follows a predetermined schedule. There are $T=ceil(2n/q)+1$ postponement phases, a constant number of allocation rounds, and a predetermined $O(n/q)$ flooding schedule for repair. On an unsuccessful sampling or allocation outcome, uncovered vertices or vertices without a won color may keep a failure flag. Subsequent messages still follow the same schedule. At termination, any unresolved vertex outputs color 1. During repair, incomplete gathered components may likewise be rejected locally. These conventions are only to specify behavior on failure; on the event analyzed above all required covers and color assignments exist. Thus the algorithm always terminates within the asserted round bound, regardless of its random choices.

*Proof of Theorem 1.* The small-palette branch uses $O_c (n/q)$ rounds and fails with probability at most $n^(-c)$. In the large-palette branch, the finite fallback is deterministic and uses $O_c (n/q)$ rounds. Otherwise, the construction and repair use $O(n/q)$ rounds, with failure bounded by (9). These branches cover all $n,q$, and the trivial cases were addressed at the outset. No step bounds the numerical magnitude of the original identifiers. #qed

= Worst-case optimality

The upper bound is tight in the worst case for exact coloring. We give a self-contained argument, including the randomized cycle lower bound. The palette-propagation mechanism is related to earlier multicoloring and optimal-coloring lower bounds [HK17, BE19]; no novelty is claimed for it.

#result([Lemma 6 (two-coloring an even cycle).], [Any randomized LOCAL algorithm that properly two-colors every labeled even cycle of length $2m$ with global success probability at least $2/3$ has worst-case round complexity $Omega(m)$. This holds even when the cycle length and a consistent orientation are given.])

*Proof.* It suffices to consider $m>=4$. Suppose the algorithm uses $T$ rounds with $2T<m-1$. Give the cycle consistent left and right ports. Choose two vertices at odd distance $d$, where $d=m$ if $m$ is odd and $d=m-1$ if $m$ is even. Their distance in both directions exceeds $2T$, so their radius-$T$ neighborhoods are disjoint and are isomorphic as rooted oriented graphs.

Temporarily assign identifiers independently and uniformly from $[M]$, for an integer $M>=100(2m)^2$, and use independent private random bits. Extend the local decision rule arbitrarily to neighborhoods with repeated identifiers, and normalize every output to a bit. The two selected output bits are independent and identically distributed, because their input neighborhoods are disjoint and identically distributed. If $rho$ is their common probability of output 1, then
$ Pr["the two outputs differ"]=2rho(1-rho)<=1/2. $
Any proper two-coloring must give different colors to the chosen vertices, because their distance is odd. Thus the overall success probability under this independent labeling experiment is at most $1/2$.

On the other hand, the probability of an identifier collision anywhere is at most $binom(2m,2)/M<1/100$. Conditioned on distinct identifiers, the assumed algorithm succeeds with probability at least $2/3$ for each labeling, hence also on their mixture. Its unconditional success probability is therefore at least $(1-1/100)(2/3)>1/2$, a contradiction. Thus $T>=(m-1)/2$ up to the integer rounding, proving the claim. If neighbor IDs are supplied initially for free, replace $T$ by $T+1$; the asymptotic lower bound is unchanged. #qed

#result([Theorem 7 (matching family).], [For every $s>=1$ and arbitrarily large $m$, there are graphs with
$ n=2m s, quad chi(G)=q=2s, quad Delta(G)=3s-1, $
on which computing a proper $[q]$-coloring with global success probability at least $2/3$ requires $Omega(m)=Omega(n/q)$ randomized LOCAL rounds in the worst case over identifiers.])

*Proof.* Let $G=C_(2m)[K_s]$: replace each cycle vertex $i$ by an $s$-clique $V_i$, and join consecutive cliques completely. Two consecutive cliques induce $K_(2s)$, so $chi(G)>=2s$. Alternating two disjoint palettes of size $s$ gives a $2s$-coloring, proving equality. Each vertex has $s-1$ neighbors in its own clique and $s$ in each adjacent clique, giving degree $3s-1$.

In any proper $[2s]$-coloring, let $A_i$ be the set of colors used on $V_i$. Each $A_i$ has size $s$, and consecutive palettes are disjoint. Since the entire palette has size $2s$,
$ A_(i+1)=[2s] without A_i, quad A_(i+2)=A_i. $
The indicator of the event $1 in A_i$ therefore properly two-colors the underlying even cycle.

A processor of that cycle can simulate all $s$ vertices in its clique. Assign the simulated vertices identifiers formed by an injective encoding of (cycle identifier, local index), and independent random tapes. Clique-internal communication is local computation, while all messages between consecutive cliques are bundled across one cycle edge. Thus each coloring round is simulated by one cycle round. The parameters supplied to the coloring algorithm are $n=2m s$ and $q=2s$, which the cycle processors know from $m,s$.

A $T$-round coloring algorithm would therefore two-color the cycle in $T$ rounds with the same success guarantee. By Lemma 6, $T=Omega(m)=Omega(n/q)$. #qed

This is worst-case tightness across the parameterized family. It does not assert a pointwise lower bound for every feasible pair $(n,q)$, or for every graph with $chi(G)<=q$. In particular, extra colors can change the complexity dramatically. The family above has $q=chi(G)$; its lower bound does not transfer to $(Delta+1)$-coloring.

= Consequences and scope

*Optimal coloring when the optimum is supplied.* Setting $q=chi(G)$ in Theorem 1 gives $O_c (n/chi(G))$ rounds. Theorem 7 matches this dependence in the worst case. Supplying the chromatic number does not remove the lower bound: the blow-up family already comes with its exact value.

*Constant-round exact coloring for linear palettes.* For each fixed $alpha>0$, every graph supplied with $chi(G)<=q<=n$ and $q>=alpha n$ can be $q$-colored in $O_(alpha,c) (1)$ rounds. This includes optimal coloring for graphs with supplied $chi(G)>=alpha n$.

*Degree-plus-one coloring.* If the maximum degree is at most a supplied $Delta<=n-1$, take $q=Delta+1$. The promise follows from greedy coloring, yielding $O_c (n/(Delta+1))$ rounds. For $Delta=Omega(n)$ this is constant. The general upper bound is not claimed to be the fastest available degree-plus-one algorithm in all other regimes.

*Why the repair includes the high-degree vertices.* Recoloring only the postponed set and its immediate boundary would not suffice for arbitrary $q$-colorable graphs: a boundary vertex can have degree at least $q$, leaving no simple extension guarantee. Adding every such vertex to the core gives a boundary of degree below $q$. The packing lemma bounds the communication cost of this enlargement, and components of $G^3 [U]$ ensure that the resulting patches do not interact.

*Role of existing tools and status of the note.* The small-palette branch uses the established network-decomposition theorem [RG20]. The dense branch uses a weighted version of local random-minimum multicoloring [K09], and the lower bound uses a familiar palette-alternation obstruction. Earlier work on optimal distributed coloring includes [BE19] and the more recent near-maximum-degree results of [FHJM26]. The proposed uniform upper bound here applies to every supplied feasible palette size $q$. This note supplies a complete argument for that bound; it does not certify a priority claim or report an independent peer review.

= References

#set text(size: 9.5pt)
#set par(justify: false, leading: 0.4em, spacing: 0.5em)

*[BE19]* Étienne Bamas and Louis Esperet. _Distributed Coloring of Graphs with an Optimal Number of Colors._ STACS 2019, LIPIcs 126, 10:1-10:15. #link("https://doi.org/10.4230/LIPIcs.STACS.2019.10")[doi:10.4230/LIPIcs.STACS.2019.10].

*[FHJM26]* Maxime Flin, Magnús M. Halldórsson, Manuel Jakob, and Yannic Maus. _Sublogarithmic Distributed Vertex Coloring with Optimal Number of Colors._ 2026. #link("https://arxiv.org/abs/2603.28637")[arXiv:2603.28637].

*[HK17]* Magnús M. Halldórsson and Christian Konrad. _Improved Distributed Algorithms for Coloring Interval Graphs with Application to Multicoloring Trees._ SIROCCO 2017; journal version, _Theoretical Computer Science_, 2019. #link("https://doi.org/10.1016/j.tcs.2018.11.028")[doi:10.1016/j.tcs.2018.11.028].

*[K09]* Fabian Kuhn. _Local Multicoloring Algorithms: Computing a Nearly-Optimal TDMA Schedule in Constant Time._ STACS 2009, LIPIcs 3, 613-624. #link("https://doi.org/10.4230/LIPIcs.STACS.2009.1852")[doi:10.4230/LIPIcs.STACS.2009.1852].

*[RG20]* Václav Rozhoň and Mohsen Ghaffari. _Polylogarithmic-Time Deterministic Network Decomposition and Distributed Derandomization._ STOC 2020. #link("https://arxiv.org/abs/1907.10937")[arXiv:1907.10937].

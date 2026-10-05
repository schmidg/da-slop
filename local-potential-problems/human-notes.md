# Local potential problems

(Notes by Gustav Schmid)

<!-- TODO: Add informal human notes below. Suggested structure: -->

## Main idea

All of the main ideas were already present in the original paper, but in the original analysis, we paid twice for the ball-growing argument at the heart of the approach. I already knew that the original analysis could be done using only the sequence of improving sets lemma, but I always had a dependence on the diameter of the improving sets. I knew that it should be possible to remove this, and GPT-6 managed to do it.

## What I checked

The new improving sequence lemma is correct and gives both improvements in the upper bounds with a straightforward adaptation of the existing approach.

## Open questions and possible issues

The lower bounds do not quite match the upper bounds. The issue might be that the definitions are slightly off. With LOC, we have a potential that just counts "bad" edges (that is, non-cut edges), while in the generic definition of local potential problems, we also have potential on the nodes. I think this is why the upper and lower bounds do not match exactly. Maybe by making some reasonable assumption on the local scale, or having a slightly cleaner definition, we can also get rid of the dependence on $K$.

I feel like it should be possible to shave one or two more log factors when aiming at specific problems, for example, in a specific algorithm for LOC.

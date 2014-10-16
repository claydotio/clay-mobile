Experiments
===========

Experiments are a way for us to test whether or not a feature is worthwhile
to do a full experiments AND learn useful information that may alter
how we experiment the complete version of a feature.

The goal for experiments is to pump the code out as quickly as possible. Since
a feature may not be implemented based on the results of an experiment, it
does not make sense to spend needless time writing tests, performing in-depth
code reviews, etc...

This is not to say we should write poor code. Proper balance of speed and
quality is still a must.

As much of the experiment code as possible should live within its own experiment
directory, so removing an experiment is as simple as deleting the experiment
folder and the one or two references located in the main codebase.

## Structure

Each experiment should have the same structure as the `src` folder. This
makes it easier to merge an experiment into the main codebase, should it do well

```
+-/src/{experiment_name}
| +-coffee
| | +- components
| | +- pages
| | +- models
| +-stylus
```

## Reference Code

Any code that references an experiment must live in root.coffee (though this
requirement is subject to change if it's not flexible enough)

Any code in the main codebase that is required to reference an experiment must
be preceded by a comment:
```
# START EXPERIMENT: experiment_name (should be the same as the folder name)
```

followed by another comment:

```
# END EXPERIMENT: experiment_name
```

## Converting an experiment into a feature

Before an experiment can become a full-fledged feature, it will need to be
finished to the quality of the rest of our code - including tests-written, and
code thoroughly reviewed.


## Ideas

Have each experiments folder checkout a full git branch inside it, would make
merging easier

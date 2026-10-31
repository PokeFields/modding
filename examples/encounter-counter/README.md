# Encounter Counter

Counts every wild monster you run into, how many were shiny, and which species you've seen most.
The counts are kept per character and survive restarts.

`storage.load()` and `storage.save()` do the saving. Saved data goes through JSON, which is why
species are counted under string keys.

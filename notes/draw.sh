#!/bin/bash
# Does an M4 -> Dot -> SVG conversion on a single file.

DOT_DIAGRAM="prepositional_phrase_problem"

dot -Tsvg "$DOT_DIAGRAM".dot -o diagrams/"$DOT_DIAGRAM".dot.svg

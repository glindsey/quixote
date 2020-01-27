#!/bin/bash
# Does an M4 -> Dot -> SVG conversion on a single file.

DOT_DIAGRAM="noun_clause_state_machine"

dot -Tsvg "$DOT_DIAGRAM".dot -o diagrams/"$DOT_DIAGRAM".dot.svg
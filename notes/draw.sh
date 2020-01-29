#!/bin/bash
# Does an M4 -> Dot -> SVG conversion on a single file.

DOT_DIAGRAM="compound_element_state_machine"

dot -Tsvg "$DOT_DIAGRAM".dot -o diagrams/"$DOT_DIAGRAM".dot.svg

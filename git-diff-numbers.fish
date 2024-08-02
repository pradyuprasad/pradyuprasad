#!/usr/bin/env fish

set diff_output (git diff --color=always --unified=0 README.md)
echo "$diff_output" | awk '
  BEGIN {
    old_line = 0
    new_line = 0
  }
  /^@@/ {
    split($0, a, " ");
    split(a[2], b, ",");
    old_line = substr(b[1], 2);
    split(a[3], c, ",");
    new_line = substr(c[1], 2);
    print $0
    next
  }
  /^[+-]/ {
    if ($0 ~ /^-/) {
      print "\033[31mOld line " old_line ": " substr($0, 2) "\033[0m";
      old_line++;
    } else {
      print "\033[32mNew line " new_line ": " substr($0, 2) "\033[0m";
      new_line++;
    }
    next
  }
  { old_line++; new_line++ }
  /^[^+-]/ {
    print "Line " old_line ": " $0;
    old_line++; new_line++
  }
'


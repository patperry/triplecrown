#!/usr/bin/env awk -f


function rmspan(str)
{
    gsub(/<\/?span[^>]*>/, "", str)
    return str
}

function strip(str)
{
    sub(/^[[:space:]]*/, "", str)
    sub(/[[:space:]]*$/, "", str)
    return str
}

function field(f)
{
    f = rmspan(f)
    f = strip(f)
    sub(/^([^\|]*\|)*/, "", f)
    sub(/^[[:space:]]*(\[\[)?/, "", f)
    gsub(/\[\[|\]\]|<br>|'''?|[*†‡]/, "", f)
    gsub(/[[:space:]]+/, " ", f)
    return f
}

function year(f)
{
    f = field(f)
    sub(/PS| BS/, "", f)
    return f
}

BEGIN {
    header = 1
}
{ 
    if (header == 1) {
       if (NR == 2) {
            header = 0
            FS = "\n";
            RS = "\\|-[^\n]*\n";
            NR = 0
        }
    } else {
        printf "%s", year($1)
        for (i = 2; i < NF; i++) {
            printf "\t%s", field($i)
        }
        printf "\n"
    }
}


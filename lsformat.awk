# AWK Script to format the output of ls
# - relative time since last modified
# - colors

BEGIN {
    # time
    minute = 60
    hour = minute * 60
    day = hour * 24
    month = day * 30.5
    year = month * 12
    # colors
    black = "\033[30m"
    red = "\033[31m"
    green = "\033[32m"
    yellow = "\033[33m"
    blue = "\033[34m"
    magenta = "\033[35m"
    cyan = "\033[36m"
    white = "\033[37m"
    # preserve white space
    FPAT = "([[:space:]]*[^[:space:]]+)"
    OFS = ""
}

$1 == "total" {
    print white $0
}
$1 != "total" {
    permissions = $1
    gsub("r", green "r", permissions)
    gsub("w", yellow "w", permissions)
    gsub("x", magenta "x", permissions)
    gsub("-", white "-", permissions)
    gsub("d", blue "d", permissions)
    gsub("l", red "l", permissions)
    links = $2
    owner = $3
    group = $4
    size = $5
    gsub("K|M|G|$", yellow "&", size)
    last_modified = $6
    # file name may be split into several fields
    file = $7
    for (i = 8; i <= NF; i++)
	file = file " " $i
    relative_last_mod = systime() - last_modified

    if (relative_last_mod > year)
	time = cyan int(relative_last_mod / year) " years"
    else if (relative_last_mod > month)
	time = blue int(relative_last_mod / month) " months"
    else if (relative_last_mod > day)
	time = magenta int(relative_last_mod / day) " days"
    else if (relative_last_mod > hour)
	time = green int(relative_last_mod / hour)" hours"
    else if (relative_last_mod > minute)
	time = yellow int(relative_last_mod / minute)" minutes"
    else
	time = red relative_last_mod " seconds"

    # note: control code length = 5
    printf("%s%s%s%s%14s%16s%s\n",
	  cyan permissions,
	  red links,
	  white owner,
	  white group,
	  green size,
	  time,
	  file)
}


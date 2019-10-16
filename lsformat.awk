# AWK Script to format the output of ls
# - relative time since last modified
# - colors

BEGIN {
    # time string
    timestr[0] = "second"
    timestr[1] = "minute"
    timestr[2] = "hour"
    timestr[3] = "day"
    timestr[4] = "month"
    timestr[5] = "year"

    # time value
    minute = 60
    hour = minute * 60
    day = hour * 24
    month = day * 30.5
    year = month * 12
    timeval[0] = 0
    timeval[1] = minute
    timeval[2] = hour
    timeval[3] = day
    timeval[4] = month
    timeval[5] = year

    # colors
    black = "\033[30m"
    red = "\033[31m"
    green = "\033[32m"
    yellow = "\033[33m"
    blue = "\033[34m"
    magenta = "\033[35m"
    cyan = "\033[36m"
    white = "\033[37m"
    timecolor[0] = red
    timecolor[1] = yellow
    timecolor[2] = green
    timecolor[3] = magenta
    timecolor[4] = cyan
    timecolor[5] = blue

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

    # select appropriate time format
    for (i = length(timestr)-1; i >= 0; i--) {
        if (relative_last_mod >= timeval[i]) {
            time = int(relative_last_mod / (timeval[i] > 0 ? timeval[i] : 1))
            time = timecolor[i] time " " timestr[i] (time == 1 ? "" : "s")
            break
        }
    }

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

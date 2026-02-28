awk '{
    s=$1;
    d=int(s/86400); s-=d*86400;
    h=int(s/3600); s-=h*3600;
    m=int(s/60);

    # Build the string conditionally using spaces as separators
    output="";
    if (d >= 365) { output = int(d/365) "y"; d %= 365; }
    if (d > 0) { output = output (output==""?"":" ") d "d"; }
    if (h > 0) { output = output (output==""?"":" ") h "h"; }
    if (m > 0) { output = output (output==""?"":" ") m "m"; }
    
    # If less than a minute, show 0m
    if (output == "") { output = "0m"; }

    print output
}' /proc/uptime


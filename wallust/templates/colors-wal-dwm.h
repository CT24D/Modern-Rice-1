static const char norm_fg[] = "#c3c1c1";
static const char norm_bg[] = "#190000";
static const char norm_border[] = "#c00000";

static const char sel_fg[] = "#c3c1c1";
static const char sel_bg[] = "#c1a500";
static const char sel_border[] = "#c3c1c1";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
};

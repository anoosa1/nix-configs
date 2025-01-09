/* See LICENSE file for copyright and license details. */

/* Constants */
#define TERMINAL "alacritty"
#define TERMCLASS "St"
#define BROWSER "io.gitlab.librewolf-community"

/* appearance */
static const unsigned int borderpx       = 1;   /* border pixel of windows */
static const unsigned int snap           = 32;  /* snap pixel */
static const int swallowfloating         = 0;   /* 1 means swallow floating windows by default */
static const unsigned int gappih         = 5;  /* horiz inner gap between windows */
static const unsigned int gappiv         = 5;  /* vert inner gap between windows */
static const unsigned int gappoh         = 5;  /* horiz outer gap between windows and screen edge */
static const unsigned int gappov         = 5;  /* vert outer gap between windows and screen edge */
static const int smartgaps_fact          = 0;   /* gap factor when there is only one client; 0 = no gaps, 3 = 3x outer gaps */
static const char autostartblocksh[]     = "autostart_blocking.sh";
static const char autostartsh[]          = "autostart.sh";
static const char dwmdir[]               = "dwm";
static const char localshare[]           = ".local/share";
static const int showbar                 = 0;   /* 0 means no bar */
static const int topbar                  = 1;   /* 0 means bottom bar */
/* Status is to be shown on: -1 (all monitors), 0 (a specific monitor by index), 'A' (active monitor) */
static const int statusmon               = -1;
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int showsystray             = 1;   /* 0 means no systray */
static const unsigned int ulinepad = 5;         /* horizontal padding between the underline and tag */
static const unsigned int ulinestroke  = 2;     /* thickness / height of the underline */
static const unsigned int ulinevoffset = 0;     /* how far above the bottom of the bar the line should appear */
static const int ulineall = 0;                  /* 1 to show underline on all tags, 0 for just the active ones */

/* Indicators: see patch/bar_indicators.h for options */
static int tagindicatortype              = INDICATOR_NONE;
static int tiledindicatortype            = INDICATOR_NONE;
static int floatindicatortype            = INDICATOR_TOP_LEFT_SQUARE;
static const char *fonts[]               = { "Comic Code:size=12" };
static const char dmenufont[]            = "Comic Code:size=12";

static char c000000[]                    = "#000000"; // placeholder value

static char normfgcolor[]                = "#bbbbbb";
static char normbgcolor[]                = "#222222";
static char normbordercolor[]            = "#444444";
static char normfloatcolor[]             = "#db8fd9";

static char selfgcolor[]                 = "#eeeeee";
static char selbgcolor[]                 = "#005577";
static char selbordercolor[]             = "#005577";
static char selfloatcolor[]              = "#005577";

static char titlenormfgcolor[]           = "#eeeeee";
static char titlenormbgcolor[]           = "#005577";
static char titlenormbordercolor[]       = "#005577";
static char titlenormfloatcolor[]        = "#005577";

static char titleselfgcolor[]            = "#bbbbbb";
static char titleselbgcolor[]            = "#222222";
static char titleselbordercolor[]        = "#444444";
static char titleselfloatcolor[]         = "#db8fd9";

static char tagsnormfgcolor[]            = "#bbbbbb";
static char tagsnormbgcolor[]            = "#222222";
static char tagsnormbordercolor[]        = "#444444";
static char tagsnormfloatcolor[]         = "#db8fd9";

static char tagsselfgcolor[]             = "#eeeeee";
static char tagsselbgcolor[]             = "#005577";
static char tagsselbordercolor[]         = "#005577";
static char tagsselfloatcolor[]          = "#005577";

static char hidnormfgcolor[]             = "#005577";
static char hidselfgcolor[]              = "#227799";
static char hidnormbgcolor[]             = "#222222";
static char hidselbgcolor[]              = "#222222";

static char urgfgcolor[]                 = "#bbbbbb";
static char urgbgcolor[]                 = "#222222";
static char urgbordercolor[]             = "#ff0000";
static char urgfloatcolor[]              = "#db8fd9";



static const unsigned int baralpha = 0xb0;
static const unsigned int borderalpha = 0xb0;
static const unsigned int alphas[][3] = {
	/*                       fg      bg        border     */
	[SchemeNorm]         = { OPAQUE, baralpha, borderalpha },
	[SchemeSel]          = { OPAQUE, baralpha, borderalpha },
	[SchemeTitleNorm]    = { OPAQUE, baralpha, borderalpha },
	[SchemeTitleSel]     = { OPAQUE, baralpha, borderalpha },
	[SchemeTagsNorm]     = { OPAQUE, baralpha, borderalpha },
	[SchemeTagsSel]      = { OPAQUE, baralpha, borderalpha },
	[SchemeHidNorm]      = { OPAQUE, baralpha, borderalpha },
	[SchemeHidSel]       = { OPAQUE, baralpha, borderalpha },
	[SchemeUrg]          = { OPAQUE, baralpha, borderalpha },
};

static char *colors[][ColCount] = {
	/*                       fg                bg                border                float */
	[SchemeNorm]         = { normfgcolor,      normbgcolor,      normbordercolor,      normfloatcolor },
	[SchemeSel]          = { selfgcolor,       selbgcolor,       selbordercolor,       selfloatcolor },
	[SchemeTitleNorm]    = { titlenormfgcolor, titlenormbgcolor, titlenormbordercolor, titlenormfloatcolor },
	[SchemeTitleSel]     = { titleselfgcolor,  titleselbgcolor,  titleselbordercolor,  titleselfloatcolor },
	[SchemeTagsNorm]     = { tagsnormfgcolor,  tagsnormbgcolor,  tagsnormbordercolor,  tagsnormfloatcolor },
	[SchemeTagsSel]      = { tagsselfgcolor,   tagsselbgcolor,   tagsselbordercolor,   tagsselfloatcolor },
	[SchemeHidNorm]      = { hidnormfgcolor,   hidnormbgcolor,   c000000,              c000000 },
	[SchemeHidSel]       = { hidselfgcolor,    hidselbgcolor,    c000000,              c000000 },
	[SchemeUrg]          = { urgfgcolor,       urgbgcolor,       urgbordercolor,       urgfloatcolor },
};





/* Tags
 * In a traditional dwm the number of tags in use can be changed simply by changing the number
 * of strings in the tags array. This build does things a bit different which has some added
 * benefits. If you need to change the number of tags here then change the NUMTAGS macro in dwm.c.
 *
 * Examples:
 *
 *  1) static char *tagicons[][NUMTAGS*2] = {
 *         [DEFAULT_TAGS] = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I" },
 *     }
 *
 *  2) static char *tagicons[][1] = {
 *         [DEFAULT_TAGS] = { "•" },
 *     }
 *
 * The first example would result in the tags on the first monitor to be 1 through 9, while the
 * tags for the second monitor would be named A through I. A third monitor would start again at
 * 1 through 9 while the tags on a fourth monitor would also be named A through I. Note the tags
 * count of NUMTAGS*2 in the array initialiser which defines how many tag text / icon exists in
 * the array. This can be changed to *3 to add separate icons for a third monitor.
 *
 * For the second example each tag would be represented as a bullet point. Both cases work the
 * same from a technical standpoint - the icon index is derived from the tag index and the monitor
 * index. If the icon index is is greater than the number of tag icons then it will wrap around
 * until it an icon matches. Similarly if there are two tag icons then it would alternate between
 * them. This works seamlessly with alternative tags and alttagsdecoration patches.
 */
static char *tagicons[][NUMTAGS] =
{
	[DEFAULT_TAGS]        = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
	[ALTERNATIVE_TAGS]    = { "A", "B", "C", "D", "E", "F", "G", "H", "I" },
	[ALT_TAGS_DECORATION] = { "<1>", "<2>", "<3>", "<4>", "<5>", "<6>", "<7>", "<8>", "<9>" },
};


/* There are two options when it comes to per-client rules:
 *  - a typical struct table or
 *  - using the RULE macro
 *
 * A traditional struct table looks like this:
 *    // class      instance  title  wintype  tags mask  isfloating  monitor
 *    { "Gimp",     NULL,     NULL,  NULL,    1 << 4,    0,          -1 },
 *    { "Firefox",  NULL,     NULL,  NULL,    1 << 7,    0,          -1 },
 *
 * The RULE macro has the default values set for each field allowing you to only
 * specify the values that are relevant for your rule, e.g.
 *
 *    RULE(.class = "Gimp", .tags = 1 << 4)
 *    RULE(.class = "Firefox", .tags = 1 << 7)
 *
 * Refer to the Rule struct definition for the list of available fields depending on
 * the patches you enable.
 */
static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 *	WM_WINDOW_ROLE(STRING) = role
	 *	_NET_WM_WINDOW_TYPE(ATOM) = wintype
	 */
	RULE(.wintype = WTYPE "DIALOG", .isfloating = 1)
	RULE(.wintype = WTYPE "UTILITY", .isfloating = 1)
	RULE(.wintype = WTYPE "TOOLBAR", .isfloating = 1)
	RULE(.wintype = WTYPE "SPLASH", .isfloating = 1)
	RULE(.class = "Gimp", .tags = 1 << 4)
	RULE(.class = "Firefox", .tags = 1 << 7)
};



/* Bar rules allow you to configure what is shown where on the bar, as well as
 * introducing your own bar modules.
 *
 *    monitor:
 *      -1  show on all monitors
 *       0  show on monitor 0
 *      'A' show on active monitor (i.e. focused / selected) (or just -1 for active?)
 *    bar - bar index, 0 is default, 1 is extrabar
 *    alignment - how the module is aligned compared to other modules
 *    widthfunc, drawfunc, clickfunc - providing bar module width, draw and click functions
 *    name - does nothing, intended for visual clue and for logging / debugging
 */
static const BarRule barrules[] = {
	/* monitor   bar    alignment         widthfunc                 drawfunc                clickfunc                hoverfunc                name */
	{ -1,        0,     BAR_ALIGN_LEFT,   width_tags,               draw_tags,              click_tags,              hover_tags,              "tags" },
	{  0,        0,     BAR_ALIGN_RIGHT,  width_systray,            draw_systray,           click_systray,           NULL,                    "systray" },
	{ -1,        0,     BAR_ALIGN_LEFT,   width_ltsymbol,           draw_ltsymbol,          click_ltsymbol,          NULL,                    "layout" },
	{ statusmon, 0,     BAR_ALIGN_RIGHT,  width_status,             draw_status,            click_statuscmd,         NULL,                    "status" },
	{ -1,        0,     BAR_ALIGN_NONE,   width_wintitle,           draw_wintitle,          click_wintitle,          NULL,                    "wintitle" },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

#define FORCE_VSPLIT 1


static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
	{ "TTT",      bstack },
	{ "===",      bstackhoriz },
	{ "|M|",      centeredmaster },
	{ ">M>",      centeredfloatingmaster },
	{ "[D]",      deck },
	{ "(@)",      spiral },
	{ "[\\]",     dwindle },
	{ "HHH",      grid },
	{ "---",      horizgrid },
	{ ":::",      gaplessgrid },
	{ "###",      nrowgrid },
};


/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

#define STACKKEYS(MOD,ACTION) \
	{ MOD, XK_j,     ACTION##stack, {.i = INC(+1) } }, \
	{ MOD, XK_k,     ACTION##stack, {.i = INC(-1) } }, \
	{ MOD, XK_v,     ACTION##stack, {.i = 0 } },
	/* {  MOD, XK_s,     ACTION##stack, {.i = PREVSEL } }, \ */
	/* { MOD, XK_e,     ACTION##stack, {.i = 1 } }, \ */
	/* { MOD, XK_a,     ACTION##stack, {.i = 2 } }, \ */
	/* { MOD, XK_z,     ACTION##stack, {.i = -1 } }, *.


/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = {
	"dmenu_run",
	"-m", dmenumon,
	//"-fn", dmenufont,
	"-nb", normbgcolor,
	"-nf", normfgcolor,
	"-sb", selbgcolor,
	"-sf", selfgcolor,
	topbar ? NULL : "-b",
	NULL
};
static const char *termcmd[]  = { "alacritty", NULL };

/* commands spawned when clicking statusbar, the mouse button pressed is exported as BUTTON */
static const StatusCmd statuscmds[] = {
	{ "notify-send Volume$BUTTON", 1 },
	{ "notify-send CPU$BUTTON", 2 },
	{ "notify-send Battery$BUTTON", 3 },
};
/* test the above with: xsetroot -name "$(printf '\x01Volume |\x02 CPU |\x03 Battery')" */
static const char *statuscmd[] = { "/bin/sh", "-c", NULL, NULL };

#include <X11/XF86keysym.h>

static const Key keys[] = {
	/* modifier                     key            function                argument */
	STACKKEYS(MODKEY,                              focus)
	STACKKEYS(MODKEY|ShiftMask,                    push)
	{ MODKEY,                       XK_Left,       focusdir,               {.i = 0 } },
	{ MODKEY|ControlMask,           XK_Left,       shiftview,              { .i = -1 } },
	{ MODKEY|ShiftMask,             XK_Left,       shifttag,               { .i = -1 } },
	{ MODKEY,                       XK_Right,      focusdir,               {.i = 1 } },
	{ MODKEY|ControlMask,           XK_Right,      shiftview,              { .i = +1 } },
	{ MODKEY|ShiftMask,             XK_Right,      shifttag,               { .i = +1 } },
	{ MODKEY,                       XK_Up,         focusdir,               {.i = 2 } },
	{ MODKEY|ControlMask,           XK_Up,         shiftview,              { .i = +1 } },
	{ MODKEY|ShiftMask,             XK_Up,         shifttag,               { .i = +1 } },
	{ MODKEY,                       XK_Down,       focusdir,               {.i = 3 } },
	{ MODKEY|ControlMask,           XK_Down,       shiftview,              { .i = -1 } },
	{ MODKEY|ShiftMask,             XK_Down,       shifttag,               { .i = -1 } },
	{ MODKEY,                       XK_bracketright,incnmaster,            {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_bracketright,incnmaster,            {.i = -1 } },
	{ MODKEY,                       XK_Return,     spawn,                  {.v = termcmd } },
	{ MODKEY|ShiftMask,             XK_Return,     zoom,                   {0} },
	{ MODKEY,                       XK_Tab,        view,                   {0} },
	{ MODKEY|ShiftMask,             XK_Tab,        view,                   {.v = (const char*[]){ TERMINAL, "-e", "htop", NULL } } },
	{ MODKEY,                       XK_semicolon,  shiftview,              { .i = 1 } },
	{ MODKEY|ShiftMask,             XK_semicolon,  shifttag,               { .i = 1 } },
	{ MODKEY,                       XK_a,          togglegaps,             {0} },
	{ MODKEY|ShiftMask,             XK_a,          defaultgaps,            {0} },
	{ MODKEY,                       XK_b,          togglebar,              {0} },
	/* { MODKEY|ShiftMask,             XK_b,          spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_c,          spawn,                  {.v = (const char*[]){ TERMINAL, "-e", "profanity", NULL } } },
	{ MODKEY|ShiftMask,             XK_c,          spawn,                  SHCMD(TERMINAL " -e abook -C ~/.local/etc/abook/abookrc --datafile ~/.local/etc/abook/addressbook") },
	{ MODKEY,                       XK_d,          spawn,                  {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_d,          spawn,                  {.v = (const char*[]){ "passmenu", NULL } } },
        /* { MODKEY,                       XK_e,          hide,                   {0} }, */
        /* { MODKEY|ShiftMask,             XK_e,          show,                   {0} }, */
	{ MODKEY,                       XK_f,          togglefullscreen,       {0} },
	{ MODKEY|ShiftMask,             XK_f,          spawn,                  {.v = (const char*[]){ "ytfzf", "-D", NULL } } },
	{ MODKEY,                       XK_g,          shiftview,              { .i = -1 } },
	{ MODKEY|ShiftMask,             XK_g,          shifttag,               { .i = -1 } },
	{ MODKEY,                       XK_h,          setmfact,               {.f = -0.05} },
	/* { MODKEY|ShiftMask,             XK_h,          spawn,                  SHCMD("") }, */
	/* { MODKEY,                       XK_j,          spawn,                  SHCMD("") }, */
	/* { MODKEY|ShiftMask,             XK_j,          spawn,                  SHCMD("") }, */
	/* { MODKEY,                       XK_k,          spawn,                  SHCMD("") }, */
	/* { MODKEY|ShiftMask,             XK_k,          spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_l,          setmfact,               {.f = +0.05} },
	/* { MODKEY|ShiftMask,             XK_l,          spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_m,          spawn,                  {.v = (const char*[]){ TERMINAL, "-e", "ncmpcpp", NULL } } },
	/* { MODKEY|ShiftMask,             XK_m,          spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_n,          spawn,                  {.v = (const char*[]){ TERMINAL, "-e", "nvim", "-c", "VimwikiIndex", NULL } } },
	{ MODKEY|ShiftMask,             XK_n,          spawn,                  SHCMD(TERMINAL " -e newsboat ; pkill -RTMIN+6 dwmblocks") },
	{ MODKEY,                       XK_q,          killclient,             {0} },
	{ MODKEY|ShiftMask,             XK_q,          quit,                   {0} },
	{ MODKEY|ControlMask|ShiftMask, XK_q,          quit,                   {1} },
	{ MODKEY,                       XK_r,          spawn,                  {.v = (const char*[]){ TERMINAL, "-e", "lf", NULL } } },
	{ MODKEY|ShiftMask,             XK_r,          self_restart,           {0} },
	{ MODKEY,                       XK_s,          togglesticky,           {0} },
	/* { MODKEY|ShiftMask,             XK_s,          spawn,                  SHCMD("") }, */
	/* { MODKEY,                       XK_v,          spawn,                  SHCMD("") }, */
	/* { MODKEY|ShiftMask,             XK_v,          spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_w,          spawn,                  {.v = (const char*[]){ BROWSER, NULL } } },
	{ MODKEY|ShiftMask,             XK_w,          spawn,                  {.v = (const char*[]){ TERMINAL, "-e", "iwctl", NULL } } },
	{ MODKEY,                       XK_x,          incrgaps,              {.i = -3 } },
	/* { MODKEY|ShiftMask,          XK_x,          spawn,                 SHCMD("") }, */
	{ MODKEY,                       XK_z,          incrgaps,               {.i = +3 } },
	/* { MODKEY|ShiftMask,          XK_z,          spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_t,          setlayout,              {.v = &layouts[0]} }, /* tile */
	{ MODKEY|ShiftMask,             XK_t,          setlayout,              {.v = &layouts[1]} }, /* float */
	{ MODKEY,                       XK_o,          setlayout,              {.v = &layouts[2]} }, /* monocle */
	{ MODKEY|ShiftMask,             XK_o,          setlayout,              {.v = &layouts[3]} }, /* bstack */
	{ MODKEY,                       XK_i,          setlayout,              {.v = &layouts[4]} }, /* bstackhoriz */
	{ MODKEY|ShiftMask,             XK_i,          setlayout,              {.v = &layouts[5]} }, /* centeredmaster */
	{ MODKEY,                       XK_u,          setlayout,              {.v = &layouts[6]} }, /* centeredfloatingmaster */
	{ MODKEY|ShiftMask,             XK_u,          setlayout,              {.v = &layouts[7]} }, /* deck  */
	{ MODKEY,                       XK_y,          setlayout,              {.v = &layouts[8]} }, /* spiral */
	{ MODKEY|ShiftMask,             XK_y,          setlayout,              {.v = &layouts[9]} }, /* dwindle */
	{ MODKEY,                       XK_p,          setlayout,              {.v = &layouts[10]} },/* grid */
	{ MODKEY|ShiftMask,             XK_p,          setlayout,              {.v = &layouts[11]} },/* horizgrid */
	{ MODKEY,                       XK_bracketleft,setlayout,              {.v = &layouts[12]} },/* gaplessgrid */
	{ MODKEY|ShiftMask,             XK_bracketleft,setlayout,              {.v = &layouts[13]} },/* nrowgrid */
	{ MODKEY,                       XK_space,      zoom,                   {0} },
	{ MODKEY|ShiftMask,             XK_space,      togglefloating,         {0} },
	{ MODKEY,                       XK_comma,      focusmon,               {.i = -1 } },
	{ MODKEY,                       XK_period,     focusmon,               {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,      tagmon,                 {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period,     tagmon,                 {.i = +1 } },
	{ MODKEY,                       XK_Insert,     spawn,                  SHCMD("xdotool type $(grep -v '^#' ~/.local/share/larbs/snippets | dmenu -i -l 50 | cut -d' ' -f1)") },
	/* { MODKEY|ShiftMask,          XK_Insert,     spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_F1,         spawn,                  SHCMD("groff -mom ~/.local/share/dwm/larbs.mom -Tpdf | zathura -") },
	/* { MODKEY|ShiftMask,             XK_F1,        spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_F2,         spawn,                  {.v = (const char*[]){ "tutorialvids.sh", NULL } } },
	/* { MODKEY|ShiftMask,             XK_F2,        spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_F3,         spawn,                  {.v = (const char*[]){ "displayselect.sh", NULL } } },
	/* { MODKEY|ShiftMask,             XK_F3,        spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_F4,         spawn,                  SHCMD(TERMINAL " -e pulsemixer; kill -44 $(pidof dwmblocks)") },
	/* { MODKEY|ShiftMask,             XK_F4,        spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_F5,         spawn,                  SHCMD(TERMINAL " -e gotop") },
	/* { MODKEY|ShiftMask,             XK_F5,        spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_F6,         spawn,                  {.v = (const char*[]){ "torwrap.sh", NULL } } },
	/* { MODKEY|ShiftMask,             XK_F6,        spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_F7,         spawn,                  {.v = (const char*[]){ "td-toggle.sh", NULL } } },
	/* { MODKEY|ShiftMask,             XK_F7,        spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_F8,         spawn,                  {.v = (const char*[]){ "mailsync", NULL } } },
	/* { MODKEY|ShiftMask,             XK_F8,        spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_F9,         spawn,                  {.v = (const char*[]){ "mounter.sh", NULL } } },
	/* { MODKEY|ShiftMask,             XK_F9,        spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_F10,        spawn,                  {.v = (const char*[]){ "unmounter.sh", NULL } } },
	/* { MODKEY|ShiftMask,             XK_F10,        spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_F11,        spawn,                  SHCMD("mpv --untimed --no-cache --no-osc --no-input-default-bindings --profile=low-latency --input-conf=/dev/null --title=webcam $(ls /dev/video[0,2,4,6,8] | tail -n 1)") },
	/* { MODKEY|ShiftMask,             XK_F11,        spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_F12,        spawn,                  SHCMD("remaps.sh") },
	/* { MODKEY|ShiftMask,             XK_F12,        spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_Escape,     spawn,                  {.v = (const char*[]){ "dmenukb.sh", NULL } } },
	/* { MODKEY|ShiftMask,             XK_Escape,     spawn,                  SHCMD("") }, */
	/* { MODKEY,                       XK_minus,      spawn,                  SHCMD("") }, */
	/* { MODKEY|ShiftMask,             XK_minus,      spawn,                  SHCMD("") }, */
	/* { MODKEY,                       XK_equal,      spawn,                  SHCMD("") }, */
	/* { MODKEY|ShiftMask,             XK_equal,      spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_grave,      spawn,                  {.v = (const char*[]){ "dmenuunicode.sh", NULL } } },
	/* { MODKEY|ShiftMask,             XK_grave,      spawn,                  SHCMD("") }, */
	{ MODKEY,                       XK_BackSpace,  spawn,                  {.v = (const char*[]){ "sysact.sh", NULL } } },
	{ MODKEY|ShiftMask,             XK_BackSpace,  spawn,                  {.v = (const char*[]){ "sysact.sh", NULL } } },
	{ 0,                            XK_Print,      spawn,                  SHCMD("maim pic-full-$(date '+%y%m%d-%H%M-%S').png") },
	{ ShiftMask,                    XK_Print,      spawn,                  {.v = (const char*[]){ "maimpick.sh", NULL } } },
	{ MODKEY,                       XK_Print,      spawn,                  {.v = (const char*[]){ "dmenurecord.sh", NULL } } },
	{ MODKEY|ShiftMask,             XK_Print,      spawn,                  {.v = (const char*[]){ "dmenurecord.sh", "kill", NULL } } },
	{ MODKEY,                       XK_Delete,     spawn,                  {.v = (const char*[]){ "dmenurecord.sh", "kill", NULL } } },
	{ MODKEY,                       XK_Scroll_Lock,spawn,                  SHCMD("killall screenkey || screenkey &") },
	{ MODKEY,                       XK_0,          view,                   {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,          tag,                    {.ui = ~0 } },

	TAGKEYS(                        XK_1,                                  0)
	TAGKEYS(                        XK_2,                                  1)
	TAGKEYS(                        XK_3,                                  2)
	TAGKEYS(                        XK_4,                                  3)
	TAGKEYS(                        XK_5,                                  4)
	TAGKEYS(                        XK_6,                                  5)
	TAGKEYS(                        XK_7,                                  6)
	TAGKEYS(                        XK_8,                                  7)
	TAGKEYS(                        XK_9,                                  8)

	{ 0, XF86XK_MyComputer,         spawn,          {.v = (const char*[]){ TERMINAL, "-e",  "lf",  "/", NULL } } },
	{ 0, XF86XK_Search,             spawn,          SHCMD("dmenu_run") },
	{ 0, XF86XK_Calculator,         spawn,          {.v = (const char*[]){ TERMINAL, "-e", "calcurse", NULL } } },
	{ 0, XF86XK_AudioMedia,         spawn,          {.v = (const char*[]){ TERMINAL, "-e", "ncmpcpp", NULL } } },
	{ 0, XF86XK_AudioRaiseVolume,   spawn,          SHCMD("pulsemixer --change-volume +5; kill -44 $(pidof dwmblocks)") },
	{ 0, XF86XK_AudioLowerVolume,   spawn,          SHCMD("pulsemixer --change-volume -5; kill -44 $(pidof dwmblocks)") },
	{ 0, XF86XK_AudioMute,          spawn,          SHCMD("pulsemixer --toggle-mute; kill -44 $(pidof dwmblocks)") },
	{ 0, XF86XK_AudioPlay,          spawn,          {.v = (const char*[]){ "mpc", "toggle", NULL } } },
	{ 0, XF86XK_AudioPrev,          spawn,          {.v = (const char*[]){ "mpc", "prev", NULL } } },
	{ 0, XF86XK_AudioNext,          spawn,          {.v = (const char*[]){ "mpc", "next", NULL } } },
	{ 0, XF86XK_AudioStop,          spawn,          {.v = (const char*[]){ "mpc", "stop", NULL } } },
	{ 0, XF86XK_HomePage,           spawn,          {.v = (const char*[]){ TERMINAL, "-e",  "lf", NULL } } },
	{ 0, XF86XK_Mail,               spawn,          SHCMD(TERMINAL " -e neomutt ; pkill -RTMIN+12 dwmblocks") },
	{ 0, XF86XK_Favorites,          spawn,          SHCMD("dmenuhandler.sh") },
};


/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask           button          function        argument */
	{ ClkLtSymbol,          0,                   Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,                   Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,                   Button2,        zoom,           {0} },
	{ ClkStatusText,        0,                   Button1,        spawn,          {.v = statuscmd } },
	{ ClkStatusText,        0,                   Button2,        spawn,          {.v = statuscmd } },
	{ ClkStatusText,        0,                   Button3,        spawn,          {.v = statuscmd } },
	/* placemouse options, choose which feels more natural:
	 *    0 - tiled position is relative to mouse cursor
	 *    1 - tiled postiion is relative to window center
	 *    2 - mouse pointer warps to window center
	 *
	 * The moveorplace uses movemouse or placemouse depending on the floating state
	 * of the selected client. Set up individual keybindings for the two if you want
	 * to control these separately (i.e. to retain the feature to move a tiled window
	 * into a floating position).
	 */
	{ ClkClientWin,         MODKEY,              Button1,        moveorplace,    {.i = 1} },
	{ ClkClientWin,         MODKEY,              Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,              Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,                   Button1,        view,           {0} },
	{ ClkTagBar,            0,                   Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,              Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,              Button3,        toggletag,      {0} },
};


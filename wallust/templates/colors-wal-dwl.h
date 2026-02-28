/* Taken from https://github.com/djpohly/dwl/issues/466 */
#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f, \
                        ((hex >> 16) & 0xFF) / 255.0f, \
                        ((hex >> 8) & 0xFF) / 255.0f, \
                        (hex & 0xFF) / 255.0f }

static const float rootcolor[]             = COLOR(0x190000ff);
static uint32_t colors[][3]                = {
	/*               fg          bg          border    */
	[SchemeNorm] = { 0xc3c1c1ff, 0x190000ff, 0xc00000ff },
	[SchemeSel]  = { 0xc3c1c1ff, 0xdb007cff, 0xc1a500ff },
	[SchemeUrg]  = { 0xc3c1c1ff, 0xc1a500ff, 0xdb007cff },
};

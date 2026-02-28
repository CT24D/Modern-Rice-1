const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#190000", /* black   */
  [1] = "#c1a500", /* red     */
  [2] = "#db007c", /* green   */
  [3] = "#d6bb00", /* yellow  */
  [4] = "#fca700", /* blue    */
  [5] = "#ff601a", /* magenta */
  [6] = "#ffc525", /* cyan    */
  [7] = "#968c8c", /* white   */

  /* 8 bright colors */
  [8]  = "#c00000",  /* black   */
  [9]  = "#ffcc02",  /* red     */
  [10] = "#ff269f", /* green   */
  [11] = "#ffe81f", /* yellow  */
  [12] = "#fec552", /* blue    */
  [13] = "#ffa579", /* magenta */
  [14] = "#ffdb88", /* cyan    */
  [15] = "#c3c1c1", /* white   */

  /* special colors */
  [256] = "#190000", /* background */
  [257] = "#c3c1c1", /* foreground */
  [258] = "#c3c1c1",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;

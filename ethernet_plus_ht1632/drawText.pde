/* ********************************************************************** 

          FUNCTIONS FOR DRAWING TEXT ON HT1632 32X8 LED DISPLAY

* *********************************************************************** */
#define START_X   2 // start drawing text on second pixel in horizontal
#define START_Y   2 // start drawing text on second pixel in horizontal
/* ********************************************************************** 
*/
/*

*/
int drawTextLeftToRight_AUXSERVER(char strone[MAX_DISPLAY_AUXSERVER], char strtwo[MAX_DISPLAY_AUXSERVER]){
  int wdone = 0;
  int wdtwo = 0;
  wdone = HT1632.getTextWidth(strone, FONT_5X4_WIDTH, FONT_5X4_HEIGHT);
  wdtwo = HT1632.getTextWidth(strtwo, FONT_5X4_WIDTH, FONT_5X4_HEIGHT);
 
  HT1632.drawTarget(BUFFER_BOARD(1));
  HT1632.clear();
  HT1632.drawText(strone, (33-counterone), START_Y, FONT_5X4, FONT_5X4_WIDTH, FONT_5X4_HEIGHT, FONT_5X4_STEP_GLYPH);
  HT1632.render();

  HT1632.drawTarget(BUFFER_BOARD(2));
  HT1632.clear();
  HT1632.drawText(strtwo, (33-countertwo), START_Y, FONT_5X4, FONT_5X4_WIDTH, FONT_5X4_HEIGHT,FONT_5X4_STEP_GLYPH);
  HT1632.render(); 
 // Font rendering example
  countertwo = (countertwo+1)%((wdtwo-30) + 32 * 2);
  counterone = (counterone+1)%((wdone-30) + 32 * 2);
  
  if(wdone > wdtwo){
    return counterone;
  }else{
    return countertwo;
    }
}
/*

*/
int drawTextLeftToRight_DIGITALPLATFORM(char strone[MAX_DISPLAY_DIGITALPLATFORM], char strtwo[MAX_DISPLAY_DIGITALPLATFORM]){
  int wdone = 0;
  int wdtwo = 0;

  HT1632.drawTarget(BUFFER_BOARD(1));
  HT1632.clear();
  HT1632.drawText(strone, (33-counterone), START_Y, FONT_5X4, FONT_5X4_WIDTH, FONT_5X4_HEIGHT, FONT_5X4_STEP_GLYPH);
  HT1632.render();

  HT1632.drawTarget(BUFFER_BOARD(2));
  HT1632.clear();
  HT1632.drawText(strtwo, (33-countertwo), START_Y, FONT_5X4, FONT_5X4_WIDTH, FONT_5X4_HEIGHT,FONT_5X4_STEP_GLYPH);
  HT1632.render(); 

 // Font rendering example
  wdone = HT1632.getTextWidth(strone, FONT_5X4_WIDTH, FONT_5X4_HEIGHT);
  wdtwo = HT1632.getTextWidth(strtwo, FONT_5X4_WIDTH, FONT_5X4_HEIGHT);
  countertwo = (countertwo+1)%((wdtwo-30) + 32 * 2);
  counterone = (counterone+1)%((wdone-30) + 32 * 2);
  
  if(wdone > wdtwo){
    return counterone;
  }else{
    return countertwo;
    }
} 

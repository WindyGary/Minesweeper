import de.bezier.guido.*;
private static final int NUM_ROWS = 10;
private static final int NUM_COLS = 10;
private static final int NUM_MINES = 1 + NUM_ROWS * NUM_COLS / 10;
private boolean isGameOver = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

// delete the system.println 
void setup ()
{   
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );
  buttons = new MSButton[NUM_ROWS][NUM_COLS];  //this initalizes the button empty apartment building
  mines = new ArrayList<MSButton>();

  //your code to initialize buttons goes here
  for (int ix = 0; ix < NUM_ROWS; ix++) {
    for (int iy = 0; iy < NUM_COLS; iy++) {
      buttons[ix][iy] = new MSButton(ix, iy);
    }
  }
  setMines();  // placed one mine
}
public void setMines()
{

  for (int i = 0; i < NUM_MINES; i++){
      int row = (int)(Math.random()*NUM_ROWS);
      int col = (int)(Math.random()*NUM_COLS);

    if (!mines.contains(buttons[row][col])) {
      mines.add(buttons[row][col]);
    } else {
      i--;
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon()){
    displayWinningMessage();
    }
  else if (isGameOver){
    displayLosingMessage();
  }
}
public boolean isWon()
{
  for (int ix = 0; ix < NUM_ROWS; ix++) {
    for (int iy = 0; iy < NUM_COLS; iy++){
      if (!buttons[ix][iy].clicked && !mines.contains(buttons[ix][iy])){
        return false;
      }
    }
  }
  return true;
}
public void displayLosingMessage()
{
  textAlign(CENTER, CENTER);
  textSize(20);
  text("YOU LOSE!!!", height/2, width/2);
  textSize(10);
}
public void displayWinningMessage()
{
  textAlign(CENTER, CENTER);
  textSize(20);
  text("YOU WIN!!!", height/2, width/2);
  textSize(10);
}
public boolean isValid(int r, int c)
{
  if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {
    return true;
  }
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int j = row-1; j <= row+1; j++) {
    for (int i = col-1; i <= col+1; i++) {
      //if (j < 0 || j > 4 || i < 0 || i > 4 || j == row && i == col) {
      //  continue;
      //}
      //if (mines.contains(buttons[j][i])) {
      //  numMines++;
      //}
        if (isValid(j, i) && mines.contains(buttons[j][i])) {
        numMines++;
      }
    }
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  public void mousePressed () 
  { 
    if(mouseButton == LEFT && !flagged){
    clicked = true;
    }
    if(mouseButton == RIGHT){
      if (!clicked){
        flagged = !flagged;
      }
    }
    if (mines.contains(this) &&  clicked && !flagged){  
      isGameOver = true;
      isLose();
    }
    else if (countMines(myRow, myCol) > 0 && clicked){     
     setLabel(countMines(myRow, myCol));
    }
    else{
        clickNeighboringButtons(myRow - 1, myCol - 1); 
        clickNeighboringButtons(myRow - 1, myCol);     
        clickNeighboringButtons(myRow - 1, myCol + 1); 
        clickNeighboringButtons(myRow, myCol - 1);     
        clickNeighboringButtons(myRow, myCol + 1);     
        clickNeighboringButtons(myRow + 1, myCol - 1); 
        clickNeighboringButtons(myRow + 1, myCol);     
        clickNeighboringButtons(myRow + 1, myCol + 1);

    }
  }
  public void clickNeighboringButtons(int r, int c) {
    if (isValid(r, c) && !buttons[r][c].clicked) {
        buttons[r][c].mousePressed();
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if (clicked && mines.contains(this))
      fill(255, 0, 0);
    else if (clicked)
      fill(200);
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    textSize(10);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}

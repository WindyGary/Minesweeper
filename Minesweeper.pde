import de.bezier.guido.*;
private static final int NUM_ROWS = 15;
private static final int NUM_COLS = 15;
private static final int NUM_MINES = 1 + NUM_ROWS * NUM_COLS / 10;
private boolean isGameLose = false;
private boolean recursing = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
void setup ()
{
  size(600,600);
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
  setMines();
}
public void setMines()
{
  for (int i = 0; i < NUM_MINES; i++) {
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);

    if (!mines.contains(buttons[row][col])) {
      mines.add(buttons[row][col]);
    } else {
      i--;
    }
  }
}
void draw() {
  background(0);
}
public boolean isWon()
{
  for (int ix = 0; ix < NUM_ROWS; ix++) {
    for (int iy = 0; iy < NUM_COLS; iy++) {
      if (!buttons[ix][iy].clicked && !mines.contains(buttons[ix][iy])) {
        return false;
      }
    }
  }
  return true;
}
public void displayLosingMessage()
{
  textSize(30);
  fill(100, 55, 200);
  text("YOU LOSE!!!", width/2, height/2);
  if (checkIfClicked()) {
    text("YOU ARE VERY UNLUCKY!!!", width/2, height/2+50);
  }
}
public void displayWinningMessage()
{
  textSize(30);
  fill(100, 55, 200);
  text("YOU WIN!!!", width/2, height/2);
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
      if (isValid(j, i) && mines.contains(buttons[j][i])) {
        numMines++;
      }
    }
  }
  return numMines;
}
public boolean checkIfClicked() {
  for (int ix = 0; ix < NUM_ROWS; ix++) {
    for (int iy = 0; iy < NUM_COLS; iy++) {
      if (buttons[ix][iy].clicked && !mines.contains(buttons[ix][iy])) {
        return false;
      }
    }
  }
  return true;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 600/NUM_COLS;
    height = 600/NUM_ROWS;
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
    if (!isGameLose) {
      if (mouseButton == LEFT && !flagged || recursing) {
        flagged = false;
        clicked = true;
        recursing = false;
      }
      if (mouseButton == RIGHT) {
        if (flagged) {
          flagged = false;
        } else if (!flagged && !clicked) {
          flagged = true;
        }
      } else if (!flagged) {
        if (mines.contains(this) &&  clicked) {
          isGameLose = true;
        } else if (countMines(myRow, myCol) > 0 && clicked) {
          setLabel(countMines(myRow, myCol));
        } else if (countMines(myRow, myCol) == 0) {
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
    }
  }
  public void clickNeighboringButtons(int r, int c) {
    if (isValid(r, c) && !buttons[r][c].clicked) {
      recursing = true;
      buttons[r][c].mousePressed();
    }
  }
  public void draw ()
  {
    if (flagged) {
      fill(0);
    } else if (clicked && mines.contains(this)) {
      fill(255, 0, 0);
    } else if (clicked) {
      fill(200);
    } else {
      fill( 100 );
    }
    
    if (isGameLose && mines.contains(this)){    // reveal the mines
      fill(255, 0, 0);
    } else if (isWon() && mines.contains(this)){
      fill(0,0,123);
    }
    rect(x, y, width, height);
    fill(0);
    textSize(10);
    text(myLabel, x+width/2, y+height/2);

    if (isWon()) {
      displayWinningMessage();
    } else if (isGameLose) {
      displayLosingMessage();
    }
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

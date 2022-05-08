import javax.swing.JOptionPane;
final int GRID=9;
final int SUB_GRID=3;
int fixArr[]={0, 0, 2, 0, 8, 0, 5, 0, 0, 8, 0, 1, 2, 5, 7, 0, 4, 9, 0, 4, 0, 0, 0, 3, 8, 2, 7, 0, 8, 4, 1, 9, 0, 0, 0, 3, 3, 0, 0, 7, 0, 5, 2, 0, 0, 1, 0, 7, 0, 3, 2, 0, 0, 0, 0, 0, 0, 0, 7, 8, 0, 0, 0, 0, 6, 0, 0, 0, 9, 1, 0, 0, 0, 2, 8, 5, 0, 0, 0, 7, 4};
int newArr[]={0, 0, 2, 0, 8, 0, 5, 0, 0, 8, 0, 1, 2, 5, 7, 0, 4, 9, 0, 4, 0, 0, 0, 3, 8, 2, 7, 0, 8, 4, 1, 9, 0, 0, 0, 3, 3, 0, 0, 7, 0, 5, 2, 0, 0, 1, 0, 7, 0, 3, 2, 0, 0, 0, 0, 0, 0, 0, 7, 8, 0, 0, 0, 0, 6, 0, 0, 0, 9, 1, 0, 0, 0, 2, 8, 5, 0, 0, 0, 7, 4};

void setup() {
  size(500, 500);
  background(200);
}

void draw() {
  drawGrid();
  fixedNumbers();
}

void drawGrid() { //draws the Sudoku matrix
  strokeWeight(1);
  for (int i=0; i<GRID; i++) {
    line(0, i*width/GRID, width, i*width/GRID);
    line(i*height/GRID, 0, i*height/GRID, height);
  }

  strokeWeight(5);
  for (int i=0; i<=SUB_GRID; i++) { 
    line(0, i*width/SUB_GRID, width, i*width/SUB_GRID);
    line(i*height/SUB_GRID, 0, i*height/SUB_GRID, height);
  }
}

void fixedNumbers() { //draws the fixed numbers on grid
  fill(0, 0, 255);
  textSize(0.04*width);
  for (int i=0; i<GRID; i++) {
    for (int j=0; j<GRID; j++) {
      if (fixArr[getCellNum(i, j)]!=0)
        text(fixArr[getCellNum(i, j)], i*width/GRID+2*textWidth(Integer.toString(fixArr[getCellNum(i, j)])), j*height/GRID+2*textAscent());
    }
  }
}

int getCellNum(int i, int j) {
  return i+j+(GRID-1)*j;
}

int inputNumber() { //only allows numbers 1-9 to be displayed
  String temp="";
  int num=0;
  if (Character.isDigit(key) && key!=0) {
    temp=key+"";
    num=int(temp);
    return num;
  } else if (key=='c'||key=='C')
    return 99;
  else {
    println("Invalid");
    return -1;
  }
}
void displayMessage() {
  int getNumber=inputNumber();
  if (getNumber==99) 
    println("Typed character :"+(char)getNumber+ "\nNow you can remove any wrong entry\nNow click on any cell with your mouse...");
  else
    println("Typed Character :"+getNumber+ "\nNow click on any cell with your mouse...");
}

void mouseClicked() {
  fill(0);
  displayMessage();
  int getNumber=inputNumber();
  for (int i=0; i<GRID; i++) {
    for (int j=0; j<GRID; j++) {
      if (mouseX>i*width/GRID && mouseX<(i+1)*width/GRID && mouseY>j*height/GRID && mouseY<(j+1)*height/GRID && fixArr[getCellNum(i, j)]==0 && getNumber!=-1) { 
        if (sudokuCheck(i, j) && getNumber!=99) {
          newArr[getCellNum(i, j)]=getNumber;
          text(Integer.toString(newArr[getCellNum(i, j)]), i*width/GRID+2*textWidth(Integer.toString(newArr[getCellNum(i, j)])), j*height/GRID+2*textAscent());
        } 
        else if (!sudokuCheck(i, j) && getNumber!=99) 
          JOptionPane.showMessageDialog(null, "You can only enter numbers 1-9 in a row, column and block once!\n Number blocked: "+getNumber, "Repetition found!", JOptionPane.ERROR_MESSAGE);

        else if (getNumber==99 && fixArr[(getCellNum(i, j))]==0) {
          newArr[getCellNum(i, j)]=0;
          fill(200);
          strokeWeight(0.005);
          rect(i*width/GRID, j*height/GRID, width/GRID, height/GRID);
        }
      } else if (mouseX>i*width/GRID && mouseX<(i+1)*width/GRID && mouseY>j*height/GRID && mouseY<(j+1)*height/GRID && fixArr[getCellNum(i, j)]!=0 && getNumber==99)
        JOptionPane.showMessageDialog(null, "You cannot remove entries made by the computer", "Error", JOptionPane.ERROR_MESSAGE);
    }
  }
}

boolean sudokuCheck(int i, int j) { //checks if there is repition in row, column or block
  int getNumber=inputNumber();
  int start=getCellNum(i, j)-getCellNum(i, j)%GRID;
  int end=getCellNum(i, j)-getCellNum(i, j)%GRID+(GRID-1);
  for (int k=start; k<end; k++) { //row check
    if (newArr[k]==getNumber) 
      return false;
  }
  for (int k=getCellNum(i, j)%GRID; k<newArr.length; k+=GRID) { //column check
    if (newArr[k]==getNumber) 
      return false;
  }
  int array[]=blockCheck(i, j); //block check
  for (int k=0; k<GRID; k++) {
    if (newArr[array[k]]==getNumber)
      return false;
  }
  return true;
}

int blockCheck(int i, int j)[]{ //finds which block has the clicked cell
  int block1[]={0, 1, 2, 9, 10, 11, 18, 19, 20};
  int block2[]={3, 4, 5, 12, 13, 14, 21, 22, 23};
  int block3[]={6, 7, 8, 15, 16, 17, 24, 25, 26};
  int block4[]={27, 28, 29, 36, 37, 38, 45, 46, 47};
  int block5[]={30, 31, 32, 39, 40, 41, 48, 49, 50};
  int block6[]={33, 34, 35, 42, 43, 44, 51, 52, 53};
  int block7[]={54, 55, 56, 63, 64, 65, 72, 73, 74};
  int block8[]={57, 58, 59, 66, 67, 68, 75, 76, 77};
  int block9[]={60, 61, 62, 69, 70, 71, 78, 79, 80};

   if (selectBlock(block1, i, j))
     return block1;
   if (selectBlock(block2, i, j))
     return block2;
   if (selectBlock(block3, i, j))
     return block3;
   if (selectBlock(block4, i, j))
     return block4;
   if (selectBlock(block5, i, j))
     return block5;
   if (selectBlock(block6, i, j))
     return block6;
   if (selectBlock(block7, i, j))
     return block7;
   if (selectBlock(block8, i, j))
     return block8;
   if (selectBlock(block9, i, j))
     return block9;
   else
     return null;
}

boolean selectBlock(int array[], int i, int j) { //checks if the clicked cell is in the block 
  int index=getCellNum(i, j);
  for (int k=0; k<GRID; k++) {
    if (array[k]==index)
      return true;
  }
  return false;
}

  

PImage bg1,bg2;
PImage enemy, fighter,hp,treasure;
PImage start1, start2, end1, end2;

PImage shoot;

int bg1X,bg1Y,bg2X,bg2Y;

float rollSpeed,bloodAmount;
float treasureX,treasureY;  
float enemyX, enemyY, enemySpeed;
float fighterX, fighterY, fighterSpeed;

boolean isPlaying;
boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;
boolean showTreasureImage = true;
boolean showLose;


final int START = 0;
final int PLAYING = 1;
final int WIN = 2;
final int LOSE = 3;
final float BLOOD = 19.2;
final int ENEMYLENGTH = 61;

final int ENEMY1 = 1;
final int ENEMY2 = 2;
final int ENEMY3 = 3;

int gameState = START;
int enemyState = ENEMY1;
int counter =0;

float [] enemyArrayX = new float[8];
float [] enemyArrayY = new float[8];
boolean [] enemyCrash = new boolean[8];


//for flame
PImage[] flame = new PImage[5];
float flameTime;
float crashX = 900000000;
float crashY = 900000000;
float sec = 0;

//for shoot
boolean [] shootBoo = new boolean[100];
boolean spacePressedBoo = false;
float shootY;
float shootX;
float [] shootPosX = new float[100];
float [] shootPosY = new float[100];
int shootCounter= 1 ;

int score = 0;



void setup () {
  textSize(40);
  
  size(640, 480) ;
  
  //crash initialize
  for(int i = 0; i< enemyCrash.length;i++){
    enemyCrash[i] = false;
  }
  
  //shoot initialize
  for(int i = 0; i< shootBoo.length;i++){
    shootBoo[i] = false;
  }
  
  
  
  //loadimage
  bg1 = loadImage("img/bg1.png");
  bg2 = loadImage("img/bg2.png");
  enemy = loadImage("img/enemy.png");
  fighter = loadImage("img/fighter.png");
  hp = loadImage("img/hp.png");
  treasure = loadImage("img/treasure.png");
  start1 = loadImage("img/start1.png");
  start2 = loadImage("img/start2.png");
  end1 = loadImage("img/end1.png");
  end2 = loadImage("img/end2.png");
  
  flame[0] = loadImage("img/flame1.png");
  flame[1] = loadImage("img/flame2.png");
  flame[2] = loadImage("img/flame3.png");
  flame[3] = loadImage("img/flame4.png");
  flame[4] = loadImage("img/flame5.png");
  
  shoot = loadImage("img/shoot.png");
  
  //bg position
  bg1X = 0;
  bg2X = -640;
  
  //speed
  rollSpeed = 1;
  enemySpeed = 2;
  fighterSpeed = 5;
  
  //blood amount 
  bloodAmount = BLOOD*2;
  
  //treaaure position random  
  treasureX = random(0,600);
  treasureY = random(0,440);
  
  //enemy position random
  enemyX = 0;
  enemyY = random(40,440);
  
  //fighter position
  fighterX = width-60;
  fighterY = height/2;
}

void draw() {
   
  switch(gameState){
  
  case START:
    image(start2,0,0);
    
    //hover
    if(mouseX>=220&&mouseX<=420&&mouseY>=380&&mouseY<=400){
      image(start1,0,0);
      
      //start game
      if(mousePressed){
        gameState = PLAYING;
      }
    }
    
    break;
    
  case PLAYING:  
   
     
     
    //backgound
    image(bg1,bg1X,0);
    bg1X+=rollSpeed;
    image(bg2,bg2X,0);
    bg2X+=rollSpeed;;
    fill(255,0,0);
    text("score:"+score,70,450);
    //background repeat
    if(bg1X==640){
      //bg1X = bg1X-1280;
      bg1X = -640;
    }else if(bg2X==640){
      //bg2X-=1280;
      bg2X = -640;
    }
    
    
    //fighter--//
        //fighter image
    image(fighter,fighterX,fighterY);
    
        //fighter move
    if (upPressed) {
        fighterY -= fighterSpeed;
      }
    if (downPressed) {
        fighterY += fighterSpeed;
      }
    if (leftPressed) {
        fighterX -= fighterSpeed;
      }
    if (rightPressed) {
        fighterX += fighterSpeed;
      }
      
        //fighter boundary detection
    if(fighterX>590){
      fighterX = 590;
    }
    if(fighterX<0){
      fighterX = 0;
    }
    if(fighterY>430){
      fighterY = 430;
    }
    if(fighterY<0){
      fighterY = 0;
    }
    
    //--fighter//
    
    
    
    
    
    
        
    //treasure--// 
    if(showTreasureImage){
      image(treasure,treasureX,treasureY);
    }
       
       //blood limit
    if(bloodAmount>BLOOD*10){
      bloodAmount = BLOOD*10;
    }else if(bloodAmount <=0){
      gameState = LOSE;
    }
             
        //hp and blood
    fill(255,0,0);
    noStroke();     
    rect(29,20,bloodAmount,20);
    image(hp,20,20);
    
        
          
        //fighter vs treasure vs blood
    if(fighterX>treasureX-20 && fighterX<(treasureX+21) && fighterY>treasureY-20 && fighterY<(treasureY+21) ){
      bloodAmount= bloodAmount+BLOOD;
      showTreasureImage = false;
      treasureX = random(0,600);
      treasureY = random(0,440);
    }
    
        //re-show
    if(counter%30==0){
      showTreasureImage = true;
    }
    counter++;
    
    //--treasure//
    
    
    //enemy--//
        //track fighter
            /*
            if(enemyY>=fighterY){
              enemyY-=enemySpeed;
            }else if(enemyY<fighterY){
              enemyY+=enemySpeed;
            }
            */
            
        //move
        enemyX += enemySpeed;
        if(enemyState>3){
          enemyState =1;
      } 
        
        //enemyState
    switch(enemyState){
        case ENEMY1:
        
          for(int i =0;i< 5;i++){
            if(enemyCrash[i] == false){
              enemyArrayX[i] = enemyX-i*ENEMYLENGTH;
              enemyArrayY[i] = enemyY;
            }
            
            if(enemyCrash[i] == true){
              enemyArrayY[i] = 100000000;
            }
            image(enemy,enemyArrayX[i],enemyArrayY[i]);
          }
          fighterVSenemyHitTest();
          shoot(5);
          flameAndResetCrash();
          closeEnemy(fighterX,fighterY,5);
        break;
            
        case ENEMY2:
          for(int i =0;i< 5;i++){
            if(enemyCrash[i] == false){
              enemyArrayX[i] = enemyX-i*ENEMYLENGTH;
              enemyArrayY[i] = enemyY-i*ENEMYLENGTH;
            }
            if(enemyCrash[i] == true){
              enemyArrayY[i] = 100000000;
            }
              image(enemy,enemyArrayX[i],enemyArrayY[i]);
          }
          fighterVSenemyHitTest();
          shoot(5);
          flameAndResetCrash();
          //boundary detection
          if(enemyY-4*ENEMYLENGTH<0){
            enemyY = 4*ENEMYLENGTH;
          }
          
        break;
        
        case ENEMY3:
        for(int i = 0; i<enemyArrayX.length;i++){
          if(enemyCrash[i]==false){
            if(i == 0){
              enemyArrayX[i] = enemyX-i*ENEMYLENGTH;
              enemyArrayY[i] = enemyY-i*ENEMYLENGTH;
            }else if(i ==1){
              enemyArrayX[i] = enemyX-i*ENEMYLENGTH;
              enemyArrayY[i] = enemyY-i*ENEMYLENGTH;
            }else if(i ==2){
              enemyArrayX[i] = enemyX-i*ENEMYLENGTH;
              enemyArrayY[i] = enemyY-i*ENEMYLENGTH;
            }else if(i ==3){
              enemyArrayX[i] = enemyX-i*ENEMYLENGTH;
              enemyArrayY[i] = enemyY-(i-2)*ENEMYLENGTH;
            }else if(i ==4){
              enemyArrayX[i] = enemyX-i*ENEMYLENGTH;
              enemyArrayY[i] = enemyY;
            }else if(i==5){
              enemyArrayX[i] = enemyX-(i-2)*ENEMYLENGTH;
              enemyArrayY[i] = enemyY+(i-4)*ENEMYLENGTH;
            }else if(i==6){
              enemyArrayX[i] = enemyX-(i-4)*ENEMYLENGTH;
              enemyArrayY[i] = enemyY+(i-4)*ENEMYLENGTH;
            }else if(i==7){
              enemyArrayX[i] = enemyX-(i-6)*ENEMYLENGTH;
              enemyArrayY[i] = enemyY+(i-6)*ENEMYLENGTH;
            }
          }
          if(enemyCrash[i]==true){
            enemyArrayY[i] = 100000;
          }
            image(enemy,enemyArrayX[i],enemyArrayY[i]);
        }
        fighterVSenemyHitTest();
        shoot(8);
        flameAndResetCrash();
        //boundary detection
        if(enemyY+3*ENEMYLENGTH>height){
          enemyY=height-(3*ENEMYLENGTH);
        }
        if(enemyY-2*ENEMYLENGTH<0){
          enemyY=2*ENEMYLENGTH;
        }
        break;
      }
  
    //--enemy//
  
  case WIN:
    
    break;
    
  case LOSE:
    image(end2,0,0);
    enemyState = 1;
    //hover
    if(mouseX>215 && mouseX<425 && mouseY>300 && mouseY<340){
      image(end1,0,0);
      //restart
      if(mousePressed){
        gameState = PLAYING;
        
        //reset game setting
        bloodAmount = BLOOD*2;
        fighterX = width-60;
        fighterY = height/2;
        enemyX = 0-ENEMYLENGTH;
        for(int i =0; i <enemyCrash.length;i++){
          enemyCrash[i] = false;
        }
      }
     }
    
    break;
 }

}
void keyPressed(){
  
   if (key == CODED) { 
    switch (keyCode) {
      case UP:
        upPressed = true;
        break;
      case DOWN:
        downPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
      
    }
  }
  
  if(key==' '){
    shootBoo[shootCounter] = true;
    spacePressedBoo = true;
  }
  

}
void keyReleased(){
  
   if (key == CODED) {
    switch (keyCode) {
      case UP:
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
      
    }
  }

}



void fighterVSenemyHitTest(){
  //hit test
          for(int i =0;i< 8;i++){
              if(fighterX>enemyArrayX[i]-35 && fighterX<(enemyArrayX[i]+35) && fighterY>enemyArrayY[i]-35 && fighterY<(enemyArrayY[i]+35)){
            bloodAmount = bloodAmount -BLOOD*2;
            //for crash
            enemyCrash[i] = true;
            crashX = enemyArrayX[i]+30;
            crashY = enemyArrayY[i]+30;
            } 
          }
}



void shoot(int enemyNum){
  //shoot--------//
    if(spacePressedBoo){
      shootPosX[shootCounter] = fighterX;
      shootPosY[shootCounter] = fighterY;
      spacePressedBoo =false;
      
      shootCounter++;
      if(shootCounter==6){
        shootCounter =1;
      }
    }
    
    for(int i =0;i<6;i++){
      if(shootBoo[i]){
        image(shoot,shootPosX[i],shootPosY[i]);
      }
      
      if(shootPosY[i]<enemyArrayY[closeEnemy(fighterX,fighterY,enemyNum)])
      {
        shootPosY[i]+=3;
      }
      if(shootPosY[i]>enemyArrayY[closeEnemy(fighterX,fighterY,enemyNum)])
      {
        shootPosY[i]-=3;
      }
     shootPosX[i]-=5;      
    }
    
    
    
    //shoot hit test
          for(int i =0;i<enemyNum ;i++){
            for(int j =0;j<6;j++){
              if(shootPosX[j]>enemyArrayX[i]-35 && shootPosX[j]<(enemyArrayX[i]+35) && shootPosY[j]>enemyArrayY[i]-35 && shootPosY[j]<(enemyArrayY[i]+35)){
            
            enemyCrash[i] = true;
            crashX = enemyArrayX[i]+30;
            crashY = enemyArrayY[i]+30; 
            shootPosY[j] = 1000000;
            score+=20;
              }
            } 
          }
    
    
    
    //--------shoot//
}
void flameAndResetCrash(){
  //flame
          sec++;
          if(sec>6){
             flameTime++;
             sec=0;
           }
           if(flameTime>=flame.length){
             crashX=10000; 
             crashY=10000;
             flameTime=0;
           }
          image(flame[(int)flameTime],crashX,crashY);
          
          // reset and reset crash
          if(enemyX >= (width+ENEMYLENGTH*4)){
            enemyX = 0-ENEMYLENGTH;
            enemyY = random(40,400);
            enemyState++;
            
            for(int i = 0; i<enemyCrash.length;i++){
              enemyCrash[i] = false;
            }  
          }
}

int closeEnemy(float x, float y, int enemyNum)
{
  float [] distance = new float[enemyNum];
  float smallest = 1000000000;
  int closestEnemy=0;
  
  for(int i = 0;i<enemyNum;i++)
  {
    distance[i] = (x - enemyArrayX[i])*(x - enemyArrayX[i])+(y - enemyArrayY[i])*(y - enemyArrayY[i]);
  }
  
  for(int i = 0;i<enemyNum;i++)
  {
    if(distance[i]<smallest)
    {
      smallest = distance[i];
    }
  }
  
  for(int i = 0;i<enemyNum;i++)
  {
    if(distance[i]==smallest)
    {
      closestEnemy = i;
    }
  }
  println(closestEnemy);
  return closestEnemy;
  

}

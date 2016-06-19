boolean clickable = true;
int width = 1000;
int height = 600;
int bcColor = 100;
int stage = 1;
int w = 20, h = 20;
PVector position;
PVector velocity;
PVector acceleration;
PVector mouse = new PVector(0, 0);
double angle = 0;
double vInitial = 0;
double displaySpeed = 0;
double posOldx = 0, posOldy = 0;
double maxHeightx = -1;
double maxHeighty = 0;

double scaleF = 0.1;



void setup() {
 size(width, height);
 frameRate(30);
 position = new PVector(50, 550);
 velocity = new PVector(0, 0);
 acceleration = new PVector(0, 9.8);
}

void updateMouse() {
 position.set(50, 550);

 // Draws the ball in the initial position
 fill(0, 121, 164);
 stroke(255);
 strokeWeight(3);
 ellipse(position.x, position.y, w, h);

 // Draws coordinate axes
 line(50, 550, 50, 400);
 line(50, 550, 200, 550);

 if (mousePressed && mouseX >= 50 && mouseY <= 550) {
  // Update mouse pos
  stroke(215, 73, 96);
  strokeWeight(5);
  mouse.set(mouseX, mouseY);
  mouse.sub(position); 
  line(50, 550, mouse.x + 50, mouse.y + 550);

  // Display v0
  fill(255);
  vInitial = dist(50, 550, mouse.x, mouse.y) * scaleF;
  displaySpeed = map(vInitial, 50, 140, 10, 50);
  displaySpeed = nf(displaySpeed, 0, 2);
  textFont("sans-serif", 20);
  text("vi = " + nf(displaySpeed, 0, 2) + " m/s", mouseX, mouseY - 20);

  angle = acos((mouseX - 50 + mouseY - 550) / sqrt(2) / sqrt(pow(mouseX - 50, 2) + pow(mouseY - 550, 2))) - 45 * PI / 180;
  noFill();
  stroke(255);
  strokeWeight(1);
  arc(50, 550, 100, 100, 2 * PI - angle, 2 * PI);
  text(nf(angle * 180 / PI, 0, 1) + " deg", 130, 540);
  clickable = false;
 }
}

void updateBall() {
 // Update ball physics
 velocity.add(acceleration);
 position.add(velocity);

 // Check Max height
 if (position.y > posOldy && maxHeightx == -1) {
  maxHeightx = posOldx;
  maxHeighty = posOldy;
  console.log("max height " + maxHeighty);
 } else {
  posOldx = position.x;
  posOldy = position.y;
 }

 // Draw ball
 fill(0, 121, 164);
 stroke(255);
 strokeWeight(3);

 if (position.y <= 550)
  ellipse(position.x, position.y, w, h);

 // Draws coordinate axes
 line(50, 550, 50, 400);
 line(50, 550, 200, 550);

 if (position.y > 550) {
  stage = 3;
 }
}

void displayResults() {
 if (!clickable) {

  // Calculate max height
  double maxHeight = pow(displaySpeed * sin(angle), 2) / (2 * 9.8);
  double maxHeightForImage = pow(vInitial * sin(angle), 2) / (2 * 9.8);

  // Calcuate time until drop
  double timeFinal = 2 * displaySpeed * sin(angle) / 9.8;
  double timeFinalForImage = 2 * vInitial * sin(angle) / 9.8;

  // Calculate max range
  double maxRange = displaySpeed * cos(angle) * timeFinal;
  double maxRangeForImage = vInitial * cos(angle) * timeFinal;

  // Draw on max Height
  stroke(217, 91, 67);
  strokeWeight(10);
  line(maxHeightx, 550, maxHeightx, maxHeighty);

  // Draw Results box (transparent)
  stroke(96, 42, 94, 255 * 1 / 2);
  strokeWeight(10);
  fill(29, 21, 78, 255 * 1 / 2);
  rect(650, 50, 300, 500);

  // Display results
  fill(255);
  textFont("serif", 48);
  text("Results", 720, 120);
  textFont("sans-serif", 18);
  text("vi = " + nf(displaySpeed, 0, 2) + " m/s", 670, 180);
  text("Angle = " + nf(angle * 180 / PI, 0, 2) + " deg", 670, 220);
  text("Time ball hits ground = " + nf(timeFinal, 0, 2) + " s", 670, 270);
  text("Range when ball hits ground = ", 670, 310);
  text(nf(maxRange, 0, 2) + " m", 710, 330)
  text("Maximum Height = " + nf(maxHeight, 0, 2) + " m", 670, 370);

  text("Click anywhere to restart", 700, 500);
 }
}

void mouseClicked() {
 if (clickable == false && stage == 1) {
  console.log("stage 2");
  velocity.set(vInitial * cos(angle), -vInitial * sin(angle));
  position.add(velocity);
  posOldy = position.y;
  posOldx = position.x;
  stage = 2;
 }
 if (clickable && stage == 3) {
  // FLUSH EVERYTHING
  maxHeightx = -1;
  maxHeighty = 0;
  oldPosx = 0;
  oldPosy = 0;
  stage = 1;
 }
}

void draw() {

 stroke(255);

 if (stage == 1) {
  background(bcColor);
  updateMouse();
 }
 if (stage == 2) {
  updateBall();
 }
 if (stage == 3) {
  displayResults();
  clickable = true;
 }
}
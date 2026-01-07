
void setup() {
  // println(System.getProperty("java.version"));
  // Version 17.x. Pretty modern, we got a lot of cool things to work with >:3
  
  size(640, 480);
  
  // Set up internal services
  httpConnectionSetup();
  cameraFeedSetup();
  
  
}

void draw() {
  //text("hello!", 100, 100);
  background(#FFFFFF);
  
  // Draw the feed of the camera.
  cameraFeed();
  
  // Draw recording icon (temporary)
  fill(#FF0000);
  circle(48, 48, 32);
  
}





void mousePressed() {
  
  // Stop the Draw loop
  noLoop();
  
  // Capture the webcam's feed
  PImage cameraOutput = captureFeed();
  
  if (cameraOutput == null) return;
  cameraOutput.save("data/cameraoutput.jpg"); // Save the image (if it exists) to the drive.
  image(cameraOutput, 0, 0); // Preview the image.
  
  fill(#999999);
  circle(48, 48, 32);
  
  delay(200); // Debounce
  
  // Send a request to the AI and point to the newly saved image.
  String result = requestDetection("cameraoutput.jpg");
  
  // Process Result
  processModelResult(result);

  // Restart the draw() loop
  loop();
  
}

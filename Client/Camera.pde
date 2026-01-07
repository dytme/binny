
// █▀█ █▀▀ █▀█ █░█ █ █▀█ █▀▀ █▀▄▀█ █▀▀ █▄░█ ▀█▀ █▀
// █▀▄ ██▄ ▀▀█ █▄█ █ █▀▄ ██▄ █░▀░█ ██▄ █░▀█ ░█░ ▄█

import processing.video.*; // Import the official library that lets us utilize the webcam's input.
Capture video; // Video feed




void cameraFeedSetup() {

  video = new Capture(this, 640, 480); // PApplet + 640x480 resolution, a safe / standard choice.
                                       // The model API will handle resizing, and trying to force a square aspect ratio of 640x640 only caused compression issues.
                                       
  video.start(); // Start capturing the live feed.
  println(video.width, video.height);
}

void cameraFeed() {
  if (video.available()) {
     video.read();
     image(video, 0, 0);
  }
}

PImage captureFeed() {
  if (video.available()) {
    video.read();
    return video;
  } else return null;
}

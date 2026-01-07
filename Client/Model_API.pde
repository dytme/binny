
// █▀█ █▀▀ █▀█ █░█ █ █▀█ █▀▀ █▀▄▀█ █▀▀ █▄░█ ▀█▀ █▀
// █▀▄ ██▄ ▀▀█ █▄█ █ █▀▄ ██▄ █░▀░█ ██▄ █░▀█ ░█░ ▄█

// Importing the new Java HTTP Client, which is nicer to use than the older method(s).

// TODO: Credit Oracle?
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

HttpClient client;
String detectAPI = "http://localhost:3000/detect";

// Name map for possible detection results
JSONObject nameMap;

// Look-up table that tells us where an item is supposed to be disposed.
JSONObject binMap;


void httpConnectionSetup() {
  // Create HTTP Client
  println("Attempting to create Http client");
  client = HttpClient.newHttpClient();
  println("Http client created!");
  
  // Load in JSON files.
  nameMap = loadJSONObject("name_map.json");
  binMap = loadJSONObject("bin_map.json");
}

// █▀█ █▀▀ █▀█ █░█ █▀▀ █▀ ▀█▀   █▀▄ █▀▀ ▀█▀ █▀▀ █▀▀ ▀█▀ █ █▀█ █▄░█
// █▀▄ ██▄ ▀▀█ █▄█ ██▄ ▄█ ░█░   █▄▀ ██▄ ░█░ ██▄ █▄▄ ░█░ █ █▄█ █░▀█

String requestDetection(String filePath) {
  
  println("Client detection request");
  byte[] image = loadBytes(filePath);
  
  if (image == null) {
    return "Invalid image at filepath.";
  }
  
  println("Image loaded in");
  
  // Huge thanks to baeldung.com for the guide on setting up the Java HTTP Client and sending POST requests through it.
  // https://www.baeldung.com/java-httpclient-post#bd-preparing-a-post-request
  HttpRequest req = HttpRequest.newBuilder()
    .uri(URI.create(detectAPI))
    .header("Content-Type", "image/jpeg")
    .POST(HttpRequest.BodyPublishers.ofByteArray(image))
    .build();
    
  println("Http Request Built");
    
  try {
    
    println("Sending request to server");
    HttpResponse<String> res = client.send(req, HttpResponse.BodyHandlers.ofString());
    println("Connection Status: " + res.statusCode());
    return res.body();
    
    
  } catch (IOException e) {
    println("Connection to the Model API failed. Full error:");
    println(e);
    return "-2";
  } catch (InterruptedException e) {
    println("Server connection interrupted");
    println(e);
    return "-2";
  }
  
}

// Attribute the int result returned by the model with an actual object and disposal category.
void processModelResult(String result) {
  
  // Turn the String back into an integer. Used to determine errors (any result < 0 is an error/issue);
  int intResult = Integer.parseInt(result);
  
  // Any result smaller than -2 implies an error. If that's the case, we'll print nothing.
  if (intResult <= -2) return;
  
  // Set up default answers.
  String objectName = "N/A";
  String disposalCategory = "N/A";
  
  // Analyze result(s)
  if (intResult > 0 && intResult < 59) { // If the model detected something, then it will always return an integer between 0 and 59.
    objectName = nameMap.getString(result);
    disposalCategory = binMap.getString(result);
  } else if (intResult == -1) { // If the model detected nothing, then it returns -1.
    objectName = "None Detected";
  }
  
  // Output result(s)
  println("==========================");
  println("Results of last detection:");
  println("Raw Int: " + result);
  println("Object Type: " + objectName);
  println("Disposal: " + disposalCategory);
  println("==========================");
  
  // TODO: Implement Hardware Behaviour and Explicit Output based on disposalCategory
  switch (disposalCategory) {
    case "RESIDUAL":
      break;
    case "PLASTIC":
      break;
    case "PAPER":
      break;
    case "SERVICE_DESK":
      break;
    default:
      break;
  }
  
}

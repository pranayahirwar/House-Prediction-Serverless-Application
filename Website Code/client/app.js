function getBathValue() {
  var uiBathrooms = document.getElementsByName("uiBathrooms");
  for (var i in uiBathrooms) {
    if (uiBathrooms[i].checked) {
      return parseInt(i) + 1;
    }
  }
  return -1;
}

function getBHKValue() {
  var uiBHK = document.getElementsByName("uiBHK");
  for (var i in uiBHK) {
    if (uiBHK[i].checked) {
      return parseInt(i) + 1;
    }
  }
  return -1;
}

function onClickedEstimatePrice() {
  console.log("Estimate price button clicked");
  var location = document.getElementById("uiLocations");
  var sqft = document.getElementById("uiSqft");
  var bhk = getBHKValue();
  var bathrooms = getBathValue();
  var estPrice = document.getElementById("uiEstimatedPrice");

  //Extracted values for some varaible
  var locationValue = location.value;
  var sqftValue = parseFloat(sqft.value);

  // Calling Azure API which will call Azure Function

  var url = "https://hp-api-management.azure-api.net/prediction/function-1-exp";
  url += "?subscription-key=Bb3r$pnJ7&xLM6sTk0DVQtZ9c8f2W@hu";
  url += "&location=" + encodeURIComponent(locationValue);
  url += "&total_sqft=" + encodeURIComponent(sqftValue);
  url += "&bhk=" + encodeURIComponent(bhk);
  url += "&bathrooms=" + encodeURIComponent(bathrooms);

  $.post(url, function (data, status) {
    estPrice.innerHTML = "<h2>" + data + " Lakhs</h2>";
    console.log(status);
  });

}

function onPageLoad() {
  console.log("document loaded");
  var url = "/api/get_location_names";
  $.get(url, function (data, status) {
    console.log("got response for get_location_names request");
    if (data) {
      var locations = data.locations;
      var uiLocations = document.getElementById("uiLocations");
      $('#uiLocations').empty();
      for (var i in locations) {
        var opt = new Option(locations[i]);
        $('#uiLocations').append(opt);
      }
    }
  });
}

window.onload = onPageLoad;

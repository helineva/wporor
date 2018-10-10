const BREWERIES = {};

BREWERIES.show = () => {
  $("#brewerytable tr:gt(0)").remove();
  const table = $("#brewerytable");

  BREWERIES.list.forEach((brewery) => {
    table.append('<tr>'
      + '<td>' + brewery['name'] + '</td>'
      + '<td>' + brewery['year'] + '</td>'
      + '<td>' + brewery['beers_count'] + '</td>'
      + '<td>' + brewery['active'] + '</td>'
      + '</tr>');
  });
};

document.addEventListener("turbolinks:load", () => {
  if ($("#brewerytable").length == 0) {
    return;
  };

  $.getJSON('breweries.json', (breweries) => {
    BREWERIES.list = breweries;
    BREWERIES.show();
  });
});

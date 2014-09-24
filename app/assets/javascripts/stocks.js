$(document).ready(function() {
   $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });

  var $form = $('form[id=generate_graph]');
  var $formUser = $('form[id=generate_stock_quote]');

  $form.on('submit', ajaxGraph);
  $formUser.on('submit', ajaxStockQuote);


});

function ajaxStockQuote() {
  event.preventDefault();

  $.ajax('/investments', {
    type: 'POST',
    dataType: 'json',
    data: $(this).serialize()
  }).done(function(data) {
    console.log(data);
    $('.stock-info').html(injectStockHTML(data));
  })
}

function ajaxGraph() {
  event.preventDefault();
  console.log(this)

  $.ajax('/stocks', {
    type: 'POST',
    dataType: 'json',
    data: $(this).serialize()
  }).done(function(response) {
    dataArray = generateDataArray(response.pastStockData);
    renderGraph(dataArray, response.currentStockData.symbol);
  })
}


function parseClosingData(pastStockDataObjects) {
  var result = [];

  for (var i = 0; i < pastStockDataObjects.length; i++) {
    console.log(pastStockDataObjects[i]);
    floatClose = parseFloat(pastStockDataObjects[i].adjusted_close);
    result.push(floatClose);
  }

  return result.reverse();
}


function dateData(resultObj) {
  var result = [];

  for (var i = 0; i < resultObj.length; i++) {
    result.push(Date.parse(resultObj[i].trade_date));
  }

  return result.reverse();
}


function generateDataArray(resultObj) {
  var dateArray = dateData(resultObj);
  var priceArray = parseClosingData(resultObj);
  var result = [];

  for (var i = 0; i < resultObj.length; i++) {
    result.push([dateArray[i], priceArray[i]]);
  }

  return result;
}

// function parseData(data) {
//   var result = $.parseJSON(data.file_data);
//   return generateDataArray(result.results);
// }

function injectStockHTML(data) {
  var html = '<p><b>Asking Price: </b>' + data.ask + '</p>';
  html += '<p><b> Bid Price: </b>' + data.bid + '</p>';
  html += '<p><b> Last trade date: </b>' + data.last_trade_date  + '</p>';
  html += '<p><b> PE ratio: </b>' + data.pe_ratio  + '</p>';
  html += '<p><b> Average Daily Volume: </b>' + data.average_daily_volume  + '</p>';
  html += '<p><b> Earnings Per Share: </b>' + data.earnings_per_share  + '</p>';
  html += '<p><b> 52 Week Low: </b>' + data.low_52_weeks  + '</p>';
  html += '<p><b> 52 Week High: </b>' + data.high_52_weeks  + '</p>';
  html += '<p><b> One Year Target Price: </b>' + data.one_year_target_price  + '</p>';
  html += '<p><b> 52 week range: </b>' + data.weeks_range_52  + '</p>';
  html += '<p><b> Day Value Change: </b>' + data.day_value_change  + '</p>';
  html += '<p><b> Dividend Yield: </b>' + data.dividend_yield;

  return html;
};

function renderGraph(dataArray, symbol) {
  $('#container').highcharts('StockChart', {
    rangeSelector: {
      selected: 1,
      inputEnabled: $('#container').width() > 480
    },
    title: {
      text: symbol + ' Stock Price'
    },
    yAxis: {
      type: 'logarithmic',
    },
    series: [{
      name: symbol,
      data: dataArray,
      type : 'area',
      threshold : null,
      tooltip: {
        valueDecimals: 2
      },
      fillColor: {
        linearGradient: {
          x1: 0,
          y1: 0,
          x2: 0,
          y2: 1
        },
        stops : [
          [0, Highcharts.getOptions().colors[0]],
          [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
        ]
      }
    }]
  });
};








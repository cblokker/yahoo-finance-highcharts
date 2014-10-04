$(document).ready(function() {
  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });

  var substringMatcher = function(strs) {
    return function findMatches(q, cb) {
      var matches, substrRegex;
   
      // an array that will be populated with substring matches
      matches = [];
   
      // regex used to determine if a string contains the substring `q`
      substrRegex = new RegExp(q, 'i');
   
      // iterate through the pool of strings and for any string that
      // contains the substring `q`, add it to the `matches` array
      $.each(strs, function(i, str) {
        if (substrRegex.test(str)) {
          // the typeahead jQuery plugin expects suggestions to a
          // JavaScript object, refer to typeahead docs for more info
          matches.push({ value: str });
        }
      });
   
      cb(matches);
    };
  };
   
  var states = ['aapl', 'aa', 'amzn', 'nflx', 'gild', 'fb', 'lulu'];
   
  $('.typeahead').typeahead({
    hint: true,
    highlight: true,
    minLength: 1,
  },
  {
    name: 'states',
    displayKey: 'value',
    source: substringMatcher(states)
  })


  var $form = $('form[id=generate_graph]'),
      $formUser = $('form[id=generate_stock_quote]'),
      $formBuyStock = $('form[id=buy_stock]'),
      $investmentCard = $('.investment-card'),

      $stockInfoButton = $('.stock-info-button'),

      $buttonPerformance = $('button[name=performance]'),
      $buttonFundamentals = $('button[name=fundamentals]'),
      $buttonTransactionHistory = $('button[name=transaction-history]'),
      $buttonHeadlines = $('button[name=headlines]');

  $buttonPerformance.on('click', performaceButtonToggle);
  $buttonFundamentals.on('click', fundamentalsButtonToggle);
  $buttonTransactionHistory.on('click', transactionHistoryButtonToggle);
  $buttonHeadlines.on('click', headlinesButtonToggle);

  function performaceButtonToggle() {
    $('.investment-performance').fadeIn('fast');
    $('.investment-fundamentals').fadeOut('fast');
    $('.investment-transaction-history').fadeOut('fast');
    $('.investment-headlines').fadeOut('fast');
  }

  function fundamentalsButtonToggle() {
    $('.investment-performance').fadeOut('fast');
    $('.investment-fundamentals').fadeIn('fast');
    $('.investment-transaction-history').fadeOut('fast');
    $('.investment-headlines').fadeOut('fast');
  }

  function transactionHistoryButtonToggle() {
    $('.investment-performance').fadeOut('fast');
    $('.investment-fundamentals').fadeOut('fast');
    $('.investment-transaction-history').fadeIn('fast');
    $('.investment-headlines').fadeOut('fast');
  }

  function headlinesButtonToggle() {
    $('.investment-performance').fadeOut('fast');
    $('.investment-fundamentals').fadeOut('fast');
    $('.investment-transaction-history').fadeOut('fast');
    $('.investment-headlines').fadeIn('fast');
  }


  $investmentCard.mousedown(function() {
    $(".investment-card").not(this).removeClass("investment-card-active");
    $(this).toggleClass("investment-card-active");

    $(this).next().slideToggle('fast');
    $(".investment-card-details").not($(this).next()).slideUp('fast');
  })

  // update buy button value when user inputs number of shares
  $('body').on('input', '#investment_number_of_shares', function() {
    var value = $('#stock-info p').first().text().replace("Price: $", "");
    console.log(value);
    var total = $('#investment_number_of_shares').val() * value;
    $('#buy_button').val('$' + total.toString() + ' buy');
  });

  $form.on('submit', ajaxGraph);

  $.ajax('/investments', {
    type: 'GET',
    dataType: 'json',
    data: $(this).serialize()
  }).done(function(data) {
    $('.stock-info').html(injectStockHTML(data));
  })

  if ($('#pie-chart').size() > 0) { ajaxPieChart(); }
});


function ajaxStockQuote() {
  event.preventDefault();

  $.ajax('/investments', {
    type: 'GET',
    dataType: 'json',
    data: $(this).serialize()
  }).done(function(data) {
    // console.log(data);
    $('.stock-info').html(injectStockHTML(data));
  })
}


function ajaxGraph() {
  // if (event.which == 13) {
    event.preventDefault();

    $.ajax('/stocks', {
      type: 'POST',
      dataType: 'json',
      data: $(this).serialize(),
      error: function(xhr, status, error) {
        $('#container').html("ERROR");
      }
    }).done(function(response) {
      dataArray = generateDataArray(response.pastStockData);
      $('#stock-info').html(injectStockHTML(response.currentStockData));
      $('#actions').html(injectBuyButtonStock(response.currentStockData));
      $('#share-price').html(injectSharePrice(response.currentStockData));
      renderGraph(dataArray, response.currentStockData.symbol);
    })
  // }
}


function ajaxBuyStock() {
  event.preventDefault();

  $.ajax('/investments', {
    type: 'POST',
    dataType: 'json',
    data: $(this).serialize()
  }).done(function(response) {
    // console.log(response)
  })
}

function ajaxPieChart() {
  console.log('heyyy');

  $.ajax('/users', {
    type: 'GET',
    dataType: 'json'
  }).done(function(response) {
    console.log(response);
    renderPieChart(response);

  })
}


function parseClosingData(pastStockDataObjects) {
  var result = [];

  for (var i = 0; i < pastStockDataObjects.length; i++) {
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


function injectStockHTML(data) {
  var html = '<h1>' + data.symbol + '</h1>'
  html += '<p>Price: $' + data.ask + '</p>'
  html += '<p>P/E:</p>'
  html += '<p>P/B:</p>'
  html += '<p>EPS:</p>'
  html += '<p>ROA:</p>'
  html += '<p>ROE:</p>'
  html += '<p>Net Margin:</p>'
  html += '<p>Rev. Growth:</p>'
  console.log(html);
  return html
};

function injectBuyButtonStock(data) {
  html = '<input type="hidden" name="investment[symbol]", value="' + data.symbol + '">'
  return html
}

function injectSharePrice(data) {
  html = '$' + data.ask
  return html
}

function generatePieChartData(portfolio) {
  

}

function renderPieChart(data) {
  $('#pie-chart').highcharts({
    tooltip: {
      pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
    },
    plotOptions: {
      pie: {
        allowPointSelect: true,
        cursor: 'pointer',
        dataLabels: {
          enabled: true,
          format: '<b>{point.name}</b>: {point.percentage:.1f} %',
          style: {
            color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
          }
        }
      }
    },
    credits: {
      enabled: false
    },
    exporting: { enabled: false },
    series: [{
      type: 'pie',
      name: 'Browser share',
      data: data
    }]
  });
}


function renderGraph(dataArray, symbol) {
  $('#stock-graph').highcharts('StockChart', {
    rangeSelector: {
      selected: 1,
      inputEnabled: $('#container').width() > 480
    },
    credits: {
      enabled: false
    },
    yAxis: {
      type: 'logarithmic',
    },
    xAxis: {
      gridLineWidth: 1
    },
    exporting: { enabled: false },
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

  $("#stock-wrapper").slideToggle('slow');
};








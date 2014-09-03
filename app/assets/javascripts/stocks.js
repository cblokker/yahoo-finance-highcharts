$(document).ready(function() {
   $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });

  var $form = $('form');

  $form.on('submit', function(e) {
    e.preventDefault();

    $.ajax('/stocks', {
      type: 'POST',
      dataType: 'json',
      data: $form.serialize()
    }).done(function(response) {
      // console.log(response.pastStockData);
      historyData = parseClosingData(response.pastStockData);
      console.log(historyData);
      renderGraph(historyData);
      // console.log(historyData);
      // html = injectStockHTML(response.data.table);

      // $('.stock-info').html(html)
    })
  });
});

function parseClosingData(pastStockDataObjects) {
  result = [];

  for (var i = 0; i < pastStockDataObjects.length; i++) {
    console.log(pastStockDataObjects[i]);
    floatClose = parseFloat(pastStockDataObjects[i].adjusted_close);
    result.push(floatClose);
  }

  return result.reverse();
}

// function parseData(data) {
//   var result = $.parseJSON(data.file_data);
//   return generateDataArray(result.results);
// }

// function injectStockHTML(data) {
//   var html = '<p><b>Asking Price: </b>' + data.ask + '</p>';
//   html += '<p><b> Bid Price: </b>' + data.bid + '</p>';
//   html += '<p><b> Last trade date: </b>' + data.last_trade_date  + '</p>';
//   html += '<p><b> PE ratio: </b>' + data.pe_ratio  + '</p>';
//   html += '<p><b> Average Daily Volume: </b>' + data.average_daily_volume  + '</p>';
//   html += '<p><b> Earnings Per Share: </b>' + data.earnings_per_share  + '</p>';
//   html += '<p><b> 52 Week Low: </b>' + data.low_52_weeks  + '</p>';
//   html += '<p><b> 52 Week High: </b>' + data.high_52_weeks  + '</p>';
//   html += '<p><b> One Year Target Price: </b>' + data.one_year_target_price  + '</p>';
//   html += '<p><b> 52 week range: </b>' + data.weeks_range_52  + '</p>';
//   html += '<p><b> Day Value Change: </b>' + data.day_value_change  + '</p>';
//   html += '<p><b> Dividend Yield: </b>' + data.dividend_yield;

//   return html;
// };

function renderGraph(dataArray) {
  console.log(dataArray)
  $('#container').highcharts({
      title: {
          text: "stock",
          x: -20
      },
      // xAxis: {
      //     categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      //         'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
      // },
      yAxis: {
          title: {
              text: 'Price'
          },
          plotLines: [{
              value: 0,
              width: 1,
              color: '#808080'
          }]
      },
      tooltip: {
          valueSuffix: '$'
      },
      legend: {
          layout: 'vertical',
          align: 'right',
          verticalAlign: 'middle',
          borderWidth: 0
      },
      series: [{
          name: 'Tokyo',
          data: dataArray
      }]
  });
};








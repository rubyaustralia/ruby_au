const am4core = require("@amcharts/amcharts4/core");
const am4charts = require("@amcharts/amcharts4/charts");
const am4maps = require("@amcharts/amcharts4/maps");
const am4geodata_australiaLow = require("@amcharts/amcharts4-geodata/australiaLow").default;

$(document).ready(() => {
  if ($("#survey-results").length == 0) { return; }


  var chart = am4core.create("age-chart", am4charts.XYChart);

  chart.data = [
    {"range": "0-18", "count": 0},
    {"range": "19-24", "count": 1},
    {"range": "25-32", "count": 49},
    {"range": "33-38", "count": 47},
    {"range": "39-46", "count": 33},
    {"range": "47-58", "count": 4},
    {"range": "59+", "count": 0}
  ]

  var categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis());
  categoryAxis.dataFields.category = "range";
  categoryAxis.title.text = "Age Range";

  var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
  valueAxis.title.text = "Count";

  var series = chart.series.push(new am4charts.ColumnSeries());
  series.dataFields.valueY = "count";
  series.dataFields.categoryX = "range";
  series.columns.template.tooltipText = "Range: {categoryX}\nCount: {valueY}";


  var map = am4core.create("states-chart", am4maps.MapChart);
  map.geodata = am4geodata_australiaLow;

  var polygonSeries = new am4maps.MapPolygonSeries();
  polygonSeries.useGeodata = true;

  polygonSeries.data = [
    {"id": "AU-ACT", "value": 4},
    {"id": "AU-NSW", "value": 33},
    {"id": "AU-NT",  "value": 0},
    {"id": "AU-QLD", "value": 13},
    {"id": "AU-SA",  "value": 5},
    {"id": "AU-TAS", "value": 1},
    {"id": "AU-VIC", "value": 63},
    {"id": "AU-WA",  "value": 6}
  ];
  polygonSeries.heatRules.push({
    "property": "fill",
    "target": polygonSeries.mapPolygons.template,
    "min": am4core.color("#F2EBFD"),
    "max": am4core.color("#241146")
  });
  map.series.push(polygonSeries);

  // Configure series
  var polygonTemplate = polygonSeries.mapPolygons.template;
  polygonTemplate.tooltipText = "{name}: {value}";


  var chart = am4core.create("education-chart", am4charts.PieChart);
  chart.innerRadius = am4core.percent(40);
  chart.startAngle = 0;
  chart.endAngle = 360;

  chart.data = [
    {"type": "High School", "count": 15},
    {"type": "TAFE", "count": 14},
    {"type": "Bachelors", "count": 82},
    {"type": "Masters", "count": 18},
    {"type": "PhD", "count": 2},
    {"type": "Other", "count": 3}
  ]

  var pieSeries = chart.series.push(new am4charts.PieSeries());
  pieSeries.dataFields.category = "type";
  pieSeries.dataFields.value = "count";


  var chart = am4core.create("employment-chart", am4charts.PieChart);
  chart.innerRadius = am4core.percent(40);
  chart.startAngle = -40;
  chart.endAngle = 320;

  chart.data = [
    {"type": "Full-time Employee", "count": 99},
    {"type": "Part-time Employee", "count": 4},
    {"type": "Self Employed: Contractor/Freelancer", "count": 8},
    {"type": "Self Employed: Own Product", "count": 4},
    {"type": "Director/Owner", "count": 9},
    {"type": "Student", "count": 5},
    {"type": "Unemployed", "count": 4},
    {"type": "Other", "count": 1}
  ]

  var pieSeries = chart.series.push(new am4charts.PieSeries());
  pieSeries.dataFields.category = "type";
  pieSeries.dataFields.value = "count";


  var chart = am4core.create("experience-chart", am4charts.PieChart);
  chart.innerRadius = am4core.percent(40);
  // chart.startAngle = -40;
  // chart.endAngle = 320;

  chart.data = [
    {"type": "Entry-level/Junior", "count": 14},
    {"type": "Mid-level", "count": 26},
    {"type": "Senior/Principal", "count": 84}
  ]

  var pieSeries = chart.series.push(new am4charts.PieSeries());
  pieSeries.dataFields.category = "type";
  pieSeries.dataFields.value = "count";


  var chart = am4core.create("office-chart", am4charts.PieChart);
  chart.innerRadius = am4core.percent(40);
  // chart.startAngle = -40;
  // chart.endAngle = 320;

  chart.data = [
    {"type": "Only in an office", "count": 8},
    {"type": "Only remote", "count": 7},
    {"type": "Usually office, occasionally remote", "count": 57},
    {"type": "Usually remote, occasionally office", "count": 14},
    {"type": "Wherever", "count": 35},
    {"type": "Other", "count": 1}
  ]

  var pieSeries = chart.series.push(new am4charts.PieSeries());
  pieSeries.dataFields.category = "type";
  pieSeries.dataFields.value = "count";


  var chart = am4core.create("company-size-chart", am4charts.XYChart);

  chart.data = [
    {"range": "0-10", "count": 19},
    {"range": "11-20", "count": 24},
    {"range": "21-50", "count": 23},
    {"range": "51-100", "count": 12},
    {"range": "101-500", "count": 28},
    {"range": "501-5000", "count": 15},
    {"range": "5001+", "count": 3}
  ]

  var categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis());
  categoryAxis.dataFields.category = "range";
  categoryAxis.title.text = "Number of Employees";

  var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
  valueAxis.title.text = "Count";

  var series = chart.series.push(new am4charts.ColumnSeries());
  series.dataFields.valueY = "count";
  series.dataFields.categoryX = "range";
  series.columns.template.tooltipText = "Range: {categoryX}\nCount: {valueY}";


  var chart = am4core.create("colleague-size-chart", am4charts.XYChart);

  chart.data = [
    {"range": "1", "count": 9},
    {"range": "2-4", "count": 21},
    {"range": "5-10", "count": 40},
    {"range": "11-20", "count": 14},
    {"range": "21-50", "count": 14},
    {"range": "50+", "count": 17}
  ]

  var categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis());
  categoryAxis.dataFields.category = "range";
  categoryAxis.title.text = "Number of Rubyists";

  var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
  valueAxis.title.text = "Count";

  var series = chart.series.push(new am4charts.ColumnSeries());
  series.dataFields.valueY = "count";
  series.dataFields.categoryX = "range";
  series.columns.template.tooltipText = "Range: {categoryX}\nCount: {valueY}";


  var chart = am4core.create("hire-size-chart", am4charts.XYChart);

  chart.data = [
    {"range": "0", "count": 26},
    {"range": "1-3", "count": 47},
    {"range": "4-10", "count": 21},
    {"range": "11+", "count": 18}
  ]

  var categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis());
  categoryAxis.dataFields.category = "range";
  categoryAxis.title.text = "New Hires (people)";

  var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
  valueAxis.title.text = "Count";

  var series = chart.series.push(new am4charts.ColumnSeries());
  series.dataFields.valueY = "count";
  series.dataFields.categoryX = "range";
  series.columns.template.tooltipText = "Range: {categoryX}\nCount: {valueY}";


  var chart = am4core.create("hobby-time-chart", am4charts.XYChart);

  chart.data = [
    {"range": "0-0.5", "count": 3},
    {"range": "1-1.5", "count": 11},
    {"range": "2-3", "count": 20},
    {"range": "4-6", "count": 22},
    {"range": "7-10", "count": 42},
    {"range": "11-15", "count": 30},
    {"range": "16+", "count": 6}
  ]

  var categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis());
  categoryAxis.dataFields.category = "range";
  categoryAxis.title.text = "Years";

  var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
  valueAxis.title.text = "Count";

  var series = chart.series.push(new am4charts.ColumnSeries());
  series.dataFields.valueY = "count";
  series.dataFields.categoryX = "range";
  series.columns.template.tooltipText = "Range: {categoryX}\nCount: {valueY}";


  var chart = am4core.create("professional-time-chart", am4charts.XYChart);

  chart.data = [
    {"range": "0", "count": 15},
    {"range": "0.5-1.5", "count": 11},
    {"range": "2-4", "count": 22},
    {"range": "5-7", "count": 36},
    {"range": "8-10", "count": 30},
    {"range": "11-16", "count": 20}
  ]

  var categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis());
  categoryAxis.dataFields.category = "range";
  categoryAxis.title.text = "Years";

  var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
  valueAxis.title.text = "Count";

  var series = chart.series.push(new am4charts.ColumnSeries());
  series.dataFields.valueY = "count";
  series.dataFields.categoryX = "range";
  series.columns.template.tooltipText = "Range: {categoryX}\nCount: {valueY}";


  var chart = am4core.create("focuses-chart", am4charts.PieChart);
  chart.innerRadius = am4core.percent(40);
  // chart.startAngle = -40;
  // chart.endAngle = 320;

  chart.data = [
    {"type": "Ruby", "count": 101},
    {"type": "Javascript", "count": 73},
    {"type": "Tech Leadership/Management", "count": 54},
    {"type": "Elixir", "count": 33},
    {"type": "Go", "count": 22},
    {"type": "Python", "count": 19},
    {"type": "Other (Functional languages)", "count": 17},
    {"type": "Other (OO languages)", "count": 14},
    {"type": "Rust", "count": 10}
  ]

  var pieSeries = chart.series.push(new am4charts.PieSeries());
  pieSeries.dataFields.category = "type";
  pieSeries.dataFields.value = "count";
});

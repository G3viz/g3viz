HTMLWidgets.widget({
  name: 'g3Lollipop',
  type: 'output',
  factory: function (el) {
    return {
      renderValue: function (x) {
        input = x;
        domID = el;

        var snvData = x.snvData;
        var domainData = x.domainData;
        var snvDataFormat = x.snvDataFormat;
        var domainDataFormat = x.domainDataFormat;
        var plotSettings = x.plotSettings;

        lollipop = g3.Lollipop(el.id);

        lollipop.data.snvData = snvData;
        lollipop.data.domainData = domainData;
        lollipop.format.snvData = snvDataFormat;
        lollipop.format.domainData = domainDataFormat;
        lollipop.setOptions(plotSettings);

        lollipop.draw();

        el.chart = lollipop;
      },
      resize: function (width, height) {
        // TODO: code to re-render the widget with a new size
      },
    };
  }
});

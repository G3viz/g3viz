HTMLWidgets.widget({
  name: 'g3Lollipop',
  type: 'output',
  factory: function (el) {
    return {
      renderValue: function (x) {
        //input = x;
        //domID = el;

        console.log(x);

        var root_id = document.getElementById(el.id);

        if (x.pngButton || x.svgButton) {
          var btn_group = document.createElement('div')

          if (x.svgButton) {
            var svg_btn = document.createElement('BUTTON')
            svg_btn.innerHTML = 'save as SVG'
            svg_btn.id = 'save-as-svg'

            svg_btn.onclick = function (e) {
              g3.output().toSVG('g3-lollipop')
            }
            btn_group.appendChild(svg_btn)
          }

          if (x.pngButton) {
            var png_btn = document.createElement('BUTTON')
            png_btn.innerHTML = 'save as PNG'
            png_btn.id = 'save-as-png'

            png_btn.onclick = function (e) {
              g3.output().toPNG('g3-lollipop')
            }

            btn_group.appendChild(png_btn)
          }

          root_id.appendChild(btn_group)
        }

        var main_div = document.createElement('div');
        main_div.id = "lollipop-container";

        root_id.appendChild(main_div);

        var snvData = x.snvData;
        var domainData = x.domainData;
        var snvDataFormat = x.snvDataFormat;
        var domainDataFormat = x.domainDataFormat;
        var plotSettings = x.plotSettings;

        var lollipop = g3.Lollipop(main_div.id);

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

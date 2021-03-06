/*global fontomas, _, $, Modernizr*/

;(function () {
  "use strict";


  $(function () {
    var steps, result, selector, result_font;

    // check browser's capabilities
    if (!Modernizr.fontface) {
      fontomas.logger.error("bad browser");
      $('#err-bad-browser').modal({backdrop: 'static', keyboard: false});
      return;
    }

    result_font   = new fontomas.models.result_font();

    steps     = new fontomas.ui.wizard.steps();
    selector  = new fontomas.ui.wizard.selector.pane();
    result    = new fontomas.ui.wizard.result.pane({model: result_font});


    // update glypsh count on wizard steps tab
    result_font.glyphs.on('add remove', function () {
      steps.setGlyphsCount(result_font.glyphs.length);
    });

    selector.on('click:glyph', function (data) {
      var glyph = result_font.getGlyph(data.font_id, data.glyph_id);

      if (glyph) {
        glyph.destroy();
        return;
      }

      result_font.addGlyph(data);
    });

    // handle font close
    selector.on('remove:font', function (font) {
      result_font.removeGlyphsByFont(font.id);
    });


    // KLUDGE: should be replaced with selector.addFont() in future
    selector.addEmbeddedFonts(fontomas.embedded_fonts);

    // show selector tab after load complete
    steps.activate('#selector');

    // Attach tooltip handler to matching elements
    $('.tooltip-enabled').tooltip();
  });

}());

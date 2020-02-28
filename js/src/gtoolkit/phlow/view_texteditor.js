var View = require('./view');

class TextEditorView extends View {
    constructor() {
        super();
        this.string = '';
    }

    setString(aString) {
        this.string = aString;
        return this;
    }

    getString() {
        return this.string;
    }

    asDictionaryForExport() {
        let exportData = super.asDictionaryForExport();
        exportData = exportData.concat([
            [ "viewName", "GtDeclarativeTextEditor" ],
            [ "dataTransport", 1 ],
            [ "string", this.getString() ] ]);
        return exportData;
    }
}

module.exports = TextEditorView;

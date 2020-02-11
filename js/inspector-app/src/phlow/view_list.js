var View = require('./view');

class ListView extends View {
    constructor() {
        super();
        this.itemsCallback = () => {[]};
        this.itemFormatCallback = item => String(item);
    }

    items(itemsCallback) {
        this.itemsCallback = itemsCallback;
        return this;
    }

    itemFormat(itemFormatCallback) {
        this.itemFormatCallback = itemFormatCallback;
        return this;
    }

    computeItems() {
        return this.itemsCallback();
    }

    asDictionaryForExport() {
        let exportData = super.asDictionaryForExport();
        exportData['viewName'] = 'GtDeclarativeList';
        exportData['dataTransport'] = 1;
        exportData['items'] = this.computeItems().map( 
            item => { return this.itemFormatCallback(item) }
        )
        return exportData;
    }
}

module.exports = ListView;
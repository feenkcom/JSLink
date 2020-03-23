var View = require('./view');

class TableView extends View {
    constructor() {
        super();
        this.itemsCallback = () => {[]};
        this.columnNames = null;
		// Default accessor is to return the selected row
		this.accessor = (selection) => this.itemsCallback()[selection-1];
    }

    items(itemsCallback) {
        this.itemsCallback = itemsCallback;
        return this;
    }

    computeItems() {
        return this.itemsCallback();
    }

    asDictionaryForExport() {
        let exportData = super.asDictionaryForExport();
        exportData['viewName'] = 'GtDeclarativeTable';
        exportData['dataTransport'] = 1;
        exportData['columnNames'] = this.columnNames;
        exportData['items'] = this.computeItems();
        return exportData;
    }
}


module.exports = TableView;

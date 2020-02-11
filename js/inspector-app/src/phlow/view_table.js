var View = require('./view');

class TableView extends View {
    constructor() {
        super();
        this.itemsCallback = () => {[]};
        this.columns = [];
    }

    items(itemsCallback) {
        this.itemsCallback = itemsCallback;
        return this;
    }

    column(columnTitle, columnFormatCallback) {
        let tableColumn = new TableColumn(columnTitle, columnFormatCallback);
        this.columns.push(tableColumn);
        return this;
    }

    computeItems() {
        return this.itemsCallback();
    }

    asDictionaryForExport() {
        let exportData = super.asDictionaryForExport();
        exportData['viewName'] = 'GtDeclarativeColumnedList';
        exportData['dataTransport'] = 1;
        exportData['columnWidths'] = this.columns.map(
            column => null
        );
        exportData['columnTitles'] = this.columns.map(
            column => column.getTitle()
        );
        exportData['items'] = this.computeItems().map(item => { 
            return this.columns.map(
                column => column.formatItem(item));
        });
        return exportData;
    }
}

class TableColumn {
    constructor(title, formatCallback) {
        this.title = title;
        this.formatCallback = formatCallback;
    }

    getTitle() {
        return this.title;
    }
  
    formatItem(item) {
        return this.formatCallback(item);
    }
}

module.exports = TableView;
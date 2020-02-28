var View = require('./view');

class TableView extends View {
    constructor() {
        super();
        this.itemsCallback = () => {[]};
        this.columns = [];
        this.accessorName = null;
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

    accessor(accessorName) {
		this.accessorName = accessorName;
        return this;
    }

    asDictionaryForExport() {
        let exportData = super.asDictionaryForExport();
        exportData = exportData.concat([
		    [ "viewName", "GtDeclarativeColumnedList" ],
            [ "dataTransport", 1],
            [ "columnWidths", this.columns.map(column => null) ],
            [ "columnTitles", this.columns.map(column => column.getTitle()) ],
            [ "items", this.computeItems().map(item => { 
                return this.columns.map(
                    column => column.formatItem(item)); }) ],
            [ "accessor", this.accessorName ] ]);
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

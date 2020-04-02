var View = require('./view');

class SerialisableColumnedListView extends View {
    constructor() {
        super();
        this.itemsComputation = [];
        this.columnValues = [];
    }

    items(itemsComputation) {
        this.itemsComputation = itemsComputation;
        return this;
    }

    column(title, columnComputation)  {
        this.columnValues.push({
            'title': title,
            'computation': columnComputation
        });
        return this;
    }

    asDictionaryForExport() {
        let exportData = super.asDictionaryForExport();
        exportData['type'] = 'columned-list';
       
        exportData['items'] = this.itemsComputation;
        exportData['columns'] = this.columnValues;

        return exportData;
    }

}

module.exports = SerialisableColumnedListView;
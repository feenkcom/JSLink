var View = require('./view');

class SerialisableListView extends View {
    constructor() {
        super();
        this.itemsComputation = [];
        this.itemFormatComputation = [];
    }

    items(itemsComputation) {
        this.itemsComputation = itemsComputation;
        return this;
    }

    itemFormat(itemFormatComputation) {
        this.itemFormatComputation = itemFormatComputation;
        return this;
    }

    computeItems() {
        return this.itemsCallback();
    }

    asDictionaryForExport() {
        let exportData = super.asDictionaryForExport();
        exportData['type'] = 'list';
       
        exportData['items'] = this.itemsComputation;
        exportData['itemsFormat'] = this.itemFormatComputation;

        return exportData;
    }

    asVegaDictionaryForExport() {
        let exportData = super.asDictionaryForExport();
    
        exportData['data'] = this.itemsComputation;
        exportData['layers'] = [{
            view: 'list',
            title: this.viewTitle,
            priority: this.viewPriority,
            transform: {
                format: this.itemFormatComputation
            }
        }];

        return exportData;
    }
}

module.exports = SerialisableListView;

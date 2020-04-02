var ListView = require('./view_list');
var ColumnedListView = require('./view_columnedlist');
var TableView = require('./view_table');
var CookiesView = require('./view_cookies');
var CircularPackView = require('./view_circular_pack');
var CookiesStencilView = require('./view_cookies_stencil');
var TextEditorView = require('./view_texteditor');
var SerialisableListView = require('./view_list_serialisable');
var SerialisableColumnedListView = require('./view_columnedlist_serialisable');
var SerialisableTreeMapView = require('./view_treemap_serialisable');

class ViewBuilder {
    textEditor() {
        return new TextEditorView();
    }

    list() {
        return new ListView();
    }

    columnedList() {
        return new ColumnedListView();
    }

    table() {
        return new TableView();
    }

    circularPack() {
        return new CircularPackView();
    }

    cookies() {
        return new CookiesView();
    }

    cookiesStencil() {
        return new CookiesStencilView();
    }

    serialisableList() {
        return new SerialisableListView();
    }

    serialisableColumnedList() {
        return new SerialisableColumnedListView();
    }

    serialisableTreeMap() {
        return new SerialisableTreeMapView();
    }
    
}

module.exports = ViewBuilder;
